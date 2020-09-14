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
	
q_who(X) :- member(X, ['Who', 'who']).
q_how(X) :- member(X, ['How', 'how']).
q_to_be(X) :- member(X, ['Is', 'is', 'Are', 'are']).
q_she(X) :- member(X, ['she', 'her']).
q_he(X) :- member(X, ['he', 'him', 'his']).
q_do(X) :- member(X, ['Do', 'do', 'Does', 'does']).
q_have(X) :- member(X, ['have', 'has']).
q_for(X) :- member(X, ['for', 's']).
q_many(X) :- member(X, ['many']).


start :-
  	nb_setval(lastName, 'NONE'),
	writeln("Enter your questions:"),
  	repeat, 	
  	readln(Line),
  	((answer(Line), fail);(Line = [exit], !)).

%+How many RELATIVE's does HE/SHE have?
answer([Hw, M, R, _, S, D, It, Hv, '?']) :-
	q_how(Hw),
	q_many(M),
	q_do(D),
	(q_he(It); q_she(It)),
	q_have(Hv),
	q_for(S),
	move(R, _, _),
	nb_getval(lastName, X),
	findall(Q, move(R, Q, X), T), %!,
	numizmat(T, N),
	write(It), write(" has "), write(N), write(" "), write(R), writeln("s."), !.

%+How many RELATIVE's does PERSON have?
answer([Hw, M, R, _, S, D, P, Hv, '?']) :-
	q_how(Hw),
	q_many(M),
	q_do(D),
	q_have(Hv),
	q_for(S),
	move(R, _, _),
	nb_setval(lastName, P),
	findall(Q, move(R, Q, P), T), !,
	numizmat(T, N),
	write(P), write(" has "), write(N), write(" "), write(R), writeln("s."), !.
	
%+Who is PERSON's RELATIVE ? 
answer([Who, Is, P, _, S, R, '?']) :-
	q_who(Who),
	q_to_be(Is),
	q_for(S),
	move(R, _, _),
	nb_setval(lastName, P),
	findall(Q, (move(R, Q, P)), T), !,
  	write(P), write("'s "), write(R), writeln(" is "), printer(T), !.

%+Who is IS/HER RELATIVE ? 
answer([Who, Is, It, R, '?']) :-
	q_who(Who),
	q_to_be(Is),
	move(R, _, _),
	nb_getval(lastName, X),
	findall(Q, (move(R, Q, X)), T), !,
  	write(It), write(" "), write(R), writeln(" is "), printer(T), !.

%+Is PERSON HIS/HER RELATIVE ?
answer([Is, P, It, R, '?']) :-
	q_to_be(Is),
	(q_he(It); q_she(It)),
	move(R, _, _),
	nb_getval(lastName, X),
	(move(R, P, X) -> writeln("Yes"); not(move(R, P, X)) -> writeln("No")), !.
	
%+Is HE/SHE PERSON's RELATIVE ?
answer([Is, It, P, _, S, R, '?']) :-
	q_to_be(Is),
	(q_he(It); q_she(It)),
	q_for(S),
	move(R, _, _),
	nb_getval(lastName, X),
	(move(R, X, P) -> writeln("Yes"); not(move(R, X, P)) -> writeln("No")), !.
	
%+Is PERSON PERSON's RELATIVE ? 
answer([Is, P1, P2, _, S, R, '?']) :-
	q_to_be(Is),
	q_for(S),
	(move(R, P1, P2) -> writeln("Yes"); not(move(R, P1, P2)) -> writeln("No")), !.

%+Who is RELATIVE for HIM/HER ?
answer([Who, Is, R, For, It, '?']) :-
	q_who(Who),
	q_to_be(Is),
	q_for(For),
	(q_he(It); q_she(It)),
	nb_getval(lastName, X),
	findall(Q, (move(R, Q, X)), T), %!,
  	write(R), write(" for "), write(It), writeln(" is "), printer(T), !.

%+Who is RELATIVE for PERSON ? 
answer([Who, Is, R, For, P, '?']) :-
	q_who(Who),
	q_to_be(Is),
	q_for(For),
	move(R, _, _),
  	nb_setval(lastName, P),
  	findall(Q, move(R, Q, P), T), !,
  	write(R), write(" for "), write(P), writeln(" is "), printer(T), !.
		
%+Who is HE/SHE for PERSON ? 
answer([Who, Is, It, For, P, '?']) :-
	q_who(Who),
	q_to_be(Is),
	q_for(For),
	(q_he(It); q_she(It)),
	nb_getval(lastName, X),
  	move(R, X, P), !,
  	write(It), write(" is "), write(R), write(" for "), writeln(P), !.
  	
%+Who is PERSON for PERSON ?
answer([Who, Is, P1, For, P2, '?']) :-
	q_who(Who),
	q_to_be(Is),
	q_for(For),
  	move(Q, P1, P2),
  	write(P1), write(" for "), write(P2), write(" is "), writeln(Q), !.

%+Does HE/SHE have RELATIVE ?
answer([Do, It, Have, R, '?']) :-
	q_do(Do),
	q_have(Have),
	(q_he(It); q_she(It)),
	nb_getval(lastName, X),
	move(R, _, _),
	(move(R, _, X) -> writeln("Yes"); not(move(R, _, X)) -> writeln("No")), !.
  	
%+Does PERSON have RELATIVE ?
answer([Do, P, Have, R, '?']) :-
	q_do(Do),
	q_have(Have),
	move(R, _, _),
	nb_setval(lastName, P),
	(move(R, _, P) -> writeln("Yes"); not(move(R, _, P)) -> writeln("No")), !.

printer([]).
printer([H|T]) :- delete([H|T], H, T1), printer(T1), writeln(H).

numizmat([], 0).
numizmat([H|T], N) :- delete([H|T], H, T1), numizmat(T1, M), N is M + 1.
