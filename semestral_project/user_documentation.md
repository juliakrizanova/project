# User Documentation

In this documentation you can find the description of program controls (what and how can be done with the program), interface description.

## Description of the GUI functionalities:
Carefully read instructions before starting working with the Louise GUI iterface. 

- At the beginning it is necessary to choose the set of positive and negative examples that Louise will learn. This can be done in 2 ways:
    - Either, choose the problem that you want to work on from the dropdown menu. After pressing the "Load text file" button, the positive and negative examples will be displayed. These are just the simple examples. If you want to have set of positive and negative examples from the real world planning problem, follow the second option.
    - The second option makes it possible to create positive and negative examples based on your own planning program. For this you need to upload a directory with all the desired files in: "mil4planning/entry_files/samplePlans/all-domains".
        - If you don't want to create your own examples, you can as well choose to parse any of the directories with real world planning programs that are present in “mil4planning/entry_files/samplePlans/all-domains”. 
        - You can do so by pressing "Create Other Examples" button in the GUI.
        -  This will display an overview (in the terminal) of the possible directories to choose from. Once you chose a directory, write its name into the command line and press enter.
        -  This will create set of positive and negative examples from the chosen directory data. These sets of examples will be stored under the name "dict-name_positive_out.txt" or "dict-name_negative_out.txt" (these files will be located here: mil4planning/entry_files/samplePlans/all-domains)
        -  These files won't load into GUI, as they would take too much space and the content wouldn't be readable.
        -  However, if you want to see how the file with examples look like, you can choose to open it in a text editor.
        -  This can be done by pressing "Search Other Examples" button. After pressing the button a file explorer will open, so you can choose the file you want to see and open it in the text editor. 
-  Type "SWI-Prolog" inside the text box in order to run the program.
-  Here consult one of Louise's loading files and and learn. 
 => For example: [load_headless], learn(s/2). 
 
- After learning, a text file named clauses_to_rename.txt will be created. You can rename them by pressing "Rename" button.
 
- After this step, the renamed rules are written inside a prolog file "renamed_clauses.pl". After consulting this file, you can make queries about postive and negative examples displayed in the gui and see whether they are true or false. 
    - If you do not wish to make manual queries about specific positive or negative example, you can simply test all of them by pressing the "Test all examples" button. This will display an overview (in the terminal) of the possible files to choose from. Once you chose the file with examples that you wish to review, write its name into the command line and press enter. The program will go through all of the examples inside a file and will output true to the command line after each positive example that should have the true output.
