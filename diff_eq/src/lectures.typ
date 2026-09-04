#import sys.inputs.preamble: *

// Катмулл-Ром -> кубический Безье: гладкая кривая через заданные точки
// (встроенного сплайна в Typst нет, внешние пакеты для этого не нужны).
#let catmull-ctrl(p0, p1, p2, p3) = (
  (p1.at(0) + (p2.at(0) - p0.at(0)) / 6, p1.at(1) + (p2.at(1) - p0.at(1)) / 6),
  (p2.at(0) - (p3.at(0) - p1.at(0)) / 6, p2.at(1) - (p3.at(1) - p1.at(1)) / 6),
)
#let smooth-open(pts) = {
  let n = pts.len()
  range(n - 1).map(i => {
    let p0 = pts.at(calc.max(0, i - 1))
    let p1 = pts.at(i)
    let p2 = pts.at(i + 1)
    let p3 = pts.at(calc.min(n - 1, i + 2))
    let (c1, c2) = catmull-ctrl(p0, p1, p2, p3)
    curve.cubic(c1, c2, p2)
  })
}
// Стрелка-треугольник: остриё ровно в точке tip (глиф ▲/▶ ставится по
// метрикам шрифта и на конце линии выглядит смещённым).
#let arrowhead(tip, dir) = {
  let (x, y) = tip
  let pts = if dir == "up" {
    ((x, y), (x - 2.6pt, y + 7pt), (x + 2.6pt, y + 7pt))
  } else if dir == "right" {
    ((x, y), (x - 7pt, y - 2.6pt), (x - 7pt, y + 2.6pt))
  } else {
    ((x, y), (x + 7pt, y - 2.6pt), (x + 7pt, y + 2.6pt))
  }
  place(top + left, curve(
    fill: ink, stroke: none,
    curve.move(pts.at(0)), curve.line(pts.at(1)), curve.line(pts.at(2)), curve.close(),
  ))
}

#align(center)[
  #text(size: 0.95em)[
    Лектор: #link("mailto:serega-saulin@mail.ru")[Саулин Сергей Михайлович] \
    #text(fill: muted)[
      #link("mailto:serega-saulin@mail.ru")[serega-saulin\@mail.ru] (в приоритете)
      #h(0.6em) · #h(0.6em)
      #link("mailto:saulin.sm@phystech.edu")[saulin.sm\@phystech.edu]
    ]
  ]
]

= Литература

+ #link("https://www.klex.ru/2bgw")[Понтрягин - обыкновенные дифференциальные уравнения]
+ #link("https://e.lanbook.com/book/59554")[Петровском - Лекции по теории обыкновенных дифференциальных уравнений]

#pagebreak()

= Первая лекция

== Уравнения, разрешённые относительно старшей производной

#defn(title: "Дифференциальное уравнение n-го порядка")[
  #grid(
    columns: (1fr, auto),
    align: (center + horizon, horizon),
    $ F(x,y,y',...,y^(\(n\)))=0 $, [(1)],
  )
  $x in I subset RR$ - интервал
  $y=y(x), y:I -> RR$ - n раз дифференцируема
  $F$ зависит от $y^(\(n\))$ не фиктивно
]

#defn(title: "Решение дифференциального уравнения (1)")[
  $phi:I -> RR$ - решение (1), если $phi$ - n раз дифференцируема на $I$ и $F(x, phi (x), phi '(x), ..., phi ^ (\(n\)) \(x\)) equiv 0$
]

#defn(title: "Общее решение дифференциального уравнения (1)")[
  Множество всех решений уравнения (1).
]

#defn(title: "Уравнение, разрешённое относительно старшей производной")[
  (1) - это уравнение, разрешённое относительно старшей производной, если $exists Phi : G -> RR, G subset RR ^ (n+1)$ - область $: y^ (\(n\)) = Phi (x, y, y', ..., y^ (\(n-1\)))$.
]

#defn(title: "Система ДУ в нормальной форме")[
  Система ДУ называется системой в нормальной форме, если она может быть записана в виде

  #grid(
    columns: (1fr, auto),
    align: (center + horizon, horizon),
    $ cases(
      y_1' = f_1 (x, y_1, ..., y_n),
      y_2' = f_2 (x, y_1, ..., y_n),
      ...,
      y_n' = f_n (x, y_1, ..., y_n),
    ) $, [(2)],
  )
  $ f_k: G -> RR $
  $ G subset RR^(n+1) - "область" $
  $ y(x) = vec(y_1(x), ..., y_n (x)) $
  $ f(x, y) = vec(f_1(x, y), f_2(x, y), ..., f_n (x, y)) $
  $ y' = f(x, y) $
]

#defn(title: "Область")[
  Область - открытое связное множество.
]

#remark(title: none)[
  Любое ДУ (1), разрешимое относительно старшей производной, может быть записано в виде системы ДУ в нормальной форме.

  $ y_1 := y, y_2 = y_1' = y', ..., y_n = y_(n-1) ' = y^(\(n-1\)) $

  Тогда

  $ cases(
    y_1 ' = y_2,
    y_2 ' = y_3,
    ...,
    y_(n-1) ' = y_n,
    y_n ' = Phi (x, y_1, y_2, ..., y_n),
  ) $

  $f(x, y_1, ..., y_n) = vec(y_2, y_3, ..., y_n, Phi (x, y_1, ..., y_n))$
]

#theorem(title: "Формулировка теоремы о существовании и единственности решения Задачи Коши")[
  Пусть $ f: G -> RR^n$, $G$ - область в $RR^(n+1)$, $(x_0, y_0) in G$.

  Тогда Задача Коши для ДУ $y'=f(x,y)$ называется

  #grid(
    columns: (1fr, auto),
    align: (center + horizon, horizon),
    $ cases(
      y' = f(x,y),
      y(x_0) = y_0,
    ) $, [(4)],
  )
  (4) называется начальное условие

  Решением ЗК называется такая вектор-функция $y:I -> RR^n$, где $I subset RR$ - интервал, $x_0 in I$:

  1. $y'(x)=f(x, y(x)) forall x in I$
  2. $y(x_0)=y_0$

  #align(center)[
    #box(width: 200pt, height: 240pt)[
      // Контур области G: путь начинается и заканчивается в точке излома,
      // поэтому рисуем его как ОТКРЫТУЮ кривую — тогда в этой точке
      // получается настоящий уголок, а не сглаженный сплайном изгиб.
      #let blob-pts = (
        (133pt, 110pt), (103pt, 95pt), (95pt, 65pt), (115pt, 40pt),
        (125pt, 25pt), (155pt, 23pt), (178pt, 35pt), (188pt, 60pt),
        (182pt, 85pt), (163pt, 100pt), (133pt, 110pt),
      )
      // Интегральная кривая через (x_0, y_0): от неё строятся горизонталь
      // к уровню y_0 и вертикали к оси x.
      #let sol-pts = (
        (112pt, 74pt), (118pt, 70pt), (130pt, 60pt),
        (140pt, 47pt), (150pt, 35pt), (156pt, 31pt),
      )

      // оси
      #place(top + left,
        curve(
          stroke: (paint: ink, thickness: 0.8pt, cap: "round"),
          curve.move((60pt, 15pt)), curve.line((60pt, 205pt)),
          curve.move((25pt, 190pt)), curve.line((180pt, 190pt)),
        )
      )
      #arrowhead((60pt, 12pt), "up")
      #arrowhead((183pt, 190pt), "right")

      // уровень y0 — от оси y до начала интегральной кривой
      #place(top + left,
        curve(
          stroke: (paint: ink, thickness: 0.5pt, dash: "dashed"),
          curve.move((60pt, 70pt)), curve.line((118pt, 70pt)),
        )
      )

      // область G
      #place(top + left,
        curve(
          stroke: (paint: ink, thickness: 1pt, join: "round", cap: "round"),
          curve.move(blob-pts.at(0)),
          ..smooth-open(blob-pts),
        )
      )

      // интегральная кривая
      #place(top + left,
        curve(
          stroke: (paint: ink, thickness: 1.1pt, cap: "round"),
          curve.move(sol-pts.at(0)),
          ..smooth-open(sol-pts),
        )
      )

      // вертикали от концов кривой к оси x и засечки на оси
      #place(top + left,
        curve(
          stroke: 0.8pt + ink,
          curve.move((118pt, 70pt)), curve.line((118pt, 190pt)),
          curve.move((150pt, 35pt)), curve.line((150pt, 190pt)),
          curve.move((118pt, 186pt)), curve.line((118pt, 194pt)),
          curve.move((150pt, 186pt)), curve.line((150pt, 194pt)),
        )
      )

      // Δx0
      #place(top + left,
        curve(
          stroke: 0.6pt + ink,
          curve.move((118pt, 202pt)), curve.line((150pt, 202pt)),
        )
      )
      #arrowhead((118pt, 202pt), "left")
      #arrowhead((150pt, 202pt), "right")

      // скобка интервала I
      #place(top + left,
        curve(
          stroke: 0.6pt + ink,
          curve.move((118pt, 216pt)), curve.line((118pt, 220pt)),
          curve.line((150pt, 220pt)), curve.line((150pt, 216pt)),
        )
      )

      // подписи
      #place(top + left, dx: 52pt, dy: 3pt)[$y$]
      #place(top + left, dx: 42pt, dy: 63pt)[$y_0$]
      #place(top + left, dx: 168pt, dy: 15pt)[$G$]
      #place(top + left, dx: 178pt, dy: 192pt)[$x$]
      #place(top + left, dx: 122pt, dy: 206pt)[#text(size: 8pt)[$Delta x_0$]]
      #place(top + left, dx: 130pt, dy: 224pt)[$I$]
    ]
  ]
]

#note[
  $xi in RR^n$ - евклидова длина ($|xi|=sqrt(xi_1^2+...+xi_n^2), xi=(xi_1, ..., xi_n)^T$)
]

#defn(title: "Липшицева по y функция (в G)")[
  $f:G -> RR^n$ - липшицево в $G$ по совокупности $y$, если $exists L > 0: forall y_1, y_2: (x, y_1), (x, y_2) in G => |f(x, y_1) - f(x, y_2)| <= L |y_1 - y_2|$. L - константа липшицева.

  Обозначается: $f in "Lip"_y(G)$.
]

#defn(title: "Локально липшицева по y функция")[
  f - локально липшицево в $G$ по $y$, если $forall (x_0, y_0) in G " " exists epsilon > 0: f in "Lip"_y (B_epsilon (x_0, y_0))$

  Обозначается: $f in "LocLip"_y (G)$
]

#exercise[
  $f, f_y' in C(G), G subset RR^2$ - область.

  Тогда $forall K subset G$ - компакта $f in "Lip"_y (K)$.

  $f'_y(x,y) = (d f)/(d y)(x,y)$
]

#defn(title: "Локальное совпадение решений")[
  Пусть $y_1: I_1 -> RR^n, y_2: I_2 -> RR^n$ - два решения ЗК (4), $I_1, I_2 subset RR$ - интервал, $x_0 in I_1 inter I_2$. Говорят, что $y_1(x)$ и $y_2(x)$ локально совпадают, если $exists I subset I_1, I subset I_2 : x_0 in I : y_1(x)=y_2(x) forall x in I$.
]

#theorem(title: "Теорема Коши-Липшица (локальное существование и единственность)")[
  Пусть $f in C(G), f in "LocLip"_y(G)$, $G subset RR^(n+1)$ - область. Тогда $forall (x_0, y_0) in G exists I subset RR$ - интервал, $x_0 in I$, $exists y: I -> RR^n$. $y'(x)=f(x,y(x)) forall x in I$ и $y(x_0)=y_0$

  Причём такая функция локально единственная.
]

== Линейное однородное ДУ с постоянными коэффициентами

#grid(
  columns: (1fr, auto),
  align: (center + horizon, horizon),
  $ y^(\(n\))+a_1 y^(\(n-1\))+...+a_(n-1) y'+a_n y=0 $, [(5)],
)

$a_1, a_2, ..., a_n in RR (CC)$ $y: RR -> CC$

#remark(title: none)[
  + Пусть y(x) - решение (5). Тогда $c dot y(x)$ - тоже решение (5) $forall c in RR$

  + Пусть $y_1(x)$ и $y_2(x)$ - решение (5). Тогда $y(x) = y_1(x) + y_2(x)$ - тоже решение (5).

  => Множество решений (5) - это линейное пространство
]

#defn(title: "Характеристический многочлен")[
  $chi (lambda)=lambda^n+a_1 lambda^(n-1)+...+a_(n-1) lambda + a_n$ - характеристический многочлен уравнения (5)
]

#defn(title: "Характеристическое уравнение")[
  $chi (lambda)=0$ - характеристическое уравнение.
]

#pagebreak()

//#theorem(title: "")[
//
//]
