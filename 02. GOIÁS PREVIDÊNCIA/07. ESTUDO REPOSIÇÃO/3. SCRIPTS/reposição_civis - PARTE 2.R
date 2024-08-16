#Script by Leonardo Malaquias
# estudo de reposicao de servidores desconsiderando militares e docentes da UEG
rm(list=ls())
library(tidyverse)
library(readxl)

# Data: 07/2024
setwd("Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO")
estrutura_remuneratoria = read_excel("estruturas_remuneratorias_JUN2024.xlsx")

# dados = read_excel("Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/Atuario202407.xlsx", sheet = "Ativo") %>%
#   filter(CO_TIPO_CARGO != 8,
#          !(NO_CARGO %in% c("Docente de Ensino Superior - RTI - UEG",
#           "Docente de Ensino Superior - RTP - UEG",
#           "Docente de Ensino Superior - RTIDP - UEG"))) %>%
#   select(NU_ANO, ID_SERVIDOR_CPF, CO_SEXO_SERVIDOR, DT_NASC_SERVIDOR, DT_ING_SERV_PUB, DT_ING_CARREIRA, NO_CARGO, VL_BASE_CALCULO,
#          VL_REMUNERACAO, VL_CONTRIBUICAO, NU_TEMPO_RGPS, NU_TEMPO_RPPS_MUN, NU_TEMPO_RPPS_EST, NU_TEMPO_RPPS_FED,
#          IN_ABONO_PERMANENCIA, IDADE, TEMPO_SERV_PUB, TEMPO_CARREIRA, TEMPO_CONTRIBUICAO_TOTAL)

dados_ativos = list()
i = 1
for(k in 2014:2023) {
  dados_ativos[[i]] = read_excel(paste0("Atuario12", k, ".xlsx"), sheet = "ativo") %>%
    filter(CO_TIPO_CARGO != 8,
           !(NO_CARGO %in% c("Docente de Ensino Superior - RTI - UEG",
                             "Docente de Ensino Superior - RTP - UEG",
                             "Docente de Ensino Superior - RTIDP - UEG")))
  i = i + 1
}