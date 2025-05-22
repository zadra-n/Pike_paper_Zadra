library(ggplot2)
library(dplyr)
library(svglite)

setwd("C:/Users/zadran/Desktop/Pike_2024/ROH/Het")

df_het <- read.csv("out.het", sep="\t")
df_new_name <- read.csv("ID_luccio.csv" )

colnames(df_het)[colnames(df_het) == "INDV"] <- "ID_VCF_loc"


df_rename <- df_new_name[, c("ID_VCF_loc", "ID_NEW")]

df_het_rename <- merge(df_rename, df_het, by ="ID_VCF_loc" )


###calculate heterozigosity 

df_het_rename$O_het <- (df_het_rename$N_SITES - df_het_rename$O.HOM)/df_het_rename$N_SITES
df_het_rename$Location <- sub(".*_", "", df_het_rename$ID_VCF_loc)
df_het_rename$Location <- ifelse(df_het_rename$Location == 'Tras','Trasimeno',
                                 ifelse(df_het_rename$Location == 'Tren','Trento',
                                 ifelse(df_het_rename$Location == 'Po','Po',
                                 ifelse(df_het_rename$Location == 'Aadi','Alto Adige',
                                 ifelse(df_het_rename$Location == 'Danu','Danube',
                                 ifelse(df_het_rename$Location == 'Hatc','Unknown',
                                 ifelse(df_het_rename$Location == 'Gard','Garda',df_het_rename$Location)))))))
                                                      

####set colour for each location

sampled_colors_2  <- c("Trento" = "#CD0000",
                       "Adda" = "#3A5FCD",
                       "Trasimeno" = "#43CD80",
                       "Garda" = "#8968CD", 
                       "Po" = "orange3",
                       "Alto Adige" = "#9FB6CD",
                       "Danube" = "#CDBA96",
                       "Elbe" = "#9BCD9B",
                       "Unknown" = "#CDCDC1")
###define level for plotting
df_het_rename$Location <- factor(df_het_rename$Location, levels = c("Trento", "Garda","Po", "Trasimeno", "Adda", "Alto Adige", "Unknown", "Danube", "Elbe"))
              

####plot heterozigosty data 

ggplot(data=df_het_rename, mapping = aes(x=ID_NEW, y=O_het)) +
  geom_col(mapping = aes(fill = Location), width = 0.8, color = "black") +
  facet_grid(cols = vars(Location),
             scales = "free_x",
             space = "free_x") +
  scale_fill_manual(values = sampled_colors_2) +
  ylab("Heterozygosity") +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_text(size = 9),
        axis.text.x = element_text(size = 7, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(size = 7, angle = 90, hjust = 0.5),
        axis.ticks.x = element_blank(),
        strip.text.x = element_text(size = 7))


ggsave("Heterozigosity.svg", width = 12, height = 4, device = 'svg')
ggsave("Heterozigosity.png", width = 12, height = 4, device = 'png')
ggsave("Heterozigosity.pdf", width = 12, height = 4, device = 'pdf')


###plot for SIBE presentaion

ggplot(data=df_het_rename, mapping = aes(x=ID_NEW, y=O_het)) +
  geom_col(mapping = aes(fill = Location), width = 0.8, color = "black") +
  facet_grid(cols = vars(Location),
             scales = "free_x",
             space = "free_x") +
  scale_fill_manual(values = sampled_colors_2) +
  ylab("Heterozygosity") +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_text(size = 14),
        #axis.text.x = element_text(size = 7, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 10, angle = 90, hjust = 0.5),
        axis.ticks.x = element_blank(),
        #strip.text.x = element_text(size = 7))
        strip.text.x = element_blank(), 
        legend.key.size = unit(0.5, 'cm'))

ggsave("Heterozigosity_SIBE.svg", width = 9, height = 2, device = 'svg')
ggsave("Heterozigosity_SIBE.png", width = 9, height = 2, dpi = 600, device = 'png')
ggsave("Heterozigosity_SIBE.pdf", width = 9, height = 2, device = 'pdf')
                                        