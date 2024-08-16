#Script by Leonardo Malaquias
# estudo de reposicao de servidores considerando apenas militares
# calculo do ano de aposentadoria de cada servidor

rm(list=ls())
library(tidyverse)
library(readxl)

# Data: 07/2024

## funcao que calcula o ano de aposentadoria de cada servidor
source("Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/3. SCRIPTS/functions/APOSENTADORIA_MILITARES.R")

dados = read_excel("Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/Atuario202407.xlsx", sheet = "Ativo") %>%
  filter(CO_TIPO_CARGO == 8)
  # select(NU_ANO, ID_SERVIDOR_CPF, CO_SEXO_SERVIDOR, DT_NASC_SERVIDOR, DT_ING_SERV_PUB, DT_ING_CARREIRA, NO_CARGO, VL_BASE_CALCULO,
  #        VL_REMUNERACAO, VL_CONTRIBUICAO, NU_TEMPO_RGPS, NU_TEMPO_RPPS_MUN, NU_TEMPO_RPPS_EST, NU_TEMPO_RPPS_FED,
  #        IN_ABONO_PERMANENCIA, IDADE, TEMPO_SERV_PUB, TEMPO_CARREIRA, TEMPO_CONTRIBUICAO_TOTAL)


## Estudo levando em conta apenas os praças 

militares_pracas = dados %>%
  filter(NO_CARGO %in% c("Soldado - Lei 15.668" ,
          "Cabo - Lei 15.668" ,
          "Terceiro Sargento - Lei 15.668" ,
          "Terceiro Sargento - Lei 15.668 - DECISÃO JUDICIAL",
          "Segundo Sargento - Lei 15.668" ,
          "Segundo Sargento - Lei 15.668 - DECISÃO JUDICIAL" ,
          "Primeiro Sargento - Lei 15.668", 
          "Primeiro Sargento - Lei 15.668 - DECISÃO JUDICIAL" ,
          "Subtenente - Lei 15.668"))

homens_pracas = militares_pracas %>%
  filter(CO_SEXO_SERVIDOR == 2)
cargos_homens_pracas = split(homens_pracas, homens_pracas$NO_CARGO)

mulheres_pracas = militares_pracas %>%
  filter(CO_SEXO_SERVIDOR == 1)
cargos_mulheres_pracas = split(mulheres_pracas, mulheres_pracas$NO_CARGO)


## Estudo levando em conta apenas os oficiais

militares_oficiais = dados %>%
  filter(!(NO_CARGO %in% c("Soldado - Lei 15.668" ,
                           "Cabo - Lei 15.668" ,
                           "Terceiro Sargento - Lei 15.668" ,
                           "Terceiro Sargento - Lei 15.668 - DECISÃO JUDICIAL",
                           "Segundo Sargento - Lei 15.668" ,
                           "Segundo Sargento - Lei 15.668 - DECISÃO JUDICIAL" ,
                           "Primeiro Sargento - Lei 15.668", 
                           "Primeiro Sargento - Lei 15.668 - DECISÃO JUDICIAL" ,
                           "Subtenente - Lei 15.668")))

homens_oficiais = militares_oficiais %>%
  filter(CO_SEXO_SERVIDOR == 2)
cargos_homens_oficiais = split(homens_oficiais, homens_oficiais$NO_CARGO)

mulheres_oficiais = militares_oficiais %>%
  filter(CO_SEXO_SERVIDOR == 1)
cargos_mulheres_oficiais = split(mulheres_oficiais, mulheres_oficiais$NO_CARGO)



aposentados = aposentadoria.militares(cargos_homens_pracas, cargos_mulheres_pracas,
                                      cargos_homens_oficiais, cargos_mulheres_oficiais, 
                                      verbose = FALSE)



df_homens_pracas = aposentados[[1]]
df_mulheres_pracas = aposentados[[2]]

df_homens_oficiais = aposentados[[3]]
df_mulheres_oficiais = aposentados[[4]]

militares = bind_rows(df_homens_pracas, df_homens_oficiais, 
                      df_mulheres_pracas, df_mulheres_oficiais)
