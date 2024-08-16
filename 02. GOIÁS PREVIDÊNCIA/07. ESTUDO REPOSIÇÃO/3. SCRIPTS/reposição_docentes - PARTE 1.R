#Script by Leonardo Malaquias
# estudo de reposicao de servidores considerando apenas os docentes da UEG
rm(list=ls())
library(tidyverse)
library(readxl)

# Data: 07/2024
estrutura_remuneratoria = read_excel("Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/estruturas_remuneratorias_JUN2024.xlsx")

dados = read_excel("Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/Atuario202407.xlsx", sheet = "Ativo") %>%
  filter(NO_CARGO %in% c("Docente de Ensino Superior - RTI - UEG",
                           "Docente de Ensino Superior - RTP - UEG",
                           "Docente de Ensino Superior - RTIDP - UEG")) %>%
  select(NU_ANO, ID_SERVIDOR_CPF, CO_SEXO_SERVIDOR, DT_NASC_SERVIDOR, DT_ING_SERV_PUB, DT_ING_CARREIRA, NO_CARGO, VL_BASE_CALCULO,
         VL_REMUNERACAO, VL_CONTRIBUICAO, NU_TEMPO_RGPS, NU_TEMPO_RPPS_MUN, NU_TEMPO_RPPS_EST, NU_TEMPO_RPPS_FED,
         IN_ABONO_PERMANENCIA, IDADE, TEMPO_SERV_PUB, TEMPO_CARREIRA, TEMPO_CONTRIBUICAO_TOTAL)
dados$NU_ANO = as.numeric(dados$NU_ANO)
dados$IDADE = round(dados$IDADE)
dados$TEMPO_SERV_PUB = round(dados$TEMPO_SERV_PUB)
dados$TEMPO_CARREIRA = round(dados$TEMPO_CARREIRA)
dados$TEMPO_CONTRIBUICAO_TOTAL = round(dados$TEMPO_CONTRIBUICAO_TOTAL)


homens = dados %>%
  filter (CO_SEXO_SERVIDOR == 2)
cargos_homens = split(homens, dados$NO_CARGO)


mulheres = dados %>%
  filter (CO_SEXO_SERVIDOR == 1)
cargos_mulheres = split(mulheres, dados$NO_CARGO)


condicao = FALSE
for(i in 1:length(cargos_homens)) {
  
  cargos_homens[[i]]$ANO_APOSENTADORIA = rep(NA, nrow(cargos_homens[[i]])) 
  
  if(nrow(cargos_homens[[i]]) > 0) {
    
    for(k in 1:nrow(cargos_homens[[i]])) {
      
      while(condicao == FALSE) {
        
        apos_idade = cargos_homens[[i]]$NU_ANO[k]
        if(is.na(cargos_homens[[i]]$IDADE[k]) != TRUE) {
          while(cargos_homens[[i]]$IDADE[k] < 65) {
            cargos_homens[[i]]$IDADE[k] = cargos_homens[[i]]$IDADE[k] + 1
            apos_idade = apos_idade + 1
            # print(cargos_homens[[i]][k, c(2, 7, 16)])
            # print(apos_idade)
          }
        }
        
        apos_serv_pub = cargos_homens[[i]]$NU_ANO[k]
        if(is.na(cargos_homens[[i]]$TEMPO_SERV_PUB[k]) != TRUE) {
          while(cargos_homens[[i]]$TEMPO_SERV_PUB[k] < 10) {
            cargos_homens[[i]]$TEMPO_SERV_PUB[k]  = cargos_homens[[i]]$TEMPO_SERV_PUB[k] + 1
            apos_serv_pub = apos_serv_pub + 1
            # print(cargos_homens[[i]][k, c(2, 7, 17)])
            # print(apos_serv_pub)
          }
        }
        
        apos_tempo_carreira = cargos_homens[[i]]$NU_ANO[k]
        if(is.na(cargos_homens[[i]]$TEMPO_CARREIRA[k]) != TRUE) {
          while(cargos_homens[[i]]$TEMPO_CARREIRA[k] < 5) {
            cargos_homens[[i]]$TEMPO_CARREIRA[k]  = cargos_homens[[i]]$TEMPO_CARREIRA[k] + 1
            apos_tempo_carreira = apos_tempo_carreira + 1
            # print(cargos_homens[[i]][k, c(2, 7, 18)])
            # print(apos_tempo_carreira)
          }
        }
        
        apos_contribuicao = cargos_homens[[i]]$NU_ANO[k]
        if(is.na(cargos_homens[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]) != TRUE) {
          while(cargos_homens[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] < 25) {
            cargos_homens[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]  = cargos_homens[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] + 1
            apos_contribuicao = apos_contribuicao + 1
            # print(cargos_homens[[i]][k, c(2, 7, 19)])
            # print(apos_contribuicao)
          }
        }
        
        
        if(is.na(cargos_homens[[i]]$IDADE[k]) != TRUE && 
           is.na(cargos_homens[[i]]$TEMPO_SERV_PUB[k]) != TRUE &&
           is.na(cargos_homens[[i]]$TEMPO_CARREIRA[k]) != TRUE &&
           is.na(cargos_homens[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]) != TRUE) {
          
          if(cargos_homens[[i]]$IDADE[k] >= 65 && 
             cargos_homens[[i]]$TEMPO_SERV_PUB[k] >= 10 && 
             cargos_homens[[i]]$TEMPO_CARREIRA[k] >= 5 &&
             cargos_homens[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] >= 25) {
            
            condicao = TRUE
            ano_aposentadoria = max(apos_idade, apos_serv_pub, apos_tempo_carreira, apos_contribuicao)
            cargos_homens[[i]]$ANO_APOSENTADORIA[k] = ano_aposentadoria
          }
          
        } else condicao = TRUE
        
      }
      
      condicao = FALSE
      
    }
  }
}



condicao = FALSE
for(i in 1:length(cargos_mulheres)) {
  
  cargos_mulheres[[i]]$ANO_APOSENTADORIA = rep(NA, nrow(cargos_mulheres[[i]])) 
  
  if(nrow(cargos_mulheres[[i]]) > 0) {
    
    for(k in 1:nrow(cargos_mulheres[[i]])) {
      
      while(condicao == FALSE) {
        
        apos_idade = cargos_mulheres[[i]]$NU_ANO[k]
        if(is.na(cargos_mulheres[[i]]$IDADE[k]) != TRUE) {
          while(cargos_mulheres[[i]]$IDADE[k] < 62) {
            cargos_mulheres[[i]]$IDADE[k] = cargos_mulheres[[i]]$IDADE[k] + 1
            apos_idade = apos_idade + 1
            # print(cargos_mulheres[[i]][k, c(2, 7, 16)])
            # print(apos_idade)
          }
        }
        
        apos_serv_pub = cargos_mulheres[[i]]$NU_ANO[k]
        if(is.na(cargos_mulheres[[i]]$TEMPO_SERV_PUB[k]) != TRUE) {
          while(cargos_mulheres[[i]]$TEMPO_SERV_PUB[k] < 10) {
            cargos_mulheres[[i]]$TEMPO_SERV_PUB[k]  = cargos_mulheres[[i]]$TEMPO_SERV_PUB[k] + 1
            apos_serv_pub = apos_serv_pub + 1
            # print(cargos_mulheres[[i]][k, c(2, 7, 17)])
            # print(apos_serv_pub)
          }
        }
        
        apos_tempo_carreira = cargos_mulheres[[i]]$NU_ANO[k]
        if(is.na(cargos_mulheres[[i]]$TEMPO_CARREIRA[k]) != TRUE) {
          while(cargos_mulheres[[i]]$TEMPO_CARREIRA[k] < 5) {
            cargos_mulheres[[i]]$TEMPO_CARREIRA[k]  = cargos_mulheres[[i]]$TEMPO_CARREIRA[k] + 1
            apos_tempo_carreira = apos_tempo_carreira + 1
            # print(cargos_mulheres[[i]][k, c(2, 7, 18)])
            # print(apos_tempo_carreira)
          }
        }
        
        apos_contribuicao = cargos_mulheres[[i]]$NU_ANO[k]
        if(is.na(cargos_mulheres[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]) != TRUE) {
          while(cargos_mulheres[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] < 25) {
            cargos_mulheres[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]  = cargos_mulheres[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] + 1
            apos_contribuicao = apos_contribuicao + 1
            # print(cargos_mulheres[[i]][k, c(2, 7, 19)])
            # print(apos_contribuicao)
          }
        }
        
        
        if(is.na(cargos_mulheres[[i]]$IDADE[k]) != TRUE && 
           is.na(cargos_mulheres[[i]]$TEMPO_SERV_PUB[k]) != TRUE &&
           is.na(cargos_mulheres[[i]]$TEMPO_CARREIRA[k]) != TRUE &&
           is.na(cargos_mulheres[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]) != TRUE) {
          
          if(cargos_mulheres[[i]]$IDADE[k] >= 62 && 
             cargos_mulheres[[i]]$TEMPO_SERV_PUB[k] >= 10 && 
             cargos_mulheres[[i]]$TEMPO_CARREIRA[k] >= 5 &&
             cargos_mulheres[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] >= 25) {
            
            condicao = TRUE
            ano_aposentadoria = max(apos_idade, apos_serv_pub, apos_tempo_carreira, apos_contribuicao)
            cargos_mulheres[[i]]$ANO_APOSENTADORIA[k] = ano_aposentadoria
          }
          
        } else condicao = TRUE
        
      }
      
      condicao = FALSE
      
    }
  }
}


df_homens = bind_rows(cargos_homens)
df_mulheres = bind_rows(cargos_mulheres)

view(df_homens %>%
       group_by(ANO_APOSENTADORIA, NO_CARGO) %>%
       count() %>%
       rename(HOMENS_APOSENTADORIA = n))

view(df_mulheres %>%
       group_by(ANO_APOSENTADORIA, NO_CARGO) %>%
       count() %>%
       rename(MULHERES_APOSENTADORIA = n))
