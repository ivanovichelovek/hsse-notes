#import sys.inputs.preamble: *
#show: conspect.with(course-title: "Теория вероятностей", doc-title: "Теория вероятностей. Семинары")

#titlepage(title: "Теория вероятностей", subtitle: "Семинары", lecturer: "Широков Максим Евгеньевич")

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

#include "seminars.typ"
