rm(list=ls())
library(readxl)
library(tidyverse)
library(timeDate)

#------------------------------------------------------------------------------#
tabela_rentabilidade_risco = read_excel("Z:/GERENCIA/INVESTIMENTOS/11. PROJETO/Cadastro Fundos.xlsx") %>%
  select("NOME", "CNPJ", "Bench") %>%
  filter(!(CNPJ %in% c("25.078.994/0001-90", "44.683.378/0001-02")))

#Atencao!!! O codigo para o calculo do VaR e dos Retornos diarios esta programado ate o ultimo informe diario publicado no site da CVM,
# que no caso e o mes de junho ate a escrita deste codigo. Caso as analises sejam posteriores ao mes de junho de 2023, abra o script "Fundos" que 
# esta localizado na pasta Z:\GERENCIA\INVESTIMENTOS\11. PROJETO\3 - VaR e siga as instrucoes la contidas.
# P.s.: Nao precisa rodar o script "Fundos". Basta adicionar o informe necessario e salvar o documento.

source("Z:/GERENCIA/INVESTIMENTOS/11. PROJETO/3 - VaR/VaR_mensal (Leonardo).R")
source("Z:/GERENCIA/INVESTIMENTOS/11. PROJETO/3 - VaR/Retornos.R")

#Atencao!!!! Lembre-se de mudar os parametros necessarios. Em retorno_ano_anterior, atente-se para o ultimo dia util do ano anterior. Para o ano de
# 2022, o ultimo dia util e 30 de dezembro. Entao na variavel retorno_ano_anterior colocar "12" em format(DT_COMPTC, "%m") == "12" e "30" em format(DT_COMPTC, "%d") == "30"
# Em retorno_mes_atual, atente-se para o ultimo dia util do mes atual. Ex: se o mes atual for maio e o ultimo dia util de 
# maio for o dia 31, entao na variavel retorno_mes_atual colocar "05" em format(DT_COMPTC, "%m") == "05" e "31" em format(DT_COMPTC, "%d") == "31"
# Em retorno_mes_anterior e a mesma logica. Se o mes anterior for abril e o ultimo dia util for 28, colocar "04" em format(DT_COMPTC, "%m") == "04" e 
# "28" em format(DT_COMPTC, "%d") == "28"


retorno_ano_anterior = subset(retornos, format(DT_COMPTC, "%Y") == "2022" & format(DT_COMPTC, "%m") == "12" & format(DT_COMPTC, "%d") == "30") %>%
  pivot_longer(cols = -DT_COMPTC, names_to = "CNPJ", values_to = "retorno") %>%
  filter(!(CNPJ %in% c("25.078.994/0001-90", "44.683.378/0001-02")))
retorno_mes_atual = subset(retornos, format(DT_COMPTC, "%Y") == "2023" & format(DT_COMPTC, "%m") == "05" & format(DT_COMPTC, "%d") == "31") %>%
  pivot_longer(cols = -DT_COMPTC, names_to = "CNPJ", values_to = "retorno") %>%
  filter(!(CNPJ %in% c("25.078.994/0001-90", "44.683.378/0001-02")))
retorno_mes_anterior = subset(retornos, format(DT_COMPTC, "%Y") == "2023" & format(DT_COMPTC, "%m") == "04" & format(DT_COMPTC, "%d") == "28") %>%
  pivot_longer(cols = -DT_COMPTC, names_to = "CNPJ", values_to = "retorno") %>%
  filter(!(CNPJ %in% c("25.078.994/0001-90", "44.683.378/0001-02")))

#------------------------------------------------------------------------------#

# Calculando e criando a coluna rentabilidade/mes
rentabilidade_mes = retorno_mes_atual %>%
  mutate(rentabilidade.mes = (retorno_mes_anterior$retorno/retorno) - 1) %>%
  select(CNPJ, rentabilidade.mes)

# Calculando e criando a coluna rentabilidade/ano
rentabilidade_ano = retorno_mes_atual %>%
  mutate(rentabilidade.ano = (retorno_ano_anterior$retorno/retorno) - 1) %>%
  select(CNPJ, rentabilidade.ano)

#Juntando todas as tabelas
tabela_rentabilidade_risco = tabela_rentabilidade_risco %>%
  full_join(rentabilidade_mes, by = "CNPJ") %>%
  full_join(rentabilidade_ano, by = "CNPJ") %>%
  full_join(var, by = c("CNPJ" = "CNPJs")) %>%
  filter(!(CNPJ %in% c("25.078.994/0001-90", "44.683.378/0001-02")))

write.xlsx(tabela_rentabilidade_risco,"Z:/GERENCIA/INVESTIMENTOS/11. PROJETO/tabela_rentabilidade_risco.xlsx")
