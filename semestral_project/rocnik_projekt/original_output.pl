'$1'(A,B) :- a(A,C), a(C,B).
'$1'(A,B) :- b(A,C), b(C,B).
s(A,B) :- '$1'(A,C), '$1'(C,B).
'$1'(A,B) :- a(A,C), s(C,B).
s(A,B) :- '$1'(A,C), b(C,B).
s(A,B) :- a(A,C), b(C,B).
'$1'(A,B) :- s(A,C), b(C,B).
s(A,B) :- a(A,C), '$1'(C,B).
a([a|T],T).
b([b|T],T).
