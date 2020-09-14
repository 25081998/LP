parent(vova, lesha).
parent(vova, roma).
parent(lesha, misha).
parent(roma, kolya).
parent(roma, serega).
parent(kolya, tolya).
parent(kolya, jenya).

name(vova, vovin, vovy).
name(lesha, leshin, leshi).
name(roma, romin, romy).
name(misha, mishin, mishi).
name(kolya, kolin, koli).
name(serega, seregin, seregi).
name(jenya, jenin, jeni).
name(tolya, tolin, toli).

move(brat, X, Y) :- 
 	parent(P, X), 
	parent(P, Y).

move(papa, X, Y) :- parent(X, Y).

move(syn, X, Y) :-  parent(Y, X).

move(ded, X, Y) :- 
	parent(X, Z), 
	parent(Z, Y).

move(praded, X, Y) :-  
	parent(X, W), 
	parent(W, Z), 
	parent(Z, Y).

q_kto(X) :- member(X, ['Kto', 'kto']).
q_chei(X) :- member(X, ['Chei', 'chei']).

% A brat B?
answer([A, B, C, '?'], X) :-
	(parent(A, _); parent(_, A)),
  	move(B, _, _),
  	name(D, _, C),
  	move(B, A, D), 
	X = yes, !.	

% Kto A brat?
answer([A, B, C, '?'], X) :-
	q_kto(A),
	move(C, _, _),
  	name(D, B, _),
  	(parent(D, _);parent(_, D)),
  	findall(Q, (move(C, Q, D), Q \= D), X),
	!.

% chei brat A?
answer([A, B, C, '?'], X) :-
	q_chei(A),
	move(B, _, _),
  	name(C, _, _),
  	(parent(C, _); parent(_, C)),
  	findall(Q, (move(B, C, Q), Q \= C), X), 
	!.
