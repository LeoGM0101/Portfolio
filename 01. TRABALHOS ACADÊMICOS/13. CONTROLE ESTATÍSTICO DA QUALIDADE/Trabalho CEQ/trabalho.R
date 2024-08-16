library(qcc)
library(dplyr)
rm(list = ls())

water_potability <- read.csv("water_potability.csv")
tamanho_amostra <- rep(1:100, each = 10)

#------------------------------------------------------------------------------#

#ph


#Gerando amostra aleatória para o PH
ph <- water_potability[!is.na(water_potability$ph),] #Remoção das linhas NA
sample <- sample_n(ph, 1000)
indice_ph <- qcc.groups(sample$ph, tamanho_amostra) #Organização das 10 amostras

#Gráfico de controle da média do PH com 10 amostras de 100 observações cada
grafico_xbar_ph <- qcc(indice_ph[1:100,], type = "xbar")

#Gráfico de controle R do PH com 10 amostras de 100 observações cada
grafico_R_ph <- qcc(indice_ph[1:100,], type = "R")

#Gráfico de controle S do PH com 10 amostras de 100 observações cada
grafico_S_ph <- qcc(indice_ph[1:100,], type = "S")

#Gráfico de controle Cusum do PH com 10 amostras de 100 observações cada
grafico_cumsum_ph <- cusum(indice_ph[1:70,], newdata = indice_ph[71:100,])

#------------------------------------------------------------------------------#

#Cloramina


#Gerando amostra aleatória para Cloramina
cloramina <- water_potability[!is.na(water_potability$Chloramines),]
sample <- sample_n(cloramina, 1000)
indice_cloramina <- qcc.groups(sample$Chloramines, tamanho_amostra)

#Gráfico de controle da média de Cloramina com 10 amostras de 100 observações cada
grafico_xbar_cloramina <- qcc(indice_cloramina[1:100,], type = "xbar")

#Gráfico de controle R de Cloramina com 10 amostras de 100 observações cada
grafico_R_cloramina <- qcc(indice_cloramina[1:100,], type = "R")

#Gráfico de controle S de Cloramina com 10 amostras de 100 observações cada
grafico_S_cloramina <- qcc(indice_cloramina[1:100,], type = "S")

#Gráfico de controle Cusum de Cloramina com 10 amostras de 100 observações cada
grafico_cumsum_cloramina <- cusum(indice_cloramina[1:70,], 
                                  newdata = indice_cloramina[71:100,])

#------------------------------------------------------------------------------#

#Sulfato


#Gerando amostra aleatória para Sulfato
sulfato <- water_potability[!is.na(water_potability$Sulfate),]
sample <- sample_n(sulfato, 1000)
indice_sulfato <- qcc.groups(sample$Sulfate , tamanho_amostra)

#Gráfico de controle da média de Sulfato com 10 amostras de 100 observações cada
grafico_xbar_sulfato <- qcc(indice_sulfato[1:100,], type = "xbar")

#Gráfico de controle R de Sulfato com 10 amostras de 100 observações cada
grafico_R_sulfato <- qcc(indice_sulfato[1:100,], type = "R")

#Gráfico de controle S de Sulfato com 10 amostras de 100 observações cada
grafico_S_sulfato <- qcc(indice_sulfato[1:100,], type = "S")

#Gráfico de controle Cusum de Sulfato com 10 amostras de 100 observações cada
grafico_cumsum_sulfato <- cusum(indice_sulfato[1:70,], 
                                  newdata = indice_sulfato[71:100,])

#------------------------------------------------------------------------------#

#Trihalometanos


#Gerando amostra aleatória para Trihalometanos
trihalometanos <- water_potability[!is.na(water_potability$Trihalomethanes),]
sample <- sample_n(trihalometanos, 1000)
indice_trihalometanos <- qcc.groups(sample$Trihalomethanes, tamanho_amostra)

#Gráfico de controle da média de Trihalometanos com 10 amostras de 100 observações cada
grafico_xbar_trihalometanos <- qcc(indice_trihalometanos[1:100,], type = "xbar")

#Gráfico de controle R de Trihalometanos com 10 amostras de 100 observações cada
grafico_R_trihalometanos <- qcc(indice_trihalometanos[1:100,], type = "R")

#Gráfico de controle S de Trihalometanos com 10 amostras de 100 observações cada
grafico_S_trihalometanos <- qcc(indice_trihalometanos[1:100,], type = "S")

#Gráfico de controle Cusum de Trihalometanos com 10 amostras de 100 observações cada
grafico_cumsum_trihalometanos <- cusum(indice_trihalometanos[1:70,], 
                                  newdata = indice_trihalometanos[71:100,])

#------------------------------------------------------------------------------#

