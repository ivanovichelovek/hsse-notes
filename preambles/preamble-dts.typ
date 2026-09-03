// ===================== Стиль «dts»: «Destroying The Session» =====================
// Подключение: #import "preamble-dts.typ": * затем #show: conspect
// Портирован с classic-LaTeX преамбулы курсов ВШПИ (packages.tex/template.tex
// из Destroying_The_Session): article-класс без художественных заливок —
// чёрные нумерованные заголовки, plain-стиль amsthm (жирная шапка + курсив
// тела, без боксов и цвета), fancyhdr-шапка (цитата слева, номер страницы
// справа — титульник в счёт страниц не идёт), синие ссылки (blue!70!black)
// и титульный лист МФТИ/ВШПИ.
// Цвета pblue/pgreen/pred/pgrey в исходном packages.tex определены, но
// нигде не задействованы (\newtheorem не раскрашен) — здесь они оставлены
// только для ручного использования (см. #let pblue и т.д.), стиль текста
// монохромный.

#let pblue = rgb("#2121ff")
#let pgreen = rgb("#008000")
#let pred = rgb("#e60000")
#let pgrey = rgb("#75747a")

// blue!70!black
#let accent = rgb("#0000b2")
#let ink = luma(0)
#let muted = luma(60)

// Счётчики окружений теорем сбрасываются на каждом subsection (level 2) —
// как в остальных конспектах проекта, а не сквозным счётом по документу.
#let theorem-counter-names = ("theorem", "defn", "lemma", "consequence", "statement", "remark", "example", "algorithmm", "question", "answer")

#let conspect(
  body,
  course-title: "Теория вероятностей",
  doc-title: "Теория вероятностей. Конспект лекций",
  author: "Ваня Герунов",
  header-quote: "",
) = {
  set document(title: doc-title, author: author)
  // documentclass не задаёт "a4paper", geometry тоже не переопределяет
  // бумагу — по умолчанию article использует US Letter, а не A4.
  //
  // Кегли ниже — не подбор на глаз, а таблица стандартных размеров LaTeX
  // для \documentclass[11pt]{article} (size11.clo): \normalsize=11pt,
  // \large=12pt, \Large=14.4pt, \Huge=24.88pt. Заголовок section — \Large,
  // subsection — \large, subsubsection — \normalsize (все жирные).
  //
  // Шапка — точно по реальному generic-шаблону 3 семестра (packages.tex/
  // template.tex, одинаковы во всех курсах: aads/acos/databases/diff eq/
  // formal lang/physics/probability): fancyhf{} + fancyhead[L]=цитата,
  // fancyhead[R]=\thepage, БЕЗ fancyfoot и без уменьшения шрифта шапки.
  // \pagenumbering{arabic} стоит сразу после \end{titlepage} — титульник
  // не входит в нумерацию, первая содержательная страница получает "1".
  set page(
    paper: "us-letter",
    margin: 2cm,
    numbering: none,
    header: context {
      if counter(page).get().first() > 1 {
        grid(
          columns: (1fr, auto),
          align(left)[#header-quote],
          align(right)[#(counter(page).get().first() - 1)],
        )
        v(-0.35em)
        line(length: 100%, stroke: 0.4pt + ink)
      }
    },
  )
  // New Computer Modern — тот же шрифт, которым pdflatex/xelatex обычно
  // рендерят Computer Modern (T2A/Cyrillic по умолчанию).
  set text(font: ("New Computer Modern", "Libertinus Serif", "Liberation Serif"), size: 11pt, lang: "ru", fill: ink)
  set par(justify: true, first-line-indent: (amount: 1.25em, all: true))

  // ----- Заголовки: обычная нумерация article-класса, без цвета и боксов -----
  set heading(numbering: "1.1")
  show heading.where(level: 1): set heading(numbering: "1.")

  show heading: it => {
    set text(fill: ink, weight: "bold")
    block(above: 1.4em, below: 0.8em, it)
  }

  show heading.where(level: 1): it => {
    for name in theorem-counter-names { counter(name).update(0) }
    block(width: 100%, above: 1.6em, below: 1em)[
      #set text(size: 14.4pt / 11pt * 1em)
      #if it.numbering != none [#counter(heading).display() ]
      #it.body
    ]
  }

  show heading.where(level: 2): it => {
    for name in theorem-counter-names { counter(name).update(0) }
    block(above: 1.2em, below: 0.6em)[
      #set text(size: 12pt / 11pt * 1em)
      #if it.numbering != none [#counter(heading).display() ]
      #it.body
    ]
  }

  show heading.where(level: 3): it => {
    block(above: 1em, below: 0.4em)[
      #it.body
    ]
  }

  // colorlinks=true, linkcolor/citecolor/urlcolor=blue!70!black
  show link: set text(fill: accent)
  show ref: set text(fill: accent)
  show raw.where(block: true): block.with(inset: 8pt, width: 100%)

  set table(stroke: 0.5pt + luma(100), inset: 6pt)

  body
}

// ===================== Окружения теорем (packages.tex \newtheorem) =====================
// В оригинале \theoremstyle не переопределён — используется стиль amsthm
// «plain» по умолчанию для всех окружений: жирная шапка «Название N.»,
// тело курсивом, без заливки и рамки, нумерация сквозная внутри секции.

#let plain-theorem(body, name: "", counter-name: "", title: none) = {
  let c = counter(counter-name)
  c.step()
  block(width: 100%, above: 1em, below: 1em, breakable: true)[
    #text(weight: "bold")[#name #context c.display()#if title == none [.]]
    #if title != none [ #text(style: "italic")[(#title).]]
    #h(0.4em)
    #emph(body)
  ]
}

#let theorem(body, title: none) = plain-theorem(body, name: "Теорема", counter-name: "theorem", title: title)
#let defn(body, title: none) = plain-theorem(body, name: "Определение", counter-name: "defn", title: title)
#let lemma(body, title: none) = plain-theorem(body, name: "Лемма", counter-name: "lemma", title: title)
#let consequence(body, title: none) = plain-theorem(body, name: "Следствие", counter-name: "consequence", title: title)
#let statement(body, title: none) = plain-theorem(body, name: "Утверждение", counter-name: "statement", title: title)
#let remark(body, title: none) = plain-theorem(body, name: "Замечание", counter-name: "remark", title: title)
#let example(body, title: none) = plain-theorem(body, name: "Пример", counter-name: "example", title: title)
#let algorithmm(body, title: none) = plain-theorem(body, name: "Алгоритм", counter-name: "algorithmm", title: title)
#let question(body, title: none) = plain-theorem(body, name: "Вопрос", counter-name: "question", title: title)
#let answer(body, title: none) = plain-theorem(body, name: "Ответ", counter-name: "answer", title: title)

// ===================== Вспомогательные блоки =====================

// Примечание общего вида (в оригинале аналога нет — минимальный, без цвета)
#let note(body) = block(width: 100%, above: 1em, below: 1em)[
  #text(style: "italic")[Примечание.] #body
]

// Ключевая формула — просто центрирована, без рамки (как \[ ... \] в article)
#let key(body) = align(center)[#body]

// Разделитель — тонкая линия на всю ширину, как обычный \hrule
#let divider() = block(width: 100%, above: 1em, below: 1em)[#line(length: 100%, stroke: 0.4pt + ink)]

// Титульный лист МФТИ/ВШПИ (см. \begin{titlepage} в template.tex):
// вуз/школа сверху, предмет и семестр, номер+название лекции по центру
// (с \vspace*{\fill} с обеих сторон), лектор и автор снизу — автор со
// ссылкой (в оригинале — фирменный рикролл).
#let titlepage(
  title: "Теория вероятностей",
  subtitle: "Конспект лекций",
  lecturer: none,
  semester: "3 семестр, 2026/2027 уч. год",
  lecture-number: none,
  lecture-title: none,
  author: "Ivan Gerunov",
  author-link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
) = align(center)[
  #text(size: 12pt)[Московский физико-технический институт] \
  #text(size: 12pt)[Высшая школа программной инженерии]
  #v(2cm)
  #text(size: 14.4pt, weight: "bold")[#title] \
  #text(size: 12pt)[#semester]
  #v(1fr)
  #if lecture-number != none [
    #text(size: 24.88pt, weight: "bold")[Лекция #lecture-number] \
  ]
  #if lecture-title != none [
    #text(size: 24.88pt, weight: "bold")[#lecture-title]
  ]
  #if lecture-number == none and lecture-title == none [
    #text(size: 22pt, weight: "bold")[#subtitle]
  ]
  #v(1fr)
  #if lecturer != none [
    #text(size: 12pt)[Лектор: #text(weight: "bold")[#lecturer]] \
  ]
  #text(size: 12pt)[Автор: #link(author-link)[#author]]
  #pagebreak(weak: true)
]
