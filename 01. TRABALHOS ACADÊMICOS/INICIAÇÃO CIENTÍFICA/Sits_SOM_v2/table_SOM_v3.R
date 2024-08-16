rm(list=ls())
source("C:/Users/leona/Documents/SOM/Sits_SOM/Sits_SOM_v2/Banco de Dados_v4.R")
# source("C:/Users/leona/Documents/SOM/Sits_SOM/Sits_SOM_v2/functions/point_to_shape.R")
# source("C:/Users/leona/Documents/SOM/Sits_SOM/Sits_SOM_v2/functions/analyze_samples_v2.R")

library(tibble)
library(dplyr) #ler pacote de manipulação de dados
library(readr) #ler pacote de importação de dados
library(sits)
library(kohonen)
library(readxl)
library(openxlsx)
library(tidyverse)

Sys.setenv(SITS_CONFIG_USER_FILE='C:/Users/leona/Documents/SOM/Sits_SOM/Sits_SOM_v2/legendaSOM_MapBiomas_v2.yml')
sits_config()

sits::sits_labels(tibble(df_new))

som_map <- sits_som_map(
  tibble(df_new),
  grid_xdim = 10,
  grid_ydim = 10,
  alpha = c(0.5, 0.01),
  rlen = 100,
  distance = "euclidean"
)

#options(repr.plot.width = 20, repr.plot.height = 15)
par(mar=c(1, 1, 1, 1) - 1)
plot(som_map, band = c("NDVI"))
som_output = som_map$labelled_neurons; som_output

#options(repr.plot.width = 16, repr.plot.height = 10)
som_eval <- sits_som_evaluate_cluster(som_map)
confusion_by_samples.tb <- som_eval$mixture_percentage
par(mar=c(5, 4, 4, 2) + 0.1)
plot(som_eval)

## -----------------------------------------------------------------------------
## -------------- Removing and analyzing samples class noise -------------------
## -----------------------------------------------------------------------------

# The fuction sits_som_clean_samples clean the samples directly, but in the paper
# want to explore step by step the percentage of samples that were kept, removed
# and analyzed.


remove_data_set.tb <- dplyr::filter(som_output, prior_prob < 0.60)

keep_data_set.tb <-
  dplyr::filter(som_output, prior_prob >= 0.60 &
                  post_prob >= 0.60)

make_analysis_data_set.tb <-
  dplyr::filter(som_output, prior_prob >= 0.60 &
                  post_prob < 0.60)

# Check the number of samples that are kept, removed
# and need to make an analysis

unique(remove_data_set.tb$label_samples) #labels
unique(keep_data_set.tb$label_samples) #labels
unique(make_analysis_data_set.tb$label_samples) #labels

new_samples <- sits_som_clean_samples(
  som_map, 
  prior_threshold = 0.6,
  posterior_threshold = 0.6,
  keep = c("clean", "analyze")
)
new_samples %>%
  group_by(label) %>%
  count(eval)
table(new_samples$eval)

#sits_labels_summary(df_new)


#Get informations about each neuron
neuron_sample_data <- som_class_noise_reduce.tb$statistics_samples$samples_t

labels_to_analyse <- sits::sits_labels(make_analysis_data_set.tb)$label

#Join the information about the samples probabilities and the neurons information
make_analysis.tb <- make_analysis_data_set.tb %>% dplyr::inner_join(neuron_sample_data, by = "id_sample")

make_analysis.tb_2 = new_samples %>%
  filter(eval == "clean")



#prepare the samples to plot in qgis to verify the spatial location
point_to_shape (make_analysis.tb, name_file = "samples_to_analyze_info")

