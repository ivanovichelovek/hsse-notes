// ===================== Стиль «slate»: современный, тёмно-бирюзовый акцент =====================
// Подключение: #import "preamble-slate.typ": * затем #show: conspect

#let accent = rgb("#0f766e")
#let accent-light = rgb("#e6f4f3")
#let accent-mid = rgb("#a9d4d0")
#let ink = rgb("#1e293b")
#let muted = rgb("#64748b")

#let conspect(body, course-title: "Теория вероятностей", doc-title: "Теория вероятностей. Конспект лекций", author: "Ivan Gerunov") = {
  set document(title: doc-title, author: author)
  set page(
    paper: "a4",
    margin: (top: 3cm, bottom: 2.8cm, x: 2.5cm),
    numbering: "1",
    header: context {
      if counter(page).get().first() > 1 {
        let sections = query(heading.where(level: 1).before(here()))
        let title = if sections.len() > 0 { sections.last().body } else { [] }
        set text(size: 8.5pt, fill: muted, font: ("Liberation Sans", "Noto Sans"))
        grid(
          columns: (1fr, 1fr),
          align(left)[#text(fill: accent, weight: "bold")[#course-title]],
          align(right)[#title],
        )
        v(-0.4em)
        line(length: 100%, stroke: 1.2pt + accent)
      }
    },
  )
  set text(font: ("Libertinus Serif", "Liberation Serif"), size: 11pt, lang: "ru", fill: ink)
  set par(justify: true, leading: 0.68em, first-line-indent: (amount: 1.25em, all: true), spacing: 1em)

  // ----- Заголовки (sans) -----
  set heading(numbering: "1.1")
  show heading.where(level: 1): set heading(numbering: "1.")

  show heading: it => {
    set text(fill: ink, font: ("Liberation Sans", "Noto Sans"))
    block(above: 1.6em, below: 0.9em, it)
  }

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(0.4em)
    block(width: 100%, above: 0em, below: 1.3em, fill: ink, inset: (x: 14pt, y: 12pt), radius: 4pt)[
      #set text(size: 1.6em, weight: "bold", fill: white)
      #if it.numbering != none [
        #text(fill: accent-mid, size: 0.65em, font: ("JetBrainsMono NF",))[#counter(heading).display()]
        #h(0.35em)
      ]
      #it.body
    ]
  }

  show heading.where(level: 2): it => {
    block(width: 100%, above: 1.5em, below: 0.7em)[
      #set text(size: 1.2em, weight: "bold", fill: accent)
      #box(fill: accent, width: 0.5em, height: 0.5em, radius: 1pt)
      #h(0.4em)
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
      #text(fill: accent)[#sym.arrow.r.curve]
      #h(0.3em)
      #it.body
    ]
  }

  show link: set text(fill: accent)
  show ref: set text(fill: accent)
  show raw.where(block: true): block.with(fill: luma(248), inset: 8pt, width: 100%, radius: 4pt, stroke: 0.5pt + accent-mid)

  set table(stroke: 0.5pt + accent-mid, inset: 6pt)
  show table.cell.where(y: 0): strong.with()
  show table.cell.where(y: 0): set text(fill: accent, font: ("Liberation Sans", "Noto Sans"))

  body
}

// ===================== Вспомогательные блоки =====================

#let label-font = ("Liberation Sans", "Noto Sans")

#let note(body) = block(
  width: 100%,
  fill: accent-light,
  inset: 10pt,
  radius: 4pt,
  body,
)

#let defcounter = counter("defn")
#let defn(body, title: none) = {
  defcounter.step()
  block(width: 100%, breakable: true)[
    #box(
      fill: ink, inset: (x: 6pt, y: 3pt), radius: 2pt,
    )[#text(fill: white, size: 0.8em, weight: "bold", font: label-font)[ОПРЕДЕЛЕНИЕ #context defcounter.display()]]
    #if title != none [ #h(0.3em) #text(style: "italic", fill: muted)[#title]]
    #v(0.3em)
    #body
  ]
}

#let excounter = counter("example")
#let example(body, title: none) = {
  excounter.step()
  block(
    width: 100%,
    fill: white,
    stroke: 1pt + accent-mid,
    inset: 10pt,
    radius: 4pt,
    breakable: true,
  )[
    #box(
      fill: accent, inset: (x: 6pt, y: 3pt), radius: 2pt,
    )[#text(fill: white, size: 0.8em, weight: "bold", font: label-font)[ПРИМЕР #context excounter.display()]]
    #if title != none [ #h(0.3em) #text(style: "italic", fill: muted)[#title]]
    #v(0.3em)
    #body
  ]
}

#let key(body) = align(center)[
  #block(
    fill: accent,
    inset: 12pt,
    radius: 6pt,
  )[#text(fill: white)[#body]]
]

#let divider() = align(center)[
  #v(0.3em)
  #box(fill: accent, width: 3em, height: 2pt)
  #v(0.3em)
]

#let titlepage(
  title: "Теория вероятностей",
  subtitle: "Конспект лекций",
  lecturer: none,
  author: "Ivan Gerunov",
) = align(center + horizon)[
  #block(width: 85%)[
    #box(fill: accent, width: 4em, height: 4pt)
    #v(1em)

    #text(size: 30pt, weight: "bold", fill: ink, font: ("Liberation Sans", "Noto Sans"))[#title]

    #v(0.5em)

    #text(size: 14pt, fill: accent, font: ("Liberation Sans", "Noto Sans"))[#subtitle]

    #v(2.5em)

    #if lecturer != none [
      #block(fill: accent-light, inset: (x: 14pt, y: 8pt), radius: 4pt)[
        #text(size: 12pt, fill: ink)[Лектор: #text(weight: "bold")[#lecturer]]
      ]
      #v(2.5em)
    ]

    #text(size: 10pt, fill: muted)[Конспект: #author]

    #v(0.4em)

    #text(size: 9pt, fill: muted)[
      #datetime.today().display("[day].[month].[year]")
    ]
  ]
]
