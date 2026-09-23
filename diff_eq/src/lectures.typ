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

= Третья лекция

1) $a_0 y^((n))+a_1 y^((n-1))+...+a_(n-1)y'+a_n y=0$, $a_0 != 0; a_0, a_1, ..., a_n in CC$

2) $chi(lambda) = a_0 lambda^n+a_1 lambda^(n-1)+...+a_n$ - характеристический многолчен

== Дифференциальные операторы, порождаемые многочленами

$f in C^infinity (RR), D=d/(d x) : C^infinity(RR)->C^infinity(RR)$

$D(f)=d/(d x)f(x)$, $D^k = D circle .. circle D = (d^k)/(d x^k), k in NN$

$I=D^0=I d$, $I(f)=f$

$P(lambda)=p_0 lambda^n + p_1 lambda^(n-1)+...+p_(n-1)^lambda + p_n$, $p_0, p_1, ..., p_n in CC$

$P(D)=p_0 D^n + p_1 D^(n-1) + ... + p_(n-1)D + p_n I$

#lemma()[
  Пусть $P, Q и R - $многочлены:

  $P(lambda) = Q(lambda) dot R(lambda)$. Тогда

  $P(D) = Q(D) circle R(D)$

  Док-во:

  Доказательство следует из справедливости следующих равенств:

  1. $(a D^k) circle (d D^m) = a b D^(k + m)$, $a, b in CC$
  2. $D^k circle (R_1 + r_2)(D) = D^k circle R_1(D) + D^k circle R_2(D)$
  3. $(Q_1+Q_2)(D) circle R(D) = Q_1(D) circle R(D) + Q_2(D) circle R(D)$

  $F in C^infinity (RR)=>((A D^k) circle (b D^m))f(x)=a D^k(b f^((m))(x)=a b f^((m + k))(x)=(a b D^(m+k))(f(x))$
]

#consequence()[
  Пусть $Q$ и $R$ - произвольные многочлены. Тогда $Q(D) circle R(D)=R(D) circle Q(D)$.
]

#theorem(title: "формула Двига")[
  Пусть $f in C(RR), lambda in CC, P - "многочлен"$. Тогда $P(D)(e^(lambda x)f(x))=e^(lambda x)P(D + lambda I)(f(x))$.

  Док-во:

  Заметим, что $D(e^(lambda x)f(x))=lambda e^(lambda x)f(x) = e^(lambda x)f'(x)=e^(lambda x)(D + lambda I)(f(x))$

  Покажем, что $D^k(e^(lambda x)f(x))=e^(lambda x)(D + lambda I)^k(f(x))$

  Докажем по индукции:

  База $k=1$ -проверена

  Пусть равенство верно до $k-1$. Проверим для $k$:

  $D^n (e^(lambda x)f(x)) = D circle D^(k-1)(e^(lambda x)f(x))=D(e^(lambda x) dot (D + lambda I)^(k-1)(f(x)))=e^(lambda x)(D + lambda I)^k(f(x))$

  Тогда, если $P(lambda)=limits(sum)_(k=0)^n p_k lambda^(n-k)$, то $P(D)=limits(sum)_(k=0)^n p_k D^(n-k)=>P(D)(e^(lambda x)f(x))=limits(sum)_(k=0)^n p_k D^(n-k)(c^(lambda x)f(x))=limits(sum)_(k=0)^n p_k e^(lambda x)(D + lambda I)^(n-k)(f(x))=e^(lambda x)P(D + lambda I)(f(x))$
]

#lemma(title: "*")[
  Пусть $x_0 in RR$  - фикс и $P(D)(e^(mu x) x^g)|_(x=x_0) = 0 forall j=0, 1, ..., k$

  Тогда $mu in CC$ - это корень многочлена $P$ кратности $s > k$.

  Замечание: $P(D)(e^(mu x))=e^(mu x) P(D + mu I)(1)=e^(mu x) dot P(mu)$

  Док-во:

  Индукция по k.

  База: $k=0$: $P(D)(e^(mu x))|_(x=x_0)=e^(mu x_0)P(mu)=0=>P(mu)=0=>mu-"корень" P(lambda)=0$, т.е. $s>=0$

  Шаг инфукции: Пусть утверждение справедливо для $k$. Покажем, что оно справедливо для $k+1$.

  Пусть $q_1,q_2,...,q_n$ - корни уравнения $P$.

  Из предположения следует, что $mu$ - корень кратности $s >= k + 1$. Без ограничения общности, тчо $q_1, q_2, ..., q_(k+1)=mu$. Тогда $P(lambda)=p_0(lambda - q_n)dot(lambda-q_(n-1)) dot ... dot (lambda-q_(k+2))(lambda - mu)^(k+1)=> P(D)(e^(mu x) x^(k+1))=e^(mu x)P(D + lambda I)(x^(k+1))=e^(mu x)Q(D+mu I)circle D^(k+1)(x^(k+1))$, где $Q(lambda)=p_0(lambda-q_n)(lambda - q(n-1))dot ... dot (lambda - q_(n+2))$

  Но $P(D)(e^(mu x)x^(k+1))|_(x=x_0)=0=>Q(D+mu I)(1)=Q(mu)=0=>mu -$ корень кратности $s >= k+2$ для $P$.
]

== Дифференциальные уравнения n-го порядка с простыми коэффициентами. Случай кратных корней

#theorem()[
  Пусть $lambda_1, lambda_2, ..., lambda_n$ - попарно различные корни хар. уравнения. $chi (lambda)=0$ алгебраические кратности которых $k_1, k_2, ..., k)m$ соответствует (k_1+k_2+...+k_m=n). Тогда общее решение уравнения (1) имеет вид:

  $ y(x)=limits(sum)_(j=1)^m P_j(x) e^(lambda_j x) $ (3)

  где $P_j(x)$ - многочлен степени $<= k_j - 1$, j=1

  Док-во:

  Покажем, что любая функци вида (3) является решением (1).

  Уранение (1) можно записать в следующем виде: $chi(D)(y(x))=0$.

  Достаточно убедиться, что решениями являются следующие функции: $e^(mu x), x e^(mu x), ..., x^(k-1)e^(mu x)$, где $mu$ - корень $chi(lambda)=0)$ кратности $k$.

  Тогда $chi(x)=zeta(lambda) dot (lambda - mu)^k$, $zeta(lambda)$ - многочлен, $zeta(mu)!=0$

  $=> chi(D)(x^j e^(mu x)) = e^(mu x) chi(D + mu I)(x^j)=e^(mu x) zeta(D + mu I) circle D^k(x^j)$, $j <= k - 1 => D^k(x^j)=0 => e^(mu x) zeta(D + mu I) circle D^k(x^j) equiv 0$

  т.е. $forall$ функция вида (3) - это решение (1).

  Покажем что $forall $ решение (1) имеет вид (3).

  Определим

  $y_1(x)=e^(lambda_1 x), y_(k_1+2)(x)=x e^(lambda_2 x), ..., y_(k_1+...+k_m)(x)=e^(lambda_m x), ..., y_n(x)=x^m e^(lambda_m x)$.

  Пусть $y(x)$ - решение уравнения (1) с начальными условиями $y(x_0)=y_0, y'(x_0)=y_0', ..., y^((n-1))(x_0)=y_0^(n-1)$

  Покажем, что $exists c_1, c_2, ..., c_n in CC$ $y(x)=limits(sum)_(k=1)^n c_k y_k(x)$

  $=> y^((j))(x_0)=limits(sum)_(k=1)^n c_k y_k^((j))(x_0)$, $j=0, 1, ..., n-1$ (4)

  Матрица системы (4):

  $M=...$

  Пусть M - вырожденая $=> exists f_0, f_1, ..., f_(n-1) in CC$

  $limits(sum)_(i=0)^(n-1)y_j^((i)) f_(x-1-i)=0 forall j=1, ..., n$

  Рассмотрим многочлен $P(lambda)=limits(sum))(i=0)^(n-1) b_(n-1-i) lambda^i$
]
