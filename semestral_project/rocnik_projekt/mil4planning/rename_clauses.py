from pathlib import Path
import re

current_dir = Path(__file__).resolve().parent
file_path = current_dir.parent / 'clauses_to_rename.txt'


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

def replace_callback(match):
    return match.group(1) + '_' + str(list_idx+1)

for list_idx, sub_list in enumerate(parsed_file_list):
    for i,clause in enumerate(sub_list):
        dollar_indexes = [i for i, char in enumerate(clause) if char == '$']
        
        if dollar_indexes == []:
            renamed_clause_sub_list.append(clause)
        else:
            new_clause = re.sub(r'(\$[0-9]+)', replace_callback, clause)
            renamed_clause_sub_list.append(new_clause)

        if i == len(sub_list)-1:
            final_renamed_clauses_list.append(renamed_clause_sub_list)
            renamed_clause_sub_list = []


write_to_file = str(final_renamed_clauses_list)
with open('renamed_clauses_file.txt', 'w') as f:
    f.write(write_to_file)