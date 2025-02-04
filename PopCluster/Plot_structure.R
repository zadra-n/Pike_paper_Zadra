#install.packages("dplyr")
library(dplyr)
library(stringr)
library(ggplot2)
library(tidyr)
library(svglite)

args <- commandArgs(trailingOnly = TRUE)

# Check if we have the correct number of arguments
if (length(args) != 3) {
  stop("Usage: Rscript Plot_structure.R Admixture_K_x_Ky_reheader pike_metadata working_directory_path", call. = FALSE)
}

setwd(args[3])
# Assign arguments to variables for clarity
ad <- args[1]
mt <- args[2]
dataset_admixture <- read.csv(ad)
metadata <- read.csv(mt)


####extract the name of the value for K and the number of run it is used to rename the plot in output and for the plot title
pattern <- "K_\\d+_R_\\d+"
matches <- regexpr(pattern, ad)
extracted_string <- regmatches(ad, matches)
print(extracted_string)

k_columns <- grep("^K", colnames(dataset_admixture), value = TRUE)

######## STEPS NEEDED FOR ADJUSTING THIS SPECIFIC DATASET ######################################

###in the label column remove the last part after the _ from each value in the cell
#dataset_admixture$Label <- sub("_[^_]+$", "", dataset_admixture$Label)

###substitute the column name from label to ID_VCF_loc
names(dataset_admixture)[names(dataset_admixture) == "Label"] <- "ID_VCF_loc"

###change unwanted ID_VCF_loc with another entry
#dataset_admixture$ID_VCF_loc[dataset_admixture$ID_VCF_loc == 'esox48_Tras_esox48'] <- 'esox48_Tras'
#dataset_admixture$ID_VCF_loc[dataset_admixture$ID_VCF_loc == 'l107_Hatc_l107'] <- 'l107_Hatc'
#dataset_admixture$ID_VCF_loc[dataset_admixture$ID_VCF_loc == 'l113_Hatc_l113'] <- 'l113_Hatc'
#dataset_admixture$ID_VCF_loc[dataset_admixture$ID_VCF_loc == 'l118_Hatc_l118'] <- 'l118_Hatc'

#######################################################################################################

###merge Popcluster analysis using the column  
merged_dataset <- merge(dataset_admixture, metadata, by = "ID_VCF_loc")


####
pivot_merged <- pivot_longer(merged_dataset, cols=starts_with("K"), names_to='K', values_to='Q')

 #options(repr.plot.width=18, repr.plot.height=8)


library(RColorBrewer)

# Determine the number of unique classes for the color palette
num_classes <- length(unique(pivot_merged$K))

# Select a suitable color palette from RColorBrewer
# 'Set1', 'Set2', 'Set3', 'Dark2', etc., are good for discrete variables
# You can choose 'Paired', 'Accent', or any other palette that suits your data
#palette_name <- if (num_classes > 8) "Set3" else "Set1"
#colors <- brewer.pal(num_classes, palette_name)
#colors

color_list <- c("#ff595e", "#ff924c", "#ffca3a", "#c5ca30", "#8ac926", "#52a675","#1982c4", "#4267ac", "#6a4c93", "#b5a6c9")

# Select the first two colors
colors <- color_list[1:num_classes]
colors

ggplot(pivot_merged, aes(x = ID_NEW, y = Q, fill = K)) +
  geom_bar(stat = "identity", width = 1, position = "stack", color = "black") +
  facet_grid(~factor(REGION_NAME, levels = c("Austria-Danube", 'Germany-Elbe', 'Hatchery', 'AltoAdige', 'Trentino', 'Garda', 'Po', 'Trasimeno', 'AddaSystem')),
             scales = "free_x", space = "free_x") +
  theme_bw() +
  theme(panel.spacing = unit(0, "cm"),
        strip.background = element_rect(fill = "white"),
        axis.text.x = element_text(size = rel(1.5), angle = 90, hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = rel(1.8)),
        axis.title = element_text(size = 21, face = "bold"),
        legend.key.size = unit(1, 'cm'),
        legend.title = element_text(size = 21, face = 'bold'),
        legend.text = element_text(size = 15),
        strip.text.x = element_text(size = 15, face = 'bold'),
        plot.title = element_text(size = 24, face = 'bold'),
        plot.subtitle = element_text(size = 18)) +
  scale_fill_manual(values = colors,limits =k_columns) +
  labs(title = paste0(extracted_string, " Pike"), subtitle = "Full dataset PopCluster analysis for all the population", x = "Sample ID", y= "Q (ancestry)")

ggsave(paste0(extracted_string, ".svg"), width=18, height=8, unit="in")
ggsave(paste0(extracted_string, ".svg"), width = 18, height = 8, device = 'svg')