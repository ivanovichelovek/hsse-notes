#import sys.inputs.preamble: *

= Семинар 2

#defn(title: "Класс языков P")[

  $P = limits(union)_(c=1)^infinity "DTIME"\(n^c\)$
]

#defn(title: "Класс языков NP")[

  $"NP" = limits(union)_(c=1)^infinity "NTIME"\(n^c\)$

  $"NP"$ - класс таких языков $L$, что существует ДМТ $V(x, s)$, работающая за полином от $ |x|:$$ cases(forall x in L exists s V(x,s)=1, forall x in.not L forall s V(x, s) = 0) $
]
