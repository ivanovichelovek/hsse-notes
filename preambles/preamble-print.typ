// ===================== Стиль «print»: типографский, без заливок =====================
// Подключение: #import "preamble-print.typ": * затем #show: conspect
// Только линии и типографика (кегль/начертание/трекинг), никаких цветных
// и серых заливок — расчёт на печать без тонера на фон.

#let accent = luma(0)
#let accent-light = luma(255)
#let accent-mid = luma(150)
#let ink = luma(0)
#let muted = luma(110)

#let conspect(body, course-title: "Теория вероятностей", doc-title: "Теория вероятностей. Конспект лекций", author: "Ivan Gerunov") = {
  set document(title: doc-title, author: author)
  set page(
    paper: "a4",
    margin: (top: 3.3cm, bottom: 3cm, x: 2.8cm),
    numbering: "1",
    header: context {
      if counter(page).get().first() > 1 {
        let sections = query(heading.where(level: 1).before(here()))
        let title = if sections.len() > 0 { sections.last().body } else { [] }
        set text(size: 8.5pt, fill: muted, tracking: 0.08em)
        align(center)[#upper(title)]
        v(-0.35em)
        align(center)[#box(width: 8%)[#line(length: 100%, stroke: 0.5pt + ink)]]
      }
    },
  )
  set text(font: ("Libertinus Serif", "Liberation Serif"), size: 11pt, lang: "ru", fill: ink)
  set par(justify: true, leading: 0.72em, first-line-indent: (amount: 1.4em, all: true), spacing: 1em)

  // ----- Заголовки: только линии и типографика -----
  set heading(numbering: "1.1")
  show heading.where(level: 1): set heading(numbering: "1.")

  show heading: it => {
    set text(fill: ink)
    block(above: 1.6em, below: 0.9em, it)
  }

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(2.2em)
    align(center)[
      #block(width: 100%, above: 0em, below: 1.6em)[
        #if it.numbering != none [
          #text(size: 0.8em, tracking: 0.3em, fill: muted)[ГЛАВА #counter(heading).display()]
          #v(0.5em)
        ]
        #par(justify: false)[
          #text(size: 1.7em, weight: "regular", tracking: 0.03em, hyphenate: false)[#upper(it.body)]
        ]
        #v(0.4em)
        #box(width: 12%)[#line(length: 100%, stroke: 0.7pt + ink)]
      ]
    ]
  }

  show heading.where(level: 2): it => {
    block(width: 100%, above: 1.7em, below: 0.9em)[
      #set text(size: 1.15em, weight: "regular", style: "italic", tracking: 0.02em)
      #if it.numbering != none [
        #counter(heading).display()
        #h(0.35em)
      ]
      #it.body
      #v(0.2em)
      #line(length: 100%, stroke: 0.4pt + accent-mid)
    ]
  }

  show heading.where(level: 3): it => {
    block(above: 1.1em, below: 0.5em)[
      #set text(size: 1.0em, weight: "bold")
      #it.body
      #sym.space.nobreak
      #box(width: 1.2em)[#line(length: 100%, stroke: 0.4pt + ink)]
    ]
  }

  show link: it => underline(it)
  show ref: it => underline(it)
  show raw.where(block: true): block.with(inset: 8pt, width: 100%, stroke: 0.5pt + ink)

  set table(stroke: 0.5pt + ink, inset: 6pt)
  show table.cell.where(y: 0): strong

  body
}

// ===================== Вспомогательные блоки (без заливок) =====================

#let note(body) = block(
  width: 100%,
  stroke: (top: 0.4pt + ink, bottom: 0.4pt + ink),
  inset: (y: 8pt, x: 0pt),
  body,
)

#let plain-theorem(body, name: "", counter-name: "", title: none) = {
  let c = counter(counter-name)
  c.step()
  block(width: 100%, above: 0.7em, below: 0.7em)[
    #text(weight: "bold", style: "italic")[#name #context c.display().]
    #if title != none [ #text(style: "italic", fill: muted)[ (#title)]]
    #h(0.35em)
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
    stroke: (left: 0.6pt + ink),
    inset: (left: 12pt, rest: 4pt),
    breakable: true,
  )[
    #text(weight: "regular", style: "italic")[Пример #context excounter.display()]
    #if title != none [ #text(fill: muted)[ — #title]]
    #linebreak()
    #body
  ]
}

// Задача (для семинаров) — экономная разметка: висячая шапка
// вразрядку и тонкая линейка слева.
#let probcounter = counter("problem")
#let problem(body, title: none) = {
  probcounter.step()
  block(
    width: 100%,
    stroke: (left: 1.2pt + ink),
    inset: (left: 12pt, rest: 4pt),
    breakable: true,
  )[
    #set par(first-line-indent: 0em)
    #text(weight: "bold", tracking: 0.08em, size: 0.9em)[ЗАДАЧА #context probcounter.display()]
    #if title != none [ #text(fill: muted)[ — #title]]
    #linebreak()
    #body
  ]
}

#let key(body) = align(center)[
  #block(
    stroke: (top: 0.9pt + ink, bottom: 0.9pt + ink),
    inset: (y: 12pt, x: 10pt),
  )[#body]
]

#let divider() = align(center)[
  #v(0.4em)
  #text(size: 0.9em, tracking: 0.4em)[· · ·]
  #v(0.2em)
]

#let titlepage(
  title: "Теория вероятностей",
  subtitle: "Конспект лекций",
  lecturer: none,
  author: "Ivan Gerunov",
) = align(center + horizon)[
  #block(width: 78%)[
    #box(width: 18%)[#line(length: 100%, stroke: 0.7pt + ink)]
    #v(1.2em)

    #par(justify: false)[
      #text(size: 27pt, weight: "regular", tracking: 0.04em, hyphenate: false)[#upper(title)]
    ]

    #v(0.6em)

    #text(size: 12pt, fill: muted, style: "italic")[#subtitle]

    #v(1.2em)
    #box(width: 18%)[#line(length: 100%, stroke: 0.7pt + ink)]
    #v(3em)

    #if lecturer != none [
      #text(size: 10pt, fill: muted, tracking: 0.2em)[КУРС ЛЕКЦИЙ]
      #v(0.4em)
      #text(size: 12pt)[#lecturer]
      #v(2.5em)
    ]

    #text(size: 9.5pt, fill: muted)[Конспект: #author]

    #v(0.4em)

    #text(size: 8.5pt, fill: muted)[
      #datetime.today().display("[day].[month].[year]")
    ]
  ]
]
