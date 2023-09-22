replace(I, L, E, K) :-
    nth0(I, L, _, R),
    nth0(I, K, E, R).

% usage: 
% ?- replace(2, [1, 2, 3, 4, 5], 10, X).
% X = [1, 2, 10, 4, 5].
% ----------------

replace(List, Idx, With, ListOut) :-
    length(Idx, Before),
    append(Before, [_Discard|Rest], List),
    append(Before, [With|Rest], ListOut).


:- use_module(library(clpfd)).

list_item_replaced([_|Xs], 0, E, [E|Xs]).
list_item_replaced([X|Xs], N, E, [X|Ys]) :-
    N #> 0,
    N #= N0+1,
    list_item_replaced(Xs, N0, E, Ys).