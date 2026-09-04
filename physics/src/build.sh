#!/usr/bin/env bash
# Компилирует main-<doc>.typ под каждую преамбулу из ../../preambles/
# и складывает результаты в ../pdf/<doc>/.
#
# Использование: ./build.sh [-s|--style <стиль>] [doc ...]
# Без аргументов собирает все документы предмета под все преамбулы.
# --style сужает сборку до одного стиля (можно повторять): имя стиля — это
# суффикс преамбулы (dts, academic, bw, ...), базовый preamble.typ — "default".
# Нужно для быстрой пересборки при живом редактировании: один стиль вместо семи.
set -euo pipefail
cd "$(dirname "$0")"

all_docs=(lectures seminars labs)
docs=()
styles=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s | --style)
      [[ $# -ge 2 ]] || { echo "$1: не указан стиль" >&2; exit 2; }
      styles+=("$2")
      shift 2
      ;;
    -*)
      echo "Неизвестный ключ: $1" >&2
      exit 2
      ;;
    *)
      docs+=("$1")
      shift
      ;;
  esac
done

if [[ ${#docs[@]} -eq 0 ]]; then
  docs=("${all_docs[@]}")
fi

# Имена документов проверяем до первого mkdir: иначе опечатка (или мусор,
# прилетевший из скрипта-обёртки) молча создаёт ../pdf/<мусор>/ и падает
# только на поиске main-<мусор>.typ.
for doc in "${docs[@]}"; do
  known=0
  for candidate in "${all_docs[@]}"; do
    if [[ "$doc" == "$candidate" ]]; then
      known=1
      break
    fi
  done
  if [[ $known -eq 0 ]]; then
    echo "Неизвестный документ '$doc'. Есть: ${all_docs[*]}" >&2
    exit 2
  fi
done

if [[ ${#styles[@]} -eq 0 ]]; then
  preambles=(../../preambles/preamble*.typ)
else
  preambles=()
  for style in "${styles[@]}"; do
    if [[ "$style" == default ]]; then
      preamble="../../preambles/preamble.typ"
    else
      preamble="../../preambles/preamble-$style.typ"
    fi
    [[ -f "$preamble" ]] || { echo "Нет стиля '$style' ($preamble)" >&2; exit 1; }
    preambles+=("$preamble")
  done
fi

for doc in "${docs[@]}"; do
  mkdir -p "../pdf/$doc"
  for preamble in "${preambles[@]}"; do
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
