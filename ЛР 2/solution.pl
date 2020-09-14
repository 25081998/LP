person("Воронов").
person("Павлов").
person("Левицкий").
person("Сахаров").

proffesion(танцор).
proffesion(художник).
proffesion(певец).
proffesion(писатель).

knows("Воронов", певец).
knows("Левицкий", певец).
knows("Павлов", писатель).
knows("Павлов", художник).
knows(писатель, "Павлов").
knows(художник, "Павлов").
knows(писатель, художник).
knows(художник, писатель).
knows(писатель, "Сахаров").
knows(писатель, "Воронов").

notknows("Воронов", "Левицкий").

knowself(A) :- member(man(X, Y), A), knows(X, Y).
knowself(A) :- member(man(X, Y), A), knows(Y, X).

conflict(A) :- member(man(X, Y), A),
  	member(man(Z, W), A),
  	knows(X, W),
  	notknows(X, Z).
conflict(A) :- member(man(X, Y), A),
  	member(man(Z, W), A),
  	knows(Y, W),
  	notknows(X, Z).

solution(A) :-
  	A = [man("Воронов", P1), man("Павлов", P2), man("Левицкий", P3), man("Сахаров", P4)],
  	proffesion(P1), proffesion(P2), proffesion(P3), proffesion(P4),
  	P1 \= P2, P1 \= P3, P1 \= P4, P2 \= P3, P2 \= P4, P3 \= P4,
  	not(knowself(A)),
  	not(conflict(A)).
