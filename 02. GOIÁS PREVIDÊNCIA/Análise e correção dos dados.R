rm(list=ls())
library(readxl)
library(tidyverse)
library(openxlsx)

base122021_ativo = read_excel("Z:/ArquivosTI/Atuario122021.xlsx", sheet = "Ativo")
base122021_inativo = read_excel("Z:/ArquivosTI/Atuario122021.xlsx", sheet = "Inativo")
base122021_pensionista = read_excel("Z:/ArquivosTI/Atuario122021.xlsx", sheet = "Pensionista")

#------------------------------------------------------------------------------#

#Ativos

#analisando data de ingresso no servico publico e no servico publico do estado
erros = 0
for(i in 1:length(base122021_ativo$DT_ING_SERV_PUB)) {
  if(base122021_ativo$DT_ING_SERV_PUB[i] > base122021_ativo$DT_ING_ENTE[i]) {
    erros = erros + 1
  }
}; erros

erro_data_ingresso = base122021_ativo %>%
  filter(DT_ING_SERV_PUB > DT_ING_ENTE)

#analisando a composicao da massa
erros_1 = 0
erros_2 = 0
for(i in 1:length(base122021_ativo$CO_COMP_MASSA)) {
  if(is.na(base122021_ativo$CO_COMP_MASSA[i]) == TRUE) {
    erros_1 = erros_1 + 1
  }
  if(base122021_ativo$CO_COMP_MASSA[i] != 1 || base122021_ativo$CO_COMP_MASSA[i] != 2) {
    erros_2 = erros_2 + 1
  } 
}; erros_1; erros_2

#analisando o tipo de fundo
erros_1 = 0
erros_2 = 0
for(i in 1:length(base122021_ativo$CO_TIPO_FUNDO)) {
  if(is.na(base122021_ativo$CO_TIPO_FUNDO[i]) == TRUE) {
    erros_1 = erros_1 + 1
  }
  if(base122021_ativo$CO_TIPO_FUNDO[i] != 1 && base122021_ativo$CO_TIPO_FUNDO[i] != 2) {
    erros_2 = erros_2 + 1
  } 
}; erros_1; erros_2

#analisando o codigo do poder
erros_1 = 0
erros_2 = 0
for(i in 1:length(base122021_ativo$CO_PODER)) {
  if(is.na(base122021_ativo$CO_PODER[i]) == TRUE) {
    erros_1 = erros_1 + 1
  }
  if(base122021_ativo$CO_PODER[i] != 1 && base122021_ativo$CO_PODER[i] != 6) {
    erros_2 = erros_2 + 1
  } 
}; erros_1; erros_2

#analisando o codigo do tipo de poder
erros_1 = 0
erros_2 = 0
for(i in 1:length(base122021_ativo$CO_TIPO_PODER)) {
  if(is.na(base122021_ativo$CO_TIPO_PODER[i]) == TRUE) {
    erros_1 = erros_1 + 1
  }
  if(base122021_ativo$CO_TIPO_PODER[i] != 1) {
    erros_2 = erros_2 + 1
  } 
}; erros_1; erros_2

#analisando o codigo do tipo de populacao
erros_1 = 0
erros_2 = 0
for(i in 1:length(base122021_ativo$CO_TIPO_POPULACAO)) {
  if(is.na(base122021_ativo$CO_TIPO_POPULACAO[i]) == TRUE) {
    erros_1 = erros_1 + 1
  }
  if(base122021_ativo$CO_TIPO_POPULACAO[i] != 1 && base122021_ativo$CO_TIPO_POPULACAO[i] != 8) {
    erros_2 = erros_2 + 1
  } 
}; erros_1; erros_2

#analisando o tipo de cargo
erros_1 = 0
erros_2 = 0
tipo_cargo = seq(2,8,1)
for(i in 1:length(base122021_ativo$CO_TIPO_CARGO)) {
  if(is.na(base122021_ativo$CO_TIPO_CARGO[i]) == TRUE) {
    erros_1 = erros_1 + 1
  }
  if(base122021_ativo$CO_TIPO_CARGO[i] != 1) {
    erros_2 = erros_2 + 1
  } 
}; erros_1; erros_2

# sapply(tipo_cargo, function(x) if(base122021_ativo$CO_TIPO_CARGO != x) {erros_2 = erros_2 + 1})

#analisando se ha linhas vazias na base de calculo mensal do servidor
erros = 0
for(i in 1:length(base122021_ativo$VL_BASE_CALCULO)) {
  if(is.na(base122021_ativo$VL_BASE_CALCULO[i]) == TRUE) {
    erros = erros + 1
  }
}; erros

#analisando se ha linhas vazias na contribuicao mensal
erros = 0
for(i in 1:length(base122021_ativo$VL_CONTRIBUICAO)) {
  if(is.na(base122021_ativo$VL_CONTRIBUICAO[i]) == TRUE) {
    erros = erros + 1
  }
}; erros


#analisando se ha linhas vazias no tempo de contribuicao do servidor para o RGPS
erros = 0
for(i in 1:length(base122021_ativo$NU_TEMPO_RGPS)) {
  if(is.na(base122021_ativo$NU_TEMPO_RGPS[i]) == TRUE) {
    erros = erros + 1
  }
}; erros

#analisando se ha linhas vazias no tempo de contribuicao do servidor na esfera municipal
erros = 0
for(i in 1:length(base122021_ativo$NU_TEMPO_RPPS_MUN)) {
  if(is.na(base122021_ativo$NU_TEMPO_RPPS_EST[i]) == TRUE) {
    erros = erros + 1
  }
}; erros

#analisando se ha linhas vazias o tempo de contribuicao do servidor na esfera estadual
erros = 0
for(i in 1:length(base122021_ativo$NU_TEMPO_RPPS_EST)) {
  if(is.na(base122021_ativo$NU_TEMPO_RPPS_EST[i]) == TRUE) {
    erros = erros + 1
  }
}; erros


#analisando se ha linhas vazias o tempo de contribuicao do servidor na esfera federal
erros = 0
for(i in 1:length(base122021_ativo$NU_TEMPO_RPPS_FED)) {
  if(is.na(base122021_ativo$NU_TEMPO_RPPS_FED[i]) == TRUE) {
    erros = erros + 1
  }
}; erros
