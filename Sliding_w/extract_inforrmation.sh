#!/bin/bash

# Set the directory containing your .tree files
Trees='/mnt/c/Users/zadran/Desktop/Pike_2024/Pike_phylo/sliding/No_po_500kb/tree_list.txt'
 
####################################################################
##  run the following command to create the tree_list.txt adjust  ##
##    the sort  command ordering by the specific field			  ##
##        ls *tree | sort -t '_' -k3,3n -k5,5n                    ##
####################################################################


echo -e "NC\tNumber\tStart\tEnd\tTree"
# Loop through .tree files in the specified directory

while IFS= read -r line; do	
    # Split the filename to extract the required parts
    IFS='_' read -r -a PARTS <<< "$line"
    NC="NC_${PARTS[2]}"
    NUMBER="${PARTS[3]}"
    Start="${PARTS[4]}"
    End="${PARTS[5]%.*}" # Remove the file extension

    # Read the content of the file
    CONTENT=$(cat "$line")
    # Print the extracted data and file content
    echo -e "$NC\t$NUMBER\t$Start\t$End\t$CONTENT"
done < "$Trees"