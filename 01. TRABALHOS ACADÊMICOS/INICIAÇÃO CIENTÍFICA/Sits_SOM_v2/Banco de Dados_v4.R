rm(list = ls())

set.seed(2024)
library(tidyverse)
library(readxl)
library(openxlsx)

regiao = c("R1", "R2", "R4", "R5")
indice = c("DAI", "DAS", "DBI", "DBS", "NOD")
nomes = c()
lista_df = list()

# Importando todas as bases e combinando em um unico data frame
l = 1
for(i in 1:length(regiao)) {
  for(k in 1:length(indice)) {
    nomes[l] = paste0(regiao[i], "_", indice[k],"_INDICE_SORTPONTOS_1985_2022.xlsx")
    lista_df[[l]] = read_excel(paste0("C:/Users/leona/Documents/SOM/indices_temporal/", nomes[l]))
    l = l+1
  }
}
dados = as.data.frame(purrr::reduce(lista_df, dplyr::full_join, by = "DTYMD"))
dados = dados %>%
  filter(DTYMD >= "2020-08-01" & DTYMD <= "2021-07-31")
rm(lista_df, regiao, indice, nomes)
#2020-08-28

rownames(dados) = dados$DTYMD
dados = dados[, -1]
dados_t = as.data.frame(t(dados)) %>% 
  rownames_to_column(var = "nomes_linhas")
dados_t = separate(dados_t, nomes_linhas, into = c("ponto", "regiao", "categoria", "indice"), sep = "_")

#write.xlsx(dados_t, "C:/Users/leona/Desktop/indices_temporal/Dados.xlsx")





df_long = pivot_longer(dados_t, cols = -c(ponto, regiao, categoria, indice), names_to = "data", values_to = "valor")

categoria = unique(df_long$categoria)
indice = unique(df_long$indice)
df_list = list()
pontos = unique(df_long$ponto)
for(i in 1:length(pontos)) {
  df_list[[i]] = filter(df_long, ponto == pontos[i])
}

df_list_new = list()
for(i in 1:length(df_list)) {
  df_list_new[[i]] = df_list[[i]][c(-4, -5, -6)]
  df_list_new[[i]] = unique(df_list_new[[i]])
}

set.seed(2024)
df_new = do.call(rbind, df_list_new)
df_new$start_date = rep("2020-08-01", length(df_new$ponto))
df_new$start_date = as.Date(df_new$start_date)
df_new$end_date = rep("2021-07-31", length(df_new$ponto))
df_new$end_date = as.Date(df_new$end_date)
df_new$latitude = runif(length(df_new$start_date), -50, -10)
df_new$longitude = runif(length(df_new$start_date), -50, -10)

df_new = df_new %>%
  rename(label = categoria, cube = regiao) %>%
  select(longitude, latitude, ponto, start_date, end_date,
         label, cube)
df_new$time_series = rep(NA, length(df_new$ponto))
df_new$time_series = vector("list", nrow(df_new))




################################################

df_list_indice = list()
for(i in 1:length(df_list)) {
  
  df_evi = df_list[[i]] %>% 
    filter(indice == 'EVI') %>%
    rename(EVI = valor) %>%
    select(ponto, data, EVI)
  df_evi$data = as.Date(df_evi$data)
  
  df_grnd = df_list[[i]] %>% 
    filter(indice == 'GRND') %>%
    rename(GRND = valor) %>%
    select(ponto, data, GRND)
  df_grnd$data = as.Date(df_grnd$data)
  
  df_NDII1 = df_list[[i]] %>% 
    filter(indice == 'NDII1') %>%
    rename(NDII1 = valor) %>%
    select(ponto, data, NDII1)
  df_NDII1$data = as.Date(df_NDII1$data)
  
  df_NDII2 = df_list[[i]] %>% 
    filter(indice == 'NDII2') %>%
    rename(NDII2 = valor) %>%
    select(ponto, data, NDII2)
  df_NDII2$data = as.Date(df_NDII2$data)
  
  df_NDVI = df_list[[i]] %>% 
    filter(indice == 'NDVI') %>%
    rename(NDVI = valor) %>%
    select(ponto, data, NDVI)
  df_NDVI$data = as.Date(df_NDVI$data)
  
  df_SWND = df_list[[i]] %>% 
    filter(indice == 'SWND') %>%
    rename(SWND = valor) %>%
    select(ponto, data, SWND)
  df_SWND$data = as.Date(df_SWND$data)
  
  df_list_indice[[i]] = data.frame(Index = df_evi$data)
  df_list_indice[[i]]$EVI = df_evi$EVI
  df_list_indice[[i]]$GRND = df_grnd$GRND
  df_list_indice[[i]]$NDII1 = df_NDII1$NDII1
  df_list_indice[[i]]$NDII2 = df_NDII2$NDII2
  df_list_indice[[i]]$NDVI = df_NDVI$NDVI
  df_list_indice[[i]]$SWND = df_SWND$SWND
  
  df_new$time_series[[i]] = df_list_indice[[i]]
                    
  
}



