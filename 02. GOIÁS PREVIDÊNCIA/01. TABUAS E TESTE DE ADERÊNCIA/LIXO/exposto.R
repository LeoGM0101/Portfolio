library(readxl)
library(tidyverse)
library(openxlsx)
rm(list=ls(all=TRUE))

setwd("Z:/GERENCIA/RELATÓRIO DE HIPÓTESES/2022/MORTALIDADE")
base2018_ativos = read_excel("base2018.xlsx", sheet = "Ativo")
base2018_inativos = read_excel("base2018.xlsx", sheet = "Inativo")
base2019 = read_excel("base2019.xlsx")
base2020 = read_excel("base2020.xlsx")
base2021 = read_excel("base2021.xlsx")
#------------------------------------------------------------------------------#
tabela_2018_ativos_masculino = base2018_ativos %>%
  filter(sexo == "M") %>%
  group_by(idade) %>%
  distinct(cpf) %>%
  count(idade) %>%
  rename(QUANTIDADE = n, IDADE = idade)
tabela_2018_ativos_feminino = base2018_ativos %>%
  filter(sexo == "F") %>%
  group_by(idade) %>%
  distinct(cpf) %>%
  count(idade) %>%
  rename(QUANTIDADE = n, IDADE = idade)

tabela_2018_inativos_masculino = base2018_inativos %>%
  replace(is.null(.), 0) %>%
  filter(TipoAposentadoria != "Invalidez", TipoAposentadoria != 0, sexo == "M") %>%
  group_by(idade) %>%
  distinct(cpf) %>%
  count(idade) %>%
  rename(QUANTIDADE = n, IDADE = idade)
tabela_2018_inativos_feminino = base2018_inativos %>%
  replace(is.null(.), 0) %>%
  filter(TipoAposentadoria != "Invalidez", TipoAposentadoria != 0, sexo == "F") %>%
  group_by(idade) %>%
  distinct(cpf) %>%
  count(idade) %>%
  rename(QUANTIDADE = n, IDADE = idade)

tabela_2018_masculino = tabela_2018_ativos_masculino %>%
  full_join(tabela_2018_inativos_masculino, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  mutate(QUANTIDADE = QUANTIDADE.x + QUANTIDADE.y) %>%
  select(IDADE, QUANTIDADE)

tabela_2018_feminino = tabela_2018_ativos_feminino %>%
  full_join(tabela_2018_inativos_feminino, by = "IDADE") %>%
  replace(is.na(.), 0) %>%
  mutate(QUANTIDADE = QUANTIDADE.x + QUANTIDADE.y) %>%
  select(IDADE, QUANTIDADE)

tabela_2018 = list("Masculino" = tabela_2018_masculino, "Feminino" = tabela_2018_feminino)
#------------------------------------------------------------------------------#  
tabela_2019_masculino = base2019 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  count(IDADE) %>%
  rename(QUANTIDADE = n)

tabela_2019_feminino = base2019 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  count(IDADE) %>%
  rename(QUANTIDADE = n)

tabela_2019 = list("Masculino" = tabela_2019_masculino, "Feminino" = tabela_2019_feminino)
#------------------------------------------------------------------------------#
tabela_2020_masculino = base2020 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  count(IDADE) %>%
  rename(QUANTIDADE = n)

tabela_2020_feminino = base2020 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  count(IDADE) %>%
  rename(QUANTIDADE = n)

tabela_2020 = list("Masculino" = tabela_2020_masculino, "Feminino" = tabela_2020_feminino)
#------------------------------------------------------------------------------#
tabela_2021_masculino = base2021 %>%
  filter(CO_SEXO_SERVIDOR == 2) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  count(IDADE) %>%
  rename(QUANTIDADE = n)

tabela_2021_feminino = base2021 %>%
  filter(CO_SEXO_SERVIDOR == 1) %>%
  group_by(IDADE) %>%
  distinct(ID_SERVIDOR_CPF) %>%
  count(IDADE) %>%
  rename(QUANTIDADE = n)

tabela_2021 = list("Masculino" = tabela_2021_masculino, "Feminino" = tabela_2021_feminino)
#------------------------------------------------------------------------------#
write.xlsx(tabela_2018, file="exposto_2018.xlsx")
write.xlsx(tabela_2019, file="exposto_2019.xlsx")
write.xlsx(tabela_2020, file="exposto_2020.xlsx")
write.xlsx(tabela_2021, file="exposto_2021.xlsx")
