import subprocess

file_name = "mil4planning\parsed_positive_examples\louise_positive_out.txt"
# file_name = "semestral_projectFF/mil4planning/parsed_positive_examples/louise_positive_out.txt" # path working for linux execution

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
