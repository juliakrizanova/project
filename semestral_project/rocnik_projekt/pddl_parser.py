import os

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


# create positive example file:_________________________________________________________________________________________________________
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



# create negative example file:_________________________________________________________________________________________________________
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



# these files wont load into GUI, They are too big anyways. However, if you really want to see how the file with examples look, you can choose to open it in a text editor

