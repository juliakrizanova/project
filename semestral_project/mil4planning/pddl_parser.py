import os

# import sys
# directory = input("Enter the directory path: ")
# directory = sys.argv[1]
# directory = "/home/juliakrizanova/Documents/mff_cuni4/rocnikac/mil4planning/entry_files/simple/umele/postfix0/"
directory = "/home/juliakrizanova/Documents/mff_cuni4/rocnikac/mil4planning/entry_files/simple/umele/"
dir_name = input("Choose dir name: ")
directory = directory+dir_name+"/"

all_files_actions = []
for filename in os.listdir(directory):
    if filename.endswith(".txt"):
        print("Filename:", filename)
        curr_file = os.path.join(directory, filename)
        with open(curr_file, "r") as f:
            curr_file_actions = []
            for line in f:
                line = line.strip()
                if line:
                    action = line.strip("()").split(" ")[0]
                    # print("Action",action)
                    curr_file_actions.append(action)
            print(curr_file_actions)
        all_files_actions.append(curr_file_actions)
        print(all_files_actions)


"""
# specify full path to output file
# out_filename = filename[:-4] + "_out.txt"
# out_filename = "postfix0_out.txt"
out_filename = dir_name + "_out.txt"
output_dir = "/home/juliakrizanova/Documents/mff_cuni4/rocnikac/mil4planning/parsed_files/"
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

with open(os.path.join(output_dir, out_filename), "w") as f:
    for a, action in enumerate(all_files_actions):
        f.write("[")
        for i,act in enumerate(action):
            if i+1 == len(action):
                f.write(act)
            else:
                f.write(act+", ")
        f.write("]")
        if a+1 == len(all_files_actions):
            break
        else:    
            f.write("\n")
"""

#save as positive example format
#s([a,a,b,b],[]).
out_filename = dir_name + "_positive_out.txt"
output_dir = "/home/juliakrizanova/Documents/mff_cuni4/rocnikac/mil4planning/parsed_positive_examples/"
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

with open(os.path.join(output_dir, out_filename), "w") as f:
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
