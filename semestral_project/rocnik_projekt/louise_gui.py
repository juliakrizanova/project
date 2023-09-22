import tkinter as tk
import AppOpener
from pathlib import Path
import subprocess
import re
from tkinter.filedialog import askopenfilename
import os

root = tk.Tk()
# root.geometry("1000x550")
root.geometry("")

def rename_clauses(event):
    current_dir = Path(__file__).resolve().parent
    file_path = 'clauses_to_rename.txt'

    # parse clauses
    with open(file_path, 'r') as f:
        file = f.readlines()
        sub_list = []
        parsed_file_list = []
        for num,line in enumerate(file):
            if "[ [" in line:
                new_line = line.replace("[ [", "").strip()
                new_line = new_line[:-1]
                sub_list.append(new_line)
            elif "]" in line and num != len(file)-1:
                parsed_file_list.append(sub_list)
                sub_list = []
            elif "[" in line:
                new_line = line.replace("[", "").strip()
                new_line = new_line[:-1]
                sub_list.append(new_line)
            else:
                new_line = line.strip()
                new_line = new_line[:-1]
                sub_list.append(new_line)


    # rename clauses
    final_renamed_clauses_list = []
    renamed_clause_sub_list = []
    original_unrenamed_clauses = []
    unrenamed_sub_list = []
    background_knwoledge = ["a([a|T],T).", "b([b|T],T)."]
    def replace_callback(match):
        return match.group(1) + '_' + str(list_idx+1)

    for list_idx, sub_list in enumerate(parsed_file_list):
        for i,clause in enumerate(sub_list):
            dollar_indexes = [i for i, char in enumerate(clause) if char == '$']
            
            if dollar_indexes == []:
                renamed_clause_sub_list.append(clause)
                unrenamed_sub_list.append(clause)
            else:
                new_clause = re.sub(r'(\$[0-9]+)', replace_callback, clause)
                renamed_clause_sub_list.append(new_clause)
                unrenamed_sub_list.append(clause)

            if i == len(sub_list)-1:
                final_renamed_clauses_list.append(renamed_clause_sub_list)
                renamed_clause_sub_list = []
                original_unrenamed_clauses.append(unrenamed_sub_list)
                unrenamed_sub_list = []

    # write_to_file = str(final_renamed_clauses_list)
    # with open('renamed_clauses_file.txt', 'w') as f:
    #     f.write(write_to_file)


    # prolog_list = [
    #     [ "m(chain,'$1_1',a,a)-(m(chain,A,B,C) :- m(A,D,E),m(B,D,F),m(C,F,E))",
    #       "m(chain,'$1_1',b,b)-(m(chain,G,H,I) :- m(G,J,K),m(H,J,L),m(I,L,K))",
    #       "m(chain,s,'$1_1','$1_1')-(m(chain,M,N,O) :- m(M,P,Q),m(N,P,R),m(O,R,Q))"
    #     ],
    #     [ "m(chain,'$1_2',a,s)-(m(chain,S,T,U) :- m(S,V,W),m(T,V,X),m(U,X,W))",
    #       "m(chain,s,'$1_2',b)-(m(chain,Y,Z,A1) :- m(Y,B1,C1),m(Z,B1,D1),m(A1,D1,C1))",
    #       "m(chain,s,a,b)-(m(chain,E1,F1,G1) :- m(E1,H1,I1),m(F1,H1,J1),m(G1,J1,I1))"
    #     ],
    #     [ "m(chain,'$1_3',s,b)-(m(chain,K1,L1,M1) :- m(K1,N1,O1),m(L1,N1,P1),m(M1,P1,O1))",
    #       "m(chain,s,a,'$1_3')-(m(chain,Q1,R1,S1) :- m(Q1,T1,U1),m(R1,T1,V1),m(S1,V1,U1))",
    #       "m(chain,s,a,b)-(m(chain,W1,X1,Y1) :- m(W1,Z1,A2),m(X1,Z1,B2),m(Y1,B2,A2))"
    #     ],
    #     [ "m(chain,s,a,b)-(m(chain,C2,D2,E2) :- m(C2,F2,G2),m(D2,F2,H2),m(E2,H2,G2))"
    #     ]
    # ]
    prolog_list = final_renamed_clauses_list

    result = []
    transformed_clauses = []
    for i, rule_set in enumerate(prolog_list):
        for j, rule in enumerate(rule_set):
            rule = rule.replace(" ", "")
            head, body_x = rule.split(')-(')
            if i == 0 and j == 0:
                body = body_x.strip()+"("
                body = body.replace("m(chain,", "")
                index = body.index('):-')
                body = body[:index].split(',')
            head = head.strip()+")"
            head = head.replace("m(chain,", "")
            head = head.replace("'", "")
            head = head[:-1].split(',')

            n_head = []
            for item in head:
                if item[0] == '$':
                    n_item = f"'{item}'"
                    n_head.append(n_item)
                else:
                    n_head.append(item)

            # if head[0][0] == "$":
            #     result = f"'{n_head[0]}'({body[0]},{body[1]}) :- {n_head[1]}({body[0]},{body[2]}), {n_head[2]}({body[2]},{body[1]})." 
            # else:
            #     result = f"{n_head[0]}({body[0]},{body[1]}) :- {n_head[1]}({body[0]},{body[2]}), {n_head[2]}({body[2]},{body[1]})." 
            result = f"{n_head[0]}({body[0]},{body[1]}) :- {n_head[1]}({body[0]},{body[2]}), {n_head[2]}({body[2]},{body[1]})." 
            transformed_clauses.append(result)
    
    result = []
    unnamed_list = original_unrenamed_clauses
    original_unstransformed_clauses = []
    for i, rule_set in enumerate(unnamed_list):
        for j, rule in enumerate(rule_set):
            rule = rule.replace(" ", "")
            head, body_x = rule.split(')-(')
            if i == 0 and j == 0:
                body = body_x.strip()+"("
                body = body.replace("m(chain,", "")
                index = body.index('):-')
                body = body[:index].split(',')
            head = head.strip()+")"
            head = head.replace("m(chain,", "")
            head = head.replace("'", "")
            head = head[:-1].split(',')

            n_head = []
            for item in head:
                if item[0] == '$':
                    n_item = f"'{item}'"
                    n_head.append(n_item)
                else:
                    n_head.append(item)

            # if head[0][0] == "$":
            #     result = f"'{n_head[0]}'({body[0]},{body[1]}) :- {n_head[1]}({body[0]},{body[2]}), {n_head[2]}({body[2]},{body[1]})." 
            # else:
            #     result = f"{n_head[0]}({body[0]},{body[1]}) :- {n_head[1]}({body[0]},{body[2]}), {n_head[2]}({body[2]},{body[1]})." 
            result = f"{n_head[0]}({body[0]},{body[1]}) :- {n_head[1]}({body[0]},{body[2]}), {n_head[2]}({body[2]},{body[1]})." 
            original_unstransformed_clauses.append(result)

    unique_transformed_clauses = []
    for rule in transformed_clauses:
        if rule not in unique_transformed_clauses:
            unique_transformed_clauses.append(rule)

    unique_untransformed_clauses = []
    for rule in original_unstransformed_clauses:
        if rule not in unique_untransformed_clauses:
            unique_untransformed_clauses.append(rule)

    for item in unique_transformed_clauses:
        print(item)
    for item in background_knwoledge:
        print(item)

    with open('renamed_clauses.pl', 'w') as file:
        for item in unique_transformed_clauses:
            file.write(item+'\n')
        for item in background_knwoledge:
            file.write(item+'\n')

    with open('original_output.pl', 'w') as file:
        for item in unique_untransformed_clauses:
            file.write(item+'\n')
        for item in background_knwoledge:
            file.write(item+'\n')


# ___________________________________________________________________________________________________________________________________________


def test_all(event):
    def list_directories_and_files(path):
        try:
            # List all directories and files in the given path
            items = os.listdir(path)
            
            # print(f"Contents of {path}:")
            # for item in items:
                # print(item)
            
            return items
        except FileNotFoundError:
            print(f"Path '{path}' not found.")
            return []


    # PATH CAN BE EDITED BY USER
    # file_name = "semestral_projectFF/mil4planning/parsed_positive_examples/louise_positive_out.txt" # path working for linux execution
    file_name = "mil4planning\parsed_positive_examples\louise_positive_out.txt"
    # dir_path = r"mil4planning\parsed_positive_examples"


    # items = list_directories_and_files(dir_path)
    # print(items)


    # # Ask the user to select a directory
    # file_name = input("Choose file name to test examples (i.e. louise_positive_out.txt): ")
    # whole_path = os.path.join(dir_path, file_name)
    # print(whole_path)

    lines = []
    positive_examples = []

    with open(file_name, 'r') as file:
        # Read all lines and store them in the 'lines' list
        lines = file.readlines()

    for example in lines:
        example = example.strip()
        example = example[:-1]
        positive_examples.append(example)

    def create_prolog_file(example, file_name_prolog):
        
        with open(file_name_prolog, 'w') as file:
            # Write data to the file
            file.write(":-[renamed_clauses].\n")
            file.write(f":-{example}, write('true').\n")
            file.write(":-halt.\n")

        # The file is automatically closed when the 'with' block exits
        print(f"\nData has been written to {file_name_prolog}")


    for i, example in enumerate(positive_examples):
        file_name_prolog = "prolog_test_example_"+str(i)+".pl"
        
        swipl_file = create_prolog_file(example, file_name_prolog)
        try:
            print("fileneme: ", file_name_prolog)
            subprocess.run(['swipl', file_name_prolog], check=True)    
        except subprocess.CalledProcessError as e:
            print(f"Error running program2: {e}")













# ____________________________________________________________________________________________________________________________________________


def clear_and_create_new_gui():
    # Clear the current GUI
    for widget in root.winfo_children():
        widget.destroy()
    # Create a new GUI
    # select_file_text = tk.Label(root, text="Select file you want to investigate:").pack()

    # options = ["anbn","cyklus", "infix", "linear", "postfix0", "postfix1", "prefix0", "prefix1"]
    # option_var = tk.StringVar()
    # option_var.set("options")  # Set the default option
    # option_menu = tk.OptionMenu(root, option_var, *options)
    # option_menu.pack()


    # Create a Label for the left side
    select_file_text = tk.Label(root, text="Select file you want to investigate:",font=("", 15))
    select_file_text.pack(padx=10, pady=10)  # Adjust padx and pady as needed

    # Define the options for the OptionMenu
    options = ["anbn", "cyklus", "infix", "linear", "postfix0", "postfix1", "prefix0", "prefix1"]
    option_var = tk.StringVar()
    option_var.set("Options")  # Set the default option

    # Create the OptionMenu for the right side
    option_menu = tk.OptionMenu(root, option_var, *options)
    option_menu.pack(padx=10, pady=10)  # Adjust padx and pady as needed
    option_menu.config(font=("", 12))



    # # Create a Left Text widget to display the text
    # left_text_title = tk.Label(root, text="Positive examples (should return true):").pack()
    # text_widget_left = tk.Text(root, wrap=tk.WORD, height=6)
    # text_widget_left.pack()
    

    # # Create a Right Text widget to display the text
    # right_text_title = tk.Label(root, text="Negative examples (should return false):").pack()
    # text_widget_right = tk.Text(root, wrap=tk.WORD, height=6)
    # text_widget_right.pack()

    # Create a frame to hold the Text widgets
    text_frame = tk.Frame(root)
    text_frame.pack(padx=10, pady=10)

    # Create a Left Text widget
    left_text_title = tk.Label(text_frame, text="Positive examples \n (should return true):", font=("", 12))
    left_text_title.grid(row=0, column=0, padx=(0, 10))  # Adjust padx as needed

    text_widget_left = tk.Text(text_frame, wrap=tk.WORD, height=6)
    text_widget_left.grid(row=0, column=1)

    # Create a Right Text widget
    right_text_title = tk.Label(text_frame, text="Negative examples \n (should return false):", font=("", 12))
    right_text_title.grid(row=1, column=0, padx=(0, 10))  # Adjust padx as needed

    text_widget_right = tk.Text(text_frame, wrap=tk.WORD, height=6)
    text_widget_right.grid(row=1, column=1)


    def load_text_file():
        selected_option = option_var.get()
        file_paths = {
            "anbn": ["mil4planning\parsed_positive_examples\louise_positive_out.txt", "mil4planning\parsed_negative_examples\louise_negative_out.txt"],
            "cyklus": ["mil4planning\parsed_positive_examples\cyklus_positive_out.txt", ""],
            "infix": ["mil4planning\parsed_positive_examples\infix_positive_out.txt", ""],
            "linear": ["mil4planning\parsed_positive_examples\linear_positive_out.txt",""],
            "postfix0": ["mil4planning\parsed_positive_examples\postfix0_positive_out.txt", ""],
            "postfix1": ["mil4planning\parsed_positive_examples\postfix1_positive_out.txt", ""],
            "prefix0": ["mil4planning\parsed_positive_examples\prefix0_positive_out.txt", ""],
            "prefix1": ["mil4planning\parsed_positive_examples\prefix1_positive_out.txt", ""]
        }

        file_path_left = file_paths.get(selected_option, "")[0]  # Get the selected file path
        print(file_path_left)

        file_path_right = file_paths.get(selected_option, "")[1]
        print(file_path_right)


        try:
            with open(file_path_left, "r") as file:
                text_content = file.read()
                text_widget_left.delete("1.0", "end") 
                text_widget_left.insert("1.0", text_content)
        except FileNotFoundError:
            text_widget_left.delete("1.0", "end")
            text_widget_left.insert("1.0", "File not found.")

        try:
            with open(file_path_right, "r") as file:
                text_content = file.read()
                text_widget_right.delete("1.0", "end") 
                text_widget_right.insert("1.0", text_content)
        except FileNotFoundError:
            text_widget_right.delete("1.0", "end")
            text_widget_right.insert("1.0", "File not found.")
    
            
    load_button = tk.Button(root, text="Load Text File", command=load_text_file, font=("",12))
    load_button.pack()
    
    # __parse big dicts__________________________________________________________________________________________________________________________________

    def parse_other():
        # Function to display directories and files in the given path
        def list_directories_and_files(path):
            try:
                # List all directories and files in the given path
                items = os.listdir(path)
                
                # print(f"Contents of {path}:")
                # for item in items:
                    # print(item)
                
                return items
            except FileNotFoundError:
                print(f"Path '{path}' not found.")
                return []


        # PATH CAN BE EDITED BY USER
        current_path = r"mil4planning\entry_files\samplePlans\all-domains"


        items = list_directories_and_files(current_path)
        print(items)


        # Ask the user to select a directory
        user_choice = input("Select one of the displayed directories: ")

        # Check if the user's choice is a valid directory
        if user_choice in items and os.path.isdir(os.path.join(current_path, user_choice)):
            current_path = os.path.join(current_path, user_choice)
            
            # Store the contents of the selected directory in a list
            selected_directory_contents = list_directories_and_files(current_path)
            # print("Contents of selected directory stored in list:")
            # print(selected_directory_contents)
        else:
            print("Invalid choice. Please select a valid directory.")


        # create positive example file:
        # print("CURR PATH: ", current_path)
        # print(selected_directory_contents)
        all_files_actions = []
        for item in selected_directory_contents:
            curr_file = os.path.join(current_path, item)
            with open(curr_file, "r") as f:
                curr_file_actions = []
                for line in f:
                    line = line.strip()
                    if line:
                        action = line.strip("()").split(" ")[0]
                        # print("Action",action)
                        curr_file_actions.append(action)
                # print(curr_file_actions)
            all_files_actions.append(curr_file_actions)
        # print(all_files_actions)   


        #save as positive example format
        # #s([a,a,b,b],[])
        out_path = current_path + "_positive_out.txt"

        with open(out_path, "w") as f:
            for a, action in enumerate(all_files_actions):
                f.write("s([")
                for i,act in enumerate(action):
                    if i+1 == len(action):
                        f.write(act)
                    else:
                        f.write(act+", ")
                f.write("], []).")
                if a+1 == len(all_files_actions):
                    break
                else:    
                    f.write("\n")



        # create negative example file:
        all_files_actions = []
        for item in selected_directory_contents:
            curr_file = os.path.join(current_path, item)
            with open(curr_file, "r") as f:
                curr_file_actions = []
                for id,line in enumerate(f):
                    line = line.strip()
                    if line:
                        action = line.strip("()").split(" ")[0]
                        # print("Action",action)
                        curr_file_actions.append(action)
                        if id == 4:
                            curr_file_actions.reverse()
                            break
                # print(curr_file_actions)
            all_files_actions.append(curr_file_actions)


        #save as negative example format
        # #s([a,b,b,b],[])
        out_path = current_path + "_negative_out.txt"
        with open(out_path, "w") as f:
            for a, action in enumerate(all_files_actions):
                f.write("s([")
                for i,act in enumerate(action):
                    if i+1 == len(action):
                        f.write(act)
                    else:
                        f.write(act+", ")
                f.write("], []).")
                if a+1 == len(all_files_actions):
                    break
                else:    
                    f.write("\n")





    # __parse big dicts end__________________________________________________________________________________________________________________________________


    create_different = tk.Button(root, text ='Create Other Examples', command = parse_other)
    create_different.pack()
 
    def open_file():
        file = askopenfilename()
        os.system('"%s"' % file)
 
    load_big_files = tk.Button(root, text ='Search Other Examples', command = open_file)
    load_big_files.pack()

    empty_label = tk.Label(root, text="")
    empty_label.pack()

    select_app = tk.Label(root, text="Type in \"SWI-Prolog\" to load the environment: ", font=("", 14)).pack()

    text_area = tk.Text(root, height=1, width=40, font=("",15))
    text_area.pack()
    submit_button = tk.Button(root, text="Submit", font=("", 15))
    submit_button.pack()

    label = tk.Label(root, text="")
    label.pack()
    # label.config(text="Type in the name of the program you want to run")

    rename_button = tk.Button(root, text="Rename", font=("", 15))
    rename_button.pack()
    empty_ = tk.Label(root, text="").pack()

    test_button = tk.Button(root, text="Test all examples", font=("", 15))
    test_button.pack()
    empty_ = tk.Label(root, text="").pack()

    # run_process_button = tk.Button(root, text="Submit", font=("", 20))
    # run_process_button.pack()

    def open_app(event):
        app_name = text_area.get("1.0", "end")
        AppOpener.open(app_name)
        label.config(text=str("Seraching "+app_name))
        text_area.delete("1.0", "end")
        # final_clauses = rename_clauses()
        

    submit_button.bind("<Button-1>", open_app)

    rename_button.bind("<Button-1>", rename_clauses)

    test_button.bind("<Button-1>", test_all)

    # def run_subprocess(event):
    #     script_path = "rename_clauses.py"
    #     # Run the script in the background as a separate process
    #     process = subprocess.Popen(['python', script_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    #     print(process)
    #     print("Main script continues running while 'background_script.py' is running in the background.")
    #     # Check if the process is still running
    #     if process.poll() is None:
    #         print("The background script is still running.")
    #     else:
    #         # The process has completed
    #         return_code = process.returncode
    #         if return_code == 0:
    #             print(f"The background script has completed successfully with exit code {return_code}.")
    #         else:
    #             print(f"The background script has completed with an error (exit code {return_code}).")
    # run_process_button.bind("<Button-1>", run_subprocess)



# giving title to the main window
root.title("LOUISE: Polynomial-time Program Learning")

# Label is what output will be shown on the window
gui_title = tk.Label(root, text="Welcome to Louise",  font=("", 17)).pack()

gui_subtitle = tk.Label(root, text="Polynomial-time Program Learning",  font=("", 13)).pack()
empty_ = tk.Label(root, text="").pack()

# Scrollable text widget
text_widget = tk.Text(root, wrap=tk.WORD, width=130, height=31, font=("", 12), padx=20, pady=20)  # Set the width to 40 characters
text_ = "Carefully read instructions before continuing: \n \n 1. From the dropdown menu, choose the problem that you want to work on. After pressing the \"Load text file\" button, the positive and negative examples will be displayed.\n \n 1.1 There is also a possibility of creating positive and negative examples based on your own planning program. For this you need to upload a directory with all the desired files in: \"mil4planning/entry_files/samplePlans/all-domains\" If you don't want to create your own examples, you can as well choose to parse any of the directories with real world planning programs that are present in the previously mentioned place. You can do so by pressing \"Create Other Examples\" button in the GUI. This will display an overview (in the terminal) of the possible directories to choose from. Once you chose a directory, write its name into the command line and press enter. This will create set of positive and negative examples based on the chosen directory data. These sets of examples will be stored in files named \"dict-name_positive_out.txt\" or \"dict-name_negative_out.txt\" (they are located here: mil4planning/entry_files/samplePlans/all-domains)\n \n1.2 These files won't load into GUI, as they would take too much space and the content wouldn't be readable. However, if you want to see how the file with examples looks like, you can choose to open it in a text editor. This can be done by pressing \"Search Other Examples\" button. After pressing the button a file explorer will open, so you can choose the file you want to see and open it in the text editor. \n \n2. Type \"SWI-Prolog\" inside the text box in order to run the program.\n \n 3. Here consult one of Louise's loading files and and learn. \n => For example: [load_headless], learn(s/2). \n \n 4. After learning, a text file named clauses_to_rename.txt will be created. You can rename them by pressing \"Rename\" button.\n \n 5. After this step, the renamed rules are written inside a prolog file \"renamed_clauses.pl\". After consulting this file, you can make queries about postive and negative examples displayed in the gui and see whether they are true or false. \n \n 5.1 If you do not wish to make manual queries about specific positive or negative example, you can simply test all of them by pressing the \"Test all examples\" button. This will display an overview (in the terminal) of the possible files to choose from. Once you chose the file with examples that you wish to review, write its name into the command line and press enter. The program will go through all of the examples inside a file and will output true to the command line after each positive example that should have the true output.\n \n Note: there is also possibility to consult file original_clauses.pl, which is original unrenamed Louise output that originally gave incorrect results."
text_widget.insert(tk.END, text_)
text_widget.pack()

# Scrollbar for the text widget
# scrollbar = tk.Scrollbar(root, command=text_widget.yview)
# scrollbar.pack()
# text_widget.config(yscrollcommand=scrollbar.set)

# Initial GUI content
button = tk.Button(root, text="Continue",  font=("", 15), command=clear_and_create_new_gui).pack()
empty_ = tk.Label(root, text="").pack()

root.mainloop()

