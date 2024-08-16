rm(list=ls())
library(readxl)
library(openxlsx)
library(tidyverse)
set.seed(2023)


dados = read_excel("C:/Users/leona/Documents/Estatística/Usuários_CECAS_2023-alunos_graduacao.xlsx", sheet = "Tabela_Original") %>%
  distinct(Matrícula, Sexo, `E-Mail`)

dados_mulheres = dados %>%
  dplyr::filter(Sexo == "Feminino")
dados_homens = dados %>%
  dplyr::filter(Sexo == "Masculino")

amostra_mulheres = dados_mulheres %>%
  sample_n(size = 28, replace = FALSE)
amostra_homens = dados_homens %>%
  sample_n(size = 23, replace = FALSE)

planilha = createWorkbook()

addWorksheet(planilha, "Amostra Mulheres")
writeData(planilha, "Amostra Mulheres", amostra_mulheres)

addWorksheet(planilha, "Amostra Homens")
writeData(planilha, "Amostra Homens", amostra_homens)

saveWorkbook(planilha, file = "amostra_v02.xlsx", overwrite = TRUE)



amostra_total = rbind(amostra_homens, amostra_mulheres)

stephany = amostra_total %>%
  sample_n(size = 9, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(stephany, by = c("Matrícula", "Sexo", "E-Mail"))

rosimeire = amostra_total %>%
  sample_n(size = 9, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(rosimeire, by = c("Matrícula", "Sexo", "E-Mail"))

letycia = amostra_total %>%
  sample_n(size = 9, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(letycia, by = c("Matrícula", "Sexo", "E-Mail"))

leonardo = amostra_total %>%
  sample_n(size = 8, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(leonardo, by = c("Matrícula", "Sexo", "E-Mail"))

larissa = amostra_total %>%
  sample_n(size = 8, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(larissa, by = c("Matrícula", "Sexo", "E-Mail"))

nilo = amostra_total %>%
  sample_n(size = 8, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(nilo, by = c("Matrícula", "Sexo", "E-Mail"))


amostra = createWorkbook()

addWorksheet(amostra, "Stephanny")
writeData(amostra, "Stephanny", stephanny)

addWorksheet(amostra, "Rosimeire")
writeData(amostra, "Rosimeire", rosimeire)

addWorksheet(amostra, "Letycia")
writeData(amostra, "Letycia", letycia)

addWorksheet(amostra, "Leonardo")
writeData(amostra, "Leonardo", leonardo)

addWorksheet(amostra, "Larissa")
writeData(amostra, "Larissa", larissa)

addWorksheet(amostra, "Nilo")
writeData(amostra, "Nilo", nilo)


saveWorkbook(amostra, file = "amostra_divisao.xlsx", overwrite = TRUE)
  
