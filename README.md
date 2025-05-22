# Pike_paper_Zadra

Codes used for data handling, plotting and visualizing the results of the whole genome data analysis in Zadra et al xxxx.
In some cases, the plots were edited using Inkscape. This manual editing mainly involved combining the assembly plots into a single image and highlighting key elements by adding names and titles.

# Data visualization

## PCAs

After calculating the eigenvec and the eigenval using PLIK2, the PCAs were plotted using the following scripts
* `PCA_combination_full.R` Plot the different combinations of Principal Components for the full dataset (62 samples)
*  `PCA_combination_flaviae.R` Plot the different combinations of Principal Component for the datasets that comprise only the _Esox flaviea_ samples

## Population Structure using PopCluster

Script Folder **`PopCluster/`**

 The main script, `read_file_K.sh`, processes the `.K` file from PopCluster and generates outputs that are used by subsequent scripts for visualization.

`./read_file_K.sh [path_to_file (PopCluster output summary file.K)] [output_name (default: output]` 

It formats the Popcluster output and then processes and plot all the files that are needed for plotting the population structure and for finding the best k value.

first script called 

`Rscript Best_K_input.R table_bestK "$output_name" "$out_dir"`

Then, it calls the following scripts for plotting. 

`Rscript Best_K_input.R table_bestK "$output_name" "$out_dir" for plotting`
`Plot_structure.R "$input_R"  /path_to_table/ID_luccio.csv "$out_dir"`

The `read_file_k.sh` calls all the following scripts that need to be stored in the same folder

## Sliding window analysis 
the following scripts can be found in the **`Sliding_w/`** folder

* `sliding_windows_all.sh`: perform phylogenetic analysis using sliding windows across chromosomes from a VCF file. 
### Detailed description
**VCF Processing**: Extracts SNP data for each chromosome from a compressed VCF file.
**Sliding Window Analysis**: Divides each chromosome into sliding windows of a specified size and step length.
**SNP Filtering**: Skips windows with fewer than 100 SNPs to ensure robust phylogenetic analysis.
**Format Conversion**: Converts VCF data to NEXUS format using vcf2phylip.
**Phylogenetic Analysis**: Executes PAUP* commands to generate svdquartet trees for each window.

### PSliding window plot

* `extract_inforrmation.sh`: reads through the sliding window output and creates a tsv with all the information needed for plotting

* `comp_tree_slide.py`: identifies unique tree topologies and counts their occurrences. it performs rooting, calculating Robinson-Foulds distances, and classifying trees based on their topologies. The results are saved in a TSV file for R plotting
  
* `chromosome_plot.R`: processes a dataset of phylogenetic topologies and generates visualizations to analyze the distribution and abundance of topologies across chromosomes.


## ROHs and heterozygosity

This `RZooRoH_all.R` script is designed to analyze and visualize inbreeding coefficients and Runs of Homozygosity (ROH) in different populations using the RZooRoH package in R. The heterozygosity was calculated using the dedicated function of vcftools --het and then plotted using the `Heterozigosity_plot.R` script.





