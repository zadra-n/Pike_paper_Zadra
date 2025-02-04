library(ggplot2)
library(svglite)

####this script take a specific input, the first line of the Popcluster 
###output in a csv separeted format it work togather with the costum script read_file_K.sh

args <- commandArgs(trailingOnly = TRUE)

# Check if we have the correct number of arguments
if (length(args) != 3) {
  stop("Usage: Rscript Best_K.R input_file.csv output_plots working_dir", call. = FALSE)
}

# Assign arguments to variables for clarity
input_file <- args[1]
output_plot <- args[2]

setwd(args[3])

bestk <- read.csv(input_file)
class(bestk$DLK2)

bestk[bestk == "-"] <- NA
bestk$DLK2 <- as.numeric(bestk$DLK2)
bestk$FST_FIS <- as.numeric(bestk$FST.FIS)


bestK_DKL_FIS <- ggplot(bestk, aes(x = K)) +
  geom_line(aes(y = DLK2, color = 'DLK2'), linewidth = 0.8) +  # Assign color name within aes for legend
  geom_line(aes(y = FST.FIS, color = 'FST.FIS'), linewidth = 0.8) +  # Assign color name within aes for legend
  geom_point(shape=21, aes(y = DLK2, fill= 'DLK2'), color ='black', size = 2) +  # Use fill inside aes for consistency
  geom_point(shape=21, aes(y = FST_FIS, fill= 'FST.FIS'), color ='black', size = 2) +
  scale_x_continuous(breaks = bestk$K) + # Ensuring x-axis has discrete values from K
  labs(x = "K", color = "", fill = "", y = "") +  # Add titles to the legend
  theme_minimal() +
  scale_color_manual(values = c('DLK2' = 'blue', 'FST.FIS' = 'red')) +  # Manually set the colors for lines
  scale_fill_manual(values = c('DLK2' = 'blue', 'FST.FIS' = 'red')) +  # Manually set the colors for points
  theme( legend.key.size = unit(2, 'cm'), legend.text = element_text(size=15)) 

ggsave(bestK_DKL_FIS,
       filename = paste0(output_plot, "_DKL2_FIS.png"),
       path     = ".",
       width    = 310,
       height   = 150,
       units    = "mm",
       dpi      = 600
)
ggsave(bestK_DKL_FIS,
       filename = paste0(output_plot, "_DKL2_FIS.svg"),
       path     = ".",
       width    = 310,
       height   = 150,
       units    = "mm",
       dpi      = 600,
       device = 'svg'
)

logL <- ggplot(bestk, aes(x = K, y = LogL_Mean)) +
  geom_line(linewidth = 0.8, color = '#4D4D4D' ) +
  geom_point(shape=21, fill= '#4D4D4D',color ='black', size = 2) +
  scale_x_continuous(breaks = bestk$K) + # Ensuring x-axis has discrete values from K
  labs(x = "K", y = "Log likelihood") +
  #scale_y_continuous(labels = label_number_auto) +
  theme_minimal()

ggsave(logL,
       filename = paste0(output_plot, "_logL.png"),
       path     = ".",
       width    = 310,
       height   = 150,
       units    = "mm",
       dpi      = 600
)
ggsave(logL,
       filename = paste0(output_plot, "_logL.svg"),
       path     = ".",
       width    = 310,
       height   = 150,
       units    = "mm",
       dpi      = 600,
       device = 'svg'
)

print("DONE!!")