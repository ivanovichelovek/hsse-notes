// ===================== Стиль «bw»: тот же classic, но полностью серый/чёрный =====================
// Подключение: #import "preamble-bw.typ": * затем #show: conspect

#let accent = luma(25)
#let accent-light = luma(244)
#let accent-mid = luma(180)
#let ink = luma(20)
#let muted = luma(105)

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
      #set text(size: 1.9em, weight: "bold", fill: ink)
      #if it.numbering != none [
        #text(fill: muted, size: 0.7em)[#counter(heading).display()]
        #h(0.3em)
      ]
      #it.body
      #v(0.2em)
      #line(length: 100%, stroke: 1.4pt + ink)
    ]
  }

  show heading.where(level: 2): it => {
    block(width: 100%, above: 1.4em, below: 0.7em)[
      #set text(size: 1.25em, weight: "bold", fill: ink)
      #box(fill: accent-light, stroke: 0.5pt + accent-mid, inset: (x: 0.5em, y: 0.35em), radius: 3pt)[
        #if it.numbering != none [
          #text(fill: muted)[#counter(heading).display()]
          #h(0.3em)
        ]
        #it.body
      ]
    ]
  }

  show heading.where(level: 3): it => {
    block(above: 1.1em, below: 0.5em)[
      #set text(size: 1.05em, weight: "bold", fill: ink)
      #sym.triangle.filled.small.r
      #h(0.35em)
      #it.body
    ]
  }

  show link: it => underline(it)
  show ref: it => underline(it)
  show raw.where(block: true): block.with(fill: luma(245), inset: 8pt, width: 100%, radius: 3pt, stroke: 0.5pt + luma(210))

  set table(stroke: 0.5pt + luma(170), inset: 6pt)
  show table.cell.where(y: 0): strong

  body
}

// ===================== Вспомогательные блоки =====================

#let note(body) = block(
  width: 100%,
  fill: luma(246),
  stroke: (left: 2.5pt + muted),
  inset: 10pt,
  radius: (right: 3pt),
  body,
)

#let plain-theorem(body, name: "", counter-name: "", title: none) = {
  let c = counter(counter-name)
  c.step()
  block(
    width: 100%,
    fill: accent-light,
    stroke: (left: 3pt + ink),
    inset: 10pt,
    radius: (right: 4pt),
    breakable: true,
  )[
    #text(weight: "bold", fill: ink)[#name#context c.display()]
    #if title != none [ #text(style: "italic")[(#title)]]
    #v(0.15em)
    #body
  ]
}

#let defn(body, title: none) = plain-theorem(body, name: "Определение", counter-name: "defn", title: title)
#let theorem(body, title: none) = plain-theorem(body, name: "Теорема", counter-name: "theorem", title: title)
#let lemma(body, title: none) = plain-theorem(body, name: "Лемма", counter-name: "lemma", title: title)
#let consequence(body, title: none) = plain-theorem(body, name: "Следствие", counter-name: "consequence", title: title)
#let statement(body, title: none) = plain-theorem(body, name: "Утверждение", counter-name: "statement", title: title)
#let remark(body, title: none) = plain-theorem(body, name: "Замечание", counter-name: "remark", title: title)
#let algorithmm(body, title: none) = plain-theorem(body, name: "Алгоритм", counter-name: "algorithmm", title: title)
#let question(body, title: none) = plain-theorem(body, name: "Вопрос", counter-name: "question", title: title)
#let answer(body, title: none) = plain-theorem(body, name: "Ответ", counter-name: "answer", title: title)
#let exercise(body, title: none) = plain-theorem(body, name: "Упражнение", counter-name: "exercise", title: title)

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
    #text(weight: "bold", fill: ink)[Пример #context excounter.display()]
    #if title != none [ #text(style: "italic")[— #title]]
    #v(0.15em)
    #body
  ]
}

// Задача (для семинаров) — чёрная плашка с номером: заметно и при
// чёрно-белой печати.
#let probcounter = counter("problem")
#let problem(body, title: none) = {
  probcounter.step()
  block(
    width: 100%,
    stroke: 0.7pt + accent-mid,
    inset: 0pt,
    radius: 4pt,
    breakable: true,
  )[
    #block(
      width: 100%,
      fill: ink,
      inset: (x: 10pt, y: 5pt),
      radius: (top: 4pt),
      above: 0pt,
      below: 0pt,
    )[
      #set par(first-line-indent: 0em)
      #text(fill: white, weight: "bold", size: 0.92em)[Задача #context probcounter.display()]
      #if title != none [ #h(0.4em) #text(fill: luma(215), style: "italic", size: 0.92em)[#title]]
    ]
    #block(width: 100%, fill: luma(250), inset: 10pt, above: 0pt, below: 0pt, radius: (bottom: 4pt))[#body]
  ]
}

#let key(body) = align(center)[
  #block(
    fill: white,
    stroke: 1.1pt + ink,
    inset: 12pt,
    radius: 6pt,
  )[#body]
]

#let divider() = align(center)[
  #v(0.3em)
  #box(width: 40%)[#line(length: 100%, stroke: 0.6pt + accent-mid)]
  #v(0.1em)
]

#let titlepage(
  title: "Теория вероятностей",
  subtitle: "Конспект лекций",
  lecturer: none,
  author: "Ivan Gerunov",
) = align(center + horizon)[
  #block(width: 85%)[
    #line(length: 60%, stroke: 1.2pt + ink)
    #v(1em)

    #text(size: 30pt, weight: "bold", fill: ink)[#title]

    #v(0.6em)

    #text(size: 14pt, fill: muted, style: "italic")[#subtitle]

    #v(1em)
    #line(length: 60%, stroke: 1.2pt + ink)
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
