:- set_prolog_flag(encoding, utf8).

:-prolog_load_context(directory, Dir)
,asserta(user:file_search_path(project_root, Dir)).

user:file_search_path(src, project_root(src)).
user:file_search_path(subsystems, src(subsystems)).
user:file_search_path(lib, project_root(lib)).
user:file_search_path(data, project_root(data)).
user:file_search_path(output, project_root(output)).
user:file_search_path(scripts, data(scripts)).

:-use_module(configuration).
:-use_module(src(louise)).
:-use_module(src(mil_problem)).
:-use_module(src(auxiliaries)).
:-use_module(subsystems(examples_invention)).
:-use_module(subsystems(metagen)).
:-use_module(subsystems(metarule_extraction)).
:-use_module(subsystems(toil)).
:-use_module(subsystems(minimal_program)).
:-use_module(subsystems(thelma/thelma)).
:-use_module(lib(evaluation/evaluation)).
:-use_module(lib(folding_unfolding/folding_unfolding)).
:-use_module(lib(sampling/sampling)).


%:-load_test_files([]).
%:-run_tests.

% Large data may require a larger stack.
%:- set_prolog_flag(stack_limit, 4_294_967_296).
%:-set_prolog_flag(stack_limit, 8_589_934_592).
%:-set_prolog_flag(stack_limit, 17_179_869_184).
%:- set_prolog_flag(stack_limit, 2_147_483_648).
:-current_prolog_flag(stack_limit, V)
 ,format('Global stack limit ~D~n',[V]).

% Large hypotheses may require large table space.
%:- set_prolog_flag(table_space, 2_147_483_648).
%:-set_prolog_flag(table_space, 4_294_967_296).
%:-set_prolog_flag(table_space, 8_589_934_592).
%:-set_prolog_flag(table_space, 17_179_869_184).
:-current_prolog_flag(table_space, V)
 ,format('Table space ~D~n',[V]).

% the one that's working correctly
% program :-
%     open('/home/juliakrizanova/Documents/mff_cuni4/anbn_output_17apr.txt', write, Stream),
% 	forall(learn(s/2, _Ps), (write(Stream, _Ps),nl(Stream))),
%    	% H is learn(s/2),
% 	% write(Stream, H),
% 	write(Stream,a([a|T],T)),nl(Stream),
% 	write(Stream,b([b|T],T)),nl(Stream),
%     close(Stream).


program :-
    open('/home/juliakrizanova/Documents/mff_cuni4/anbn_output_17apr.txt', write, Stream),
	forall(learn(s/2, _Ps), (assert(_Ps), write(Stream, _Ps),nl(Stream))),
	write(Stream,a([a|T],T)),nl(Stream),
	write(Stream,b([b|T],T)),nl(Stream),
    close(Stream).

program_read :-
	open('/home/juliakrizanova/Documents/mff_cuni4/anbn_output_17apr.txt', read, Str),
	readln(Line),
	close(Str),
	write(Line).


%  program :-
%     open('/home/juliakrizanova/Documents/mff_cuni4/anbn_output_17apr.txt', write, Stream),
% 	forall(learn(s/2, _Ps), ((Stream, _Ps), nl(Stream))),
% 	% copy_term(_Ps, P),
% 	% write('H********learn = '),
% 	% write(H),
% 	% P = _Ps,
% 	% write('P********Ps = '),
% 	% display_clauses,
% 	% write(Stream, H),
% 	write(Stream,a([a|T],T)),nl(Stream),
% 	write(Stream,b([b|T],T)),nl(Stream),
%     close(Stream).

% display_clauses:- learn(s/2, _Ps), write(_Ps).

% man(alan).
% man(john).
% man(george).

% list_all:-
%     man(X),
%     write(X),nl,
%     fail.

% program :-
%     open('/home/juliakrizanova/Documents/mff_cuni4/prolog_output.txt',write, Stream),
%     forall(man(Man), (write(Stream,Man),nl(Stream))),
%     close(Stream).

% program:-
%    current_output(Orig), % save current output
%    open('/home/juliakrizanova/Documents/mff_cuni4/file_output_17apr.txt', write, Out),
%    set_output(Out),
%    learn(s/2),
%    write(Stream,a([a|T],T)),nl(Stream),
% 	write(Stream,b([b|T],T)),nl(Stream),
%    close(Out),
%    set_output(Orig). % restore current output