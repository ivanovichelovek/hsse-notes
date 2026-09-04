#!/usr/bin/env python3
"""Пересобирает только те PDF, которых коснулись изменённые в коммите файлы.

Использование: ci-build.py <файл-со-списком-изменённых-путей>

Логика:
  - изменение preambles/preamble*.typ -> пересобрать всё (все предметы,
    все документы, плюс отдельные лекции/семинары там, где они есть);
  - изменение <предмет>/src/build.sh -> пересобрать все документы предмета;
  - изменение <предмет>/src/main-single.typ или build-one.sh (только aads)
    -> пересобрать все уже существующие отдельные лекции/семинары предмета;
  - изменение <предмет>/src/<doc>.typ, main-<doc>.typ или
    <предмет>/src/<doc>/<файл>.typ -> пересобрать книгу <doc> предмета;
    если у предмета есть отдельная сборка (aads) — заодно пересобрать
    именно этот файл лекции/семинара отдельно;
  - любой другой файл внутри <предмет>/src/ -> на всякий случай пересобрать
    все документы предмета.
"""
import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

ALL_DOCS_RE = re.compile(r"^all_docs=\(([^)]*)\)", re.M)


def discover_subjects(root: Path) -> dict[str, dict]:
    """Какие документы есть у предмета и умеет ли он собирать отдельные лекции.

    Список собирается из файловой системы, а не задаётся здесь константой:
    раньше он был захардкожен, пережил переименование каталогов
    («diff eq» -> «diff_eq» и т.п.) и три предмета молча выпали из CI.
    Источник правды по документам — сам build.sh предмета (его all_docs),
    ведь именно ему мы потом передаём имя документа аргументом.
    """
    subjects: dict[str, dict] = {}
    for build in sorted(root.glob("*/src/build.sh")):
        src = build.parent
        m = ALL_DOCS_RE.search(build.read_text())
        if not m:
            print(f"! {build}: не нашёл all_docs=(...), предмет пропущен", file=sys.stderr)
            continue
        docs = m.group(1).split()
        if not docs:
            continue
        subjects[src.parent.name] = {
            "docs": docs,
            "per_item": (src / "build-one.sh").exists(),
        }
    return subjects


SUBJECTS = discover_subjects(REPO_ROOT)


def run(cmd, cwd):
    print(f"+ ({cwd}) {' '.join(cmd)}", flush=True)
    subprocess.run(cmd, cwd=cwd, check=True)


def main():
    if len(sys.argv) != 2:
        print(f"Использование: {sys.argv[0]} <changed-files.txt>", file=sys.stderr)
        sys.exit(1)

    changed = [
        line for line in Path(sys.argv[1]).read_text().splitlines() if line.strip()
    ]

    rebuild_full = any(f.startswith("preambles/") for f in changed)

    doc_targets: set[tuple[str, str]] = set()
    item_targets: set[tuple[str, str, str]] = set()
    template_touched: set[str] = set()

    if rebuild_full:
        doc_targets = {(s, d) for s, cfg in SUBJECTS.items() for d in cfg["docs"]}
        template_touched = {s for s, cfg in SUBJECTS.items() if cfg["per_item"]}

    for f in changed:
        for subject, cfg in SUBJECTS.items():
            prefix = f"{subject}/src/"
            if not f.startswith(prefix):
                continue

            rel = f[len(prefix):]
            parts = rel.split("/")

            if parts[0] == "build.sh":
                doc_targets.update((subject, d) for d in cfg["docs"])
            elif cfg["per_item"] and parts[0] in ("main-single.typ", "build-one.sh"):
                template_touched.add(subject)
            elif len(parts) == 2 and parts[0] in cfg["docs"] and parts[1].endswith(".typ"):
                doc = parts[0]
                doc_targets.add((subject, doc))
                if cfg["per_item"]:
                    item_targets.add((subject, doc, parts[1][: -len(".typ")]))
            elif parts[0] in (f"{d}.typ" for d in cfg["docs"]):
                doc_targets.add((subject, parts[0][: -len(".typ")]))
            elif parts[0] in (f"main-{d}.typ" for d in cfg["docs"]):
                doc_targets.add((subject, parts[0][len("main-"): -len(".typ")]))
            else:
                # неопознанный файл в src/ предмета — пересобрать всё на всякий случай
                doc_targets.update((subject, d) for d in cfg["docs"])
            break

    # main-single.typ/build-one.sh изменились -> пересобрать все существующие
    # по отдельности лекции/семинары предмета
    for subject in template_touched:
        src = REPO_ROOT / subject / "src"
        for doc in SUBJECTS[subject]["docs"]:
            d = src / doc
            if d.is_dir():
                for p in sorted(d.glob("*.typ")):
                    item_targets.add((subject, doc, p.stem))

    if not doc_targets and not item_targets:
        print("Изменений, влияющих на PDF, не найдено — пересборка не требуется.")
        return

    for subject, doc in sorted(doc_targets):
        run(["./build.sh", doc], cwd=str(REPO_ROOT / subject / "src"))

    for subject, doc, name in sorted(item_targets):
        run(["./build-one.sh", doc, name], cwd=str(REPO_ROOT / subject / "src"))


if __name__ == "__main__":
    main()
