:-module(configuration, [clause_limit/1
                        ,example_clauses/1
                        ,experiment_file/2
                        ,fold_recursive/1
                        ,generalise_learned_metarules/1
			,learner/1
                        ,learning_predicate/1
			,max_invented/1
			,metarule/2
			,metarule_constraints/2
                        ,metarule_learning_limits/1
                        ,metarule_formatting/1
                        ,minimal_program_size/2
			,recursive_reduction/1
                        ,reduce_learned_metarules/1
			,reduction/1
			,resolutions/1
			,symbol_range/2
                        ,tautology/1
			,theorem_prover/1
                        ,unfold_invented/1
			,op(100,xfx,metarule)
			]).

% Must be loaded before experiment file to allow experiment files to
% use set_configuration_option/2 without errors.
:-use_module(src(auxiliaries), [set_configuration_option/2]).
:-use_module(src/load_experiment_file).
:-reexport(lib(program_reduction/reduction_configuration),
	   except([resolutions/1])).
:-reexport(lib(evaluation/evaluation_configuration)).
:-reexport(lib/sampling/sampling_configuration).
:-reexport(subsystems(thelma/thelma_configuration)).

/** <module> Configuration options for Louise and associated libraries.

Predicates in this module represent configuration options for Louise,
its auxiliaries, sub-systems and libraries.

__Editable options__

In general, only configuration options defined as definite clauses
should be changed by the user. Directives (definite goals of the form
':-Goal') setup the environment required by Louise and its sub-systems
and should be left well enough alone. The only exception to this rule is
the :-debug(Subject) options that enable and disable logging.

__Setting configuration options__

Modules that require configuration options generally read them by
addressing the configuration option directly through its module
identifier, for example "configuration:clause_limit(K)" etc.

When a configuration option in this file is changed, the file must be
reloaded. The simplest way to do this is to call SWI-Prolog's make/0
predicate. Like this:

==
?- make.
% c:/users/.../louise/configuration compiled into configuration 0.03 sec, 0 clauses
true.
==

__Known errors__

Sometimes, editing an experiment file, then editing this configuration
file and then reloading the project with make/0 can cause SWI-Prolog to
throw up a bunch of permission errors. In that case, the safest bet is
to kill the SWI-Prolog session and start a new one. Sorry, not much I
can do about that.

__Foreign configuration options__

This configuration file re-exports a number of configuration modules
from the various libraries under louise/lib. Thse can be seen in the
reexport/1 and reexport/2 directives at the start of this file (above
the module structured comment). Those "foreign" configuration options
must be set by editing their corresponding module files (in the lib/
subdirectory where that library resides). However, some foreign
configuration options that are very frequently used are excepted from
re-exporting and are instead defined here, to avoid having to edit
multiple configuration files all the time. You can see those options by
eyballing the reexport/2 directives (they're the ones in the "except"
term).

__Dynamic options__

Some configuration options defined in this file are declard dynamic.
These can in general be set without editing the configuration file, with
a call to set_configuration_option/2. Unfortunately, that predicate can
often leave behind garbage in the form of duplicate options (with
different values). Often this manifests as nondeterminism in normally
deterministic learning predicates (such as learn/1). In that case, the
user may have to inspect the current values of configuration options
loaded in memory with list_config/0 and then retract/1 duplicate options
by hand. This is a, well, sort of temporary, solution and a better one
will be implemented at some point. The dynamic database is evil.

__Multifile options__

A couple of configuration options defined in this module file,
particularly metarule/2 and metarule_constraints/2 are declared
multifile so that they can be included in experiment files to keep a
permanent record of those important MIL problem elements. These options
can also be set in the configuration, for example the user doesn't have
to copy metarule/2 clauses in their experiment files everytime and can
instead refer to the ones defined in this module file directly. See the
various example experiment files under louise/data/examples for examples
of setting those configuration options in an experiment file.

__Brief description of configurable options___

The following is a quick list of configuration options that the user can
and should edit in place in this file (or set by
set_configuration_option/2) along with a quick description of their use.

* :-debug(Subject): enable/disable logging for Subject.
* clause_limit/1: number of clauses learned from each example.
* example_clauses/1: how to treat examples with bodies.
* experiment_file/2: path to the current experiment file.
* fold_recursive/1: fold overspecial programs to introduce recursion?
* generalise_learned_metarules/1: generalise TOIL-learned metarules?
* learner/1: name of the current learning system (louise).
* learning_predicate/1: current learning predicate.
* max_invented/1: maximum number of invented predicates.
* metarule/2: metarules known to the system.
* metarule_constraints/2: metasubstitution constraints for Louise.
* metarule_learning_limits/1: control over-generation in TOIL.
* metarule_formatting/1: how to pretty-print metarules.
* minimal_program_size/2: lower limit for learn_miminal/[1,2,5]
* recursive_reduction/1: recursively apply Plotkin's reduction?
* reduce_learned_metarules/1: apply Plotkin's reduction to TOIL output?
* reduction/1: how to reduce the Top Program.
* resolutions/1: depth of resolution in Plotkin's reduction.
* symbol_range/2: used to pretty-print metarule variables.
* tautology/1: what Louise considers a tautology.
* theorem_prover/1: resolution or TP operator (doesn't work).
* unfold_invented/1: unfold to remove invented predicates?

__Navigating the configuration file__

The quickest way to navigate to a configuration option is as follows.

First, move your cursor at the top of the configuration file, where the
:-module/2 declaration exporting the public predicates of this module
resides. In many systems you can move to the start of a file with
"Ctrl+Home".

Place your cursor on the name of the configuration option you wish to
edit.

In the SWI-Prolog IDE, press Ctrl + . (dot). That will bring up a dialog
titled "Find definition of predicate [in new window]". I don't know why
it says "new window" but the predicate will be listed with arity 0,
always. Correct the arity to the arity of the option you want to
navigate to and press OK.

Alternatively, if you're not in the SWI IDE, you can copy the name of
the option you wish to change and use your favourite editor's search
function to search for it. It's more convenient to search for the name
of the option followed by an opening parenthesis, e.g. "reduction(", so
that you jump straight to the definition of the option, or at least the
start of its structured comment (or precede the search with the
start-of-line character, e.g. "/^reduction(" to avoid the structured
comment).

*/

% Dynamic configuration options can be manipulated
% by means of set_configuration_option/2 in module auxiliaries.
:- dynamic clause_limit/1
          ,max_invented/1
          ,minimal_program_size/2
	  ,recursive_reduction/1
	  ,reduction/1
	  ,resolutions/1
	  ,theorem_prover/1
          ,unfold_invented/1.

% Allows experiment files to define their own, special metarules.
% BUG: Actually, this doesn't work- module quantifiers, again.
% Needs fixing.
:-multifile metarule/2.

/* Debug levels
 * Note that some of the debug topics below emit identical messages.
 * In particular, 'learn' debugs learn/5 that calls top program
 * construction and reduction that are also debugged by 'top_program'
 * and 'reduction'.
*/
:-nodebug(_). % Clear all debug topics.
%:-debug(learn). % Debug learning steps.
%:-debug(metasubstitution). % Debug metasubstitutions.
%:-debug(examples). % Debug positive and negative examples.
%:-debug(top_program). % Debug Top program construction.
%:-debug(reduction). % Debug Top program reduction.
%:-debug(predicate_invention). % Debug predicate invention.
%:-debug(learn_metarules). % Debug metarule learning
%:-debug(learned_metarules). % Debug new metarules
%:-debug(metarule_grounding). % Debug metarule template specialisation
%:-debug(examples_invention). % Debug examples invention.
%:-debug(evaluation).


%!      clause_limit(+Clauses) is semidet.
%
%       How many Clauses to learn from each single positive example.
%
%       __Choosing a sensible clause limit__
%
%       Louise learns by inductively proving a set of clauses that
%       deductively prove a positive example. Multiple such sets can be
%       learned on backtracking from each example. This option limits
%       the number of clauses learned from each example at a time.
%
%       * clause_limit(1).
%
%       Choose this setting if you don't need recursion or predicate
%       invention.
%
%       If clause_limit(1) is set, Louise can only learn a single clause
%       from each positive example at a time. Multiple clauses can be
%       learned on backtracking, but none is allowed to resolve with
%       other clauses (or itself) learned during the inductive proof.
%
%       What this means in practice is that with clause_limit(1) Louise
%       will learn hypotheses without recursion, or with recursion
%       limited to resolution with the positive examples (Louise adds
%       the positive examples to the Background Knowledge exactly to
%       allow this limited form of recursion to be learned).
%
%       * clause_limit(K) where K > 1
%
%       Choose this setting if you need recursion or predicate
%       invention.
%
%       If clause_limit(K) is set and K is more than one, Louise can
%       learn up to K clauses from each positive example at a time, and
%       those clauses are allowed to resolve with each other during the
%       inductive proof.
%
%       What this means in practice is that with clause_limits(K) where
%       K is more than 1, Louise can learn hypotheses with multiple
%       clauses "calling" each other. These may be either recursive
%       clauses or clauses with invented predicate symbols in their head
%       or body.
%
%       * Predicate invention
%
%       Note that if predicate invention is required, the option
%       max_invented/1 must also be set separately to an appropriate
%       value (representing the number of predicate symbols that Louise
%       will try to define).
%
%       __Motivation__
%
%       Briefly, the purpose of this configuration option is to limit
%       the number of times a metarule can be resolved with. There is
%       currently no known way to limit this number, so imposing a
%       manual limit, by means of this configuration option, is a
%       half-measure that will have to do until a principled solution is
%       found.
%
%       More analytically, Louise's Top Program Construction algorithm
%       learns by proving an example by SLD-Refutation against the
%       Background Knowledge (BK). In Meta-Interpetive Learning, the BK
%       is a higher-order logic program that includes not only
%       first-order definite clauses, but also second-order definite
%       clauses, the metarules. This resolution proof is carried out by
%       a Prolog meta-interpreter modified to resolve first-order goals
%       and definite clauses with each other and with second-order
%       metarules.
%
%       Metarules are definite clauses with variables in the place of
%       predicate symbols (that's what makes them second-order) so
%       resolution between two metarules with literals of the same arity
%       is always possible (a special case of this is resolution of a
%       metarule with itself). One effect of this is that performing
%       SLD-resolution with metarules can "go infinite".
%
%       ==
%       % A Metarule can always resolve with itself
%       % For example, in the Identity metarule below, P(X,Y) unifies
%       % with Q(X,Y), yielding a new goal, :-Q(X,Y) that unifies with
%       % P(X,Y) yielding a new goal :-Q(X,Y) ... and so on forever.
%
%       P(X,Y):- Q(X,Y).
%       ==
%
%       In Louise's modified, inductive Prolog meta-interpreter when a
%       branch of the SLD refutation proof fails, the meta-interpreter's
%       execution backtrakcs to try another proof branch, which always
%       succeeds as long as there is an appropriate metarule. In other
%       words, at the point where a normal first-order SLD-Refutation
%       proof would simply fail and return its result, the Top Program
%       Construction meta-interpreter merrily carries on, not knowing
%       that there is no end in sight, like a superintelligence asked to
%       calculate all the decimal digits of Pi (why a superintelligence
%       would not know that Pi has infinite decimal digits is a mystery
%       that only the spirit of Marvin Minsky can explain).
%
%       There are a bunch of heuristics that can avoid this unstoppable
%       resolution, but there is, as of yet, no know principled manner.
%       The solution adopted by louise through this configuration option
%       imposes a hard limit on the number of times resolution is
%       allowed to succeed, which in turn limits the number of clauses
%       that can be derived by proof of a single positive example.
%
%       Another way to see this is that clause_limit/1 limits the depth
%       of a resolution proof branch. Since each node in a proof branch
%       is one clause, the result of clause_limit(K) is that no more
%       than K clauses can be induced from a single example at a time.
%
%       This in turn limits the number of instances of the metarules
%       allowed to resolve with each other during the proof. Learning
%       recursion and predicate invention cannot be learned unless
%       clauses are derived that resolve with each other, thus settting
%       clause_limit(1) stops both (although a limited form of recursion
%       can still be learned with clause_limit(1) by resolution with the
%       positive examples).
%
%       __Vanilla TPC meta-interpreter__
%
%       This configuration option is called by the predicate prove/5,
%       Louise's implementation of a Meta-Interpretive Learning
%       inductive meta-interpreter. Louise's meta-interpreter is based
%       on a "vanilla" Prolog meta-interpreter, hence it's named
%       "Vanilla".
%
%       Vanilla is enabled only when K in clause_limit(K) is more than
%       1. If clause_limit(1) is set, the proof is handed off to Prolog.
%       See the source code in louise.pl and comments in learn/5 and
%       friends for more details.
%
clause_limit(1).


%!      example_clauses(?What) is semidet.
%
%       What to do with example clauses.
%
%       This option determines how Louise treats examples that are given
%       as definite clauses with one or more body literals (rather than
%       ground atoms), i.e. "example clauses".
%
%       What is one of [bind,call].
%
%       If What is "bind", example clauses are bound to each instance of
%       a metarule where that is possible.
%
%       If What is "call", the head literal of each example clause is
%       bound to the enapsulated head literal of a metarule, then the
%       body literals of the example clause are called. This may
%       result in the universally quantified variables in the head of
%       the clause, and so the encapsulated head literal of the
%       metarule, to be bound.
%
%       Use "bind" when you have a set of definite clauses that you want
%       to transform to instances of a metarule.
%
%       Use "call" when you want to use a set of definite clauses with
%       bodies to generate examples.
%
%example_clauses(bind).
example_clauses(call).


%!	experiment_file(?Path,?Module) is semidet.
%
%	The Path and Module name of an experiment file.
%
%experiment_file('data/examples/hello_world.pl',hello_world).
%experiment_file('data/examples/tiny_kinship.pl',tiny_kinship).
experiment_file('data/marta/grammar.pl',grammar).
%experiment_file('data/examples/anbn.pl',anbn).
%experiment_file('data/examples/abduced.pl',abduced).
%experiment_file('data/examples/user_metarules.pl',user_metarules).
%experiment_file('data/examples/constraints.pl',constraints).
%experiment_file('data/examples/mtg_fragment.pl',mtg_fragment).
%experiment_file('data/examples/recipes.pl',recipes).
%experiment_file('data/examples/example_invention.pl',path).
%experiment_file('data/robots/robots.pl',robots).
%experiment_file('data/coloured_graph/coloured_graph.pl',coloured_graph).
%experiment_file('data/examples/multi_pred.pl',multi_pred).
%experiment_file('data/examples/tiny_kinship_toil.pl',tiny_kinship_toil).
%experiment_file('data/examples/yamamoto.pl',yamamoto).
%experiment_file('data/examples/recursive_folding.pl',recursive_folding).
%experiment_file('data/examples/findlast.pl',findlast).


%!      fold_recursive(?Bool) is semidet.
%
%       Whether to fold overspecialised programs.
%
%       If Bool is set to 'true' Louise will attempt to fold an
%       over-specialised program to introduce recursion.
%
%       @tbd Currently, only learn/5 and its family recognise this
%       option.
%
fold_recursive(false).


%!      generalise_learned_metarules(?Bool) is semidet.
%
%       Whether to generalise learned metarules.
%
%       "Genearlisation" heare means that second-order variables in
%       learned metarules are "named apart", so for example a learned
%       metarule "P(x,,y):- Q(x,z), P(z,y)" is genealised by replacing
%       each instance of the second-order variables P and Q with new,
%       free variables, resulting in the metarule "P(x,y):- Q(x,z),
%       R(z,y)".
%
%       The new metarule is more general than the original in the sense
%       that its instances may or may not be recursive clauses- while
%       the first metarule forces the head and last body literal to have
%       the same predicate symbol.
%
%       The motivation of this option is to allow learning metarules
%       that better generalise to unseen examples. Set this option to
%       true if learn_metarules/[1,2,5] returns overly-specific
%       metarules that can only represent the training examples well.
%
%generalise_learned_metarules(true).
generalise_learned_metarules(false).


%!	learner(?Name) is semidet.
%
%	Name of the learning system this configuration is for.
%
%	Name is one of [louise,thelma].
%
%	Used to switch context between Louise and Thelma, where this is
%	needed. The typical use case is when experiment code must check
%	the values of configuration options that are particular to one
%	or the other system (e.g. resolutions/1 is not present in
%	Thelma etc).
%
learner(louise).


%!	learning_predicate(+Learning_Predicate) is semidet.
%
%	The Learning_Predicate to be used in list_learning_results/0.
%
%	Learning_Predicate is a predicate indicator, the symbol and
%	arity of one of the following learning predicates defined in
%       Louise:
%       * learn/1
%       * learn_meta/1
%       * learn_metarules/1
%       * learn_minimal/1
%       * learn_with_examples_invention/2
%       * thelma/1
%
%       The specified predicate will be used to list the learning
%       results for all learning targets defined in an experiment file
%       with a call to list_learning_results/0.
%
%	learning_predicate/1 is declared as multifile. To specify the
%	learning predicate to be used with list_learning_results/0, add
%	a clause of learning_predicate/1 to the relevant experiment
%	file.
%
%	For example, the following clause:
%	==
%	configuration:learning_predicate(learn_meta/1).
%	==
%
%	Will cause list_learning_results/0 to use learn_meta/1 for
%	all predicates in the experiment file containing that clause.
%
%	learning_predicate/1 is declared dynamic. You do not have to
%	specify a learning predicate for every experiment file.
%	list_learning_results/0 will default to learn/1.
%
%	Note that learning_predicate/1 will not affect learning by
%	calling learning predicates directly. That is, having added a
%	clause of learning_predicate/1 like the one above to an
%	experiment file you are free to then call learn/1 or any other
%	learning predicate on any of the learning targets in that
%	experiment file. Only the learning predicate used by
%	list_learning_results/0 is affected by this option.
%
%	Finally, note that specifying any other predicate than the three
%	learning predicates listed above as a learning_predicate will
%	cause list_learning_results/0 to raise an error.
%
%	@see list_learning_results/0
%
%       @tbd learning_predicate/1 is also used in lib/evaluation to
%       choose the learning predicate used to evaluate a learning
%       result. Predicates in that library default to learn/1 when
%       learning_predicate/1 is not defined.
%
:-dynamic learning_predicate/1.
:-multifile learning_predicate/1.
%learning_predicate(learn/1).
%learning_predicate(learn_minimal/1).
% etc.


%!	max_invented(?Number) is semidet.
%
%	Maximum number of invented predicates.
%
%	Assumes clause_limit(K) where K > 1.
%
max_invented(0).


%!	metarule(?Id,?P,?Q) is semidet.
%!	metarule(?Id,?P,?Q,?R) is semidet.
%
%	An encapsulated metarule.
%
%	@tbd This representation does not define constraints. For the
%	time being this doesn't seem to be necessary but a complete
%	representation will need to include constraints.
%
abduce metarule 'P(X,Y)'.
unit metarule 'P(x,y)'.
projection_21 metarule 'P(x,x):- Q(x)'.
projection_12 metarule 'P(x):- Q(x,x)'.
identity metarule 'P(x,y):- Q(x,y)'.
inverse metarule 'P(x,y):- Q(y,x)'.
chain metarule 'P(x,y):- Q(x,z), R(z,y)'.
tailrec metarule 'P(x,y):- Q(x,z), P(z,y)'.
precon metarule 'P(x,y):- Q(x), R(x,y)'.
postcon metarule 'P(x,y):- Q(x,y), R(y)'.
switch metarule 'P(x,y):- Q(x,z), R(y,z)'.
swap metarule 'P(x,y):- Q(z,x), R(z,y)'.
% Metarules with abductible first-order existentially quantified
% variables. Also see abduce metarule above.
chain_abduce_x metarule 'P(X,y):- Q(X,z), R(z,y)'.
chain_abduce_y metarule 'P(x,Y):- Q(x,z), R(z,Y)'.
chain_abduce_z metarule 'P(x,y):- Q(x,Z), R(Z,y)'.
projection_21_abduce metarule 'P(X,X):- Q(X)'.
projection_12_abduce metarule 'P(X):- Q(X,X)'.
precon_abduce metarule 'P(X,y):- Q(X), R(X,y)'.
postcon_abduce metarule 'P(x,Y):- Q(x,Y), R(Y)'.

% Generalised second order metarules (Matrix metarules). Use only with
% toil.pl
%
% WARNING Comment these out when learing with [all] metarules!
%
meta_dyadic metarule 'P(x,y):- Q(z,u), R(v,w)'.
meta_monadic metarule 'P(x,y):- Q(z,u)'.
meta_precon metarule 'P(x,y):- Q(z),R(u,v)'.
meta_postcon metarule 'P(x,y):- Q(z,u),R(v)'.
meta_projection_21 metarule 'P(x,y):- Q(z)'.
meta_projection_12 metarule 'P(x):- Q(y,z)'.

%partially_named metarule 'P(x,y):- member(x,y)'.
% Not yet implemented.

/*
% H22 metarules redundnant given chain and inverse.
% To avoid proliferation of vaguely descriptive names these are named
% by their firts-order, universally quantified variables.
% identity and switch are also in this set (but they are already named)
% TODO: convert to new format.
metarule(xy_xy_xy,P,Q,R):- m(P,X,Y), m(Q,X,Y), m(R,X,Y).
metarule(xy_xy_yx,P,Q,R):- m(P,X,Y), m(Q,X,Y), m(R,Y,X).
%metarule(xy_xz_yz,P,Q,R):- m(P,X,Y), m(Q,X,Z), m(R,Y,Z). % switch
metarule(xy_yx_xy,P,Q,R):- m(P,X,Y), m(Q,Y,X), m(R,X,Y).
metarule(xy_yx_yx,P,Q,R):- m(P,X,Y), m(Q,Y,X), m(R,Y,X).
metarule(xy_yz_xz,P,Q,R):- m(P,X,Y), m(Q,Y,Z), m(R,X,Z).
metarule(xy_yz_zx,P,Q,R):- m(P,X,Y), m(Q,Y,Z), m(R,Z,X).
metarule(xy_zx_yz,P,Q,R):- m(P,X,Y), m(Q,Z,X), m(R,Y,Z).
metarule(xy_zx_zy,P,Q,R):- m(P,X,Y), m(Q,Z,X), m(R,Z,Y).
metarule(xy_zy_xz,P,Q,R):- m(P,X,Y), m(Q,Z,Y), m(R,X,Z).
metarule(xy_zy_zx,P,Q,R):- m(P,X,Y), m(Q,Z,Y), m(R,Z,X).

Converted to new format.
TODO: create new lump category called h22 for all these plus identity
and inverse. And chain. I think chain is missing from this list.

xy_xy_xy metarule 'P(x,y):- Q(x,y), R(x,y)'.
xy_xy_yx metarule 'P(x,y):- Q(x,y), R(y,x)'.
xy_xz_yz metarule 'P(x,y):- Q(x,z), R(y,z)'. % switch
xy_yx_xy metarule 'P(x,y):- Q(y,x), R(x,y)'.
xy_yx_yx metarule 'P(x,y):- Q(y,x), R(y,x)'.
xy_yz_xz metarule 'P(x,y):- Q(y,z), R(x,z)'.
xy_yz_zx metarule 'P(x,y):- Q(y,z), R(z,x)'.
xy_zx_yz metarule 'P(x,y):- Q(z,x), R(y,z)'.
xy_zx_zy metarule 'P(x,y):- Q(z,x), R(z,y)'. % swap
xy_zy_xz metarule 'P(x,y):- Q(z,y), R(x,z)'.
xy_zy_zx metarule 'P(x,y):- Q(z,y), R(z,x)'.
*/


%!	metarule_constraints(+Metasubstitution,+Goal) is nondet.
%
%	A Goal to be called when Metasubstitution is matched.
%
%       This option is declared multifile that constraints may be
%       declared individually by experiment files, as needed. A few
%       examples are given below.
%
:- dynamic metarule_constraints/2.
:- multifile metarule_constraints/2.
/*
% Simple constraint excluding left-recursive clauses that are instances of
% a metarule with any Id and having two existentially quantified
% variables. Matches e.g. Tailrec and Identity:
%
configuration:metarule_constraints(m(_Id,P,P),fail).
*/
/*
% Simple constraint excluding left-recursive clauses that are instances of
% a metarule with any Id and having three existentially quantified
% variables. Matches e.g. Chain, Switch, Swap:
%
configuration:metarule_constraints(m(_Id,P,P,_),fail).
*/
/*
% Anti-recursion constraint - excludes recursive clauses
% Does not take into account invented or metarules with existentially
% quantified secod-order variables:
%
configuration:metarule_constraints(m(tailrec,_,_),fail).
configuration:metarule_constraints(M,fail):-
	M =.. [m,Id,P|Ps]
        ,\+ memberchk(Id,[abduce
			 ,unit
			 ,projection_21
			 ,projection_12])
	,memberchk(P,Ps).
*/
/*
% McCarthyite constraint - excludes left-recursive metasubstitutions
% Named after the other McCarthy. The senator, not the computer
% scientist.
%
configuration:metarule_constraints(M,fail):-
	M =.. [m,Id,P,P|_Ps]
        ,\+ memberchk(Id,[abduce
                      ,unit
                      ,projection_21
                      ,projection_12]).

*/
/*
% Lexicographic order constraint.
% Imposes total ordering on the Herbrand base.
% Calls src/subsystems/thelma/thelma_configuration:order_constraints/5.
% Needs problem-specific ordering of the predicate signature.
%
configuration:metarule_constraints(M,B):-
	debug(lex,'Testing constraint for metasub: ~w',M)
        ,M =.. [m,Id|Ps]
        %#REPLACE WITH PROBLEM-SPECIFIC ORDERING OF PREDICATE SIGNATURE#
        ,PS = [s,a,b] % Example ordering for a^nb^n
	,debug(lex,'Predicate signature: ~w',[PS])
        ,thelma_configuration:order_constraints(Id,Ps,Fs,STs,FTs)
	,debug(lex,'Order constraints: ~w-~w',[STs,FTs])
        ,(   thelma:order_tests(PS,Fs,STs,FTs)
	 ->  B = true
	    ,debug(lex,'Passed constraint test!',[])
	 ;   B = false
	    ,debug(lex,'Failed constraint test!',[])
	 ).
*/


%!      metarule_learning_limits(?Limits) is semidet.
%
%       Limits on metarule learning.
%
metarule_learning_limits(none).
%metarule_learning_limits(coverset).
%metarule_learning_limits(sampling(0.5)).
%metarule_learning_limits(metasubstitutions(1)).


%!      metarule_formatting(?How) is semidet.
%
%       How to print metarules learned with new_metarules/1.
%
%       How is one of: [quantified, user_friendly, expanded].
%
%       Option "quantified" prints metarules with quantifiers and in
%       formal notation found in the MIL literature. Use this option to
%       compare metarules with the ones in the literature, or just to
%       get a more clear explanation of a metarule.
%
%       Option "user_friendly" prints metarules in Louise's user-level,
%       and user-friendly format of metarules in experiment files. Use
%       this option when you want to copy a metarule and later paste it
%       to an experiment file. For example, this option is handy when
%       you learn metarules with TOIL and you want to reuse them in an
%       experiment file.
%
%       Option "expanded" prints metarules in Louise's internal format,
%       encapsulated and expanded, with an encapsulated metasubstitution
%       atom in the head. Use this option to inspect what Louise
%       actually sees when you declare a metarule.
%
%       Note that the metarules printed with option "expanded" cannot be
%       directly copy/pasted into an experiment file. Or, well, sure
%       they can... but they won't be picked up by experiment_data/5 and
%       you will probably see errors.
%
metarule_formatting(quantified).
%metarule_formatting(user_friendly).
%metarule_formatting(expanded).


%!      minimal_program_size(?Minimum,?Maximum) is semidet.
%
%       Minimum and Maximum cardinality of a minimal program.
%
%       Each of Minimum, Maximum should be an integer between 1 and
%       positive infinity ('inf' in Prolog).
%
minimal_program_size(2,inf).


%!	recursive_reduction(?Bool) is semidet.
%
%	Whether to reduce the Top program recursively or not.
%
%	Setting Bool to true enables recursie reduction of the Top
%	program. Recursive reduction means that the result of each
%	reduction step is given as input to the reduction algorithm in
%	the next step (also known as "doing the feedbacksies").
%
%	Recursive reduction can result in a stronger reduction in less
%	time, with a lower setting for resolutions/1 (in fact, the same
%	amount of reduction can take less time exactly because the
%	resolutions/1 setting can be set to a lower value).
%
%	Recursive reduction is more useful when the Top program is large
%	and many resolution steps are required to remove all redundancy
%	from it.
%
recursive_reduction(false).
%recursive_reduction(true).


%!      reduce_learned_metarules(?Bool) is semidet.
%
%       Whether to reduce learned metarules.
%
%       Reduction is by application of Plotkin's program reduction,
%       only.
%
reduce_learned_metarules(false).
%reduce_learned_metarules(true).


%!	reduction(?Method) is semidet.
%
%	Select a Method for Top program reduction.
%
%	One of:
%	* none: no reduction.
%	* plotkins: discard logically redundant clauses by application
%	of Plotkin's program reduction.
%	* subhypothesis: select one hypothesis entailed by the Top
%	program.
%
%reduction(none).
reduction(plotkins).
%reduction(subhypothesis).


%!	resolutions(?Resolutions) is semidet.
%
%	Maximum number of resolutions.
%
%	Used with solve_to_depth/3.
%
%resolutions(500_000_000_000).
%resolutions(20_500_000).
%resolutions(10_500_000).
%resolutions(5_500_000).
%resolutions(500_000).
%resolutions(250_000).
%resolutions(30_000).
%resolutions(10_000).
resolutions(5000).
%resolutions(100).
%resolutions(15).
%resolutions(0).


%!	symbol_range(?Type,?Symbols) is semidet.
%
%	A list of Symbols to pretty-print predicates or variables.
%
%	Type is one of [predicate,variable], denoting the type of
%	symbols in the currenr range.
%
%	Symbols is a list of symbols of the given Type.
%
%	The atoms in list Symbols is used to assign names to the
%	variables in a metarule for pretty-printing.
%
%	Warning:
%	--------
%
%	symbol_range/2 must have exactly two clauses: one for the
%	symbols to be used as names for second-order existentially
%	quantified variables, and one to be used as names for
%	first-order existentially and universally quantified variables.
%
%	You can change each Symbols list as you see fit, but _do not
%	remove or add clauses_ to symbol_range/2!
%
%	Used by
%	-------
%
%	This predicate is used by predicates in the transitive closure
%	of print_metarules/1 and print_metarule/1, in particular,
%	numbered_symbol/3, which uses this to generate lists of
%	predicate symbols to be assigned to variables in metarules
%	according with their (first- or second-) order.
%
symbol_range(predicate, ['P','Q','R','S','T']).
symbol_range(variable, ['X','Y','Z','U','V','W']).
% Silly. Don't use.
%symbol_range(predicate, ['Alice','Bob','Carol']).
%symbol_range(variable, ['Smith','Brown','Carpenter','Miller','Green']).


%!      tautology(+Clause) is det.
%
%       True when Clause is a tautology.
%
%       This configuration option formalises the concept of a
%       tautological clause as it is used in Louise. In short, a clause
%       is a tautology if it is a definite clause with one or more body
%       literals and all its literals are identical.
%
%       For example, the following clause is considered to be a
%       tautology:
%       ==
%       p(A,B):- p(A,B), p(A,B)
%       ==
%
%       Whereas the following clauses are not considered to be
%       tautologies:
%       ==
%       p(a,b)
%       p(A,B):- p(B,A)
%       ==
%
%       And so on. Formalising the concept of tautology in Louise is
%       useful because of the way the Top Proram Construction (TPC)
%       algorithm works. TPC adds to the background knowledge the set of
%       positive examples, which then functions as an extensional,
%       partial definition of each target predicate. TPC then
%       generalises each example to a clause that entails the example
%       with respect to the background knowledge. Since the background
%       knowledge includes each positive example, it is possible and in
%       fact common to end up with clauses generalising an example by
%       creating an implication of an atom of the example's predicate by
%       one or more instances of itself. For example, if p(a,b) is a
%       positive example, p(A,B):- p(A,B) is a clause tautologically
%       expressing the fact that each atom of p/2 entails itself.
%
%       Such tautologies are removed from the Top program by Plotkin's
%       program reduction algorithm since they are always entailed by
%       the rest of the Top program (and by anything else, ever really).
%       However, alternative reduction methods, such as subhypothesis
%       selection or minimal program learning do not rely on entailment
%       of a clause by the rest of the program and so may not be able to
%       get rid of tautologies as simply as Plotkin's reduction. For
%       such reduction methods, a tautology check is needed. This
%       predicate forms the basis of such a check.
%
%       Note that tautological clause generally only arise when the
%       Identity metarule, or one of its specialisations is in the set
%       of metarules for a MIL problem. The Identity metarule is P(x,y)
%       :- Q(x,y) where {P,Q} are second-order existentially quantified
%       variables that are not constrainted to be different. If P = Q
%       then the resulting clause is a tautology, but this is not always
%       the case, so Identity is generally useful (in fact,
%       indispensible, given that it represents one third of the
%       properties necessary to construct an equivalence relation). A
%       specialisation of Identity is a metarule with multiple clauses
%       having identical literals up to renaming of their second order
%       existentially quantified variables, for example the following is
%       a specialisation of Identity: P(x,y):- Q(x,y), R(x,y) and if P =
%       Q = R the resulting clause would be a tautology as defined by
%       this predicate.
%
tautology(H:-B):-
        copy_term(H:-B,C_)
        ,clause_literals(C_,Ls)
        ,numbervars(Ls)
        ,sort(Ls,[_]).


%!	theorem_prover(?Algorithm) is semidet.
%
%	Theorem proving Algorithm to use in Top program construction.
%
%	Algorithm is one of: [resolution, tp].
%
%	With option 'resolution', the Top program is constructed in a
%	top-down manner, using SLD resolution.
%
%	With option 'tp', the Top program is constructed in a bottom-up
%	manner, using a TP operator.
%
%	__Trade offs__
%
%       Option 'resolution' is generally faster when clause_limit(1) is
%       set because it hands off to the Prolog interpreter. On the other
%       hand the meta-interpretation can enter infinite right-recursion
%       (left-recursion is avoided by tabling).
%
%	Option tp is slower because it's implemented in Prolog and it's
%       not terribly optimised either. 'tp' currently can't perform
%       predicate invention. On the other hand, 'tp' guarantees
%       termination and runs in polynomial time, at least for definite
%       programs (but then, there are no guarantees outsid of definite
%       programs). Finally, 'tp' only accepts datalog programs, so for
%       example it will not work on problems where examples or BK have
%       lists not hidden away by flattening.
%
%       While the current implementation of the TP Operator does not
%       allow for predicate invention, bottom-up predicate invention is
%       possible, as described in "Complete bottom-up predicate
%       invention in MIL" by Hocquette and Muggleton, published
%       in IJCAI-20. Implementing this in Louise is left for future
%       work.
%
theorem_prover(resolution).
%theorem_prover(tp).


%!      unfold_invented(?Bool) is semidet.
%
%       Whether to unfold programs to remove invented symbols.
%
%       See the module dynamic_learning and unfold_invented/3 for an
%       explanation of unfolding programs to remove invented symbols.
%
%       @tbd Document unfolding in this configuration option, also.
%
unfold_invented(false).
%unfold_invented(true).


% Loads the current experiment file in the Swi-Prolog IDE when the
% configuration is changed.
%
% It is perfectly safe to remove this directive.
%
%:-experiment_file(P,_)
%  ,edit(P).


% This line ensures the experiment file set in the configuration option
% experiment_file/2 is always updated when the configuration module is
% changed and reloaded. Don't remove it.
%
% DO NOT REMOVE THIS LINE!
:- experiment_file(P,_)
  ,load_experiment_file(P).
