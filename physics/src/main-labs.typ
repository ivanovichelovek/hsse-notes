#import sys.inputs.preamble: *
#show: conspect.with(course-title: "Физика", doc-title: "Физика. Лабораторные работы")

#titlepage(title: "Физика", subtitle: "Лабораторные работы")

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

#include "labs.typ"
