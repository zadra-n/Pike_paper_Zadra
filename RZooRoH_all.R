library(RZooRoH)
library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)

setwd("C:/Users/zadran/Desktop/Pike_2024/ROH/RzooRoH")

# read input file of genotype probabilities
Garda <- zoodata(genofile = "Garda.gen.gz", zformat = "gp", samplefile = "garda.txt")
Trento <- zoodata(genofile = "Trento.gen.gz", zformat = "gp", samplefile = "Trento.txt")
Trasimeno <- zoodata(genofile = "Trasimeno.gen.gz", zformat = "gp", samplefile = "Trasimeno.txt")
Po <- zoodata(genofile = "Po.gen.gz", zformat = "gp", samplefile = "Po.txt")
Hatc <- zoodata(genofile = "Hatc.gen.gz", zformat = "gp", samplefile = "Hatc.txt")
AAdi <- zoodata(genofile = "Aadi.gen.gz", zformat = "gp", samplefile = "AAdi.txt")
Adda <- zoodata(genofile = "Adda.gen.gz", zformat = "gp", samplefile = "Adda.txt")
Danubio <- zoodata(genofile = "Danubio.gen.gz", zformat = "gp", samplefile = "Danu.txt")
Elbe <- zoodata(genofile = "Elbe.gen.gz", zformat = "gp", samplefile = "Elbe.txt")

###set model with classes
model_roh <- zoomodel(K = 6, krates=c(32,128,256,512,1024,1024))

results_Garda <- zoorun(model_roh, Garda)
results_Trasimeno <- zoorun(model_roh, Trasimeno)
results_Trento <- zoorun(model_roh, Trento)
results_Po <- zoorun(model_roh, Po)
results_Hatc <- zoorun(model_roh, Hatc)
results_Aadi <- zoorun(model_roh, AAdi)
results_Adda <- zoorun(model_roh, Adda)
results_Danubio <- zoorun(model_roh, Danubio)
results_Elbe <- zoorun(model_roh, Elbe)

###save the data

saveRDS(results_Garda, file = "results_Garda.rds")
saveRDS(results_Trento, file = "results_Trento.rds")
saveRDS(results_Trasimeno, file = "results_Trasimeno.rds")
saveRDS(results_Po, file = "results_Po.rds")
saveRDS(results_Hatc, file = "results_Hatc.rds")
saveRDS(results_Aadi, file = "results_Aadi.rds")
saveRDS(results_Adda, file = "results_Adda.rds")
saveRDS(results_Danubio, file = "results_Danumbio.rds")
saveRDS(results_Elbe, file = "results_Elbe.rds")

###reads RDS 

results_Garda <- readRDS(file ="results_Garda.rds")
results_Trasimeno <- readRDS(file ="results_Trasimeno.rds")
results_Trento <- readRDS(file ="results_Trento.rds")
results_Po <- readRDS(file ="results_Po.rds")
results_Hatc <- readRDS(file ="results_Hatc.rds")
results_Aadi <- readRDS(file ="results_Aadi.rds")
results_Adda <- readRDS(file ="results_Adda.rds")
results_Danubio <- readRDS(file ="results_Danumbio.rds")
results_Elbe <- readRDS(file ="results_Elbe.rds")

###use coefficent inbreeading#####
in_coeff_Garda <- 1- results_Garda@realized[,6]
in_coeff_Trento <- 1- results_Trento@realized[,6]
in_coeff_Trasimeno  <- 1- results_Trasimeno@realized[,6]
in_coeff_Po  <- 1- results_Po@realized[,6]
in_coeff_Hatc  <- 1- results_Hatc@realized[,6]
in_coeff_Aadi  <- 1- results_Aadi@realized[,6]
in_coeff_Adda  <- 1- results_Adda@realized[,6]
in_coeff_Danubio  <- 1- results_Danubio@realized[,6]
in_coeff_Elbe  <- 1- results_Elbe@realized[,6]
####get a function to color the plot
###call it like >get_rgb_with_alpha("colorname/code", alpha_value from 0 to 1)
get_rgb_with_alpha <- function(color_name, alpha=0.5) {
  rgb_values <- col2rgb(color_name)
  rgb(rgb_values[1], rgb_values[2], rgb_values[3], maxColorValue = 255, alpha = alpha*255)
}

##set colour for each population andtrasparency 

rgb_Garda <- get_rgb_with_alpha("tomato", 0.5)
rgb_Trento <- get_rgb_with_alpha("steelblue", 0.5)
rgb_Trasimeno <- get_rgb_with_alpha("cadetblue", 0.5)
rgb_Po <- get_rgb_with_alpha("sienna", 0.5)
rgb_Hatc <- get_rgb_with_alpha("purple", 0.5)
rgb_Aadi <- get_rgb_with_alpha("plum", 0.5)
rgb_Adda <- get_rgb_with_alpha("seagreen", 0.5)
rgb_Dabubio <- get_rgb_with_alpha("goldenrod", 0.5)
rgb_Elbe <- get_rgb_with_alpha("chartreuse", 0.5)

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
###bins
# Define the number of bins
number_of_bins <- 10

# Define the breaks for all histograms
breaks <- seq(0, 1, length.out = number_of_bins + 1)
###create an hinstaogram for each inbreeading coefficent without plotting any
hist_Garda <- hist(in_coeff_Garda, breaks = breaks, plot = FALSE)
hist_Trento <- hist(in_coeff_Trento, breaks = breaks, plot = FALSE)
hist_Trasimeno <- hist(in_coeff_Trasimeno, breaks = breaks, plot = FALSE)
hist_Po <- hist(in_coeff_Po, nc=10, plot = FALSE)
hist_Hatc <- hist(in_coeff_Hatc, nc=10, plot = FALSE)
hist_Aadi <- hist(in_coeff_Aadi, nc=10, plot = FALSE)
hist_Adda <- hist(in_coeff_Adda, nc=10,plot = FALSE)
hist_Danubio <- hist(in_coeff_Danubio,nc=10, plot = FALSE)
hist_Elbe <- hist(in_coeff_Elbe, nc=10, plot = FALSE)


####make a dataframe out the coefficent of inbreeading

Inbreeading <- c(in_coeff_Garda, in_coeff_Trento, in_coeff_Trasimeno, in_coeff_Po, in_coeff_Hatc, in_coeff_Aadi, in_coeff_Adda, in_coeff_Danubio, in_coeff_Elbe)

Location <- c(rep("Garda", length(in_coeff_Garda)), 
                 rep("Trento", length(in_coeff_Trento)), 
                 rep("Trasimeno", length(in_coeff_Trasimeno)), 
                 rep("Po", length(in_coeff_Po)),
                 rep("Hatc", length(in_coeff_Hatc)),
                 rep("Adige", length(in_coeff_Aadi)),
                 rep("Adda", length(in_coeff_Adda)),
                 rep("Danubio", length(in_coeff_Danubio)),
                 rep("Elbe", length(in_coeff_Elbe)))

df_in_coeff <- data.frame(Inbreeading = Inbreeading, Location = Location)

####Define colours 
sampled_colors_2  <- c("Trento" = "#CD0000",
                       "Adda" = "#3A5FCD",
                       "Trasimeno" = "#43CD80",
                       "Garda" = "#8968CD", 
                       "Po" = "orange3",
                       "Alto Adige" = "#9FB6CD",
                       "Danube" = "#CDBA96",
                       "Elbe" = "#9BCD9B",
                       "Unknown" = "#CDCDC1")

###boxplot, do not work to few data
ggplot(df_in_coeff, aes(x = Inbreeading, y = Location, fill= Location)) +
         geom_boxplot() +
         geom_jitter(color="black", size=0.4, alpha=0.9) +
         theme_minimal() +
         scale_fill_manual(values = sampled_colors_2)

###scatter plot most suitable for tplotting the inbreeding coefficient by location
ggplot(df_in_coeff, aes(x = Location, y = Inbreeading, color = Location)) +
  geom_point() +
  theme_minimal() +
  labs(title = "Inbreeding coefficent by Location",
       x = "Location",
       y = "Inbreeding") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 


xlim_min <- min(c(hist_Garda$breaks, hist_Trento$breaks, hist_Trasimeno$breaks, hist_Po$breaks, hist_Hatc$breaks, hist_Aadi$breaks, hist_Adda$breaks, hist_Danubio$breaks, hist_Elbe$breaks)) - 0.05
xlim_max <- max(c(hist_Garda$breaks, hist_Trento$breaks, hist_Trasimeno$breaks, hist_Po$breaks, hist_Hatc$breaks, hist_Aadi$breaks, hist_Adda$breaks, hist_Danubio$breaks, hist_Elbe$breaks)) + 0.05

# Determine the maximum y-axis limit
max_y <- max(c(hist_Garda$counts, hist_Trento$counts, hist_Trasimeno$counts, hist_Po$counts, hist_Hatc$counts, hist_Aadi$counts, hist_Adda$counts, hist_Danubio$counts, hist_Elbe$counts))


pop_tot <- list(garda=results_Garda,Trento=results_Trento, Trasimeno = results_Trasimeno, Po = results_Po, Hatc = results_Hatc, Aadi = results_Aadi, Adda = results_Adda, Danubio = results_Danubio, Elbe = results_Elbe)
zooplot_partitioning(pop_tot, plotids = FALSE,
                     ylim=c(0,0.5), nonhbd = FALSE)

results_Po@realized
results_Po@sampleids
results_Trento@sampleids
results_Trento@krates

rates <- c(32,128,256,512,1024, "older")


###create a dataframe with all the data
##read the realized as dataframe
Trento <- as.data.frame(results_Trento@realized)
###add rates as column name
names(Trento) <- rates
##add ids as rownames
Trento$ID <- results_Trento@sampleids
#add location columns
Trento$Loc <- "Trento"

Garda <- as.data.frame(results_Garda@realized)
names(Garda) <- rates
Garda$ID <- results_Garda@sampleids
Garda$Loc <- "Garda"


Po <- as.data.frame(results_Po@realized)
names(Po) <- rates
Po$ID <- results_Po@sampleids
Po$Loc <- "Po"


Adda <- as.data.frame(results_Adda@realized)
names(Adda) <- rates
Adda$ID <- results_Adda@sampleids
Adda$Loc <- "Adda"

Danubio <- as.data.frame(results_Danubio@realized)
names(Danubio) <- rates
Danubio$ID <- results_Danubio@sampleids
Danubio$Loc <- "Danubio"

Trasimeno <- as.data.frame(results_Trasimeno@realized)
names(Trasimeno) <- rates
Trasimeno$ID <- results_Trasimeno@sampleids
Trasimeno$Loc <- "Trasimeno"

Aadi <- as.data.frame(results_Aadi@realized)
names(Aadi) <- rates
Aadi$ID <- results_Aadi@sampleids
Aadi$Loc <- "Aadi"

Hatc <- as.data.frame(results_Hatc@realized)
names(Hatc) <- rates
Hatc$ID <- results_Hatc@sampleids
Hatc$Loc <- "Hatc"

Elbe <- as.data.frame(results_Elbe@realized)
names(Elbe) <- rates
Elbe$ID <- results_Elbe@sampleids
Elbe$Loc <- "Elbe"
###merge the dataframe
merged_data <- rbind(Trento, Garda, Po,Adda, Danubio,Trasimeno,Aadi, Hatc,Elbe)

####add short name column
colnames(merged_data)[colnames(merged_data) == "ID"] <- "ID_VCF_loc" 

###Read the table with the ID
df_new_name <- read.csv("../Het/ID_luccio.csv" )
df_rename <- df_new_name[, c("ID_VCF_loc", "ID_NEW")]
merged_data <-  merge(df_rename, merged_data, by ="ID_VCF_loc" )
merged_data$Loc <- ifelse(merged_data$Loc == 'Danubio','Danube',
                                 ifelse(merged_data$Loc == 'Aadi','Alto Adige',
                                 ifelse(merged_data$Loc == 'Hatc','Unknown', merged_data$Loc)))
                                        
write_tsv(merged_data,file = "merged_data_prova.tsv" )



####plot the data
data_long <- merged_data %>%
  select(-older) %>%
  pivot_longer(cols = c(`32`, `128`, `256`, `512`, `1024`), names_to = "Class", values_to = "Froh")

###Use factor to order the column by Loc and Class
data_long$Loc <- factor(data_long$Loc, levels = c("Trento", "Garda","Po", "Trasimeno", "Adda", "Alto Adige", "Unknown", "Danube", "Elbe"))


###Plot the data
ggplot(data_long, aes(x = ID_NEW, y = Froh, fill = Class)) +
  geom_bar(stat = "identity", width = 0.8, color = "black") +
  facet_grid(~Loc, scales = "free_x", space = "free_x") +
  labs(y = "Froh", fill = "Class", x = NULL) +
  scale_fill_manual(name = "HBD classes",
                    values = c("#ff4040", "#ffa500", "#ffffb3", "#33ff33", "#00cc66"), 
                    breaks = c(32,128,256,512,1024)) +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_text(size = 9),
        axis.text.x = element_text(size = 7, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_text(size = 7, angle = 90, hjust = 0.5),
        axis.ticks.x = element_blank(),
        strip.text.x = element_text(size = 7))

####plot_data for presentation Sibe
ggplot(data_long, aes(x = ID_NEW, y = Froh, fill = Class)) +
  geom_bar(stat = "identity", width = 0.8, color = "black") +
  facet_grid(~Loc, scales = "free_x", space = "free_x") +
  labs(y = "Froh", fill = "Class", x = NULL) +
  scale_fill_manual(name = "HBD classes",
                    values = c("#ff4040", "#ffa500", "#ffffb3", "#33ff33", "#00cc66"), 
                    breaks = c(32,128,256,512,1024)) +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_text(size = 14),
        #axis.text.x = element_text(size = 7, angle = 90, vjust = 0.5, hjust = 1),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 10, angle = 90, hjust = 0.5),
        axis.ticks.x = element_blank(),
        #strip.text.x = element_text(size = 7),
        strip.text.x = element_blank()) 

ggsave("Froh_presentation.svg", width = 9, height = 2, device = 'svg')
ggsave("Froh_presentation.png", width = 9, height = 2, dpi = 600, device = 'png')
ggsave("Froh_presentation.pdf", width = 9, height = 2, device = 'pdf')

##########################################################
ggplot(data_long, aes(x = factor(ID, levels = ID_NEW), y = Value, fill = Measurement)) +
  geom_bar(stat = "identity", position = "stack") +
  #geom_vline(xintercept = separator_positions[-1] + 0.5, linetype = "dotted", color = "black") +
  scale_fill_manual(values = colors) +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  labs(title = "Stacked Barplot by ID and Loc", x = "ID", y = "Value", fill = "Measurement")


hist(results_Garda@hbdseg$length/100000, ,col='tomato' ,nc=100)

zooplot_hbdseg(pop_tot, chr=25, coord=c(1,10000000))
