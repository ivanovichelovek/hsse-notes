#import sys.inputs.preamble: *
#show: conspect.with(course-title: "Дифференциальные уравнения", doc-title: "Дифференциальные уравнения. Лекции")

#titlepage(title: "Дифференциальные уравнения", subtitle: "Лекции")

#pagebreak()

#heading(level: 1, numbering: none, outlined: false)[Содержание]
#show outline.entry.where(level: 1): it => {
  v(0.6em, weak: true)
  set text(weight: "bold", fill: accent)
  it
}
#outline(
  title: none,
  depth: 2,
)

#pagebreak()

#include "lectures.typ"
