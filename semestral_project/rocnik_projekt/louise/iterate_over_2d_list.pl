iterate_over_2d_list([], [], 1).
iterate_over_2d_list([Row | Rest], Result, Order) :- process_row(Row, ProcessedRow, Order),
                                                    OrderNew is Order + 1,
                                                    iterate_over_2d_list(Rest, RestResult, OrderNew),
                                                    append(ProcessedRow, RestResult, Result).


process_row([], [], 1).
process_row([T | Ts], [Result | Rest], Order) :- process_T(T, Result),
                                                process_row(Ts, Rest, Order).


process_T(T, Term) :-   T = A-(B:-_),
                        arg(Position, A, Term).

% Example usage
% Ts = [
%     [m(chain,$1,a,a)-(m(chain,_121978,_121980,_121982):-m(_121978,_121994,_121996),m(_121980,_121994,_122010),m(_121982,_122010,_121996))],
%     [m(chain,$1,a,s)-(m(chain,_122176,_122178,_122180):-m(_122176,_122192,_122194),m(_122178,_122192,_122208),m(_122180,_122208,_122194))]
% ],
% iterate_over_2d_list(Ts, Result).


% TODO: Not yet working correctly!
% Ts = [
%     m(chain,$1,a,a)-(m(chain,_121978,_121980,_121982):-m(_121978,_121994,_121996),m(_121980,_121994,_122010),m(_121982,_122010,_121996)),
%     m(chain,$1,a,s)-(m(chain,_122176,_122178,_122180):-m(_122176,_122192,_122194),m(_122178,_122192,_122208),m(_122180,_122208,_122194))
% ],
% process_row(Ts, Result, 1).