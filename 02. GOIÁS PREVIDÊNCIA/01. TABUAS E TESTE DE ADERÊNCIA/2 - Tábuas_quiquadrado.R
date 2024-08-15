#OBS.: antes de rodar este codigo, certifique-se que o codigo '1 - expostos-obitos-v04' foi rodado anteriormente.
rm(list=ls(all=TRUE))
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

#Outras tabuas
tabuas = read_excel("Banco de Tábuas Biométricas_julho 2021_v02.xlsm", sheet = "TÁBUAS (1)") %>%
  dplyr::rename(Idades = `Idades Exatas (X)`)

#------------------------------------------------------------------------------#

tabuas_total_masculino = list("expostos e obitos" = expostos_obitos_masculino,
                              "IBGE_2018" = IBGE_homens_2018, 
                              "IBGE_2019" = IBGE_homens_2019,
                              "IBGE_2020" = IBGE_homens_2020,
                              "IBGE_2021" = IBGE_homens_2021,
                              "Outras tabuas" = tabuas)
tabuas_total_feminino = list("expostos e obitos" = expostos_obitos_feminino,
                             "IBGE_2018" = IBGE_mulheres_2018, 
                             "IBGE_2019" = IBGE_mulheres_2019,
                             "IBGE_2020" = IBGE_mulheres_2020,
                             "IBGE_2021" = IBGE_mulheres_2021,
                             "Outras tabuas" = tabuas)
tabuas_total_ambos = list("expostos e obitos" = expostos_obitos_ambos,
                    "IBGE_2018" = IBGE_2018, 
                    "IBGE_2019" = IBGE_2019,
                    "IBGE_2020" = IBGE_2020,
                    "IBGE_2021" = IBGE_2021,
                    "Outras tabuas" = tabuas)

homens = purrr::reduce(tabuas_total_masculino, dplyr::full_join, by = c("IDADE" = "Idades")) %>%
  filter(IDADE >= 18, IDADE <= 111) %>%
  arrange(IDADE) %>%
  dplyr::rename(IBGE_2018 = qx.x, IBGE_2019 = qx.y, IBGE_2020 = qx.x.x, IBGE_2021 = qx.y.y) %>%
  mutate(Vivos = ifelse(is.na(Vivos), 0, Vivos), 
         Falecidos = ifelse(is.na(Falecidos), 0, Falecidos),
         Total = ifelse(is.na(Total), 0, Total),
         IBGE_2018 = ifelse(is.na(IBGE_2018), 1.00000000, IBGE_2018),
         IBGE_2019 = ifelse(is.na(IBGE_2019), 1.00000000, IBGE_2019),
         IBGE_2020 = ifelse(is.na(IBGE_2020), 1.00000000, IBGE_2020),
         IBGE_2021 = ifelse(is.na(IBGE_2021), 1.00000000, IBGE_2021),
         E.IBGE_2018 = Vivos * IBGE_2018,
         E.IBGE_2019 = Vivos * IBGE_2019,
         E.IBGE_2020 = Vivos * IBGE_2020,
         E.IBGE_2021 = Vivos * IBGE_2021,
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
         -`GAM-94 FEMALE`)

mulheres = purrr::reduce(tabuas_total_feminino, dplyr::full_join, by = c("IDADE" = "Idades")) %>%
  filter(IDADE >= 18, IDADE <= 111) %>%
  arrange(IDADE) %>%
  dplyr::rename(IBGE_2018 = qx.x, IBGE_2019 = qx.y, IBGE_2020 = qx.x.x, IBGE_2021 = qx.y.y) %>%
  mutate(Vivas = ifelse(is.na(Vivas), 0, Vivas), 
         Falecidas = ifelse(is.na(Falecidas), 0, Falecidas),
         Total = ifelse(is.na(Total), 0, Total),
         IBGE_2018 = ifelse(is.na(IBGE_2018), 1.00000000, IBGE_2018),
         IBGE_2019 = ifelse(is.na(IBGE_2019), 1.00000000, IBGE_2019),
         IBGE_2020 = ifelse(is.na(IBGE_2020), 1.00000000, IBGE_2020),
         IBGE_2021 = ifelse(is.na(IBGE_2021), 1.00000000, IBGE_2021),
         E.IBGE_2018 = Vivas * IBGE_2018,
         E.IBGE_2019 = Vivas * IBGE_2019,
         E.IBGE_2020 = Vivas * IBGE_2020,
         E.IBGE_2021 = Vivas * IBGE_2021,
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
  filter(IDADE >= 18, IDADE <= 100) %>%
  arrange(IDADE) %>%
  dplyr::rename(IBGE_2018 = qx.x, IBGE_2019 = qx.y, IBGE_2020 = qx.x.x, IBGE_2021 = qx.y.y) %>%
  mutate(Vivos = ifelse(is.na(Vivos), 0, Vivos), 
         Falecidos = ifelse(is.na(Falecidos), 0, Falecidos),
         Total = ifelse(is.na(Total), 0, Total),
         IBGE_2018 = ifelse(is.na(IBGE_2018), 1.00000000, IBGE_2018),
         IBGE_2019 = ifelse(is.na(IBGE_2019), 1.00000000, IBGE_2019),
         IBGE_2020 = ifelse(is.na(IBGE_2020), 1.00000000, IBGE_2020),
         IBGE_2021 = ifelse(is.na(IBGE_2021), 1.00000000, IBGE_2021),
         E.IBGE_2018 = Vivos * IBGE_2018,
         E.IBGE_2019 = Vivos * IBGE_2019,
         E.IBGE_2020 = Vivos * IBGE_2020,
         E.IBGE_2021 = Vivos * IBGE_2021,
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
  tabela_homens[h] = round(homens[i])
  h = h + 1
}

falecidos_homens = homens %>%
  select(Falecidos)

testes_homens = list(
  "IBGE 2018" = chisq.test(falecidos_homens, tabela_homens[[1]])[c("statistic", "p.value")],
  "IBGE 2019" =  chisq.test(falecidos_homens, tabela_homens[[2]])[c("statistic", "p.value")],
  "IBGE 2020" =  chisq.test(falecidos_homens, tabela_homens[[3]])[c("statistic", "p.value")],
  "IBGE 2021" = chisq.test(falecidos_homens, tabela_homens[[4]])[c("statistic", "p.value")],
  "AT2000 (Suavizada 10%)" = chisq.test(falecidos_homens, tabela_homens[[5]])[c("statistic", "p.value")],
  "AT-2000 MALE" = chisq.test(falecidos_homens, tabela_homens[[6]])[c("statistic", "p.value")],
  "AT-49 MALE" = chisq.test(falecidos_homens, tabela_homens[[7]])[c("statistic", "p.value")],
  "AT-83 MALE (Basic)" = chisq.test(falecidos_homens, tabela_homens[[8]])[c("statistic", "p.value")],
  "AT-83 MALE (IAM)" = chisq.test(falecidos_homens, tabela_homens[[9]])[c("statistic", "p.value")],
  "BR-EMSmt-v.2010-m" = chisq.test(falecidos_homens, tabela_homens[[10]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2010-m" = chisq.test(falecidos_homens, tabela_homens[[11]])[c("statistic", "p.value")],
  "BR-EMSmt-v.2015-m" = chisq.test(falecidos_homens, tabela_homens[[12]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2015-m" = chisq.test(falecidos_homens, tabela_homens[[13]])[c("statistic", "p.value")],
  "BR-EMSmt-v.2021-m" = chisq.test(falecidos_homens, tabela_homens[[14]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2021-m" = chisq.test(falecidos_homens, tabela_homens[[15]])[c("statistic", "p.value")],
  "CSO58 MALE" = chisq.test(falecidos_homens, tabela_homens[[16]])[c("statistic", "p.value")],
  "GAM-71 MALE" = chisq.test(falecidos_homens, tabela_homens[[17]])[c("statistic", "p.value")],
  "GAM-83 - MASC (suav 10%)" = chisq.test(falecidos_homens, tabela_homens[[18]])[c("statistic", "p.value")],
  "GAM83_BÁSICA - MASC" = chisq.test(falecidos_homens, tabela_homens[[19]])[c("statistic", "p.value")],
  "GAM-94MALE" = chisq.test(falecidos_homens, tabela_homens[[20]])[c("statistic", "p.value")])

#------------------------------------------------------------------------------#
#Testes para as mulheres

tabela_mulheres = numeric()
h = 1

for(i in grep("^E.", colnames(mulheres))) {
  tabela_mulheres[h] = round(mulheres[i])
  h = h + 1
}

falecidas_mulheres = mulheres %>%
  select(Falecidas)

testes_mulheres = list(
  "IBGE 2018" = chisq.test(falecidas_mulheres, tabela_mulheres[[1]])[c("statistic", "p.value")],
  "IBGE 2019" = chisq.test(falecidas_mulheres, tabela_mulheres[[2]])[c("statistic", "p.value")],
  "IBGE 2020" = chisq.test(falecidas_mulheres, tabela_mulheres[[3]])[c("statistic", "p.value")],
  "IBGE 2021" = chisq.test(falecidas_mulheres, tabela_mulheres[[4]])[c("statistic", "p.value")],
  "AT2000 (Suavizada 10%)" = chisq.test(falecidas_mulheres, tabela_mulheres[[5]])[c("statistic", "p.value")],
  "AT-2000 FEMALE" = chisq.test(falecidas_mulheres, tabela_mulheres[[6]])[c("statistic", "p.value")],
  "AT-49 FEMALE" = chisq.test(falecidas_mulheres, tabela_mulheres[[7]])[c("statistic", "p.value")],
  "AT-83 FEMALE (Basic)" = chisq.test(falecidas_mulheres, tabela_mulheres[[8]])[c("statistic", "p.value")],
  "AT-83 FEMALE (IAM)" = chisq.test(falecidas_mulheres, tabela_mulheres[[9]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2010-f" = chisq.test(falecidas_mulheres, tabela_mulheres[[10]])[c("statistic", "p.value")],
  "BR-EMSmt-v.2015-f" = chisq.test(falecidas_mulheres, tabela_mulheres[[11]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2015-f" = chisq.test(falecidas_mulheres, tabela_mulheres[[12]])[c("statistic", "p.value")],
  "BR-EMSmt-v.2021-f" = chisq.test(falecidas_mulheres, tabela_mulheres[[13]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2021-f" = chisq.test(falecidas_mulheres, tabela_mulheres[[14]])[c("statistic", "p.value")],
  "CSO58 FEMALE" = chisq.test(falecidas_mulheres, tabela_mulheres[[15]])[c("statistic", "p.value")],
  "GAM-71 FEMALE" = chisq.test(falecidas_mulheres, tabela_mulheres[[16]])[c("statistic", "p.value")],
  "GAM-83 - FEMALE (suav 10%)" = chisq.test(falecidas_mulheres, tabela_mulheres[[17]])[c("statistic", "p.value")],
  "GAM83_BÁSICA - FEMALE" = chisq.test(falecidas_mulheres, tabela_mulheres[[18]])[c("statistic", "p.value")],
  "GAM-94 FEMALE" = chisq.test(falecidas_mulheres, tabela_mulheres[[19]])[c("statistic", "p.value")])

#------------------------------------------------------------------------------#
#Testes para ambos os sexos

tabela_total = numeric()
h = 1

for(i in grep("^E.", colnames(tabuas_ambos))) {
  tabela_total[h] = round(tabuas_ambos[i])
  h = h + 1
}

falecidos = tabuas_ambos %>%
  select(Falecidos)

testes_ambos = list(
  "IBGE 2018" = chisq.test(falecidos, tabela_total[[1]])[c("statistic", "p.value")],
  "IBGE 2019" =  chisq.test(falecidos, tabela_total[[2]])[c("statistic", "p.value")],
  "IBGE 2020" =  chisq.test(falecidos, tabela_total[[3]])[c("statistic", "p.value")],
  "IBGE 2021" = chisq.test(falecidos, tabela_total[[4]])[c("statistic", "p.value")],
  "AT2000 (Suavizada 10%)" = chisq.test(falecidos, tabela_total[[5]])[c("statistic", "p.value")],
  "AT-2000 MALE" = chisq.test(falecidos, tabela_total[[6]])[c("statistic", "p.value")],
  "AT-49 MALE" = chisq.test(falecidos, tabela_total[[7]])[c("statistic", "p.value")],
  "AT-83 MALE (Basic)" = chisq.test(falecidos, tabela_total[[8]])[c("statistic", "p.value")],
  "AT-83 MALE (IAM)" = chisq.test(falecidos, tabela_total[[9]])[c("statistic", "p.value")],
  "BR-EMSmt-v.2010-m" = chisq.test(falecidos, tabela_total[[10]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2010-m" = chisq.test(falecidos, tabela_total[[11]])[c("statistic", "p.value")],
  "BR-EMSmt-v.2015-m" = chisq.test(falecidos, tabela_total[[12]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2015-m" = chisq.test(falecidos, tabela_total[[13]])[c("statistic", "p.value")],
  "BR-EMSmt-v.2021-m" = chisq.test(falecidos, tabela_total[[14]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2021-m" = chisq.test(falecidos, tabela_total[[15]])[c("statistic", "p.value")],
  "CSO58 MALE" = chisq.test(falecidos, tabela_total[[16]])[c("statistic", "p.value")],
  "GAM-71 MALE" = chisq.test(falecidos, tabela_total[[17]])[c("statistic", "p.value")],
  "GAM-83 - MASC (suav 10%)" = chisq.test(falecidos, tabela_total[[18]])[c("statistic", "p.value")],
  "GAM83_BÁSICA - MASC" = chisq.test(falecidos, tabela_total[[19]])[c("statistic", "p.value")],
  "GAM-94MALE" = chisq.test(falecidos, tabela_total[[20]])[c("statistic", "p.value")],
  "AT2000 (Suavizada 10%)" = chisq.test(falecidos, tabela_total[[21]])[c("statistic", "p.value")],
  "AT-2000 FEMALE" = chisq.test(falecidos, tabela_total[[22]])[c("statistic", "p.value")],
  "AT-49 FEMALE" = chisq.test(falecidos, tabela_total[[23]])[c("statistic", "p.value")],
  "AT-83 FEMALE (Basic)" = chisq.test(falecidos, tabela_total[[24]])[c("statistic", "p.value")],
  "AT-83 FEMALE (IAM)" = chisq.test(falecidos, tabela_total[[25]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2010-f" = chisq.test(falecidos, tabela_total[[26]])[c("statistic", "p.value")],
  "BR-EMSmt-v.2015-f" = chisq.test(falecidos, tabela_total[[27]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2015-f" = chisq.test(falecidos, tabela_total[[28]])[c("statistic", "p.value")],
  "BR-EMSmt-v.2021-f" = chisq.test(falecidos, tabela_total[[29]])[c("statistic", "p.value")],
  "BR-EMSsb-v.2021-f" = chisq.test(falecidos, tabela_total[[30]])[c("statistic", "p.value")],
  "CSO58 FEMALE" = chisq.test(falecidos, tabela_total[[31]])[c("statistic", "p.value")],
  "GAM-71 FEMALE" = chisq.test(falecidos, tabela_total[[32]])[c("statistic", "p.value")],
  "GAM-83 - FEMALE (suav 10%)" = chisq.test(falecidos, tabela_total[[33]])[c("statistic", "p.value")],
  "GAM83_BÁSICA - FEMALE" = chisq.test(falecidos, tabela_total[[34]])[c("statistic", "p.value")],
  "GAM-94 FEMALE" = chisq.test(falecidos, tabela_total[[35]])[c("statistic", "p.value")])



#------------------------------------------------------------------------------
tabela_testes_masculinos = ldply(testes_homens, data.frame)#
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


openxlsx::saveWorkbook(wb, "Testes de Aderencia_quiquadrado.xlsx", overwrite = TRUE)

