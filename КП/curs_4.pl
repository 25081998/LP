child('Aнна', 'Дмитрий').
child('Анна', 'Светлана').
child('Максим', 'Дмитрий').
child('Максим', 'Светлана').
child('Валерий', 'Николай').
child('Валерий', 'Татьяна').
child('Дмитрий', 'Николай').
child('Дмитрий', 'Татьяна').
child('Владимир', 'Виктор').
child('Владимир', 'Антонина').
child('Светлана', 'Виктор').
child('Светлана', 'Антонина').
child('Виктор', 'Мытарёв').
child('Клавдия', 'Мытарёв').
child('Мария', 'Мытарёв').
child('Валентина', 'Мытарёв').
child('Мария', 'Валерий').
child('Валерий', 'Валерий').
child('Антон', 'Владимир').
child('Татьяна', 'Алексей').
child('Татьяна', 'Зоя').
child('Виктор', 'Алексей').
child('Виктор', 'Зоя').
child('Николай', 'Борис').
child('Николай', 'Татьяна').
child('Юрий', 'Борис').
child('Юрий', 'Татьяна').

female('Светлана').
female('Анна').
female('Татьяна').
female('Антонина').
female('Клавдия').
female('Мария').
female('Валентина').
female('Людмила').
female('Тамара').
female('Валентина').
female('Нина').
female('Мария').
female('Зоя').
female('Татьяна').

male('Дмитрий').
male('Максим').
male('Николай').
male('Виктор').
male('Владимир').
male('Мытарёв').
male('Владимир').
male('Валерий').
male('Валерий').
male('Антон').
male('Алексей').
male('Виктор').
male('Борис').
male('Юрий').

move(mother, X, Y) :- 
	female(X),
 	child(Y, X).
 	
move(father, X, Y) :- 
	male(X),
 	child(Y, X).

move(daughter, X, Y) :-  
	female(X),
	child(X, Y).
	
move(son, X, Y) :-  
	male(X),
	child(X, Y).

move(wife, X, Y) :-
	female(X),
	male(Y),
	child(Z, X),
	child(Z, Y).
	
move(husband, X, Y) :-
	female(Y),
	male(X),
	child(Z, X),
	child(Z, Y).

move(sister, X, Y) :-
	female(X),
	child(X, Z),
	child(Y, Z).
	
move(brother, X, Y) :-
	male(X),
	child(X, Z),
	child(Y, Z).
	
move(grandmother, X, Y) :-
	female(X),
	child(Z, X),
	child(Y, Z).
	
move(grandfather, X, Y) :-
	male(X),
	child(Z, X),
	child(Y, Z).

move(granddaughter, X, Y) :-
	female(X),
	child(X, Z),
	child(Z, Y).
	
move(grandson, X, Y) :-
	male(X),
	child(X, Z),
	child(Z, Y).	

way([X|T], [Y, X|T]):-
  move(_, X, Y),
  not(member(Y, [X|T])).

natural(1).
natural(B) :- natural(A), B is A + 1.

itdpth([A|T], A, [A|T], 0).

itdpth(P, A, L, N) :-
  	N > 0,
  	way(P, Pl),
  	Nl is N - 1,
  	itdpth(Pl, A, L, Nl).

id_search(Until, After, L) :-
  	natural(N),
  	itdpth([Until], After, L, N), !.

translator([H, R], [W]) :- move(W, R, H), !.
translator([H, R|T], TQ) :- 
	translator([R|T], TY), move(W, R, H), 
	append(TY, [W], TQ), !.

printer([]).
printer([H|T]) :- write(' - '), write(H), delete([H|T], H, T1), printer(T1).

relative(W, X, Y) :- (findall(Q, move(W, Q, X), Y), !; id_search(X, Y, L), translator(L, W), write('W '), printer(W)).

