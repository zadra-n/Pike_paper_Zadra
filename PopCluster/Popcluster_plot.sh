#!/bin/bash

##extract admixture analysis

#!/bin/bash

# Script to extract admixture analysis from a given file with the format inputname_K_x_R_y.
# The output will be a CSV file containing the relevant admixture information.


if [ -z "$1" ]; then
    echo "Usage: $0 inputname_K_x_R_y out_dir"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Usage: $0 inputname_K_x_R_y out_dir"
    exit 1
fi


suffix="Admixture"
filename=$(basename "$1")
output_name="${suffix}_${filename}"

dir_path=$(dirname "$1")

echo "directory patH ${dir_path}"
out_dir=$2
echo "directory patH ${out_dir}"
###extract K value 

if [[ $filename =~ _K_([0-9]+)_ ]]; then
    num_cols="${BASH_REMATCH[1]}"
else
    echo "Error: The filename does not contain the expected format 'inputname_K_x_R_y'."
    exit 1
fi


# Extract the admixture analysis section, remove the first 7 lines, unnecessary whitespaces, colons, and format the table header
sed -n '/Admixture analysis/,/^$/p' "$1" | \
  sed '1,7d; s/^ *//g; s/://g; s/Cluster.*/Cluster/; s/[[:space:]]\+/,/g'  > "${out_dir}/${output_name}"

# Generate column headers to add
headers_to_add=""
for ((i=1; i<=num_cols; i++)); do
    headers_to_add+=",K$i"
done



awk -v hta="$headers_to_add" 'NR==1 {$0=$0 hta} 1' "${dir_path}/${out_dir}/${output_name}" > "${out_dir}/${output_name}_reheader.csv"

input_R="${output_name}_reheader.csv"

echo "The column name ${headers_to_add} are in the ${input_R}" 

rm "${out_dir}/${output_name}"
pwd
Rscript Plot_structure.R "$input_R"  /mnt/c/Users/zadran/Desktop/Pike_2024/Luccio_data/ID_luccio.csv "$out_dir"