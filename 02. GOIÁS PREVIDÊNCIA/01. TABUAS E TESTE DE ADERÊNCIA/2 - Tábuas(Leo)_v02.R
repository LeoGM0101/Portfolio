#OBS.: antes de rodar este codigo, certifique-se que o codigo '1 - expostos-obitos-v02' foi rodado anteriormente.
rm(list=ls(all=TRUE))
library(readxl)
library(plyr)
library(tidyverse)
library(openxlsx)
library(purrr)
library(xlsx)

setwd("Z:/GERENCIA/RELATÓRIO DE HIPÓTESES/2022/MORTALIDADE/01. TABUAS E TESTE DE ADERÊNCIA")
expostos_obitos_masculino = read_excel("expostos e obitos.xlsx", sheet = "Masculino - Soma")
expostos_obitos_feminino = read_excel("expostos e obitos.xlsx", sheet = "Feminino - Soma")

#------------------------------------------------------------------------------#
#IBGE 2018
IBGE_homens_2018 = read_excel("Homens.xlsx", sheet = "2018") %>%
  select(`Idades Exatas (X)`, qx)
IBGE_homens_2018$`Idades Exatas (X)` = as.numeric(IBGE_homens_2018$`Idades Exatas (X)`)
IBGE_mulheres_2018 = read_excel("Mulheres.xlsx", sheet = "2018") %>%
  select(`Idades Exatas (X)`, qx)
IBGE_mulheres_2018$`Idades Exatas (X)` = as.numeric(IBGE_mulheres_2018$`Idades Exatas (X)`)

#IBGE 2019
IBGE_homens_2019 = read_excel("Homens.xlsx", sheet = "2019") %>%
  select(`Idades Exatas (X)`, qx)
IBGE_homens_2019$`Idades Exatas (X)` = as.numeric(IBGE_homens_2019$`Idades Exatas (X)`)
IBGE_mulheres_2019 = read_excel("Mulheres.xlsx", sheet = "2019") %>%
  select(`Idades Exatas (X)`, qx)
IBGE_mulheres_2019$`Idades Exatas (X)` = as.numeric(IBGE_mulheres_2019$`Idades Exatas (X)`)

#IBGE 2020
IBGE_homens_2020 = read_excel("Homens.xlsx", sheet = "2020") %>%
  select(`Idades Exatas (X)`, qx)
IBGE_homens_2020$`Idades Exatas (X)` = as.numeric(IBGE_homens_2020$`Idades Exatas (X)`)
IBGE_mulheres_2020 = read_excel("Mulheres.xlsx", sheet = "2020") %>%
  select(`Idades Exatas (X)`, qx)
IBGE_mulheres_2020$`Idades Exatas (X)` = as.numeric(IBGE_mulheres_2020$`Idades Exatas (X)`)

#IBGE 2021
IBGE_homens_2021 = read_excel("Homens.xlsx", sheet = "2021") %>%
  select(`Idades Exatas (X)`, qx)
IBGE_homens_2021$`Idades Exatas (X)` = as.numeric(IBGE_homens_2021$`Idades Exatas (X)`)
IBGE_mulheres_2021 = read_excel("Mulheres.xlsx", sheet = "2021") %>%
  select(`Idades Exatas (X)`, qx)
IBGE_mulheres_2021$`Idades Exatas (X)` = as.numeric(IBGE_mulheres_2021$`Idades Exatas (X)`)

#Outras tabuas
tabuas = read_excel("Banco de Tábuas Biométricas_julho 2021_v02.xlsm", sheet = "TÁBUAS (1)")

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

homens = purrr::reduce(tabuas_total_masculino, dplyr::full_join, by = c("IDADE" = "Idades Exatas (X)")) %>%
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

mulheres = purrr::reduce(tabuas_total_feminino, dplyr::full_join, by = c("IDADE" = "Idades Exatas (X)")) %>%
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
  
#------------------------------------------------------------------------------#
#Teste KS bilateral - avalia a concordancia entre a distribuicao observada da amostra
# e uma determinada distribuicao teorica.
# H0: A distribucao observada adere a distribuicao esperada, ou seja, F(x) = F*(x)
# H1: F(x) != F*(x)

#------------------------------------------------------------------------------#
#Testes para os homens

#Teste para a tábua IBGE 2018
tabela_homens_ibge2018 = homens %>%
  filter(IDADE >= 18, E.IBGE_2018 > 0) %>%
  select(Falecidos, E.IBGE_2018)

#Teste para a tábua IBGE 2019
tabela_homens_ibge2019 = homens %>%
  filter(IDADE >= 18, E.IBGE_2019 > 0) %>%
  select(Falecidos, E.IBGE_2019)

#Teste para a tábua IBGE 2020
tabela_homens_ibge2020 = homens %>%
  filter(IDADE >= 18, E.IBGE_2020 > 0) %>%
  select(Falecidos, E.IBGE_2020)

#Teste para a tábua IBGE 2021
tabela_homens_ibge2021 = homens %>%
  filter(IDADE >= 18, E.IBGE_2021 > 0) %>%
  select(Falecidos, E.IBGE_2021)

#Teste para a tábua AT2000 (Suavizada 10%)
tabela_homens_AT2000S = homens %>%
  filter(IDADE >= 18, `E.AT2000 (Suavizada 10%)_MAS` > 0) %>%
  select(Falecidos, `E.AT2000 (Suavizada 10%)_MAS`)

#Teste para a tábua AT-2000 MALE
tabela_homens_AT2000M = homens %>%
  filter(IDADE >= 18, `E.AT-2000 MALE` > 0) %>%
  select(Falecidos, `E.AT-2000 MALE`)

#Teste para a tábua AT-49 MALE
tabela_homens_AT49MALE = homens %>%
  filter(IDADE >= 18, `E.AT-49 MALE` > 0) %>%
  select(Falecidos, `E.AT-49 MALE`)

#Teste para a tábua AT-83 MALE (Basic)
tabela_homens_AT83MALE = homens %>%
  filter(IDADE >= 18, `E.AT-83 MALE (Basic)` > 0) %>%
  select(Falecidos, `E.AT-83 MALE (Basic)`)

#Teste para a tábua AT-83 MALE (IAM)
tabela_homens_AT83MALEIAM = homens %>%
  filter(IDADE >= 18, `E.AT-83 MALE (IAM)` > 0) %>%
  select(Falecidos, `E.AT-83 MALE (IAM)`)

#Teste para a tábua BR-EMSmt-v.2010-m
tabela_homens_EMSmt2010m = homens %>%
  filter(IDADE >= 18, `E.BR-EMSmt-v.2010-m` > 0) %>%
  select(Falecidos, `E.BR-EMSmt-v.2010-m`)

#Teste para a tábua BR-EMSsb-v.2010-m
tabela_homens_EMSsb2010m = homens %>%
  filter(IDADE >= 18, `E.BR-EMSsb-v.2010-m` > 0) %>%
  select(Falecidos, `E.BR-EMSsb-v.2010-m`)

#Teste para a tábua BR-EMSmt-v.2015-m
tabela_homens_EMSmt2015m = homens %>%
  filter(IDADE >= 18, `E.BR-EMSmt-v.2015-m` > 0) %>%
  select(Falecidos, `E.BR-EMSmt-v.2015-m`)

#Teste para a tábua BR-EMSsb-v.2015-m
tabela_homens_EMSsb2015m = homens %>%
  filter(IDADE >= 18, `E.BR-EMSsb-v.2015-m` > 0) %>%
  select(Falecidos, `E.BR-EMSsb-v.2015-m`)

#Teste para a tábua BR-EMSmt-v.2021-m
tabela_homens_EMSmt2021m = homens %>%
  filter(IDADE >= 18, `E.BR-EMSmt-v.2021-m` > 0) %>%
  select(Falecidos, `E.BR-EMSmt-v.2021-m`)

#Teste para a tábua BR-EMSsb-v.2021-m
tabela_homens_EMSsb2021m = homens %>%
  filter(IDADE >= 18, `E.BR-EMSsb-v.2021-m` > 0) %>%
  select(Falecidos, `E.BR-EMSsb-v.2021-m`)

#Teste para a tábua CSO58 MALE
tabela_homens_CSO58 = homens %>%
  filter(IDADE >= 18, `E.CSO58 MALE` > 0) %>%
  select(Falecidos, `E.CSO58 MALE`)

#Teste para a tábua GAM-71 MALE
tabela_homens_GAM71  = homens %>%
  filter(IDADE >= 18, `E.GAM-71 MALE` > 0) %>%
  select(Falecidos, `E.GAM-71 MALE`)

#Teste para a tábua GAM83_BÁSICA - MASC
tabela_homens_GAM83 = homens %>%
  filter(IDADE >= 18, `E.GAM83_BÁSICA - MASC` > 0) %>%
  select(Falecidos, `E.GAM83_BÁSICA - MASC`)

#Teste para a tábua GAM-83 - MASC (suav 10%)
tabela_homens_GAM83suav = homens %>%
  filter(IDADE >= 18, `E.GAM-83 - MASC (suav 10%)` > 0) %>%
  select(Falecidos, `E.GAM-83 - MASC (suav 10%)`)

#Teste para a tábua GAM-94MALE
tabela_homens_GAM94 = homens %>%
  filter(IDADE >= 18, `E.GAM-94MALE` > 0) %>%
  select(Falecidos, `E.GAM-94MALE`)

testes_homens = list(
  "IBGE 2018" = ks.test(tabela_homens_ibge2018$Falecidos, tabela_homens_ibge2018$E.IBGE_2018)[c("statistic", "p.value")],
  "IBGE 2019" = ks.test(tabela_homens_ibge2019$Falecidos, tabela_homens_ibge2019$E.IBGE_2019)[c("statistic", "p.value")],
  "IBGE 2020" = ks.test(tabela_homens_ibge2020$Falecidos, tabela_homens_ibge2020$E.IBGE_2020)[c("statistic", "p.value")],
  "IBGE 2021" = ks.test(tabela_homens_ibge2021$Falecidos, tabela_homens_ibge2021$E.IBGE_2021)[c("statistic", "p.value")],
  "AT2000 (Suavizada 10%)" = ks.test(tabela_homens_AT2000S$Falecidos, tabela_homens_AT2000S$`E.AT2000 (Suavizada 10%)_MAS`)[c("statistic", "p.value")],
  "AT-2000 MALE" = ks.test(tabela_homens_AT2000M$Falecidos, tabela_homens_AT2000M$`E.AT-2000 MALE`)[c("statistic", "p.value")],
  "AT-49 MALE" = ks.test(tabela_homens_AT49MALE$Falecidos, tabela_homens_AT49MALE$`E.AT-49 MALE`)[c("statistic", "p.value")],
  "AT-83 MALE (Basic)" = ks.test(tabela_homens_AT83MALE$Falecidos, tabela_homens_AT83MALE$`E.AT-83 MALE (Basic)`)[c("statistic", "p.value")],
  "AT-83 MALE (IAM)" = ks.test(tabela_homens_AT83MALEIAM$Falecidos, tabela_homens_AT83MALEIAM$`E.AT-83 MALE (IAM)`)[c("statistic", "p.value")],
  "BR-EMSmt-v.2010-m" = ks.test(tabela_homens_EMSmt2010m$Falecidos, tabela_homens_EMSmt2010m$`E.BR-EMSmt-v.2010-m`)[c("statistic", "p.value")],
  "BR-EMSsb-v.2010-m" = ks.test(tabela_homens_EMSsb2010m$Falecidos, tabela_homens_EMSsb2010m$`E.BR-EMSsb-v.2010-m`)[c("statistic", "p.value")],
  "BR-EMSmt-v.2015-m" = ks.test(tabela_homens_EMSmt2015m$Falecidos, tabela_homens_EMSmt2015m$`E.BR-EMSmt-v.2015-m`)[c("statistic", "p.value")],
  "BR-EMSsb-v.2015-m" = ks.test(tabela_homens_EMSsb2015m$Falecidos, tabela_homens_EMSsb2015m$`E.BR-EMSsb-v.2015-m`)[c("statistic", "p.value")],
  "BR-EMSmt-v.2021-m" = ks.test(tabela_homens_EMSmt2021m$Falecidos, tabela_homens_EMSmt2021m$`E.BR-EMSmt-v.2021-m`)[c("statistic", "p.value")],
  "BR-EMSsb-v.2021-m" = ks.test(tabela_homens_EMSsb2021m$Falecidos, tabela_homens_EMSsb2021m$`E.BR-EMSsb-v.2021-m`)[c("statistic", "p.value")],
  "CSO58 MALE" = ks.test(tabela_homens_CSO58$Falecidos, tabela_homens_CSO58$`E.CSO58 MALE`)[c("statistic", "p.value")],
  "GAM-71 MALE" = ks.test(tabela_homens_GAM71$Falecidos, tabela_homens_GAM71$`E.GAM-71 MALE`)[c("statistic", "p.value")],
  "GAM-83 - MASC (suav 10%)" = ks.test(tabela_homens_GAM83suav$Falecidos, tabela_homens_GAM83suav$`E.GAM-83 - MASC (suav 10%)`)[c("statistic", "p.value")],
  "GAM83_BÁSICA - MASC" = ks.test(tabela_homens_GAM83$Falecidos, tabela_homens_GAM83$`E.GAM83_BÁSICA - MASC`)[c("statistic", "p.value")],
  "GAM-94MALE" = ks.test(tabela_homens_GAM94$Falecidos, tabela_homens_GAM94$`E.GAM-94MALE`)[c("statistic", "p.value")])


#------------------------------------------------------------------------------#
#testes para as mulheres

#Teste para a tábua IBGE 2018
tabela_mulheres_ibge2018 = mulheres %>%
  filter(IDADE >= 18, E.IBGE_2018 > 0) %>%
  select(Falecidas, E.IBGE_2018)

#Teste para a tábua IBGE 2019
tabela_mulheres_ibge2019 = mulheres %>%
  filter(IDADE >= 18, E.IBGE_2019 > 0) %>%
  select(Falecidas, E.IBGE_2019)

#Teste para a tábua IBGE 2020
tabela_mulheres_ibge2020 = mulheres %>%
  filter(IDADE >= 18, E.IBGE_2020 > 0) %>%
  select(Falecidas, E.IBGE_2020)

#Teste para a tábua IBGE 2021
tabela_mulheres_ibge2021 = mulheres %>%
  filter(IDADE >= 18, E.IBGE_2021 > 0) %>%
  select(Falecidas, E.IBGE_2021)

#Teste para a tábua AT2000 (Suavizada 10%)
tabela_mulheres_AT2000S = mulheres %>%
  filter(IDADE >= 18, `E.AT2000 (Suavizada 10%)_FEM` > 0) %>%
  select(Falecidas, `E.AT2000 (Suavizada 10%)_FEM`)

#Teste para a tábua AT-2000 FEMALE
tabela_mulheres_AT2000 = mulheres %>%
  filter(IDADE >= 18, `E.AT-2000 FEMALE` > 0) %>%
  select(Falecidas, `E.AT-2000 FEMALE`)

#Teste para a tábua AT-49 FEMALE
tabela_mulheres_AT49 = mulheres %>%
  filter(IDADE >= 18, `E.AT-49 FEMALE` > 0) %>%
  select(Falecidas, `E.AT-49 FEMALE`)

#Teste para a tábua AT-83 FEMALE (Basic)
tabela_mulheres_AT83 = mulheres %>%
  filter(IDADE >= 18, `E.AT-83 FEMALE (Basic)` > 0) %>%
  select(Falecidas, `E.AT-83 FEMALE (Basic)`)

#Teste para a tábua AT-83 FEMALE (IAM)
tabela_mulheres_AT83IAM = mulheres %>%
  filter(IDADE >= 18, `E.AT-83 FEMALE (IAM)` > 0) %>%
  select(Falecidas, `E.AT-83 FEMALE (IAM)`)

#Teste para a tábua BR-EMSsb-v.2010-f
tabela_mulheres_EMSsb2010 = mulheres %>%
  filter(IDADE >= 18, `E.BR-EMSsb-v.2010-f` > 0) %>%
  select(Falecidas, `E.BR-EMSsb-v.2010-f`)

#Teste para a tábua BR-EMSmt-v.2015-f
tabela_mulheres_EMSmt2015 = mulheres %>%
  filter(IDADE >= 18, `E.BR-EMSmt-v.2015-f` > 0) %>%
  select(Falecidas, `E.BR-EMSmt-v.2015-f`)

#Teste para a tábua BR-EMSsb-v.2015-f
tabela_mulheres_EMSsb2015 = mulheres %>%
  filter(IDADE >= 18, `E.BR-EMSsb-v.2015-f` > 0) %>%
  select(Falecidas, `E.BR-EMSsb-v.2015-f`)

#Teste para a tábua BR-EMSmt-v.2021-f
tabela_mulheres_EMSmt2021 = mulheres %>%
  filter(IDADE >= 18, `E.BR-EMSmt-v.2021-f` > 0) %>%
  select(Falecidas, `E.BR-EMSmt-v.2021-f`)

#Teste para a tábua BR-EMSsb-v.2021-f
tabela_mulheres_EMSsb2021 = mulheres %>%
  filter(IDADE >= 18, `E.BR-EMSsb-v.2021-f` > 0) %>%
  select(Falecidas, `E.BR-EMSsb-v.2021-f`)

#Teste para a tábua CSO58 FEMALE
tabela_mulheres_CSO58 = mulheres %>%
  filter(IDADE >= 18, `E.CSO58 FEMALE` > 0) %>%
  select(Falecidas, `E.CSO58 FEMALE`)

#Teste para a tábua GAM-71 FEMALE
tabela_mulheres_GAM71  = mulheres %>%
  filter(IDADE >= 18, `E.GAM-71 FEMALE` > 0) %>%
  select(Falecidas, `E.GAM-71 FEMALE`)

#Teste para a tábua GAM83_BÁSICA - FEMALE
tabela_mulheres_GAM83 = mulheres %>%
  filter(IDADE >= 18, `E.GAM83_BÁSICA - FEMALE` > 0) %>%
  select(Falecidas, `E.GAM83_BÁSICA - FEMALE`)

#Teste para a tábua GAM-83 - FEMALE (suav 10%)
tabela_mulheres_GAM83suav = mulheres %>%
  filter(IDADE >= 18, `E.GAM-83 - FEMALE (suav 10%)` > 0) %>%
  select(Falecidas, `E.GAM-83 - FEMALE (suav 10%)`)

#Teste para a tábua GAM-94 FEMALE
tabela_mulheres_GAM94 = mulheres %>%
  filter(IDADE >= 18, `E.GAM-94 FEMALE` > 0) %>%
  select(Falecidas, `E.GAM-94 FEMALE`)


testes_mulheres = list(
  "IBGE 2018" = ks.test(tabela_mulheres_ibge2018$Falecidas, tabela_mulheres_ibge2018$E.IBGE_2018)[c("statistic", "p.value")],
  "IBGE 2019" = ks.test(tabela_mulheres_ibge2019$Falecidas, tabela_mulheres_ibge2019$E.IBGE_2019)[c("statistic", "p.value")],
  "IBGE 2020" = ks.test(tabela_mulheres_ibge2020$Falecidas, tabela_mulheres_ibge2020$E.IBGE_2020)[c("statistic", "p.value")],
  "IBGE 2021" = ks.test(tabela_mulheres_ibge2021$Falecidas, tabela_mulheres_ibge2021$E.IBGE_2021)[c("statistic", "p.value")],
  "AT2000 (Suavizada 10%)" = ks.test(tabela_mulheres_AT2000S$Falecidas, tabela_mulheres_AT2000S$`E.AT2000 (Suavizada 10%)_FEM`)[c("statistic", "p.value")],
  "AT-2000 FEMALE" = ks.test(tabela_mulheres_AT2000$Falecidas, tabela_mulheres_AT2000$`E.AT-2000 FEMALE`)[c("statistic", "p.value")],
  "AT-49 FEMALE" = ks.test(tabela_mulheres_AT49$Falecidas, tabela_mulheres_AT49$`E.AT-49 FEMALE`)[c("statistic", "p.value")],
  "AT-83 FEMALE (Basic)" = ks.test(tabela_mulheres_AT83$Falecidas, tabela_mulheres_AT83$`E.AT-83 FEMALE (Basic)`)[c("statistic", "p.value")],
  "AT-83 FEMALE (IAM)" = ks.test(tabela_mulheres_AT83IAM$Falecidas, tabela_mulheres_AT83IAM$`E.AT-83 FEMALE (IAM)`)[c("statistic", "p.value")],
  "BR-EMSsb-v.2010-f" = ks.test(tabela_mulheres_EMSsb2010$Falecidas, tabela_mulheres_EMSsb2010$`E.BR-EMSsb-v.2010-f`)[c("statistic", "p.value")],
  "BR-EMSmt-v.2015-f" = ks.test(tabela_mulheres_EMSmt2015$Falecidas, tabela_mulheres_EMSmt2015$`E.BR-EMSmt-v.2015-f`)[c("statistic", "p.value")],
  "BR-EMSsb-v.2015-f" = ks.test(tabela_mulheres_EMSsb2015$Falecidas, tabela_mulheres_EMSsb2015$`E.BR-EMSsb-v.2015-f`)[c("statistic", "p.value")],
  "BR-EMSmt-v.2021-f" = ks.test(tabela_mulheres_EMSmt2021$Falecidas, tabela_mulheres_EMSmt2021$`E.BR-EMSmt-v.2021-f`)[c("statistic", "p.value")],
  "BR-EMSsb-v.2021-f" = ks.test(tabela_mulheres_EMSsb2021$Falecidas, tabela_mulheres_EMSsb2021$`E.BR-EMSsb-v.2021-f`)[c("statistic", "p.value")],
  "CSO58 FEMALE" = ks.test(tabela_mulheres_CSO58$Falecidas, tabela_mulheres_CSO58$`E.CSO58 FEMALE`)[c("statistic", "p.value")],
  "GAM-71 FEMALE" = ks.test(tabela_mulheres_GAM71$Falecidas, tabela_mulheres_GAM71$`E.GAM-71 FEMALE`)[c("statistic", "p.value")],
  "GAM-83 - FEMALE (suav 10%)" = ks.test(tabela_mulheres_GAM83suav$Falecidas, tabela_mulheres_GAM83suav$`E.GAM-83 - FEMALE (suav 10%)`)[c("statistic", "p.value")],
  "GAM83_BÁSICA - FEMALE" = ks.test(tabela_mulheres_GAM83$Falecidas, tabela_mulheres_GAM83$`E.GAM83_BÁSICA - FEMALE`)[c("statistic", "p.value")],
  "GAM-94 FEMALE" = ks.test(tabela_mulheres_GAM94$Falecidas, tabela_mulheres_GAM94$`E.GAM-94 FEMALE`)[c("statistic", "p.value")])


#------------------------------------------------------------------------------#
tabela_testes_masculinos = ldply(testes_homens, data.frame)
tabela_testes_femininos = ldply(testes_mulheres, data.frame)

wb = openxlsx::createWorkbook()
openxlsx::addWorksheet(wb, sheetName = "Homens")
openxlsx::addWorksheet(wb, sheetName = "Mulheres")
openxlsx::addWorksheet(wb, sheetName = "Testes masculinos")
openxlsx::addWorksheet(wb, sheetName = "Testes femininos")

openxlsx::writeData(wb, "Homens", homens )
openxlsx::writeData(wb, "Mulheres", mulheres )
openxlsx::writeData(wb, "Testes masculinos", tabela_testes_masculinos )
openxlsx::writeData(wb, "Testes femininos", tabela_testes_femininos )

openxlsx::saveWorkbook(wb, "Testes de Aderencia.xlsx", overwrite = TRUE)
