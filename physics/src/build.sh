#!/usr/bin/env bash
# Компилирует main-<doc>.typ под каждую преамбулу из ../../preambles/
# и складывает результаты в ../pdf/<doc>/.
#
# Использование: ./build.sh [doc ...]
# Без аргументов собирает все документы предмета.
set -euo pipefail
cd "$(dirname "$0")"

all_docs=(lectures seminars labs)
docs=("$@")
if [[ ${#docs[@]} -eq 0 ]]; then
  docs=("${all_docs[@]}")
fi

for doc in "${docs[@]}"; do
  mkdir -p "../pdf/$doc"
  for preamble in ../../preambles/preamble*.typ; do
    name="$(basename "$preamble" .typ)"          # preamble, preamble-academic, ...
    style="${name#preamble}"                     # "", -academic, -mono, ...
    style="${style#-}"                            # "", academic, mono, ...
    out="../pdf/$doc/style${style:+-$style}.pdf"  # ../pdf/lectures/style.pdf, ...

    echo "==> $preamble -> $out"
    # Путь для #import — от корня Typst-проекта (--root ../..), т.к. теперь
    # исходники лежат в <предмет>/src/, а preambles/ — в корне репозитория.
    typst compile --root ../.. --input "preamble=/preambles/$(basename "$preamble")" "main-$doc.typ" "$out"
  done
done
