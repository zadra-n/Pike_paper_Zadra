#!/bin/bash

# Check if a file path has been provided 
if [ -z "$1" ]; then
    echo "Usage: $0 [path_to_file (popcluster output summary file.K)] [output_name (defoult: output]"
    exit 1
fi

# Use the first argument as the file path
path_to_file="$1"
dir_path=$(dirname "$path_to_file")


# Check if the file exists
if [ ! -f "$path_to_file" ]; then
    echo "File not found: $path_to_file (popcluster output summary file.K)] "
    exit 1
fi

# Optional: check for Rscript and second argument
if [ -z "$2" ]; then
    echo "Warning: No output name provided. Defaulting to 'output'."
    output_name="output"
else
    output_name="$2"
fi

# Check for Rscript
if ! command -v Rscript &> /dev/null; then
    echo "Rscript could not be found. Please ensure it is installed and in your PATH."
    exit 1
fi

##counter
line_number=0

echo $dir_path
##add_dir_result
out_dir="${dir_path}/Result"

mkdir "$out_dir"

while IFS= read -r line; do

    echo "Processing line number: $line_number"
    # Check if the line is blank
    if [ -z "$line" ]; then
        # Extract the lines that refer to the best k
        head -n "$line_number" "$path_to_file" > "${out_dir}/table_bestK"
        break
    fi
	((line_number++))
done < "$path_to_file"

###create a comma-separated file
# Remove leading spaces from the file
sed -i 's/^[ \t]*//g; s/[[:space:]]\+/,/g; /^$/d' "${out_dir}/table_bestK"
sed -i 's/^ *//g;  s/\"//g; /^$/d' "${out_dir}/table_bestK"


echo "Stopped at line number: $line_number"
echo "Now running Rscript for input file processing..."


Rscript Best_K_input.R table_bestK "$output_name" "$out_dir"

#### Iterate over the CSV, skipping the header line

tail -n +2 ${out_dir}/table_bestK | cut -d ',' -f2 > ${out_dir}/tmp

echo  "Popcluster result directory: $dir_path"


###extract the admixture analysis from the file in the Popcluster_folder
while IFS= read -r id; do 
	full_path="${dir_path}/${id}"
	
	./Popcluster_plot.sh  "$full_path" "$out_dir"
	
done < ${out_dir}/tmp

rm ${out_dir}/tmp
