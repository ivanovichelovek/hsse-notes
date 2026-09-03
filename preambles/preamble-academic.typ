// ===================== Стиль «academic»: классический учебник =====================
// Подключение: #import "preamble-academic.typ": * затем #show: conspect

#let accent = rgb("#7a1f2b")
#let accent-light = rgb("#f6ecec")
#let accent-mid = rgb("#d9b9bd")
#let ink = luma(25)
#let muted = luma(100)

#let conspect(body, course-title: "Теория вероятностей", doc-title: "Теория вероятностей. Конспект лекций", author: "Ivan Gerunov") = {
  set document(title: doc-title, author: author)
  set page(
    paper: "a4",
    margin: (top: 3.2cm, bottom: 3cm, x: 2.7cm),
    numbering: "— 1 —",
    header: context {
      if counter(page).get().first() > 1 {
        let sections = query(heading.where(level: 1).before(here()))
        let title = if sections.len() > 0 { sections.last().body } else { [] }
        set text(size: 9pt, fill: muted, style: "italic")
        align(center)[#title]
        v(-0.4em)
        align(center)[#box(width: 20%)[#line(length: 100%, stroke: 0.5pt + accent)]]
      }
    },
  )
  set text(font: ("Noto Serif", "Liberation Serif"), size: 11pt, lang: "ru", fill: ink)
  set par(justify: true, leading: 0.72em, first-line-indent: (amount: 1.5em, all: true), spacing: 1em)

  // ----- Заголовки -----
  set heading(numbering: "I.1.")
  show heading.where(level: 1): set heading(numbering: "I.")

  show heading: it => {
    set text(fill: ink)
    block(above: 1.6em, below: 0.9em, it)
  }

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(2em)
    align(center)[
      #block(width: 100%, above: 0em, below: 1.4em)[
        #if it.numbering != none [
          #text(fill: accent, size: 0.85em, tracking: 0.15em)[ГЛАВА #counter(heading).display()]
          #v(0.4em)
        ]
        #text(size: 1.7em, weight: "bold", fill: ink)[#upper(it.body)]
        #v(0.3em)
        #text(fill: accent)[#sym.ast.op #sym.ast.op #sym.ast.op]
      ]
    ]
  }

  show heading.where(level: 2): it => {
    block(width: 100%, above: 1.6em, below: 0.8em)[
      #set text(size: 1.2em, weight: "bold", fill: accent, style: "italic")
      #if it.numbering != none [
        #counter(heading).display()
        #h(0.3em)
      ]
      #it.body
    ]
  }

  show heading.where(level: 3): it => {
    block(above: 1.1em, below: 0.5em)[
      #set text(size: 1.0em, weight: "bold", fill: ink)
      #sym.section
      #h(0.3em)
      #it.body
    ]
  }

  show link: set text(fill: accent)
  show ref: set text(fill: accent)
  show raw.where(block: true): block.with(fill: luma(247), inset: 8pt, width: 100%, stroke: 0.5pt + accent-mid)

  set table(stroke: 0.5pt + accent-mid, inset: 6pt)
  show table.cell.where(y: 0): strong

  body
}

// ===================== Вспомогательные блоки =====================

#let note(body) = block(
  width: 100%,
  fill: luma(250),
  stroke: 0.6pt + accent-mid,
  inset: 10pt,
  body,
)

#let defcounter = counter("defn")
#let defn(body, title: none) = {
  defcounter.step()
  block(width: 100%, above: 0.8em, below: 0.8em, breakable: true)[
    #text(weight: "bold", fill: accent, style: "italic")[Определение #context defcounter.display().]
    #if title != none [ #text(style: "italic", fill: muted)[(#title)]]
    #h(0.3em)
    #body
  ]
}

#let excounter = counter("example")
#let example(body, title: none) = {
  excounter.step()
  block(
    width: 100%,
    inset: (left: 12pt, rest: 8pt),
    stroke: (left: 1.5pt + accent),
    breakable: true,
  )[
    #text(weight: "bold", fill: accent)[Пример #context excounter.display().]
    #if title != none [ #text(style: "italic", fill: muted)[ #title.]]
    #v(0.15em)
    #body
  ]
}

#let key(body) = align(center)[
  #block(
    fill: accent-light,
    stroke: (top: 1pt + accent, bottom: 1pt + accent),
    inset: (y: 12pt, x: 16pt),
  )[#body]
]

#let divider() = align(center)[
  #v(0.3em)
  #text(fill: accent, size: 1.1em)[#sym.ast.op]
  #v(0.1em)
]

#let titlepage(
  title: "Теория вероятностей",
  subtitle: "Конспект лекций",
  lecturer: none,
  author: "Ivan Gerunov",
) = align(center + horizon)[
  #block(width: 80%)[
    #text(fill: accent, size: 1.3em)[#sym.ast.op #sym.ast.op #sym.ast.op]
    #v(1.2em)

    #text(size: 30pt, weight: "bold", fill: ink)[#title]

    #v(0.5em)

    #text(size: 13pt, fill: accent, style: "italic")[#subtitle]

    #v(0.8em)
    #text(fill: accent, size: 1.3em)[#sym.ast.op #sym.ast.op #sym.ast.op]
    #v(2.5em)

    #if lecturer != none [
      #text(size: 12pt, style: "italic", fill: muted)[Курс лекций]
      #v(0.3em)
      #text(size: 13pt)[#lecturer]
      #v(2.5em)
    ]

    #text(size: 10pt, fill: muted)[Конспект: #author]

    #v(0.4em)

    #text(size: 9pt, fill: muted)[
      #datetime.today().display("[day].[month].[year]")
    ]
  ]
]
