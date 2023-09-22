% original line: N = $3, with_output_to(atom(Y), write(N)), sub_atom(Y, 0, 1, _, C), C = '$'.

process_list([]).
process_list([N|Rest]) :-   with_output_to(atom(Y), write(N)),
                            sub_atom(Y, 0, 1, _, C),
                            C = '$',
                            process_list(Rest).

% ?- List = [$3, $4, $5], process_list(List).
%  _______________________________________________


process_list([]).
process_list([Item|Rest]) :- % process_item(Item),
                            is_dollar(Item),
                            process_list(Rest).

% process_item(Item) :- with_output_to(atom(Y), write(Item)),
%                         sub_atom(Y, 0, 1, _, C),
%                         C = '$'.

% Example usage
% List = [$3, foo, $5, bar], process_list(List).


% is_dollar(Item) :- (process_item(Item) -> writeln('variable with dollar'); writeln('not dollar variable')).

% is_dollar(Item) :- (process_item(Item) -> writeln('variable with dollar'); true).


process_item(Item) :- with_output_to(atom(Y), write(Item)),
                        sub_atom(Y, 0, 1, _, C),
                        C = '$'
                        , 
                        term_to_atom(Item, Atom),
                        atom_concat(Atom, '_1', CC),
                        writeln(CC).

is_dollar(Item) :- (process_item(Item) -> writeln('variable with dollar'); true).
% is_dollar(Item) :- (process_item(Item) -> writeln('variable with dollar'); writeln('not dollar variable')).

% Working!!!!
% L=[1,1,2,$3,4], forall(member(N,L), is_dollar(N)).
% L = [m(chain,$1,a,a)-(m(chain,_10266,_10268,_10270):-m(_10266,_10282,_10284),m(_10268,_10282,_10298),m(_10270,_10298,_10284)),m(chain,$1,b,b)-(m(chain,_10330,_10332,_10334):-m(_10330,_10346,_10348),m(_10332,_10346,_10362),m(_10334,_10362,_10348)),m(chain,s,$1,$1)-(m(chain,_10394,_10396,_10398):-m(_10394,_10410,_10412),m(_10396,_10410,_10426),m(_10398,_10426,_10412))]
% Item = m(chain,$1,a,a)-(m(chain,_10266,_10268,_10270):-m(_10266,_10282,_10284))



% 
% ?- T = m(chain,$1,a,a)-(m(chain,_10266,_10268,_10270):-m(_10266,_10282,_10284)), T = A-(B:-L), arg(Position, A, Term).