library(ggplot2)
library(dplyr)
library(svglite)

setwd("C:/Users/zadran/Desktop/Pike_2024/Pike_phylo/sliding/Compare_tree/500kb_no_po")

df_topo <- read.csv("topologies_no_po_500kb.tsv", sep="\t")

df_topo$Length <- df_topo$End - df_topo$Start +1


# Count the frequency of each topology, excluding 'No_tree' and 'none'
topology_counts <- df_topo %>%
  filter(Topology != 'No_tree' & Topology != 'none') %>%
  count(Topology, sort = TRUE)

###topo topologies list with no non and no_tree
top_topologies <- topology_counts$Topology[1:6]

###the next step create a new column called Topology_Simple and add No Tree when there is no information about the tree and 
##Other topology if the topology are not in the top 6
df_topo <- df_topo %>%
  mutate(Topology_Simple = case_when(
    Topology %in% top_topologies ~ Topology,
    Topology == "none" | Topology == "No_tree" ~ "No tree",
    TRUE ~ "Other topology"
  ))


topo_count <- df_topo %>%
  group_by(NC, Topology_Simple) %>%
  summarise(Count = n(), .groups = 'drop')


chromosome_length <- max(df_topo$End)
y_breaks <- seq(0, max(df_topo$End), by = 10000000)  # Adjust the sequence based on your data range
y_labels <- y_breaks / 1000000  # Convert to 'Mega' base pair units without the 'M' suffix

# Determine the order of TopologyCategory based on total counts, descending
topology_order <- topo_count %>%
  group_by(Topology_Simple) %>%
  summarise(TotalCount = sum(Count)) %>%
  arrange(desc(TotalCount)) %>%
  pull(Topology_Simple)

topo_count$Topology_Simple <- factor(topo_count$Topology_Simple, levels = topology_order)

costum_order <- c(top_topologies, "No tree","Other topology")

legend_colors <- setNames(c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#7f7f7f", "black"), costum_order)

chrom_plot <-
  ggplot(df_topo, aes(ymin = Start, ymax = End, fill = Topology_Simple)) +
  geom_rect(aes(xmin = as.numeric(factor(NC)) - 0.3, xmax = as.numeric(factor(NC)) + 0.4), color = " black", linewidth = 0.4) +  # Adjust bar width and spacing here
  scale_y_continuous(breaks = seq(0, max(df_topo$End), by = 10000000), labels = seq(0, max(df_topo$End) / 1000000, by = 10)) +  # Custom y-axis labels
  theme_minimal() +
  scale_fill_manual(values = legend_colors, breaks = costum_order) +
  labs(x = "Chromosome", y = "Position (Mb)", fill = "Topology") +
  scale_x_continuous(breaks = 1:length(unique(df_topo$NC)), labels = unique(df_topo$NC), name = "Chromosome") +  # Set x-axis for chromosomes
  theme(axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())

chrom_plot <- ggplot(df_topo, aes(ymin = Start, ymax = End, fill = Topology_Simple)) +
  geom_rect(aes(xmin = as.numeric(factor(NC)) - 0.3, xmax = as.numeric(factor(NC)) + 0.4), 
            color = "black", linewidth = 0.4) +  # Adds black border with specified line width
  scale_y_continuous(
    breaks = seq(0, max(df_topo$End), by = 10000000), 
    labels = seq(0, max(df_topo$End) / 1000000, by = 10)) +  # Custom y-axis labels
  theme_minimal() +
  scale_fill_manual(values = legend_colors, breaks = costum_order) +
  labs(x = "Chromosome", y = "Position (Mb)", fill = "Topology") +
  scale_x_continuous(
    breaks = 1:length(unique(df_topo$NC)), 
    labels = unique(df_topo$NC), 
    name = "Chromosome") +  # Set x-axis for chromosomes
  theme(
    axis.title.x = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank())

ggsave("topology_chrom_distribution.png", chrom_plot, width = 8, height = 6, units = "in")
ggsave("topology_chrom_distribution.svg", plot = chrom_plot, width = 8, height = 6,units = "in", device = 'svg')

topo_count$Topology_Simple <- factor(topo_count$Topology_Simple, levels = costum_order)

topo_abundance <- 
  topo_count %>%
  ggplot(aes(x = NC, y = Count, fill = Topology_Simple)) +
  geom_bar(stat = "identity", position = "stack", width = 0.7, color = " black", linewidth = 0.4) +
  scale_fill_manual(values = legend_colors, breaks = costum_order) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()) +
  labs(x = "Chromosome", y = "Count", title = "Abundance of Topologies per Chromosome")

ggsave("topology_barplot_1po.png", topo_abundance, width = 8, height = 6, units = "in")
ggsave("topo_abundance.svg", plot = topo_abundance, width = 8, height = 6, device = 'svg')

