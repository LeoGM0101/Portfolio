#Script by Leonardo Malaquias

# estudo de reposicao de servidores desconsiderando militares e docentes da UEG. 
# Este primeiro script e para segmentar os servidores de acordo com os seus cargos e determinar 
# o ano de aposentadoria de cada servidor quando todos os pre-requisitos forem atendidos. 
# Nao e considerado nenhum abono permanencia.

rm(list=ls())
library(tidyverse)
library(readxl)

# Data: 07/2024

## funcao que calcula o ano de aposentadoria de cada servidor
source("Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/3. SCRIPTS/functions/APOSENTADORIA_CIVIS_DOCENTES.R")

dados = read_excel("Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/Atuario202407.xlsx", sheet = "Ativo") %>%
  filter(CO_TIPO_CARGO != 8,
         !(NO_CARGO %in% c("Docente de Ensino Superior - RTI - UEG",
          "Docente de Ensino Superior - RTP - UEG",
          "Docente de Ensino Superior - RTIDP - UEG")))
  # select(NU_ANO, ID_SERVIDOR_CPF, CO_SEXO_SERVIDOR, DT_NASC_SERVIDOR, DT_ING_SERV_PUB, DT_ING_CARREIRA, NO_CARGO, VL_BASE_CALCULO,
  #        VL_REMUNERACAO, VL_CONTRIBUICAO, NU_TEMPO_RGPS, NU_TEMPO_RPPS_MUN, NU_TEMPO_RPPS_EST, NU_TEMPO_RPPS_FED,
  #        IN_ABONO_PERMANENCIA, IDADE, TEMPO_SERV_PUB, TEMPO_CARREIRA, TEMPO_CONTRIBUICAO_TOTAL)
dados$DT_ING_SERV_PUB = as.Date(dados$DT_ING_SERV_PUB)
dados$DT_ING_CARREIRA = as.Date(dados$DT_ING_CARREIRA)
dados$NU_ANO = as.numeric(dados$NU_ANO)
dados$IDADE = round(dados$IDADE)
dados$TEMPO_SERV_PUB = round(dados$TEMPO_SERV_PUB)
dados$TEMPO_CARREIRA = round(dados$TEMPO_CARREIRA)
dados$TEMPO_CONTRIBUICAO_TOTAL = round(dados$TEMPO_CONTRIBUICAO_TOTAL)


## Aqui, e criada a lista de servidores masculinos ativos segmentada por seus respectivos cargos
homens = dados %>%
  filter (CO_SEXO_SERVIDOR == 2)
cargos_homens = split(homens, dados$NO_CARGO)


## Aqui, e criada a lista de servidoras ativas segmentada por seus respectivos cargos
mulheres = dados %>%
  filter (CO_SEXO_SERVIDOR == 1)
cargos_mulheres = split(mulheres, dados$NO_CARGO)


## Apos a criacao das listas de servidores masculinos e femininos segmentadas por seus cargos, a funcao que calcula o ano
## de aposentadoria de cada servidor e aplicada a essas listas. A ordem das listas na funcao e a lista
## de servidores masculinos primeiro e depois a lista de servidores do sexo feminino
aposentados = aposentadoria.civis.docentes(cargos_homens, cargos_mulheres)

## o primeiro item da lista gerada pela funcao corresponde aos servidores masculinos e 
## o segundo item corresponde aos servidores femininos. 
df_homens = aposentados[[1]]
df_mulheres = aposentados[[2]]

view(df_homens %>%
  group_by(ANO_APOSENTADORIA) %>%
  count() %>%
  rename(HOMENS_APOSENTADORIA = n))

view(df_mulheres %>%
    group_by(ANO_APOSENTADORIA) %>%
    count() %>%
    rename(MULHERES_APOSENTADORIA = n))


# write.xlsx(df_homens, file="Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/aposentadoria_homens.xlsx")
# write.xlsx(df_mulheres, file="Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/aposentadoria_mulheres.xlsx")

