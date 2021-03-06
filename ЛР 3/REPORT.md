#№ Отчет по лабораторной работе №3
## по курсу "Логическое программирование"

## Решение задач методом поиска в пространстве состояний

### студент: Бабичева А. Д. М8О-204Б-17

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|    5.11      |       5       |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Метод поиска в пространстве состояний является основным методом решения задач искусственного интеллекта, и именно пространство состояний определяет вид конечного решения. Множество решений при таком подходе представляется ориентированным графом, вершинами которого являются текущие состояния, а ребрами - переходы. Достижение решения сводится к поиску кратчайшего пути до него.

Prolog имеет необходимый инструментарий для реализации подобных графов. Для перехода целесообразно будет использовать встроенный предикат move, а любое состояние можно описать собственным предикатом. Путем перебора различных конфигураций данных будет осуществляться движение по графу. Именно поэтому Prolog отлично подходит для решения подобных задач.

## Задание

2. Три миссионера и три каннибала хотят переправиться с левого берега реки на правый. Как это сделать за минимальное количество шагов, если в их распоряжении 3-х местная лодка и ни при каких обстоятельствах миссионеры не должны остаться в меньшинстве?

## Принцип решения

Опишите своими словами принцип решения задачи, приведите важные фрагменты кода. Какие алгоритмы поиска вы использовали? 

Для решения данной задачи необходимо реализовать алгоритмы поиска: в ширину, в глубину и с итерационным углублением.

Возможными состояниями в лодке и на берегу могут быть:

```
can(["К", "М", "М"]).
can(["К", "М"]).
can(["К", "К"]).
can(["М"]).
can(["К"]).
```

Переход между состояниями будет происходить с помощью предиката move, аргументами которого будут начальное, конечное состояния и номер берега:

```
move(Until, After, 1) :-
  	can(Between),
  	away(Until, Between, After),
  	number_of_elems(After, "К", N2),
  	number_of_elems(After, "М", M2),
  	check_state(M2, N2),
  	away(["К", "К", "К", "М", "М", "М"], After, Another),
  	number_of_elems(Another, "К", N3),
  	number_of_elems(Another, "М", M3),
  	check_state(M3, N3).

move(Until, After, 2) :-
  	can(Between),
  	away(After, Between, Until),
  	number_of_elems(After, "К", N2),
  	number_of_elems(After, "М", M2),
  	check_state(M2, N2),
  	away(["К", "К", "К", "М", "М", "М"], After, Another),
  	number_of_elems(Another, "К", N3),
  	number_of_elems(Another, "М", M3),
  	check_state(M3, N3).
```

Проверка возможности следующего состояния будет производиться сравнением количества каннибалов и мессионеров:

```
check_state(X, Y) :- X >= Y, !.
check_state(X, Y) :- X = 0, !.
check_state(_, Y) :- Y = 0, !.
```

Для формирования списка путевых состояний используется:

```
way([state(X, 1)|T], [state(Y, 2), state(X, 1)|T]):-
  	move(X, Y, 1),
  	not(mymember(state(Y, 2), [state(X, 1)|T])).

way([state(X, 2)|T], [state(Y, 1), state(X, 2)|T]):-
  	move(X, Y, 2),
  	not(mymember(state(Y, 1), [state(X, 2)|T])).
```

Поиск в глубину:

```
dsrch([state(X, 2)|T], X, [state(X, 2)|T]).

dsrch([state(R, N)|P], X, L):-
  	way([state(R, N)|P], P1),
  	dsrch(P1, X, L).


dpth_search(Until, After):-
 	get_time(Time1),
 	dsrch([state(Until, 1)], After, L),
 	get_time(Time2),
 	T is Time2 - Time1,
 	write('Time: '),
 	writeln(T),
 	printer(L).
```

Поиск в ширину:

```
bdth([[state(X, 2)|T]|_], X, [state(X, 2)|T]).

bdth([B|P], X, L):-
  	findall(W, way(B, W), Q),
  	append(P, Q, QP),!, 
  	bdth(QP, X, L);
  	bdth(P, X, L).

bdth_search(Until, After):-
  	get_time(Time1),
  	bdth([[state(Until, 1)]], After, L),
  	get_time(Time2),
  	T is Time2 - Time1,
  	write('Time: '),
  	writeln(T),
  	printer(L).
```

Поиск с итерационным углублением:

```
itdpth([state(A, 2)|T], A, [state(A, 2)|T], 0).

itdpth(P, A, L, N) :-
  	N > 0,
  	way(P, Pl),
  	Nl is N - 1,
  	itdpth(Pl, A, L, Nl).

id_search(Until, After) :-
  	get_time(Time1),
  	natural(N),
  	itdpth([state(Until, 1)], After, L, N),
  	get_time(Time2),
  	T is Time2 - Time1,
  	write('Time: '),
  	writeln(T),
  	printer(L), !.
```

## Результаты

```
?- id_search(["М", "М", "М", "К", "К", "К"], []).
Time: 0.009680747985839844
1: [М,М,М,К,К,К] —> 2:[]
1: [М,М,К,К] —> 2:[К,М]
1: [М,М,М,К,К] —> 2:[К]
1: [М,К] —> 2:[К,К,М,М]
1: [К,М,М,К] —> 2:[К,М]
1: [К] —> 2:[К,К,М,М,М]
1: [М,К] —> 2:[К,К,М,М]
1: [] —> 2:[К,К,К,М,М,М]
true.
?- bdth_search(["М", "М", "М", "К", "К", "К"], []).
Time: 0.003154754638671875
1: [М,М,М,К,К,К] —> 2:[]
1: [М,М,К,К] —> 2:[К,М]
1: [М,М,М,К,К] —> 2:[К]
1: [М,К] —> 2:[К,К,М,М]
1: [К,М,М,К] —> 2:[К,М]
1: [К] —> 2:[К,К,М,М,М]
1: [М,К] —> 2:[К,К,М,М]
1: [] —> 2:[К,К,К,М,М,М]
true .
?- dpth_search(["М", "М", "М", "К", "К", "К"], []).
Time: 0.0006678104400634766
1: [М,М,М,К,К,К] —> 2:[]
1: [М,М,К,К] —> 2:[К,М]
1: [М,М,М,К,К] —> 2:[К]
1: [М,К] —> 2:[К,К,М,М]
1: [К,М,М,К] —> 2:[К,М]
1: [К] —> 2:[К,К,М,М,М]
1: [М,К] —> 2:[К,К,М,М]
1: [] —> 2:[К,К,К,М,М,М]
true .
```

! Алгоритм поиска |  Длина найденного первым пути  |  Время работы      |
|-----------------|--------------------------------|--------------------|
| В глубину       |   7                            |0.000667810440063476|
| В ширину        |   7                            |0.003154754638671875|
| ID              |   7                            |0.009680747985839844|

## Выводы

Это лабораторная работу позволила мне прикоснуться к задачам искуственного интеллекта в пространстве состояний, попробовать себя в решении подобной задачи. Я научилась анализировать состояния на предмет их допустимости в условиях конкретной задачи, познакомилась со встроенными предикатами move и get_time. Помиомо этого, я познакомилась с реализацией на Prolog обычной в нашем понимании арифметики.

Также я познакомилась с реализацией методов поиска на языке Prolog, которая существенно отличается от реализации на императивных языках программирования. Однозначно, Prolog позволяет в несколько раз сократить код для реализации данных алгоритмов.

Какие алгоритмы поиска в каких случаях удобно использовать? Какие оказались оптимальными в вашем конкретном случае?

Я считаю, что самым эффективным по памяти алгоритмом из представленных является поиск с итерационным углублением. Его можно использовать в условиях ограниченной памяти.

Самым эффективным по времени оказался алгоритм поиска в глубину. Однако им не стоит злоупотреблять при решении задачи о нахождении кратчайшего пути, так как решением может оказаться самый "глубокий" путь. Следует отметить, что в данной задаче все алгоритмы нашли путь длиной 7.

Наименее эффективным по памяти, однако более эффективным по времени (чем поиск с итерационным углублением), стал поиск в ширину, который я бы не стала в дальнейшем использовать, ведь он показал средние результаты относительно других алгоритмов.

Подобный опыт очень важен, так как решение таких задач на логических языках позволяет взгялнуть иначе на подход к нему.
