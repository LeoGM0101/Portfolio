rm(list=ls(all=TRUE))
library(readxl)
library(tidyverse)
library(openxlsx)

setwd("Z:/GERENCIA/RELATÓRIO DE HIPÓTESES/2022/MORTALIDADE/01. TESTE DE ADERÊNCIA")
expostos_obitos_masculino = read_excel("expostos e obitos.xlsx", sheet = "Masculino - Soma")
expostos_obitos_feminino = read_excel("expostos e obitos.xlsx", sheet = "Feminino - Soma")

#------------------------------------------------------------------------------#
#Tabua 2018
tabua_homens_2018 = read_excel("Homens.xlsx", sheet = "2018")
tabua_homens_2018$`Idades Exatas (X)` = as.numeric(tabua_homens_2018$`Idades Exatas (X)`)
tabua_mulheres_2018 = read_excel("Mulheres.xlsx", sheet = "2018")
tabua_mulheres_2018$`Idades Exatas (X)` = as.numeric(tabua_mulheres_2018$`Idades Exatas (X)`)

homens_2018 = expostos_obitos_masculino %>%
  full_join(tabua_homens_2018, by = c("IDADE" = "Idades Exatas (X)")) %>%
  arrange(IDADE) %>%
  select(IDADE, Vivos, Falecidos, qx) %>%
  mutate(Vivos = ifelse(is.na(Vivos), 0, Vivos), 
         Falecidos = ifelse(is.na(Falecidos), 0, Falecidos), 
         qx = ifelse(is.na(qx), 1.00000000, qx), 
         E = Vivos * qx)

mulheres_2018 = expostos_obitos_feminino %>%
  full_join(tabua_mulheres_2018, by = c("IDADE" = "Idades Exatas (X)")) %>%
  arrange(IDADE) %>%
  select(IDADE, Vivas, Falecidas, qx) %>%
  mutate(Vivas = ifelse(is.na(Vivas), 0, Vivas), 
         Falecidas = ifelse(is.na(Falecidas), 0, Falecidas), 
         qx = ifelse(is.na(qx), 1.00000000, qx), 
         E = Vivas * qx)

#Teste Qui-Quadrado e Teste KS - Masculino

aderencia_2018_masculino = homens_2018 %>%
  filter(Vivos != 0, E != 0)

chisq.test(aderencia_2018_masculino$Falecidos, aderencia_2018_masculino$E)
ks.test(aderencia_2018_masculino$Falecidos, aderencia_2018_masculino$E)

#Teste Qui-Quadrado e Teste KS - Feminino

aderencia_2018_feminino = mulheres_2018 %>%
  filter(Vivas != 0, E != 0)

chisq.test(aderencia_2018_feminino$Falecidas, aderencia_2018_feminino$E)
ks.test(aderencia_2018_feminino$Falecidas, aderencia_2018_feminino$E)


#------------------------------------------------------------------------------#
#Tabua 2019
tabua_homens_2019 = read_excel("Homens.xlsx", sheet = "2019")
tabua_homens_2019$`Idades Exatas (X)` = as.numeric(tabua_homens_2019$`Idades Exatas (X)`)
tabua_mulheres_2019 = read_excel("Mulheres.xlsx", sheet = "2019")
tabua_mulheres_2019$`Idades Exatas (X)` = as.numeric(tabua_mulheres_2019$`Idades Exatas (X)`)

homens_2019 = expostos_obitos_masculino %>%
  full_join(tabua_homens_2019, by = c("IDADE" = "Idades Exatas (X)")) %>%
  arrange(IDADE) %>%
  select(IDADE, Vivos, Falecidos, qx) %>%
  mutate(Vivos = ifelse(is.na(Vivos), 0, Vivos), 
         Falecidos = ifelse(is.na(Falecidos), 0, Falecidos), 
         qx = ifelse(is.na(qx), 1.00000000, qx), 
         E = Vivos * qx)

mulheres_2019 = expostos_obitos_feminino %>%
  full_join(tabua_mulheres_2019, by = c("IDADE" = "Idades Exatas (X)")) %>%
  arrange(IDADE) %>%
  select(IDADE, Vivas, Falecidas, qx) %>%
  mutate(Vivas = ifelse(is.na(Vivas), 0, Vivas), 
         Falecidas = ifelse(is.na(Falecidas), 0, Falecidas), 
         qx = ifelse(is.na(qx), 1.00000000, qx), 
         E = Vivas * qx)

#Teste Qui-Quadrado e Teste KS - Masculino

aderencia_2019_masculino = homens_2019 %>%
  filter(Vivos != 0, E != 0)

chisq.test(aderencia_2019_masculino$Falecidos, aderencia_2019_masculino$E)
ks.test(aderencia_2019_masculino$Falecidos, aderencia_2019_masculino$E)

#Teste Qui-Quadrado e Teste KS - Feminino

aderencia_2019_feminino = mulheres_2019 %>%
  filter(Vivas != 0, E != 0)

chisq.test(aderencia_2019_feminino$Falecidas, aderencia_2019_feminino$E)
ks.test(aderencia_2019_feminino$Falecidas, aderencia_2019_feminino$E)


#------------------------------------------------------------------------------#
#Tabua 2020
tabua_homens_2020 = read_excel("Homens.xlsx", sheet = "2020")
tabua_homens_2020$`Idades Exatas (X)` = as.numeric(tabua_homens_2020$`Idades Exatas (X)`)
tabua_mulheres_2020 = read_excel("Mulheres.xlsx", sheet = "2020")
tabua_mulheres_2020$`Idades Exatas (X)` = as.numeric(tabua_mulheres_2020$`Idades Exatas (X)`)

homens_2020 = expostos_obitos_masculino %>%
  full_join(tabua_homens_2020, by = c("IDADE" = "Idades Exatas (X)")) %>%
  arrange(IDADE) %>%
  select(IDADE, Vivos, Falecidos, qx) %>%
  mutate(Vivos = ifelse(is.na(Vivos), 0, Vivos), 
         Falecidos = ifelse(is.na(Falecidos), 0, Falecidos), 
         qx = ifelse(is.na(qx), 1.00000000, qx), 
         E = Vivos * qx)

mulheres_2020 = expostos_obitos_feminino %>%
  full_join(tabua_mulheres_2020, by = c("IDADE" = "Idades Exatas (X)")) %>%
  arrange(IDADE) %>%
  select(IDADE, Vivas, Falecidas, qx) %>%
  mutate(Vivas = ifelse(is.na(Vivas), 0, Vivas), 
         Falecidas = ifelse(is.na(Falecidas), 0, Falecidas), 
         qx = ifelse(is.na(qx), 1.00000000, qx), 
         E = Vivas * qx)

#Teste Qui-Quadrado e Teste KS - Masculino

aderencia_2020_masculino = homens_2020 %>%
  filter(Vivos != 0, E != 0)

chisq.test(aderencia_2020_masculino$Falecidos, aderencia_2020_masculino$E)
ks.test(aderencia_2020_masculino$Falecidos, aderencia_2020_masculino$E)

#Teste Qui-Quadrado e Teste KS - Feminino

aderencia_2020_feminino = mulheres_2020 %>%
  filter(Vivas != 0, E != 0)

chisq.test(aderencia_2020_feminino$Falecidas, aderencia_2020_feminino$E)
ks.test(aderencia_2020_feminino$Falecidas, aderencia_2020_feminino$E)

#------------------------------------------------------------------------------#