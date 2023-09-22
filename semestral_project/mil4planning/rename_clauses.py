from pathlib import Path
import re

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

# write_to_file = str(final_renamed_clauses_list)
# with open('renamed_clauses_file.txt', 'w') as f:
#     f.write(write_to_file)

# '$1_1'(A,B):-a(A,C),a(C,B).
# '$1_1'(A,B):-a(A,C),s(C,B).
# '$1_1'(A,B):-b(A,C),b(C,B).
# '$1_1'(A,B):-s(A,C),b(C,B).
# s(A,B):-'$1_1'(A,C),'$1_1'(C,B).
# s(A,B):-'$1_1'(A,C),b(C,B).
# s(A,B):-a(A,C),'$1_1'(C,B).
# s(A,B):-a(A,C),b(C,B).

# (Chain) ∃.P,Q,R ∀.x,y,z: P(x,y)← Q(x,z),R(z,y)

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
        if head[0][0] == "$":
            result = f"'{head[0]}'({body[0]},{body[1]}) :- {head[1]}({body[0]},{body[2]}), {head[2]}({body[2]},{body[1]})." 
        else:
            result = f"{head[0]}({body[0]},{body[1]}) :- {head[1]}({body[0]},{body[2]}), {head[2]}({body[2]},{body[1]})." 
        transformed_clauses.append(result)

unique_transformed_clauses = []
for rule in transformed_clauses:
    if rule not in unique_transformed_clauses:
        unique_transformed_clauses.append(rule)

for item in unique_transformed_clauses:
    print(item)

with open('absolutely_finalest_clauses_xxxxxxxxxxx.txt', 'w') as file:
    for item in unique_transformed_clauses:
        file.write(item+'\n')

