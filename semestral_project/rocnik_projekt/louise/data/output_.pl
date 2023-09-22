'$1_1'(A,B) :- a(A,C), a(C,B).
'$1_1'(A,B) :- b(A,C), b(C,B).
s(A,B) :- '$1_1'(A,C), '$1_1'(C,B).
'$1_2'(A,B) :- a(A,C), s(C,B).
s(A,B) :- '$1_2'(A,C), b(C,B).
s(A,B) :- a(A,C), b(C,B).
'$1_3'(A,B) :- s(A,C), b(C,B).
s(A,B) :- a(A,C), '$1_3'(C,B).
a([a|T],T).
b([b|T],T).

% ?- s([a,b],[]).
% true.

% ?- s([a,a],[]).
% false.

% ?-
% spravit toto na vsetkych pozitivnych a negativnych prikladoch(mat ich nacitane v dvoch suboroch). Do jedneho suboru si vypisat Louise nepremenovane rules, druhy subor bude tento
% => porovnat rozdiel v spravnych a nespravnych vystupoch
% spravit dokumentaciu
% skusit spravit nejake pouzivatelske rozhranie