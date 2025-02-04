
from ete3 import Tree
from collections import defaultdict
import string
import re
import pandas as pd

###import data
##function for setting an outgroup and remove the bootsrap support
def root_tree(t, outgroup):
    tr = Tree(t)
    tr.set_outgroup(tr&outgroup)
    tree = tr.write(format=1)
    return tree


###import data

df = pd.read_csv('../No_po_1m/No_po_500m.tsv', sep='\t')

##create empty list of letter combination
print(len(df))

df

# %%

counta = 0

unKnow_top = 0 
no_tree = 0
tree_counter={}
df['Topology'] = ''
topologies={}
alphabet = []
for first_letter in string.ascii_uppercase:
    # Iterate through each letter in the alphabet for the second character
    for second_letter in string.ascii_lowercase:
        # Combine the first and second letters and append to the list
        alphabet.append(first_letter + second_letter)
    ###iterate over a list of tree
        
for index, row in df.iterrows():

    if pd.isna(row['Tree']):
        no_tree = no_tree + 1 
        df.at[index, 'Topology'] = 'No_tree'
        continue
    tr=row['Tree']

    ####control the bootstrap
    numbers = re.findall(r'\d+', tr)
        
    ###filter out number by bootstrap value
    filtered_numbers = [int(num) for num in numbers if int(num) > 40]
  
        
    if len(filtered_numbers) < 2:
        unKnow_top = unKnow_top + 1
        df.at[index, 'Topology'] = 'none'
        #print(filtered_numbers)
        continue
    
    
    ####root the tree
    tree=Tree(root_tree(tr, 'Pike'))

    ####control if we are seeing a new topology
    new_topology = True

    ###append the first tree as new topology to the empty list
    if not topologies:
        topologies.update({alphabet[0]:tree})
        tree_counter.update({alphabet[0]:1})
        print(topologies)
        df.at[index, 'Topology'] = alphabet[0]
            
    ###iterate ovet the unique topology dictionary
    for count, (key, item) in enumerate(topologies.items()):
        
            #calculate the robinson foulds value to check if the trees are the same
        rf = tree.robinson_foulds(item)
            ##if the the tree is the same of teh one already present in the new topology bereaks the for cycle 
        if rf[0] == 0:
            new_topology = False
            #print(key)
            df.at[index, 'Topology'] = key
            tree_counter[key] += 1
               
        
    if new_topology:
        counta = counta +1
        
        topologies.update({alphabet[count + 1]:tree})
        tree_counter.update({alphabet[count + 1]:1})
        df.at[index, 'Topology'] = alphabet[count + 1]




# %%
df.to_csv('topologies_500k.tsv', sep='\t')

# %%
sorted_count = dict(sorted(tree_counter.items(),key=lambda item:item[1], reverse=True))

# %%
merged_dict = {}
for key in sorted_count:
    merged_dict[key]=[sorted_count[key], topologies[key]]


