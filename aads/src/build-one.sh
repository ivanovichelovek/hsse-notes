#!/usr/bin/env bash
# Компилирует одну лекцию/семинар под каждую преамбулу из ../../preambles/
# и складывает результаты в ../pdf/<doc>/<name>/.
#
# Использование:
#   ./build-one.sh lectures 01
#   ./build-one.sh seminars 01
set -euo pipefail
cd "$(dirname "$0")"

doc="${1:-}"
name="${2:-}"

if [[ "$doc" != "lectures" && "$doc" != "seminars" ]] || [[ -z "$name" ]]; then
  echo "Использование: $0 <lectures|seminars> <файл-без-.typ>" >&2
  exit 1
fi

src="$doc/$name.typ"
if [[ ! -f "$src" ]]; then
  echo "Не найден файл $src" >&2
  exit 1
fi

# Номер и заголовок для минимального титульника — берём из имени файла и
# первого заголовка первого уровня в самом файле, ничего не дублируем вручную.
number="$(sed 's/^0*//' <<< "$name")"
title="$(grep -m1 '^= ' "$src" | sed 's/^= *//')"

mkdir -p "../pdf/$doc/$name"
for preamble in ../../preambles/preamble*.typ; do
  pname="$(basename "$preamble" .typ)"          # preamble, preamble-academic, ...
  style="${pname#preamble}"                      # "", -academic, -mono, ...
  style="${style#-}"                              # "", academic, mono, ...
  out="../pdf/$doc/$name/style${style:+-$style}.pdf" # ../pdf/lectures/01/style.pdf, ...

  echo "==> $preamble -> $out"
  # Путь для #import — от корня Typst-проекта (--root ../..), см. build.sh.
  typst compile --root ../.. \
    --input "preamble=/preambles/$(basename "$preamble")" \
    --input "doc=$doc" \
    --input "number=$number" \
    --input "lecture-title=$title" \
    --input "lecture=$src" \
    main-single.typ "$out"
done
