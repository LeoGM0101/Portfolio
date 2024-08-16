rm(list=ls())
library(readxl)
library(openxlsx)
library(tidyverse)

dados = read_excel("C:/Users/leona/Documents/Estatística/9 Semestre/Amostragem/Usuários_CECAS_Amostragem.xlsx") %>%
  distinct(`Nome Do Estudante`, Matrícula, Sexo, `E-Mail`)
amostra_1_h = read_excel("C:/Users/leona/Documents/Estatística/9 Semestre/Amostragem/amostra_v02.xlsx", sheet = "Amostra Homens")
amostra_1_m = read_excel("C:/Users/leona/Documents/Estatística/9 Semestre/Amostragem/amostra_v02.xlsx", sheet = "Amostra Mulheres")

amostra2_h = dados %>%
  filter(Sexo == "Masculino",
         !Matrícula %in% amostra_1_h$Matrícula)
amostra2_m = dados %>%
  filter(Sexo == "Feminino",
         !Matrícula %in% amostra_1_m$Matrícula)

amostra_total = rbind(amostra2_h, amostra2_m)


stephany = amostra_total %>%
  sample_n(size = 16, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(stephany, by = c("Matrícula", "Sexo", "E-Mail"))

rosimeire = amostra_total %>%
  sample_n(size = 16, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(rosimeire, by = c("Matrícula", "Sexo", "E-Mail"))

letycia = amostra_total %>%
  sample_n(size = 16, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(letycia, by = c("Matrícula", "Sexo", "E-Mail"))

larissa = amostra_total %>%
  sample_n(size = 16, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(larissa, by = c("Matrícula", "Sexo", "E-Mail"))

nilo = amostra_total %>%
  sample_n(size = 16, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(nilo, by = c("Matrícula", "Sexo", "E-Mail"))

leonardo = amostra_total %>%
  sample_n(size = 17, replace = FALSE)
amostra_total = amostra_total %>%
  anti_join(leonardo, by = c("Matrícula", "Sexo", "E-Mail"))

amostra = createWorkbook()

addWorksheet(amostra, "Stephanny")
writeData(amostra, "Stephanny", stephany)

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


saveWorkbook(amostra, file = "amostra_divisao_v02.xlsx", overwrite = TRUE)
