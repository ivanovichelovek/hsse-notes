#import sys.inputs.preamble: *

= Семинар 2

#defn(title: "Класс языков P")[

  $P = limits(union)_(c=1)^infinity "DTIME"\(n^c\)$
]

#defn(title: "Класс языков NP")[

  $"NP" = limits(union)_(c=1)^infinity "NTIME"\(n^c\)$

  $"NP"$ - класс таких языков $L$, что существует ДМТ $V(x, s)$, работающая за полином от $ |x|:$$ cases(forall x in L exists s V(x,s)=1, forall x in.not L forall s V(x, s) = 0) $
]

#pagebreak()

= Семинар 3

== Класс coNP

#defn(title: "Класс языков coNP")[
  $ L in "coNP" <=> overline(L) in "NP" $
]

Переворачивая сертификатное определение NP для $overline(L)$, получаем:

#defn(title: "Сертификатное определение coNP")[
  $L in "coNP"$, если существует ДМТ $V(x, s)$, работающая за полином от $|x|$, такая что
  $ cases(forall x in L quad forall s quad V(x, s) = 1, forall x in.not L quad exists s quad V(x, s) = 0) $
]

То есть у слов #text(weight: "bold")[не] из языка есть короткое опровержение.

== Почему полином от $|x|$, а не от $|x| + |s|$

#exercise[
  Привести пример языка, который удовлетворяет сертификатному определению NP, если $V(x, s)$ работает за полином от $|x| + |s|$, но #text(weight: "bold")[не] удовлетворяет определению с полиномом от $|x|$.
]

#answer[
  Проблема остановки $"HALT" = {chevron.l M, w chevron.r : M "останавливается на" w}$.

  Сертификат — число шагов в унарной записи: $s = 1^t$. Верификатор $V(chevron.l M, w chevron.r, s)$ моделирует $M$ на $w$ не более $|s|$ шагов и выдаёт 1, если $M$ за это время остановилась. Время работы — полином от $|x| + |s|$.

  - Если $x in "HALT"$, то $M$ останавливается за какое-то $t$ шагов, и $s = 1^t$ подходит.
  - Если $x in.not "HALT"$, то $M$ не останавливается никогда, и $V(x, s) = 0$ при любом $s$.

  Но $"HALT"$ неразрешим, а $"NP" subset.eq "EXP"$ (см. ниже), поэтому $"HALT" in.not "NP"$.
]

#note[
  Если время $V$ — полином от $|x|$, то $V$ успевает прочитать только первые $"poly"(|x|)$ символов $s$, значит, сертификаты можно считать короткими: $|s| <= "poly"(|x|)$. Тогда перебор всех $s$ даёт $"NP" subset.eq "DTIME"(2^("poly"(n)))$. С полиномом от $|x| + |s|$ длина $s$ ничем не ограничена, и так определённый класс — это все перечислимые языки.
]

== Теорема об иерархии по времени

#theorem[
  Если $g$ конструируема по времени и $f(n) log f(n) = o(g(n))$, то
  $ "DTIME"(f(n)) subset.neq "DTIME"(g(n)) $
]

#consequence[
  $forall c quad "DTIME"(n^c) subset.neq "DTIME"(2^n)$.
]

Отсюда $P subset.eq "DTIME"(2^n)$ — но строгость прямо не следует: $P$ — бесконечное объединение, и теорема применяется к каждому $n^c$ по отдельности. Строгость получаем, поднявшись на ступень выше: $g(n) = 2^(2^n)$, $f(n) = 2^n$:

#key[
  $ P subset.eq "DTIME"(2^n) subset.neq "DTIME"(2^(2^n)) $
]

Аналогично, при $f(n) = 2^(n^(log n))$ (растёт быстрее любого $2^(n^c)$): $"NP" subset.eq "EXP" subset.eq "DTIME"(2^(n^(log n))) subset.neq "DTIME"(2^(2^n))$.

== NP-трудность и NP-полнота

#defn(title: "NP-трудный язык")[
  $L$ называется #text(weight: "bold")[NP-трудным] (NP-hard), если
  $ forall A in "NP" quad A <=_p L $
]

#defn(title: "NP-полный язык")[
  $L$ называется #text(weight: "bold")[NP-полным] ($L in "NPC"$), если $L in "NP"$ и $L$ NP-трудный.
]

#question[
  Что такое coNPC: $"co"("NPC")$ (дополнения NP-полных языков) или $("coNP")"C"$ (coNP-полные языки)?
]

#answer[
  Это одно и то же: $"co"("NPC") = ("coNP")"C"$.
]

#text(weight: "bold")[Доказательство.] Распишем по определению:

$ L in "co"("NPC") <=> overline(L) in "NPC" <=> cases(overline(L) in "NP", forall A in "NP" quad A <=_p overline(L)) $

Первое условие: $overline(L) in "NP" <=> L in "coNP"$.

Второе условие: $A <=_p overline(L)$ означает, что есть всюду определённая $f$, вычислимая за полином от $|x|$, с
$ x in A <=> f(x) in overline(L) $
Это то же самое, что $x in overline(A) <=> f(x) in L$, то есть $overline(A) <=_p L$ той же функцией $f$.

Когда $A$ пробегает NP, $B = overline(A)$ пробегает ровно coNP. Значит,

$ forall A in "NP" quad A <=_p overline(L) quad <=> quad forall B in "coNP" quad B <=_p L $

Вместе с $L in "coNP"$ это и есть $L in ("coNP")"C"$. Все переходы — равносильности, поэтому $"co"("NPC") = ("coNP")"C"$. $square$

#divider()

== Языки, заданные деревом вычислений

$N$ — НМТ, работающая за полином от $|x|$; $T_(N, x)$ — дерево вычислений $N$ на $x$ (все ветки конечны и имеют полиномиальную длину).

$ L_(exists +) = {x | "в " T_(N, x) " есть принимающая ветка"} in "NP" $

— это в точности язык, распознаваемый $N$.

$ L_(exists.not +) = {x | "в " T_(N, x) " нет принимающей ветки"} in "coNP" $

— это дополнение $L_(exists +)$.

$ L_(forall +) = {x | "все ветки " T_(N, x) " — принимающие"} in "coNP" $

Действительно, $overline(L_(forall +)) = {x | "в " T_(N, x) " есть отвергающая ветка"}$. Поменяем местами $q_a$ и $q_r$ в $N$ — получим НМТ $N'$ того же времени, у которой принимающие ветки ровно отвергающие ветки $N$. Значит, $overline(L_(forall +)) = L(N') in "NP"$.

#divider()

== $P subset.eq "NP" inter "coNP"$

#exercise[
  Доказать, что $P subset.eq "coNP"$ (и $P subset.eq "NP"$).
]

$P subset.eq "NP"$: верификатор $V(x, s)$ игнорирует $s$ и просто запускает полиномиальный алгоритм для $L$.

$P$ замкнут относительно дополнения (у ДМТ меняем местами $q_a$ и $q_r$), то есть $P = "coP"$. Поэтому

$ L in P <=> overline(L) in P => overline(L) in "NP" <=> L in "coNP" $

#key[
  $ P subset.eq "NP" inter "coNP" $
]

#note[
  Равенство $"NP" = "coNP"$ — открытая проблема (из $P = "NP"$ оно бы следовало).
]

#divider()

== Язык тавтологий

#exercise[
  Доказать, что язык тавтологий $"TAUT" = {phi | phi " — булева формула, истинная на всех наборах"}$ лежит в coNP.
]

#text(weight: "bold")[Решение.] Воспользуемся сертификатным определением coNP. Сертификат $s$ — набор значений переменных $phi$ (его длина не больше $|phi|$), $V(phi, s)$ — значение $phi$ на наборе $s$; оно вычисляется за полином от $|phi|$.

- $phi in "TAUT"$: $phi$ истинна на любом наборе, то есть $forall s quad V(phi, s) = 1$.
- $phi in.not "TAUT"$: есть опровергающий набор, то есть $exists s quad V(phi, s) = 0$.

Значит, $"TAUT" in "coNP"$. Эквивалентно: $overline("TAUT") = {phi | exists "набор, на котором " phi = 0} in "NP"$. $square$

#note[
  Более того, $"TAUT"$ coNP-полон: $phi in.not "SAT" <=> not phi in "TAUT"$, то есть $overline("SAT") <=_p "TAUT"$, а $overline("SAT")$ coNP-полон по доказанному выше (так как $"SAT" in "NPC"$).
]
