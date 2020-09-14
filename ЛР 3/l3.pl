number_of_elems([], X, 0).
number_of_elems([X|T], X, M) :- !, number_of_elems(T, X, N), M is N+1.
number_of_elems([H|T], X, N) :- number_of_elems(T, X, N).

findel([H|L], H, L) :- !.
findel([H|L], X, [H|L1]) :- findel(L, X, L1).

% отделение уплывших

away(L, [], L) :- !.
away([X|T], [X|T1], L) :- !,  away(T, T1, L).
away([H|T], L, L3) :- findel(L, H, L2), !, away(T, L2, L3).
away([H|T], L, [H|L2]) :- away(T, L, L2).

% проверка возможности

check_state(X, Y) :- X >= Y, !.
check_state(X, Y) :- X = 0, !.
check_state(_, Y) :- Y = 0, !.

% возможные состояния

can(["К", "М", "М"]).
can(["К", "М"]).
can(["К", "К"]).
can(["М"]).
can(["К"]).

equal(L, X) :- away(L, X, []).

mymember(state(X, N), [state(H, M)|T]) :- N = M, equal(X, H), !.
mymember(X, [H|T]) :- mymember(X, T), !.

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
  	
printer([state(X, 1)]):- write("1: "), write(X), away(["К", "К", "К", "М", "М", "М"], X, Y), write(' --> '), write("2:"), writeln(Y).

printer([state(X, _)|T]):- printer(T), write("1: "), write(X), away(["К", "К", "К", "М", "М", "М"], X, Y), write(' --> '), write("2:"), writeln(Y).

% путь

way([state(X, 1)|T], [state(Y, 2), state(X, 1)|T]):-
  	move(X, Y, 1),
  	not(mymember(state(Y, 2), [state(X, 1)|T])).

way([state(X, 2)|T], [state(Y, 1), state(X, 2)|T]):-
  	move(X, Y, 2),
  	not(mymember(state(Y, 1), [state(X, 2)|T])).

% поиск в глубину

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

% поиск в ширину

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

% поиск с итерационным углублением

natural(1).
natural(B) :- natural(A), B is A + 1.

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
