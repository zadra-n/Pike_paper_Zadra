#!/bin/bash

###set path for all the scripts that are going to be used in this pipline
###I need vcf2phylip to conver the sliding windows in nexus alignemnt

vcf2phy="/mnt/c/Users/zadran/Desktop/Desktop_ubuntu/vcf2phylip/vcf2phylip.py"
PAUP="/mnt/c/Users/zadran/Desktop/Desktop_ubuntu/paup4a168_ubuntu64"
vcf_file="/mnt/c/Users/zadran/Desktop/Pike_2024/Pike_phylo/sliding/No_po/pikeisec@nopo.vcf.gz"
cmd_paup="/mnt/c/Users/zadran/Desktop/Pike_2024/Pike_phylo/sliding/No_po/Paup_command_to_add.nex"
partition="/mnt/c/Users/zadran/Desktop/Pike_2024/Pike_phylo/sliding/No_po/partition.nex"
chr_list="/mnt/c/Users/zadran/Desktop/Pike_2024/Pike_phylo/sliding/No_po/chrom_list.txt"
###print out chromosome lenght

N_SNPs=$(bcftools view -H $vcf_file | wc -l)

echo "The lenght of the vcf file is ${N_SNPs}"


###extract chromosome name form the chrom list 
while IFS= read -r chr; do 
	vcf_base=$(basename $vcf_file | awk -F [.] '{print $1}')
	
	vcf_name=${vcf_base}_${chr}
	echo "$chr"
	
	bcftools view -r $chr $vcf_file -Oz -o ${vcf_name}.vcf.gz
	bcftools index ${vcf_name}.vcf.gz
	chr_len=$(bcftools view -h $vcf_file | grep "##contig=<ID=${chr}"| awk -F'[=,>]' '{print $5}')
	echo "the vcf_name is: ${vcf_name}"
	echo "chromosome lenght: ${chr_len}"
	
	####make the analisis in sliding window
	window_size=2000000
	step_size=2000000
	sequence_length=$chr_len # Adjust if your sequence length is different
	count=0
	for (( i=0; i<=sequence_length; i+=step_size )); do
		# Calculate the start and end positions of the current window
		start_position=$((i + 1))  
		end_position=$((i + window_size))
	
		###if the window at the end is smaller the  the window_size it takes the chromosome lenght as end
		if (($end_position > $sequence_length)); then 
			end_position=$sequence_length;
		fi
	
		##create a nexus file for each windows
		((count++))
		id=$(echo "${vcf_name}.vcf.gz" | awk -F'[.]' '{print $1}') 
		file_name="${id}_${count}"
		
		bcf_tmp="${file_name}.vcf.gz"
		bcftools view -r ${chr}:$start_position-$end_position $vcf_name.vcf.gz -Oz -o $bcf_tmp
		snps=$( bcftools view -H $bcf_tmp | wc -l)
		###control that the snps in the windows are more then 100 then it will skip the window
		if ((snps < 100)); then
			echo "Skipping window from $start_position to $end_position in chromosome $chr due to insufficient SNP count ($snps)"
			touch ${file_name}_${start_position}_${end_position}.tree
			continue
		fi
		###
		python3 $vcf2phy -i $bcf_tmp -n -p > /dev/null 2>&1
		rm  $bcf_tmp
		##snps=$(bcftools view -r ${chr}:$start_position-$end_position $vcf_name.vcf.gz | bcftools view -H | wc -l)
	
		#Print the start and end positions of the window, and the window content
		echo "Window Start: $start_position, Window End: $end_position. This window contains $snps number of SNPs";
	
	
	####concatenate the Poup command in the folder with the nexsus alignemnt created in the step above
		cp $cmd_paup tmp
		sed -i "s/ADD_NEW_NAME/${file_name}_${start_position}_${end_position}/g" tmp
		cat $file_name.min4.nexus partition.nex tmp > ${file_name}_${start_position}_${end_position}.min4.nexus
		rm tmp 
		rm $file_name.min4.nexus
	
	###launch paup analisys and control if the tree file already exist
		if [ -f "${file_name}_${start_position}_${end_position}.tree" ]; then
			echo "File ${file_name}_${start_position}_${end_position}.tree already exists. Go to next window."
			continue  # Skip to the next iteration of the loop
		fi
		$PAUP ${file_name}_${start_position}_${end_position}.min4.nexus -L ${file_name}_${start_position}_${end_position}.log 
		echo "done analysing chromosome $chr"
	done;
done < "$chr_list"
