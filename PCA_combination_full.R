library(tidyverse)
library(patchwork)


setwd("C:/Users/zadran/Desktop/Pike_2024/pca/Plink/PCA_full_dataset")

# Read data
pca <- read_table("pike_prune.eigenvec", col_name = FALSE)
eigenval <- scan("pike_prune.eigenval")

# Process PCA data
pca <- pca[-1, -1]  # Remove nuisance columns
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca) - 1))

# Assign species and location (simplified with a mapping function)
assign_group <- function(ids, patterns, groups) {
  result <- rep(NA, length(ids))
  for (i in seq_along(patterns)) {
    result[grep(patterns[i], ids)] <- groups[i]
  }
  return(result)
}

species_patterns <- c("Tren", "Adda", "Tras", "Gard", "Po", "Aadi", "Hatc", "Danu", "Elbe")
species_groups <- c(rep("E. flaviae", 7), rep("E. lucius", 2))
pca$spp <- assign_group(pca$ind, species_patterns, species_groups)

location_groups <- c("Trento", "Adda", "Trasimeno", "Garda", "Po", "Alto Adige", "Unknown", "Danube", "Elbe")
pca$loc <- assign_group(pca$ind, species_patterns, location_groups)

pca$spp_loc <- paste0(pca$spp, "_", pca$loc)

# Convert PC columns to numeric
pca <- pca %>%
  mutate(across(starts_with("PC"), as.numeric))

# Calculate percentage variance explained
pv <- data.frame(PC = 1:length(eigenval), pve = eigenval / sum(eigenval) * 100)

# Configure plot palettes
sampled_colors <- c("Trento" = "#CD0000", "Adda" = "#3A5FCD", "Trasimeno" = "#43CD80",
                    "Garda" = "#8968CD", "Po" = "orange3", "Alto Adige" = "#9FB6CD",
                    "Danube" = "#CDBA96", "Elbe" = "#9BCD9B", "Unknown" = "#CDCDC1")

shape_palette <- c("E. flaviae" = 16, "E. lucius" = 17)

# Define PCA plotting function
make_PCA_plot <- function(tbl, x, y, pve_df) {
  x_pve <- pve_df$pve[as.numeric(gsub("PC", "", as_label(enquo(x))))]
  y_pve <- pve_df$pve[as.numeric(gsub("PC", "", as_label(enquo(y))))]
  
ggplot(tbl, aes(x = {{ x }}, y = {{ y }}, color = loc, shape = spp)) +
    geom_point(size = 1.5, alpha = 0.6) +
    theme_minimal() +
    scale_color_manual(name = "Location", values = sampled_colors) +
    scale_shape_manual(name = "Putative Sp.", values = shape_palette) +
    labs(x = paste0(as_label(enquo(x)), " (", round(x_pve, 1), "%)"),
         y = paste0(as_label(enquo(y)), " (", round(y_pve, 1), "%)")) +
    theme(
      aspect.ratio = 1,
      axis.title = element_text(size = 10),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      legend.text = element_text(size = 10),
      legend.title = element_text(size = 12),
      legend.key.size = unit(1.1, "lines")
    ) +
    guides(
      color = guide_legend(title.position = "top"),
      shape = guide_legend(title.position = "top", direction = "vertical"))
}

# Create PCA plots
p12 <- make_PCA_plot(pca, PC1, PC2, pv) + theme(axis.title.x = element_blank())
p13 <- make_PCA_plot(pca, PC1, PC3, pv) + theme(axis.title.x = element_blank())
p14 <- make_PCA_plot(pca, PC1, PC4, pv)
p23 <- make_PCA_plot(pca, PC2, PC3, pv) + theme(axis.title = element_blank())
p24 <- make_PCA_plot(pca, PC2, PC4, pv) + theme(axis.title.y = element_blank())
p34 <- make_PCA_plot(pca, PC3, PC4, pv) + theme(axis.title.y = element_blank()) 

p12
# Arrange plots with unified legend
wrap_plots(
  A = p12, B = p13, C = p14, D = p23, E = p24, F = p34,
  guides = 'collect',
  design = "A##
            BD#
            CEF"
) &  theme(legend.title    = element_text(size = 7, face = "bold"),
legend.text     = element_text(size = 7),
legend.key.size = unit(0.5, "lines"),
legend.position = "bottom"
)

# Save plots
ggsave("figure_full_PCA_S1.png", width = 110, height = 110, units = "mm", dpi = 600)

######################################################
## Create presentation-specific plot for PC1 vs PC2 ##
######################################################

plot_full <- ggplot(pca, aes(x = PC1, y = PC2, color = loc, shape = spp)) +
  geom_point(size = 3, alpha = 0.6) +
  theme_minimal() +
  scale_color_manual(name = "Location", values = sampled_colors) +
  labs(
    x = paste0("PC1 (", signif(pv$pve[1], 3), "%)"),
    y = paste0("PC2 (", signif(pv$pve[2], 3), "%)")
  ) +
  theme(
    aspect.ratio = 1,
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 12),
    legend.key.size = unit(0.6, "lines"),
    legend.position = "bottom"

  ) +
  guides(
    color = guide_legend(title.position = "top"),
    shape = guide_legend(title.position = "top", direction = "vertical"))

leg <- get_legend(plot_full)
plot_full
ggsave("legend_PCAs.png", as_ggplot(leg), dpi =600)
ggsave("PCA_full_figure2.png", plot_full + theme(legend.position = "none"), width = 110, height = 110, units = "mm", dpi = 600)

