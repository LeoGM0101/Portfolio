#Obs: Nao ha distincao entre civis e militares neste codigo.

rm(list=ls(all=TRUE))
library(purrr)
library(readxl)
library(tidyverse)
library(openxlsx)

setwd("Z:/GERENCIA/RELATÓRIO DE HIPÓTESES/2023/MORTALIDADE/01. TABUAS E TESTE DE ADERÊNCIA")
base2018_ativos = read_excel("base2018.xlsx", sheet = "Ativo")
base2018_inativos = read_excel("base2018.xlsx", sheet = "Inativo")
base2019 = read_excel("base2019.xlsx")
base2020 = read_excel("base2020.xlsx")
base2021 = read_excel("base2021.xlsx")
base2022_ativos = read_excel("base2022.xlsx", sheet = "Ativo")
base2022_inativos = read_excel("base2022.xlsx", sheet = "Inativo")
base2023_ativos = read_excel("base2023.xlsx", sheet = "Ativo")
base2023_inativos = read_excel("base2023.xlsx", sheet = "Inativo")
obitos2018 = read_excel("obitos_10_2023.xlsx") %>% filter(ANO_OBITO == "2018")
obitos2019 = read_excel("obitos_10_2023.xlsx") %>% filter(ANO_OBITO == "2019")
obitos2020 = read_excel("obitos_10_2023.xlsx") %>% filter(ANO_OBITO == "2020")
obitos2021 = read_excel("obitos_10_2023.xlsx") %>% filter(ANO_OBITO == "2021")
obitos2022 = read_excel("obitos_10_2023.xlsx") %>% filter(ANO_OBITO == "2022")
obitos2023 = read_excel("obitos_10_2023.xlsx") %>% filter(ANO_OBITO == "2023")
#------------------------------------------------------------------------------#
#Expostos e obitos no ano de 2018

tabela_2018_ativos_masculino = base2018_ativos %>%
  filter(sexo == "M") %>%
  group_by(idade) %>%
  distinct(cpf) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)

tabela_2018_inativos_masculino = base2018_inativos %>%
  replace(is.null(.), 0) %>%
  filter(TipoAposentadoria != "Invalidez", TipoAposentadoria != 0, sexo == "M") %>%
  group_by(idade) %>%
  distinct(cpf) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)


tabela_2018_masculino_expostos = tabela_2018_ativos_masculino %>%
  full_join(tabela_2018_inativos_masculino, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  mutate(QUANTIDADE = QUANTIDADE.x + QUANTIDADE.y) %>%
  select(IDADE, QUANTIDADE)

tabela_2018_masculino_obitos = obitos2018 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2018_masculino = tabela_2018_masculino_expostos %>%
  full_join(tabela_2018_masculino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  dplyr::rename(Vivos = QUANTIDADE.x, Falecidos = QUANTIDADE.y) %>%
  mutate(Total = Vivos + Falecidos)


tabela_2018_ativos_feminino = base2018_ativos %>%
  filter(sexo == "F") %>%
  group_by(idade) %>%
  distinct(cpf) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)

tabela_2018_inativos_feminino = base2018_inativos %>%
  replace(is.null(.), 0) %>%
  filter(TipoAposentadoria != "Invalidez", TipoAposentadoria != 0, sexo == "F") %>%
  group_by(idade) %>%
  distinct(cpf) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)

tabela_2018_feminino_expostos = tabela_2018_ativos_feminino %>%
  full_join(tabela_2018_inativos_feminino, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  mutate(QUANTIDADE = QUANTIDADE.x + QUANTIDADE.y) %>%
  select(IDADE, QUANTIDADE)

tabela_2018_feminino_obitos = obitos2018 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2018_feminino = tabela_2018_feminino_expostos %>%
  full_join(tabela_2018_feminino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  dplyr::rename(Vivas = QUANTIDADE.x, Falecidas = QUANTIDADE.y) %>%
  mutate(Total = Vivas + Falecidas)

#------------------------------------------------------------------------------#  
#Expostos e obitos no ano de 2019

tabela_2019_masculino_expostos = base2019 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2019_masculino_obitos = obitos2019 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2019_masculino = tabela_2019_masculino_expostos %>%
  full_join(tabela_2019_masculino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  dplyr::rename(Vivos = QUANTIDADE.x, Falecidos = QUANTIDADE.y) %>%
  mutate(Total = Vivos + Falecidos)

tabela_2019_feminino_expostos = base2019 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2019_feminino_obitos = obitos2019 %>%
  filter(CO_SEXO_SERVIDOR == 1, IDADE_OBITO <= 103) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2019_feminino = tabela_2019_feminino_expostos %>%
  full_join(tabela_2019_feminino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  dplyr::rename(Vivas = QUANTIDADE.x, Falecidas = QUANTIDADE.y) %>%
  mutate(Total = Vivas + Falecidas)

#------------------------------------------------------------------------------#
#Expostos e obitos no ano de 2020

tabela_2020_masculino_expostos = base2020 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2020_masculino_obitos = obitos2020 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2020_masculino = tabela_2020_masculino_expostos %>%
  full_join(tabela_2020_masculino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  dplyr::rename(Vivos = QUANTIDADE.x, Falecidos = QUANTIDADE.y) %>%
  mutate(Total = Vivos + Falecidos)

tabela_2020_feminino_expostos = base2020 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2020_feminino_obitos = obitos2020 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2020_feminino = tabela_2020_feminino_expostos %>%
  full_join(tabela_2020_feminino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  dplyr::rename(Vivas = QUANTIDADE.x, Falecidas = QUANTIDADE.y) %>%
  mutate(Total = Vivas + Falecidas)

#------------------------------------------------------------------------------#
#Expostos e obitos no ano de 2021

tabela_2021_masculino_expostos = base2021 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2021_masculino_obitos = obitos2021 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2021_masculino = tabela_2021_masculino_expostos %>%
  full_join(tabela_2021_masculino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  dplyr::rename(Vivos = QUANTIDADE.x, Falecidos = QUANTIDADE.y) %>%
  mutate(Total = Vivos + Falecidos)

tabela_2021_feminino_expostos = base2021 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2021_feminino_obitos = obitos2021 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2021_feminino = tabela_2021_feminino_expostos %>%
  full_join(tabela_2021_feminino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  dplyr::rename(Vivas = QUANTIDADE.x, Falecidas = QUANTIDADE.y) %>%
  mutate(Total = Vivas + Falecidas)

#------------------------------------------------------------------------------#
#Expostos e obitos no ano de 2022

tabela_2022_ativos_masculino = base2022_ativos %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(idade) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)

tabela_2022_inativos_masculino = base2022_inativos %>%
  replace(is.null(.), 0) %>%
  filter(CO_TIPO_APOSENTADORIA != 4, CO_TIPO_APOSENTADORIA != 0, CO_SEXO_APOSENTADO == 2) %>%
  group_by(idade) %>%
  distinct(ID_APOSENTADO_CPF) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)


tabela_2022_masculino_expostos = tabela_2022_ativos_masculino %>%
  full_join(tabela_2022_inativos_masculino, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  mutate(QUANTIDADE = QUANTIDADE.x + QUANTIDADE.y) %>%
  select(IDADE, QUANTIDADE)

tabela_2022_masculino_obitos = obitos2022 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2022_masculino = tabela_2022_masculino_expostos %>%
  full_join(tabela_2022_masculino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  arrange(IDADE) %>%
  dplyr::rename(Vivos = QUANTIDADE.x, Falecidos = QUANTIDADE.y) %>%
  mutate(Total = Vivos + Falecidos)


tabela_2022_ativos_feminino = base2022_ativos %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(idade) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)

tabela_2022_inativos_feminino = base2022_inativos %>%
  replace(is.null(.), 0) %>%
  filter(CO_TIPO_APOSENTADORIA != 4, CO_TIPO_APOSENTADORIA != 0, CO_SEXO_APOSENTADO == 1) %>%
  group_by(idade) %>%
  distinct(ID_APOSENTADO_CPF) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)

tabela_2022_feminino_expostos = tabela_2022_ativos_feminino %>%
  full_join(tabela_2022_inativos_feminino, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  mutate(QUANTIDADE = QUANTIDADE.x + QUANTIDADE.y) %>%
  select(IDADE, QUANTIDADE)

tabela_2022_feminino_obitos = obitos2022 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2022_feminino = tabela_2022_feminino_expostos %>%
  full_join(tabela_2022_feminino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  dplyr::rename(Vivas = QUANTIDADE.x, Falecidas = QUANTIDADE.y) %>%
  mutate(Total = Vivas + Falecidas)

#------------------------------------------------------------------------------#
#Expostos e obitos no ano de 2023

tabela_2023_ativos_masculino = base2023_ativos %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(idade) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)

tabela_2023_inativos_masculino = base2023_inativos %>%
  replace(is.null(.), 0) %>%
  filter(CO_TIPO_APOSENTADORIA != 4, CO_TIPO_APOSENTADORIA != 0, CO_SEXO_APOSENTADO == 2) %>%
  group_by(idade) %>%
  distinct(ID_APOSENTADO_CPF) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)


tabela_2023_masculino_expostos = tabela_2023_ativos_masculino %>%
  full_join(tabela_2023_inativos_masculino, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  mutate(QUANTIDADE = QUANTIDADE.x + QUANTIDADE.y) %>%
  select(IDADE, QUANTIDADE)

tabela_2023_masculino_obitos = obitos2023 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2023_masculino = tabela_2023_masculino_expostos %>%
  full_join(tabela_2023_masculino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  arrange(IDADE) %>%
  dplyr::rename(Vivos = QUANTIDADE.x, Falecidos = QUANTIDADE.y) %>%
  mutate(Total = Vivos + Falecidos)



tabela_2023_ativos_feminino = base2023_ativos %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(idade) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)

tabela_2023_inativos_feminino = base2023_inativos %>%
  replace(is.null(.), 0) %>%
  filter(CO_TIPO_APOSENTADORIA != 4, CO_TIPO_APOSENTADORIA != 0, CO_SEXO_APOSENTADO == 1) %>%
  group_by(idade) %>%
  distinct(ID_APOSENTADO_CPF) %>%
  dplyr::count(idade) %>%
  dplyr::rename(QUANTIDADE = n, IDADE = idade)

tabela_2023_feminino_expostos = tabela_2023_ativos_feminino %>%
  full_join(tabela_2023_inativos_feminino, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  mutate(QUANTIDADE = QUANTIDADE.x + QUANTIDADE.y) %>%
  select(IDADE, QUANTIDADE)

tabela_2023_feminino_obitos = obitos2023 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE_OBITO) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  dplyr::count(IDADE_OBITO) %>%
  dplyr::rename(QUANTIDADE = n)

tabela_2023_feminino = tabela_2023_feminino_expostos %>%
  full_join(tabela_2023_feminino_obitos, by = c("IDADE" = "IDADE_OBITO")) %>%
  replace(is.na(.), 0) %>%
  dplyr::rename(Vivas = QUANTIDADE.x, Falecidas = QUANTIDADE.y) %>%
  mutate(Total = Vivas + Falecidas)

#------------------------------------------------------------------------------#
#Soma de expostos e obitos do sexo masculino

lista_soma_masculino = list("2018" = tabela_2018_masculino, 
                            "2019" = tabela_2019_masculino, 
                            "2020" = tabela_2020_masculino, 
                            "2021" = tabela_2021_masculino,
                            "2022" = tabela_2022_masculino,
                            "2023" = tabela_2023_masculino)

tabela_soma_masculino = purrr::reduce(lista_soma_masculino, dplyr::full_join, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  arrange(IDADE) %>%
  mutate(Vivos_1 = Vivos.x + Vivos.y + Vivos.x.x + Vivos.y.y + Vivos.x.x.x + Vivos.y.y.y, 
         Falecidos_1 = Falecidos.x + Falecidos.y + Falecidos.x.x + Falecidos.y.y + Falecidos.x.x.x + Falecidos.y.y.y, 
         Total_1 = Total.x + Total.y + Total.x.x + Total.y.y + Total.x.x.x + Total.y.y.y) %>%
  select(Vivos_1, Falecidos_1, Total_1) %>%
  dplyr::rename(Vivos = Vivos_1, Falecidos = Falecidos_1, Total = Total_1)
  
#Soma de expostos e obitos do sexo feminino

lista_soma_feminino = list("2018" = tabela_2018_feminino, 
                           "2019" = tabela_2019_feminino, 
                           "2020" = tabela_2020_feminino, 
                           "2021" = tabela_2021_feminino,
                           "2022" = tabela_2022_feminino, 
                           "2023" = tabela_2023_feminino)

tabela_soma_feminino = purrr::reduce(lista_soma_feminino, dplyr::full_join, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  arrange(IDADE) %>%
  mutate(Vivas_1 = Vivas.x + Vivas.y + Vivas.x.x + Vivas.y.y + Vivas.x.x.x + Vivas.y.y.y, 
         Falecidas_1 = Falecidas.x + Falecidas.y + Falecidas.x.x + Falecidas.y.y + Falecidas.x.x.x + Falecidas.y.y.y, 
         Total_1 = Total.x + Total.y + Total.x.x + Total.y.y + Total.x.x.x + Total.y.y.y) %>%
  select(Vivas_1, Falecidas_1, Total_1) %>%
  dplyr::rename(Vivas = Vivas_1, Falecidas = Falecidas_1, Total = Total_1)

#Total de expostos e obitos

tabela_total = tabela_soma_masculino %>%
  full_join(tabela_soma_feminino, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  arrange(IDADE) %>%
  mutate(Vivos_1 = Vivas + Vivos, 
         Falecidos_1 = Falecidas  + Falecidos, 
         Total_1 = Total.x + Total.y) %>%
  select(Vivos_1, Falecidos_1, Total_1) %>%
  dplyr::rename(Vivos = Vivos_1, Falecidos = Falecidos_1, Total = Total_1)

#------------------------------------------------------------------------------#
lista_soma = list("Masculino - Soma" = tabela_soma_masculino,
                  "Feminino - Soma" = tabela_soma_feminino,
                  "Total" = tabela_total)

openxlsx::write.xlsx(lista_soma, file="Z:/GERENCIA/RELATÓRIO DE HIPÓTESES/2023/MORTALIDADE/01. TABUAS E TESTE DE ADERÊNCIA/expostos e obitos.xlsx")
