# Semestral project documentation

## Louise - polynomial-time Program Learning
Louise is a machine learning system whose objective is to learn Prolog programs. It operates as a Meta-Interpretive Learning system, signifying a groundbreaking approach to Inductive Logic Programming—a subset of weakly-supervised machine learning dedicated to logical program development.  This learning is done by observing inputs and outputs of the program and in this way understanding the program general behaviour.

What is interesting and revolutionary about Louise is that it doesn't need to see the examples of the program itself, but it simply relies on the library of pre-existing logic programs called the background knowledge (a higher-order logic program that includes a set of clauses called metarules). This background knowledge is later used to compose new programs. It is pertinent to note that both examples and background knowledge, including metarules, can be provided by the user. Remarkably, Louise also possesses the capability to autonomously learn and augment its own background knowledge.

Louise operates on the foundation of a Top Program Construction algorithm that operates in polynomial time. This algorithm orchestrates the construction of a unique entity—a correct hypothesis—that remains consistent with the provided training examples.


## Louise's author and original work
This work was originally created as a PhD thesis of a student from Imperial College London. The github repository can be accessed via the following link: https://github.com/stassa/louise.


## Problem with the program and purpose of the project
However after testing the functionality of the program, it was found that it doesn't always returns correct outputs for certain number of positive and negative examples on which Louise was trained. 
My supervisor, M. Vomlelová, had an idea where the faulty functionality of the program could stem from. The anticipated error was the incorrect naming of variables during creation of background knowledge. 
To illustrate, during creation of background knowledge, there is a 2D list of clauses in the following format containing $number variables that are later complemented by specific function name. 
Let's take the following clauses as the example:
```
[[
m(chain,$1,a,a)-(m(chain,_121750,_121752,_121754):-m(_121750,_121766,_121768),m(_121752,_121766,_121782),m(_121754,_121782,_121768)),
m(chain,$1,b,b)-(m(chain,_121814,_121816,_121818):-m(_121814,_121830,_121832),m(_121816,_121830,_121846),m(_121818,_121846,_121832)),
m(chain,s,$1,$1)-(m(chain,_121878,_121880,_121882):-m(_121878,_121894,_121896),m(_121880,_121894,_121910),m(_121882,_121910,_121896))],

[m(chain,$1,a,s)-(m(chain,_121948,_121950,_121952):-m(_121948,_121964,_121966),m(_121950,_121964,_121980),m(_121952,_121980,_121966)),
m(chain,s,$1,b)-(m(chain,_122012,_122014,_122016):-m(_122012,_122028,_122030),m(_122014,_122028,_122044),m(_122016,_122044,_122030)),
m(chain,s,a,b)-(m(chain,_122076,_122078,_122080):-m(_122076,_122092,_122094),m(_122078,_122092,_122108),m(_122080,_122108,_122094))],

[m(chain,$1,s,b)-(m(chain,_122146,_122148,_122150):-m(_122146,_122162,_122164),m(_122148,_122162,_122178),m(_122150,_122178,_122164)),
m(chain,s,a,$1)-(m(chain,_122210,_122212,_122214):-m(_122210,_122226,_122228),m(_122212,_122226,_122242),m(_122214,_122242,_122228)),
m(chain,s,a,b)-(m(chain,_122274,_122276,_122278):-m(_122274,_122290,_122292),m(_122276,_122290,_122306),m(_122278,_122306,_122292))],

[m(chain,s,a,b)-(m(chain,_122344,_122346,_122348):-m(_122344,_122360,_122362),m(_122346,_122360,_122376),m(_122348,_122376,_122362))
]]
```

The problem is that these variables should be named in a more specific manner, as can be seen below:
```
[[
m(chain,$1_1,a,a)-(m(chain,_121750,_121752,_121754):-m(_121750,_121766,_121768),m(_121752,_121766,_121782),m(_121754,_121782,_121768)),
m(chain,$1_1,b,b)-(m(chain,_121814,_121816,_121818):-m(_121814,_121830,_121832),m(_121816,_121830,_121846),m(_121818,_121846,_121832)),
m(chain,s,$1_1,$1_1)-(m(chain,_121878,_121880,_121882):-m(_121878,_121894,_121896),m(_121880,_121894,_121910),m(_121882,_121910,_121896))],

[m(chain,$1_2,a,s)-(m(chain,_121948,_121950,_121952):-m(_121948,_121964,_121966),m(_121950,_121964,_121980),m(_121952,_121980,_121966)),
m(chain,s,$1_2,b)-(m(chain,_122012,_122014,_122016):-m(_122012,_122028,_122030),m(_122014,_122028,_122044),m(_122016,_122044,_122030)),
m(chain,s,a,b)-(m(chain,_122076,_122078,_122080):-m(_122076,_122092,_122094),m(_122078,_122092,_122108),m(_122080,_122108,_122094))],

[m(chain,$1_3,s,b)-(m(chain,_122146,_122148,_122150):-m(_122146,_122162,_122164),m(_122148,_122162,_122178),m(_122150,_122178,_122164)),
m(chain,s,a,$1_3)-(m(chain,_122210,_122212,_122214):-m(_122210,_122226,_122228),m(_122212,_122226,_122242),m(_122214,_122242,_122228)),
m(chain,s,a,b)-(m(chain,_122274,_122276,_122278):-m(_122274,_122290,_122292),m(_122276,_122290,_122306),m(_122278,_122306,_122292))],

[m(chain,s,a,b)-(m(chain,_122344,_122346,_122348):-m(_122344,_122360,_122362),m(_122346,_122360,_122376),m(_122348,_122376,_122362))
]]
```

When using specific positive examples as insputs, the learned program outputs also a negative example as true. For example the following one:
```
s([a,a,a,b],[])
```

The purpose of my work was to investigate whether the hypothesis about faulty part of the thesis is true and whether the renaming dollar variables would help with correct outputs of the program.


## Process of the semestral work
Below are some of the significant steps while working on the project:
- Getting familiar with the project. Reading articles about functionality of the Top Program Construction algorithm and MIL learning. As Louise is and extensive project, in the beginning I was trying to understand how the program works.
- Creating a parser for creation of positive and negative examples that would later serve as inputs to Louise learning. 
    - The parser can be found in the gitlab repository under the name pddl_parser.py.


- Aiming to find out which part of the program is responsible for clause handing and learning part.
- As I later found out, the learning and clause creation part happens in louise.pl file, specifically in the following part of the code: 
```
top_program(Pos,Neg,BK,MS,Ts):-
% Uses the Prolog engine and avoids using the dynamic db too much.
	configuration:theorem_prover(resolution)
	,configuration:clause_limit(K)
	,K > 0
	,S = (write_problem(user,[BK],Refs)
	     ,table(prove/6)
	     )
	,G = (debug(top_program,'Constructing Top program...',[])
	     ,generalise(Pos,MS,Ss_Gen)
	     ,debug_clauses(top_program,'Generalised Top program',Ss_Gen)
	     ,specialise(Ss_Gen,MS,Neg,Ss_Spec)
	     ,debug_clauses(top_program,'Specialised Top program',Ss_Spec)
		 ,copy_term(Ss_Spec, MM)
		,write(MM)
		 ,flatten(Ss_Spec,Ss_Spec_f)
	     ,sort(1,@<,Ss_Spec_f,Ss_Spec_s)
	     ,applied_metarules(Ss_Spec_s,MS,Ts)
	     ,debug_clauses(top_program,'Applied metarules',Ts)
	     )
	,C = (erase_program_clauses(Refs)
	     ,untable(prove/6)
	     )
	,setup_call_cleanup(S,G,C)
	% Fail if Top Program is empty.
	,Ts \= []
	,!.
```
- For some period of time, I’ve had problems understanding how this part of the program has to be treated in order not to fail while editing it.


- Investigating the nature of $NUM variables and how exactly do they behave. Trying to find out whther it is even possible to work with them during latter stages of the project
    - Trying different approaches in renaming those variables to the desired format. Main experiments included 
        - renaming the $num variable alone (replacing_rules.pl, replace_dollars_at0.pl),
        - iterating over a simple list while trying to rename $ variables by incrementally increasing the number part with every new list item (replacing_dollars_whole.pl), 
        - decomposing the 2D list into 3 subparts and examining whether $ variables can be renamed in this way (iterate_over_2d_list.pl)
    - The problem that I encountered was that the $NUM was a specific type of variable that after renaming couldn't be converted back to its original type, meaning that the luoise program would fail afterwards. There was also problem with the complicated format of the clauses that louise created, so that it was difficult to access these variables conveniently without destroying the 2D list.
- The final version that worked out fine was saving the list of generated clauses from Louise prolog environment into the separate file, from which I loaded them to python and renamed them using the tools that were available. (See rename_clauses.py file)

- After successfuly renaming $ variables, I tried to put them back to Louise and continue the work here, but unfortunately the learning was at the stage that was too complicated to edit, so it was necessary to convert the list of clauses into final rules in the similar way. For this I used transform_clauses.py program. 
- After the previous step, the final output looks as follows:
```
'$1_1'(A,B):-a(A,C),a(C,B).
'$1_1'(A,B):-a(A,C),s(C,B).
'$1_2'(A,B):-b(A,C),b(C,B).
'$1_3'(A,B):-s(A,C),b(C,B).
s(A,B):-'$1_1'(A,C),'$1_1'(C,B).
s(A,B):-'$1_2'(A,C),b(C,B).
s(A,B):-a(A,C),'$1_3'(C,B).
s(A,B):-a(A,C),b(C,B).
```

- After obtaining the rules, they were put in the separate prolog file called output_.pl together with background knowledge. Afterwards, this file can be opened in SWI-Prolog environment and it is possible to investigate whether all negative examples provide negative output and positive ones positive output.

- In order to proceed with this investigation I created a simple graphical interface built in tkinter.

- Moreover, it is possible to compare the corrected clauses with the original ones.



## Conclusion and outcomes of the projects
It was found that renaming the dollar variable really helped to correct accuracy of the outputs that Louise produced.

Moreoved the project provides an user interface created in python where user can test files in original Louise thesis and find whether by using given inputs, the outputed results are correct or not.

---

## Dependencies necessary to work with the project
In this section are mentioned all of the programs, dependencies and libraries that are required to have installed on your computer before running the project:

**!Warning: It is necessary to have windows as an operating system as the GUI for the project posesses some tools that are only available to windows users!**


- SWI-Prolog 
    - [www.swi-prolog.org](https://www.swi-prolog.org/Download.html)
- Python 3.9+
    - [www.python.org](https://www.python.org/downloads/)
- Python libraries:
    - os
    - re
    - sys
    - pathlib
    - tkinter
    - customtkinter
    - AppOpener
- Louise repository:
    - [github.com/stassa/louise](github.com/stassa/louise)

> Note: I recommend installing python libraries and modules using pip. More information about pip installation can be found [here](https://pypi.org/project/pip/). You can also install all of the python libraries by running the python file requirements.py that can be found in the project repository.


## Semestral project installation guide

### Project setup:
The first thing that needs to be done is to clone repository from gitlab to your local machine.

It is as well inevitable to have all dependencies successfuly installed and deployed.

Then everything is ready to load the GUI. You can do so by running the python file "louise_gui.py" inside the terminal or running it from a text editor for example from vscode or pycharm.

After having ran the file, the window with instructions will appear. Then, after pressing continue, the main window will appear.

### GUI:

There, you should decide on which problem would you like to focus. During the completion of the semestral project, I specifically worked with the anbn.pl file, where Louise learns a grammar of the context-free a^n b^n language in Prolog's Definite Clause Grammars form.


> In the option menu there's a lot of files to choose from, however if you wish to use your own, you can parse it to the desired format using pddl_parser.py file.

After the selection of the problem, the user interface displays positive and negative examples that are later given to the program. 

Combined with background knowledge, Louise learns the program behaviour. This behaviour can be tested by opening SWI-Prolog environment. For this it is necessary to type "SWI-Prolog" inside the text window and then press the Submit button. This should load the prolog environemnt. 

In here, the louise main file (either load_headless.pl or load_program.pl) can be consulted and it is possible to perform learning by writing learn(s/2).

The learn(s/2) command loads the prolog learned clauses into the clauses_to_rename.txt file that should appear in the same directory. If this didn't happen, the possible problem can the fact that your windows operating system defaultly saves prolog files into a specific directory (for me it was: C:\Users\julia\OneDrive\Dokumenty\Prolog). On linux this normally doesn't happen. If this problem was the case for you, please move the text file into the same directory as louise_gui.py.

The next step is clause renaming. For this it is sufficient to press the "Rename" button inside the GUI window. This action creates the renamed_clauses.pl file.

This is the file that you can later consult in prolog and test whether output for all positive examples is true and for all negative ones is false. You can do so by pasting into prolog environment the examples displayed in the GUI.

Moreover, you can compare the results with original unrenamed louise clauses and see which one of them works better.

## Contact
In case you happen to have any problems or questions about the project, please contact my on my email adress:
julia.krizannova@gmail.com
