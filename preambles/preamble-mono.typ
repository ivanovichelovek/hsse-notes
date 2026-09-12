// ===================== Стиль «mono»: минимализм, ч/б, sans =====================
// Подключение: #import "preamble-mono.typ": * затем #show: conspect

#let accent = luma(20)
#let accent-light = luma(240)
#let accent-mid = luma(190)
#let ink = luma(20)
#let muted = luma(120)

#let conspect(body, course-title: "Теория вероятностей", doc-title: "Теория вероятностей. Конспект лекций", author: "Ivan Gerunov") = {
  set document(title: doc-title, author: author)
  set page(
    paper: "a4",
    margin: (top: 3cm, bottom: 2.8cm, x: 2.6cm),
    numbering: "1",
    header: context {
      if counter(page).get().first() > 1 {
        let sections = query(heading.where(level: 1).before(here()))
        let title = if sections.len() > 0 { sections.last().body } else { [] }
        set text(size: 8pt, fill: muted, tracking: 0.06em)
        grid(
          columns: (1fr, 1fr),
          align(left)[#upper(course-title)],
          align(right)[#title],
        )
        v(-0.35em)
        line(length: 100%, stroke: 0.4pt + accent-mid)
      }
    },
  )
  set text(font: ("Liberation Sans", "Noto Sans"), size: 10.5pt, lang: "ru", fill: ink)
  set par(justify: true, leading: 0.65em, first-line-indent: (amount: 0em, all: true), spacing: 1em)

  // ----- Заголовки -----
  set heading(numbering: "1.1")
  show heading.where(level: 1): set heading(numbering: "1.")

  show heading: it => {
    set text(fill: ink)
    block(above: 1.6em, below: 0.9em, it)
  }

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(0.5em)
    block(width: 100%, above: 0em, below: 1.3em)[
      #set text(size: 1.5em, weight: "regular", tracking: 0.02em)
      #if it.numbering != none [
        #text(fill: muted, size: 0.65em)[#counter(heading).display()]
        #h(0.35em)
      ]
      #it.body
      #v(0.35em)
      #line(length: 100%, stroke: 1.6pt + ink)
    ]
  }

  show heading.where(level: 2): it => {
    block(width: 100%, above: 1.5em, below: 0.7em)[
      #set text(size: 1.05em, weight: "bold")
      #if it.numbering != none [
        #text(fill: muted)[#counter(heading).display()]
        #h(0.3em)
      ]
      #it.body
      #v(0.15em)
      #line(length: 30%, stroke: 0.6pt + ink)
    ]
  }

  show heading.where(level: 3): it => {
    block(above: 1.1em, below: 0.5em)[
      #set text(size: 0.95em, weight: "bold", style: "italic")
      #it.body
    ]
  }

  show link: it => underline(it)
  show ref: it => underline(it)
  show raw.where(block: true): block.with(fill: luma(248), inset: 8pt, width: 100%, stroke: 0.4pt + accent-mid)

  set table(stroke: 0.4pt + accent-mid, inset: 6pt)
  show table.cell.where(y: 0): strong

  body
}

// ===================== Вспомогательные блоки =====================

#let note(body) = block(
  width: 100%,
  stroke: (left: 1.2pt + ink),
  inset: (left: 10pt, rest: 6pt),
  body,
)

#let plain-theorem(body, name: "", counter-name: "", title: none) = {
  let c = counter(counter-name)
  c.step()
  block(width: 100%, above: 0.6em, below: 0.6em)[
    #text(weight: "bold")[#name #context c.display()]
    #if title != none [ #text(style: "italic", fill: muted)[(#title)]]
    #h(0.4em)
    #body
  ]
}

#let defn(body, title: none) = plain-theorem(body, name: "Опр.", counter-name: "defn", title: title)
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
    stroke: 0.4pt + accent-mid,
    inset: 10pt,
    breakable: true,
  )[
    #text(weight: "bold", style: "italic")[Пример #context excounter.display()]
    #if title != none [ #text(fill: muted)[ — #title]]
    #v(0.15em)
    #body
  ]
}

// Задача (для семинаров) — рамка потолще и шапка вразрядку,
// чтобы отличалась от примеров.
#let probcounter = counter("problem")
#let problem(body, title: none) = {
  probcounter.step()
  block(
    width: 100%,
    fill: accent-light,
    stroke: (left: 3pt + ink),
    inset: 10pt,
    breakable: true,
  )[
    #set par(first-line-indent: 0em)
    #text(weight: "bold", tracking: 0.1em, size: 0.88em)[ЗАДАЧА #context probcounter.display()]
    #if title != none [ #text(fill: muted)[ — #title]]
    #v(0.25em)
    #body
  ]
}

#let key(body) = align(center)[
  #block(
    stroke: (top: 0.7pt + ink, bottom: 0.7pt + ink),
    inset: (y: 10pt, x: 14pt),
  )[#body]
]

#let divider() = align(center)[
  #v(0.3em)
  #box(width: 15%)[#line(length: 100%, stroke: 0.5pt + ink)]
  #v(0.1em)
]

#let titlepage(
  title: "Теория вероятностей",
  subtitle: "Конспект лекций",
  lecturer: none,
  author: "Ivan Gerunov",
) = align(center + horizon)[
  #block(width: 85%)[
    #text(size: 26pt, weight: "regular", tracking: 0.05em)[#upper(title)]

    #v(0.5em)
    #line(length: 30%, stroke: 0.8pt + ink)
    #v(0.5em)

    #text(size: 12pt, fill: muted, style: "italic")[#subtitle]

    #v(3em)

    #if lecturer != none [
      #text(size: 11pt)[
        Лектор: #lecturer
      ]
      #v(2.5em)
    ]

    #text(size: 9pt, fill: muted)[Конспект: #author]

    #v(0.4em)

    #text(size: 8.5pt, fill: muted)[
      #datetime.today().display("[day].[month].[year]")
    ]
  ]
]
