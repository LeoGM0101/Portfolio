rm(list=ls())
source("C:/Users/leona/Documents/SOM/Sits_SOM/Sits_SOM_v2/Banco de Dados_v4.R")

library(tibble)
library(dplyr) #ler pacote de manipulação de dados
library(readr) #ler pacote de importação de dados
library(sits)
library(kohonen)
library(readxl)
library(openxlsx)

Sys.setenv(SITS_CONFIG_USER_FILE='C:/Users/leona/Desktop/Sits_SOM/Sits_SOM_v2/legendaSOM_MapBiomas_v2.yml')
sits_config()

set.seed(2024)

som_map <- sits_som_map(tibble(df_new), distance = "euclidean")

som_eval <- sits_som_evaluate_cluster(som_map)

#options(repr.plot.width = 20, repr.plot.height = 15)
plot(som_map)

#options(repr.plot.width = 16, repr.plot.height = 10)
plot(som_eval)

new_samples <- sits_som_clean_samples(
  som_map, 
  prior_threshold = 0.6,
  posterior_threshold = 0.6,
  keep = c("clean", "analyze")
)

#sits_labels_summary(df_new)



