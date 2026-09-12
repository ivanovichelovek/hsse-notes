#import sys.inputs.preamble: *

// почта: umnov.ea\@phystech.edu

= Первый семинар

$ F(x, y(x), y'(x), ..., y^(\(n\)) (x) = 0 $

#align(center)[$y^(\(n\)) = f(x, y, ..., y^(\(n-1\)))$ - ДУ в нормальной форме]

#divider()

#align(center)[== Методы решений]

$Phi (x, y(x)) = c, c in RR$

$Phi_x ' + Phi_y ' dot y_x '$

$y_x ' = (d y)/(d x)$

$ => Phi_x ' d x + Phi_y ' d y = 0 equiv Phi_x ' (x, y(x)) = c, c in RR$

$  $

$ f_1 (x) equiv f_2(x) $
$ => ? $ // arrow down
$ f_1 ' (x) equiv f_2 ' (x) $

$ P(x) d x + Q(y) d y = 0 $

#problem(title: "№ 10")[

  $x(y + 1) d y = (1 - y^2) d x$

  $y = -1$ - решение => можно на него поделить

  $x d y = (1 - y) d x$

  $(d y)/(1 - y)=(d x)/(x)$ (но это не эквивалентно предыдущему уравнению, так как область значений изменилась, поэтому проверяем y = 1 и x = 0, это решения).

  $-ln|1-y|=ln|x|+C, C in RR$ ($C = ln K, K>0$)

  $ln K|x||y-1|=0$

  $K|x||y-1|=1, K>0$

  $tilde(K) x \(y - 1\) = 1, tilde(K) != 0$ (когда модули больше нуля, $tilde(K) = K$, иначе $tilde(K) = -K$)

  $x\(y - 1\) = alpha = 1/tilde(K)$

  $x\(y - 1\) = beta, beta in RR$

  (Ответ: или $x(y - 1) = beta, beta in RR$, или y = 1)
]

#problem(title: "№ 62")[

  $y' = cos(y - x)$

  Замена: $z(x) = y - x$, $y' = z' + 1$

  $z' + 1 = cos(z)$

  $(d z)/(d x) + 1 = cos(z)$

  $d x=(d z)/(cos(z) - 1)$, Проверяем $cos(z) - 1 = 0$ является ли решением. Это является решением при $y equiv x + 2 pi n, n in ZZ$

  $cos x = 1 - 2 sin^2\(x/2\)$

  $integral 1/(cos x - 1) d x = integral 1/(-2 sin^2 (x/2) d x = ctg x/2 + C$

  Ответ: или $x = ctg (y - x)/2 + C, C in RR$, или $y equiv x + 2 pi n, n in ZZ$
]

#problem(title: "№ 224")[
  $(2 x + y + 2) d x - (4 x + 2 y + 9) d y = 0$

  $z = 2 x + y + z$, $y = z - 2 x - 2$, $d y = -2 d x + d z$

  $z d x - (2 z + 5)d(z - 2 x - 2) = 0$

  $z d x - (2 z + 5)(d z - 2 d x) = 0$

  $z d x - 2 z d z - 5 d z + 4 z d x + 10 d x = 0$

  $d z (- 2 z - 5) = d x (- 5 z - 10)$

  $5 d x = (2z + 5)/(z + 2) d z$

  $z + 2 = 0$

  $2 x + y + 4 = 0$

  $y = -2x + 4$ => решение

  $d z (2z + 5)/(z + 2) = 5 d x$

  $integral (2z + 5)/(z + 2) d z = 5x$

  $integral (2 + 1/(x + 2) d z = 5 x$

  $2 z + ln|z + 2| + C = 5 x, C in RR$

  $4 x + 2 y + 4 + ln|2 x + y + 4| = 5 x + C, C in RR$

  $2y + ln|2x + y + 4| = x + tilde(C), tilde(C) in RR$
]
