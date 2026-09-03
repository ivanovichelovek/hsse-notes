// ===================== Преамбула стиля «конспект» =====================
// Подключение: #import "preamble.typ": * затем #show: conspect
// (в самом верху главного .typ файла, до всего остального контента)

#let accent = rgb("#1d4d8f")
#let accent-light = rgb("#e8eef7")
#let accent-mid = rgb("#c3d3ea")
#let ink = luma(35)
#let muted = luma(105)

// Шаблон-обёртка: применяет все set/show-правила ко всему документу,
// который идёт после `#show: conspect`.
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
        set text(size: 8.5pt, fill: muted, style: "italic")
        grid(
          columns: (1fr, 1fr),
          align(left)[#course-title],
          align(right)[#title],
        )
        v(-0.4em)
        line(length: 100%, stroke: 0.5pt + accent-mid)
      }
    },
  )
  set text(font: ("Libertinus Serif", "Liberation Serif"), size: 11pt, lang: "ru", fill: ink)
  set par(justify: true, leading: 0.68em, first-line-indent: (amount: 1.25em, all: true), spacing: 1em)

  // ----- Заголовки -----
  set heading(numbering: "1.1")
  show heading.where(level: 1): set heading(numbering: "1.")

  show heading: it => {
    set text(fill: ink)
    block(above: 1.6em, below: 0.9em, it)
  }

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(0.4em)
    block(width: 100%, above: 0em, below: 1.2em)[
      #set text(size: 1.9em, weight: "bold", fill: accent)
      #if it.numbering != none [
        #text(fill: accent-mid, size: 0.7em)[#counter(heading).display()]
        #h(0.3em)
      ]
      #it.body
      #v(0.2em)
      #line(length: 100%, stroke: 1.4pt + accent)
    ]
  }

  show heading.where(level: 2): it => {
    block(width: 100%, above: 1.4em, below: 0.7em)[
      #set text(size: 1.25em, weight: "bold", fill: ink)
      #box(fill: accent-light, inset: (x: 0.5em, y: 0.35em), radius: 3pt)[
        #if it.numbering != none [
          #text(fill: accent)[#counter(heading).display()]
          #h(0.3em)
        ]
        #it.body
      ]
    ]
  }

  show heading.where(level: 3): it => {
    block(above: 1.1em, below: 0.5em)[
      #set text(size: 1.05em, weight: "bold", fill: accent)
      #sym.triangle.filled.small.r
      #h(0.35em)
      #it.body
    ]
  }

  show link: set text(fill: accent)
  show ref: set text(fill: accent)
  show raw.where(block: true): block.with(fill: luma(245), inset: 8pt, width: 100%, radius: 3pt, stroke: 0.5pt + luma(210))

  set table(stroke: 0.5pt + luma(170), inset: 6pt)
  show table.cell.where(y: 0): strong

  body
}

// ===================== Вспомогательные блоки =====================

// Примечание общего вида
#let note(body) = block(
  width: 100%,
  fill: luma(246),
  stroke: (left: 2.5pt + muted),
  inset: 10pt,
  radius: (right: 3pt),
  body,
)

// Определение (нумеруется автоматически)
#let defcounter = counter("defn")
#let defn(body, title: none) = {
  defcounter.step()
  block(
    width: 100%,
    fill: accent-light,
    stroke: (left: 3pt + accent),
    inset: 10pt,
    radius: (right: 4pt),
    breakable: true,
  )[
    #text(weight: "bold", fill: accent)[Определение#context defcounter.display()]
    #if title != none [ #text(style: "italic")[(#title)]]
    #v(0.15em)
    #body
  ]
}

// Пример (нумеруется автоматически)
#let excounter = counter("example")
#let example(body, title: none) = {
  excounter.step()
  block(
    width: 100%,
    fill: luma(250),
    stroke: 0.7pt + luma(200),
    inset: 10pt,
    radius: 4pt,
    breakable: true,
  )[
    #text(weight: "bold", fill: rgb("#8a5a00"))[Пример #context excounter.display()]
    #if title != none [ #text(style: "italic")[— #title]]
    #v(0.15em)
    #body
  ]
}

// Ключевая формула / теорема — в рамке, по центру
#let key(body) = align(center)[
  #block(
    fill: white,
    stroke: 1.1pt + accent,
    inset: 12pt,
    radius: 6pt,
  )[#body]
]

// Красивый разделитель вместо голой линии на всю ширину
#let divider() = align(center)[
  #v(0.3em)
  #box(width: 40%)[#line(length: 100%, stroke: 0.6pt + accent-mid)]
  #v(0.1em)
]

// Титульный лист с рамкой-разделителями (принимает данные, чтобы можно было
// переиспользовать в других конспектах)
#let titlepage(
  title: "Теория вероятностей",
  subtitle: "Конспект лекций",
  lecturer: none,
  author: "Ivan Gerunov",
) = align(center + horizon)[
  #block(width: 85%)[
    #line(length: 60%, stroke: 1.2pt + accent)
    #v(1em)

    #text(size: 30pt, weight: "bold", fill: accent)[#title]

    #v(0.6em)

    #text(size: 14pt, fill: muted, style: "italic")[#subtitle]

    #v(1em)
    #line(length: 60%, stroke: 1.2pt + accent)
    #v(2.2em)

    #if lecturer != none [
      #text(size: 13pt, fill: ink)[
        Лектор: #text(weight: "bold")[#lecturer]
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
