source("Z:/GERENCIA/RELATÓRIO DE HIPÓTESES/2023/MORTALIDADE/01. TABUAS E TESTE DE ADERÊNCIA/1 - expostos-obitos-v04.R")
library(readxl)
library(plyr)
library(tidyverse)
library(openxlsx)
library(purrr)
library(xlsx)

setwd("Z:/GERENCIA/RELATÓRIO DE HIPÓTESES/2023/MORTALIDADE/01. TABUAS E TESTE DE ADERÊNCIA")
expostos_obitos_masculino = read_excel("expostos e obitos.xlsx", sheet = "Masculino - Soma")
expostos_obitos_feminino = read_excel("expostos e obitos.xlsx", sheet = "Feminino - Soma")
expostos_obitos_ambos = read_excel("expostos e obitos.xlsx", sheet = "Total")

#------------------------------------------------------------------------------#
#IBGE 2018
IBGE_homens_2018 = read_excel("Homens.xlsx", sheet = "2018") %>%
  select(`Idades Exatas (X)`, qx) %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)
IBGE_homens_2018$`Idades ` = as.numeric(IBGE_homens_2018$`Idades`)
IBGE_mulheres_2018 = read_excel("Mulheres.xlsx", sheet = "2018") %>%
  select(`Idades Exatas (X)`, qx) %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)
IBGE_mulheres_2018$`Idades` = as.numeric(IBGE_mulheres_2018$`Idades`)
IBGE_2018 = read_excel("IBGE (2018-2021) - Ambos os Sexos.xlsx", sheet = "IBGE 2018 (Ambos os Sexos)") %>%
  select(`Idades`, qx)
IBGE_2018$`Idades` = as.numeric(IBGE_2018$`Idades`)

#IBGE 2019
IBGE_homens_2019 = read_excel("Homens.xlsx", sheet = "2019") %>%
  select(`Idades Exatas (X)`, qx) %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)
IBGE_homens_2019$`Idades` = as.numeric(IBGE_homens_2019$`Idades`)
IBGE_mulheres_2019 = read_excel("Mulheres.xlsx", sheet = "2019") %>%
  select(`Idades Exatas (X)`, qx) %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)
IBGE_mulheres_2019$`Idades` = as.numeric(IBGE_mulheres_2019$`Idades`)
IBGE_2019 = read_excel("IBGE (2018-2021) - Ambos os Sexos.xlsx", sheet = "IBGE 2019 (Ambos os Sexos)") %>%
  select(`Idades`, qx)
IBGE_2019$`Idades` = as.numeric(IBGE_2019$`Idades`)


#IBGE 2020
IBGE_homens_2020 = read_excel("Homens.xlsx", sheet = "2020") %>%
  select(`Idades Exatas (X)`, qx) %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)
IBGE_homens_2020$`Idades` = as.numeric(IBGE_homens_2020$`Idades`)
IBGE_mulheres_2020 = read_excel("Mulheres.xlsx", sheet = "2020") %>%
  select(`Idades Exatas (X)`, qx) %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)
IBGE_mulheres_2020$`Idades` = as.numeric(IBGE_mulheres_2020$`Idades`)
IBGE_2020 = read_excel("IBGE (2018-2021) - Ambos os Sexos.xlsx", sheet = "IBGE 2020 (Ambos os Sexos)") %>%
  select(`Idades`, qx)
IBGE_2020$`Idades` = as.numeric(IBGE_2020$`Idades`)

#IBGE 2021
IBGE_homens_2021 = read_excel("Homens.xlsx", sheet = "2021") %>%
  select(`Idades Exatas (X)`, qx) %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)
IBGE_homens_2021$`Idades` = as.numeric(IBGE_homens_2021$`Idades`)
IBGE_mulheres_2021 = read_excel("Mulheres.xlsx", sheet = "2021") %>%
  select(`Idades Exatas (X)`, qx) %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)
IBGE_mulheres_2021$`Idades` = as.numeric(IBGE_mulheres_2021$`Idades`)
IBGE_2021 = read_excel("IBGE (2018-2021) - Ambos os Sexos.xlsx", sheet = "IBGE 2021 (Ambos os Sexos)") %>%
  select(`Idades`, qx)
IBGE_2021$`Idades` = as.numeric(IBGE_2021$`Idades`)

#IBGE 2022
IBGE_homens_2022 = read_excel("Homens.xlsx", sheet = "2022") %>%
  select(`Idades Exatas (X)`, qx) %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)
IBGE_homens_2022$`Idades` = as.numeric(IBGE_homens_2022$`Idades`)
IBGE_mulheres_2022 = read_excel("Mulheres.xlsx", sheet = "2022") %>%
  select(`Idades Exatas (X)`, qx) %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)
IBGE_mulheres_2022$`Idades` = as.numeric(IBGE_mulheres_2022$`Idades`)
IBGE_2022 = read_excel("IBGE (2018-2021) - Ambos os Sexos.xlsx", sheet = "IBGE 2022 (Ambos os Sexos)") %>%
  select(`Idades`, qx)
IBGE_2022$`Idades` = as.numeric(IBGE_2022$`Idades`)

#Outras tabuas
tabuas = read_excel("Banco de Tábuas Biométricas_julho 2021_v02.xlsm", sheet = "TÁBUAS (1)") %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)

#------------------------------------------------------------------------------#

tabuas_total_masculino = list("expostos e obitos" = expostos_obitos_masculino,
                              "IBGE_2018" = IBGE_homens_2018, 
                              "IBGE_2019" = IBGE_homens_2019,
                              "IBGE_2020" = IBGE_homens_2020,
                              "IBGE_2021" = IBGE_homens_2021,
                              "IBGE_2022" = IBGE_homens_2022,
                              "Outras tabuas" = tabuas)
tabuas_total_feminino = list("expostos e obitos" = expostos_obitos_feminino,
                             "IBGE_2018" = IBGE_mulheres_2018, 
                             "IBGE_2019" = IBGE_mulheres_2019,
                             "IBGE_2020" = IBGE_mulheres_2020,
                             "IBGE_2021" = IBGE_mulheres_2021,
                             "IBGE_2022" = IBGE_mulheres_2022,
                             "Outras tabuas" = tabuas)
tabuas_total_ambos = list("expostos e obitos" = expostos_obitos_ambos,
                          "IBGE_2018" = IBGE_2018, 
                          "IBGE_2019" = IBGE_2019,
                          "IBGE_2020" = IBGE_2020,
                          "IBGE_2021" = IBGE_2021,
                          "IBGE_2022" = IBGE_2022,
                          "Outras tabuas" = tabuas)

homens = purrr::reduce(tabuas_total_masculino, dplyr::full_join, by = c("IDADE" = "Idades")) %>%
  filter(IDADE >= 18, IDADE <= 111) %>%
  arrange(IDADE) %>%
  dplyr::rename(IBGE_2018 = qx.x, IBGE_2019 = qx.y, IBGE_2020 = qx.x.x, 
                IBGE_2021 = qx.y.y, IBGE_2022 = qx) %>%
  mutate(Vivos = ifelse(is.na(Vivos), 0, Vivos), 
         Falecidos = ifelse(is.na(Falecidos), 0, Falecidos),
         Total = ifelse(is.na(Total), 0, Total),
         IBGE_2018 = ifelse(is.na(IBGE_2018), 1.00000000, IBGE_2018),
         IBGE_2019 = ifelse(is.na(IBGE_2019), 1.00000000, IBGE_2019),
         IBGE_2020 = ifelse(is.na(IBGE_2020), 1.00000000, IBGE_2020),
         IBGE_2021 = ifelse(is.na(IBGE_2021), 1.00000000, IBGE_2021),
         IBGE_2022 = ifelse(is.na(IBGE_2022), 1.00000000, IBGE_2022),
         E.IBGE_2018 = Vivos * IBGE_2018,
         E.IBGE_2019 = Vivos * IBGE_2019,
         E.IBGE_2020 = Vivos * IBGE_2020,
         E.IBGE_2021 = Vivos * IBGE_2021,
         E.IBGE_2022 = Vivos * IBGE_2022,
         `E.AT2000 (Suavizada 10%)_MAS` = Vivos * `AT2000 (Suavizada 10%)_MAS`,
         `E.AT-2000 MALE` = Vivos * `AT-2000 MALE`, 
         `E.AT-49 MALE` = Vivos * `AT-49 MALE`,
         `E.AT-83 MALE (Basic)` = Vivos * `AT-83 MALE (Basic)`,
         `E.AT-83 MALE (IAM)` = Vivos * `AT-83 MALE (IAM)`,
         `E.BR-EMSmt-v.2010-m` = Vivos * `BR-EMSmt-v.2010-m`,
         `E.BR-EMSsb-v.2010-m` = Vivos * `BR-EMSsb-v.2010-m`,
         `E.BR-EMSmt-v.2015-m` = Vivos * `BR-EMSmt-v.2015-m`,
         `E.BR-EMSsb-v.2015-m` = Vivos * `BR-EMSsb-v.2015-m`,
         `E.BR-EMSmt-v.2021-m` = Vivos * `BR-EMSmt-v.2021-m`,
         `E.BR-EMSsb-v.2021-m` = Vivos * `BR-EMSsb-v.2021-m`,
         `E.CSO58 MALE` = Vivos * `CSO58 MALE`,
         `E.GAM-71 MALE` = Vivos * `GAM-71 MALE`,
         `E.GAM83_BÁSICA - MASC` = Vivos * `GAM83_BÁSICA - MASC`,
         `E.GAM-83 - MASC (suav 10%)` = Vivos * `GAM-83 - MASC (suav 10%)`,
         `E.GAM-94MALE` = Vivos * `GAM-94MALE`) %>%
  select(-`AT2000 (Suavizada 10%)_FEM`,
         -`AT-2000 FEMALE`,
         -`AT-49 FEMALE`,
         -`AT-83 FEMALE (Basic)`,
         -`AT-83 FEMALE (IAM)`,
         -`BR-EMSsb-v.2010-f`,
         -`BR-EMSmt-v.2015-f`,
         -`BR-EMSsb-v.2015-f`,
         -`BR-EMSmt-v.2021-f`,
         -`BR-EMSsb-v.2021-f`,
         -`CSO58 FEMALE`,
         -`GAM-71 FEMALE`,
         -`GAM-83 - FEMALE (suav 10%)`,
         -`GAM83_BÁSICA - FEMALE`,
         -`GAM-94 FEMALE`,
         -`Idades `)

mulheres = purrr::reduce(tabuas_total_feminino, dplyr::full_join, by = c("IDADE" = "Idades")) %>%
  filter(IDADE >= 18, IDADE <= 111) %>%
  arrange(IDADE) %>%
  dplyr::rename(IBGE_2018 = qx.x, IBGE_2019 = qx.y, IBGE_2020 = qx.x.x, 
                IBGE_2021 = qx.y.y,  IBGE_2022 = qx) %>%
  mutate(Vivas = ifelse(is.na(Vivas), 0, Vivas), 
         Falecidas = ifelse(is.na(Falecidas), 0, Falecidas),
         Total = ifelse(is.na(Total), 0, Total),
         IBGE_2018 = ifelse(is.na(IBGE_2018), 1.00000000, IBGE_2018),
         IBGE_2019 = ifelse(is.na(IBGE_2019), 1.00000000, IBGE_2019),
         IBGE_2020 = ifelse(is.na(IBGE_2020), 1.00000000, IBGE_2020),
         IBGE_2021 = ifelse(is.na(IBGE_2021), 1.00000000, IBGE_2021),
         IBGE_2022 = ifelse(is.na(IBGE_2022), 1.00000000, IBGE_2022),
         E.IBGE_2018 = Vivas * IBGE_2018,
         E.IBGE_2019 = Vivas * IBGE_2019,
         E.IBGE_2020 = Vivas * IBGE_2020,
         E.IBGE_2021 = Vivas * IBGE_2021,
         E.IBGE_2022 = Vivas * IBGE_2022,
         `E.AT2000 (Suavizada 10%)_FEM` = Vivas * `AT2000 (Suavizada 10%)_FEM`,
         `E.AT-2000 FEMALE` = Vivas * `AT-2000 FEMALE`, 
         `E.AT-49 FEMALE` = Vivas * `AT-49 FEMALE`,
         `E.AT-83 FEMALE (Basic)` = Vivas * `AT-83 FEMALE (Basic)`,
         `E.AT-83 FEMALE (IAM)` = Vivas * `AT-83 FEMALE (IAM)`,
         `E.BR-EMSsb-v.2010-f` = Vivas * `BR-EMSsb-v.2010-f`,
         `E.BR-EMSmt-v.2015-f` = Vivas * `BR-EMSmt-v.2015-f`,
         `E.BR-EMSsb-v.2015-f` = Vivas * `BR-EMSsb-v.2015-f`,
         `E.BR-EMSmt-v.2021-f` = Vivas * `BR-EMSmt-v.2021-f`,
         `E.BR-EMSsb-v.2021-f` = Vivas * `BR-EMSsb-v.2021-f`,
         `E.CSO58 FEMALE` = Vivas * `CSO58 FEMALE`,
         `E.GAM-71 FEMALE` = Vivas * `GAM-71 FEMALE`,
         `E.GAM-83 - FEMALE (suav 10%)` = Vivas * `GAM-83 - FEMALE (suav 10%)`,
         `E.GAM83_BÁSICA - FEMALE` = Vivas * `GAM83_BÁSICA - FEMALE`,
         `E.GAM-94 FEMALE` = Vivas * `GAM-94 FEMALE`) %>%
  select(-`AT2000 (Suavizada 10%)_MAS`,
         -`AT-2000 MALE`,
         -`AT-49 MALE`,
         -`AT-83 MALE (Basic)`,
         -`AT-83 MALE (IAM)`,
         -`BR-EMSmt-v.2010-m`,
         -`BR-EMSsb-v.2010-m`,
         -`BR-EMSmt-v.2015-m`,
         -`BR-EMSsb-v.2015-m`,
         -`BR-EMSmt-v.2021-m`,
         -`BR-EMSsb-v.2021-m`,
         -`CSO58 MALE`,
         -`GAM-71 MALE`,
         -`GAM-83 - MASC (suav 10%)`,
         -`GAM83_BÁSICA - MASC`,
         -`GAM-94MALE`)

tabuas_ambos = purrr::reduce(tabuas_total_ambos, dplyr::full_join, by = c("IDADE" = "Idades")) %>%
  filter(IDADE >= 18, IDADE <= 111) %>%
  arrange(IDADE) %>%
  dplyr::rename(IBGE_2018 = qx.x, IBGE_2019 = qx.y, IBGE_2020 = qx.x.x, 
                IBGE_2021 = qx.y.y, IBGE_2022 = qx) %>%
  mutate(Vivos = ifelse(is.na(Vivos), 0, Vivos), 
         Falecidos = ifelse(is.na(Falecidos), 0, Falecidos),
         Total = ifelse(is.na(Total), 0, Total),
         IBGE_2018 = ifelse(is.na(IBGE_2018), 1.00000000, IBGE_2018),
         IBGE_2019 = ifelse(is.na(IBGE_2019), 1.00000000, IBGE_2019),
         IBGE_2020 = ifelse(is.na(IBGE_2020), 1.00000000, IBGE_2020),
         IBGE_2021 = ifelse(is.na(IBGE_2021), 1.00000000, IBGE_2021),
         IBGE_2022 = ifelse(is.na(IBGE_2022), 1.00000000, IBGE_2022),
         E.IBGE_2018 = Vivos * IBGE_2018,
         E.IBGE_2019 = Vivos * IBGE_2019,
         E.IBGE_2020 = Vivos * IBGE_2020,
         E.IBGE_2021 = Vivos * IBGE_2021,
         E.IBGE_2022 = Vivos * IBGE_2022,
         `E.AT2000 (Suavizada 10%)_MAS` = Vivos * `AT2000 (Suavizada 10%)_MAS`,
         `E.AT-2000 MALE` = Vivos * `AT-2000 MALE`, 
         `E.AT-49 MALE` = Vivos * `AT-49 MALE`,
         `E.AT-83 MALE (Basic)` = Vivos * `AT-83 MALE (Basic)`,
         `E.AT-83 MALE (IAM)` = Vivos * `AT-83 MALE (IAM)`,
         `E.BR-EMSmt-v.2010-m` = Vivos * `BR-EMSmt-v.2010-m`,
         `E.BR-EMSsb-v.2010-m` = Vivos * `BR-EMSsb-v.2010-m`,
         `E.BR-EMSmt-v.2015-m` = Vivos * `BR-EMSmt-v.2015-m`,
         `E.BR-EMSsb-v.2015-m` = Vivos * `BR-EMSsb-v.2015-m`,
         `E.BR-EMSmt-v.2021-m` = Vivos * `BR-EMSmt-v.2021-m`,
         `E.BR-EMSsb-v.2021-m` = Vivos * `BR-EMSsb-v.2021-m`,
         `E.CSO58 MALE` = Vivos * `CSO58 MALE`,
         `E.GAM-71 MALE` = Vivos * `GAM-71 MALE`,
         `E.GAM83_BÁSICA - MASC` = Vivos * `GAM83_BÁSICA - MASC`,
         `E.GAM-83 - MASC (suav 10%)` = Vivos * `GAM-83 - MASC (suav 10%)`,
         `E.GAM-94MALE` = Vivos * `GAM-94MALE`,
         `E.AT2000 (Suavizada 10%)_FEM` = Vivos * `AT2000 (Suavizada 10%)_FEM`,
         `E.AT-2000 FEMALE` = Vivos * `AT-2000 FEMALE`, 
         `E.AT-49 FEMALE` = Vivos * `AT-49 FEMALE`,
         `E.AT-83 FEMALE (Basic)` = Vivos * `AT-83 FEMALE (Basic)`,
         `E.AT-83 FEMALE (IAM)` = Vivos * `AT-83 FEMALE (IAM)`,
         `E.BR-EMSsb-v.2010-f` = Vivos * `BR-EMSsb-v.2010-f`,
         `E.BR-EMSmt-v.2015-f` = Vivos * `BR-EMSmt-v.2015-f`,
         `E.BR-EMSsb-v.2015-f` = Vivos * `BR-EMSsb-v.2015-f`,
         `E.BR-EMSmt-v.2021-f` = Vivos * `BR-EMSmt-v.2021-f`,
         `E.BR-EMSsb-v.2021-f` = Vivos * `BR-EMSsb-v.2021-f`,
         `E.CSO58 FEMALE` = Vivos * `CSO58 FEMALE`,
         `E.GAM-71 FEMALE` = Vivos * `GAM-71 FEMALE`,
         `E.GAM-83 - FEMALE (suav 10%)` = Vivos * `GAM-83 - FEMALE (suav 10%)`,
         `E.GAM83_BÁSICA - FEMALE` = Vivos * `GAM83_BÁSICA - FEMALE`,
         `E.GAM-94 FEMALE` = Vivos * `GAM-94 FEMALE`)


#------------------------------------------------------------------------------#
#Teste KS bilateral - avalia a concordancia entre a distribuicao observada da amostra
# e uma determinada distribuicao teorica.
# H0: A distribucao observada adere a distribuicao esperada, ou seja, F(x) = F*(x)
# H1: F(x) != F*(x)

#------------------------------------------------------------------------------#
#Testes para os homens

tabela_homens = numeric()
h = 1
for(i in grep("^E.", colnames(homens))) {
  tabela_homens[h] = homens[i]
  h = h + 1
}

falecidos_homens = homens %>%
  select(Falecidos)

nome_tabuas_homens = homens %>%
  select(-IDADE,
         -Vivos,
         -Falecidos,
         -Total, 
         -grep("^E.", colnames(homens)),
         -...33)
nome_tabuas_homens = as.vector(colnames(nome_tabuas_homens))
 

testes_homens = list()
for(i in 1:length(tabela_homens)) {
  testes_homens[[i]] = ks.test(falecidos_homens, tabela_homens[[i]])[c("statistic", "p.value")]
}
testes_homens = setNames(testes_homens, nome_tabuas_homens)

#------------------------------------------------------------------------------#
#Testes para as mulheres

tabela_mulheres = numeric()
h = 1

for(i in grep("^E.", colnames(mulheres))) {
  tabela_mulheres[h] = mulheres[i]
  h = h + 1
}

falecidas_mulheres = mulheres %>%
  select(Falecidas)

nome_tabuas_mulheres = mulheres %>%
  select(-IDADE,
         -Vivas,
         -Falecidas,
         -Total, 
         -grep("^E.", colnames(mulheres)),
         -...33)
nome_tabuas_mulheres = as.vector(colnames(nome_tabuas_mulheres))


testes_mulheres = list()
for(i in 1:length(tabela_mulheres)) {
  testes_mulheres[[i]] = ks.test(falecidas_mulheres, tabela_mulheres[[i]])[c("statistic", "p.value")]
}
testes_mulheres = setNames(testes_mulheres, nome_tabuas_mulheres)

#------------------------------------------------------------------------------#
#Testes para ambos os sexos

tabela_total = numeric()
h = 1

for(i in grep("^E.", colnames(tabuas_ambos))) {
  tabela_total[h] = tabuas_ambos[i]
  h = h + 1
}

falecidos = tabuas_ambos %>%
  select(Falecidos)

nome_tabuas_ambos = tabuas_ambos %>%
  select(-IDADE,
         -Vivos,
         -Falecidos,
         -Total, 
         -grep("^E.", colnames(tabuas_ambos)),
         -...33)
nome_tabuas_ambos = as.vector(colnames(nome_tabuas_ambos))

testes_ambos = list()
for(i in 1:length(tabela_total)) {
  testes_ambos[[i]] = ks.test(falecidos, tabela_total[[i]])[c("statistic", "p.value")]
}
testes_ambos = setNames(testes_ambos, nome_tabuas_ambos)

#------------------------------------------------------------------------------#
tabela_testes_masculinos = ldply(testes_homens, data.frame)
tabela_testes_femininos = ldply(testes_mulheres, data.frame)
tabela_testes_ambos = ldply(testes_ambos, data.frame)

wb = openxlsx::createWorkbook()
openxlsx::addWorksheet(wb, sheetName = "Homens")
openxlsx::addWorksheet(wb, sheetName = "Mulheres")
openxlsx::addWorksheet(wb, sheetName = "Ambos os sexos")
openxlsx::addWorksheet(wb, sheetName = "Testes masculinos")
openxlsx::addWorksheet(wb, sheetName = "Testes femininos")
openxlsx::addWorksheet(wb, sheetName = "Testes para ambos os sexos")

openxlsx::writeData(wb, "Homens", homens)
openxlsx::writeData(wb, "Mulheres", mulheres)
openxlsx::writeData(wb, "Ambos os sexos", tabuas_ambos)
openxlsx::writeData(wb, "Testes masculinos", tabela_testes_masculinos)
openxlsx::writeData(wb, "Testes femininos", tabela_testes_femininos)
openxlsx::writeData(wb, "Testes para ambos os sexos", tabela_testes_ambos)


openxlsx::saveWorkbook(wb, "Testes de Aderencia.xlsx", overwrite = TRUE)
