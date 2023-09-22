:-module(grammar, [background_knowledge/2
	       ,metarules/2
	       ,positive_example/2
	       ,negative_example/2
	       ,a/2
	       ,b/2
	       ,c/2
	       ,d/2
	       ]).

% <module> Learn an a^nb^n CFG with recursion and predicate invention.

configuration:metarule_constraints(m(chain,P,P,_),fail).
configuration:metarule_constraints(m(chain,P,_,P),fail).
configuration:metarule_constraints(m(chain,_,P,P),fail).

:- auxiliaries:set_configuration_option(clause_limit, [3]).
:- auxiliaries:set_configuration_option(max_invented, [1]).
:- auxiliaries:set_configuration_option(unfold_invented, [true]).
%:- auxiliaries:set_configuration_option(reduction, [none]).

background_knowledge(s/2,[a/2,b/2,c/2,d/2]).

metarules(s/2,[chain]).

positive_example(s/2,E):-
% Uncomment extra examples to experiment with different combinations
% thereof.
	member(E, [s([a,b,a,b,a,b,a,b],[])
		  ,s([a,b,a,b],[])
		  ,s([],[])
%		  ,s([a,a,a,b,b,b],[])
		  %,s([a,a,a,a,b,b,b,b],[])
		  %,s([a,a,a,a,a,b,b,b,b,b],[])
		  %,s([a,a,a,a,a,a,a,b,b,b,b,b,b,b],[])
		  ]).

negative_example(s/2,E):-
	member(E,[s([a,c],[])
		 ,s([a,d],[])
		 ,s([c,d],[])
		 ,s([a,a,a,b,b,b],[])
%		 ,s([a,b,a,b,a,b],[])
		 ,s([a,a,a,a,b,b,b,b],[])
	       ]).

a([a|T],T).
b([b|T],T).
c([c|T],T).
d([d|T],T).




















