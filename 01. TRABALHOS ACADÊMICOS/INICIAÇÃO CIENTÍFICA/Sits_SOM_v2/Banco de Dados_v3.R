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
    lista_df[[l]] = read_excel(paste0("C:/Users/leona/Desktop/indices_temporal/", nomes[l]))
    l = l+1
  }
}
dados = as.data.frame(purrr::reduce(lista_df, dplyr::full_join, by = "DTYMD"))
dados = dados %>%
  filter(DTYMD >= "2020-08-28")
rm(lista_df, regiao, indice, nomes)

rownames(dados) = dados$DTYMD
dados = dados[, -1]
dados_t = as.data.frame(t(dados)) %>% 
  rownames_to_column(var = "nomes_linhas")
dados_t = separate(dados_t, nomes_linhas, into = c("ponto", "regiao", "categoria", "indice"), sep = "_")

#write.xlsx(dados_t, "C:/Users/leona/Desktop/indices_temporal/Dados.xlsx")





df_long = pivot_longer(dados_t, cols = -c(ponto, regiao, categoria, indice), names_to = "data", values_to = "valor")




df = df_long %>%
  select(ponto, indice, data, valor)
df$data = as.Date(df$data)



df_evi = df %>% 
  filter(indice == 'EVI') %>%
  rename(EVI = valor) %>%
  select(ponto, data, EVI)

df_grnd = df %>% 
  filter(indice == 'GRND') %>%
  rename(GRND = valor) %>%
  select(ponto, data, GRND)

df_NDII1 = df %>% 
  filter(indice == 'NDII1') %>%
  rename(NDII1 = valor) %>%
  select(ponto, data, NDII1)

df_NDII2 = df %>% 
  filter(indice == 'NDII2') %>%
  rename(NDII2 = valor) %>%
  select(ponto, data, NDII2)

df_NDVI = df %>% 
  filter(indice == 'NDVI') %>%
  rename(NDVI = valor) %>%
  select(ponto, data, NDVI)

df_SWND = df %>% 
  filter(indice == 'SWND') %>%
  rename(SWND = valor) %>%
  select(ponto, data, SWND)

series_temporais = data.frame(ponto = df_long$ponto, regiao = df_long$regiao, categoria = df_long$categoria, 
                              data = df_long$data, evi = df_evi$EVI, grnd = df_grnd$GRND, 
                              ndii1 = df_NDII1$NDII1, ndii2 = df_NDII2$NDII2, ndvi = df_NDVI$NDVI, 
                              swnd = df_SWND$SWND)
series_temporais$data = as.Date(series_temporais$data)

#series_temporais = as_tibble(series_temporais)

lista_series_temporais = split(series_temporais, series_temporais$ponto)

df_long_sem.data = df_long %>% select(-data, -valor)

# Criar um dataframe contendo todas as combinações possíveis de ponto, região e categoria
combinacoes = expand.grid(ponto = unique(df_long_sem.data$ponto), regiao = unique(df_long_sem.data$regiao), 
                           categoria = unique(df_long_sem.data$categoria))

# Juntar as combinações com os dados originais
df_combinado = merge(combinacoes, df_long_sem.data, by = c("ponto", "regiao", "categoria"), all.x = TRUE)

dados_geral = data.frame(ponto = unique(series_temporais$ponto), start_date = rep("2020-09-13", length(unique(series_temporais$ponto))), 
                         end_date = rep("2021-12-19", length(unique(series_temporais$ponto))),
                         time_series = rep(NA, length(unique(series_temporais$ponto))))

dados_geral$time_series = vector("list", nrow(dados_geral))

# Função para extrair números
extrair_numeros = function(texto) {
  as.numeric(gsub("[^0-9]", "", texto))
}

# Ordenar os dados
dados_geral$ponto = dados_geral$ponto[order(extrair_numeros(dados_geral$ponto))]


extrair_numeros_lista = function(texto) {
  ifelse(texto == 'unknown', Inf, as.numeric(gsub("[^0-9]", "", texto)))
}



for(i in 1:nrow(dados_geral)) {
  for(j in 1:length(lista_series_temporais)) {
    if(dados_geral$ponto[i] == names(lista_series_temporais)[j]) {
      dados_geral$time_series[[i]] = lista_series_temporais[[j]]
    }
  }
}


cube = c()
label = c()
for(i in 1:nrow(dados_geral)) {
  cube[i] = unique(dados_geral$time_series[[i]][, 2])
  label[i] = unique(dados_geral$time_series[[i]][, 3])
}

for(i in 1:nrow(dados_geral)) {
  dados_geral$time_series[[i]] = dados_geral$time_series[[i]] %>%
    select(-ponto, -regiao, -categoria)
}


dados_geral = dados_geral %>%
  mutate(label = label, cube = cube)

dados_geral = dados_geral %>%
  select(ponto, start_date, end_date, label, cube, time_series)

dados_geral$start_date = as.Date(dados_geral$start_date)
dados_geral$end_date = as.Date(dados_geral$end_date)
longitude = runif(length(dados_geral$start_date), -50, -10)
dados_geral$longitude = longitude
latitude = runif(length(dados_geral$start_date), -50, -10)
dados_geral$latitude = latitude
dados_geral = dados_geral %>%
  select(latitude, longitude, start_date, end_date,
         label, cube, time_series)



dados_geral = as_tibble(dados_geral)


# saveRDS(dados_geral, "C:/Users/leona/Desktop/indices_temporal/Dados.rds")
