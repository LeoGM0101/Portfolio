rm(list=ls())
library(readxl)
library(openxlsx)
library(tidyverse)
set.seed(2023)


dados_mulheres = read_excel("C:/Users/leona/Documents/Estatística/9 Semestre/Amostragem/Usuários_CECAS_Amostragem_V1.xlsx", sheet = "BD_MULHERES") %>%
  distinct(Matrícula, Sexo)
dados_homens = read_excel("C:/Users/leona/Documents/Estatística/9 Semestre/Amostragem/Usuários_CECAS_Amostragem_V1.xlsx", sheet = "BD_HOMENS") %>%
  distinct(Matrícula, Sexo)

amostra_mulheres = sample(dados_mulheres$Matrícula, size = 28)
amostra_homens = sample(dados_homens$Matrícula, size = 23)

planilha = createWorkbook()

addWorksheet(planilha, "Amostra de Mulheres")
writeData(planilha, "Amostra de Mulheres", amostra_mulheres)

addWorksheet(planilha, "Amostra de Homens")
writeData(planilha, "Amostra de Homens", amostra_homens)

saveWorkbook(planilha, file = "amostra.xlsx", overwrite = TRUE)

