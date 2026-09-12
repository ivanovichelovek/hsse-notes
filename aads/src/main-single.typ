// Обёртка для компиляции одной лекции/семинара отдельно от книги.
// Для dts используем тот же #titlepage(), что и в обычной сборке (main-
// lectures.typ) — университет/курс/семестр/лектор, с номером и названием
// лекции вместо подзаголовка (titlepage() в preamble-dts.typ это умеет).
// У остальных 6 стилей titlepage() такой параметр не принимает (там нет
// понятия «отдельная лекция»), поэтому для них остаётся прежний минимальный
// титульник — «Лекция N. Название.» простым текстом по центру страницы.
// Используется build-one.sh: --input preamble=..., --input doc=lectures|seminars,
// --input number=N, --input lecture-title=..., --input lecture=lectures/01.typ.

#import sys.inputs.preamble: *

#let doc-titles = (lectures: "Алгоритмы. Лекции", seminars: "Алгоритмы. Семинары")
#let kind-names = (lectures: "Лекция", seminars: "Семинар")
#show: conspect.with(course-title: "Алгоритмы", doc-title: doc-titles.at(sys.inputs.doc))

#if sys.inputs.preamble.contains("dts") [
  #titlepage(
    title: "Алгоритмы",
    lecturer: "Кулапин Артур",
    lecture-number: sys.inputs.number,
    lecture-title: sys.inputs.lecture-title,
  )
] else [
  // {\Huge Лекция N. Название \par} — как в реальных titlepage Destroying
  // The Session: \Huge относительно \normalsize даёт кегль 24.88/11 ≈
  // 2.262em, без жирного начертания.
  #align(center + horizon)[
    #text(size: 24.88pt / 11pt * 1em)[#kind-names.at(sys.inputs.doc) #sys.inputs.number. #sys.inputs.lecture-title]
  ]
  #pagebreak(weak: true)
]

#include sys.inputs.lecture
