process_list([]).
process_list([Item|Rest]) :- is_dollar(Item),
                            process_list(Rest).

process_item(Item) :- with_output_to(atom(Y), write(Item)),
                    sub_atom(Y, 0, 1, _, C),
                    C = '$', 
                    term_to_atom(Item, Atom),
                    atom_concat(Atom, '_1', CC),
                    writeln(CC).

is_dollar(Item) :- (process_item(Item) -> writeln('variable with dollar'); true).
% is_dollar(Item) :- (process_item(Item) -> writeln('variable with dollar'); writeln('not dollar variable')).


% L=[1,1,2,$3,4], forall(member(N,L), is_dollar(N)).