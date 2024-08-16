#Script by Leonardo Malaquias

library(tidyverse)

aposentadoria.civis.docentes = function(lista_cargos_masculino, lista_cargos_feminino) {
  condicao = FALSE
  for(i in 1:length(lista_cargos_masculino)) {
    
    lista_cargos_masculino[[i]]$ANO_APOSENTADORIA = rep(NA, nrow(lista_cargos_masculino[[i]])) 
    
    if(nrow(lista_cargos_masculino[[i]]) > 0) {
      
      for(k in 1:nrow(lista_cargos_masculino[[i]])) {
        
        while(condicao == FALSE) {
          
          apos_idade = lista_cargos_masculino[[i]]$NU_ANO[k]
          if(is.na(lista_cargos_masculino[[i]]$IDADE[k]) != TRUE) {
            while(lista_cargos_masculino[[i]]$IDADE[k] < 65) {
              lista_cargos_masculino[[i]]$IDADE[k] = lista_cargos_masculino[[i]]$IDADE[k] + 1
              apos_idade = apos_idade + 1
            }
          }
          
          apos_serv_pub = lista_cargos_masculino[[i]]$NU_ANO[k]
          if(is.na(lista_cargos_masculino[[i]]$TEMPO_SERV_PUB[k]) != TRUE) {
            while(lista_cargos_masculino[[i]]$TEMPO_SERV_PUB[k] < 10) {
              lista_cargos_masculino[[i]]$TEMPO_SERV_PUB[k]  = lista_cargos_masculino[[i]]$TEMPO_SERV_PUB[k] + 1
              apos_serv_pub = apos_serv_pub + 1
            }
          }
          
          apos_tempo_carreira = lista_cargos_masculino[[i]]$NU_ANO[k]
          if(is.na(lista_cargos_masculino[[i]]$TEMPO_CARREIRA[k]) != TRUE) {
            while(lista_cargos_masculino[[i]]$TEMPO_CARREIRA[k] < 5) {
              lista_cargos_masculino[[i]]$TEMPO_CARREIRA[k]  = lista_cargos_masculino[[i]]$TEMPO_CARREIRA[k] + 1
              apos_tempo_carreira = apos_tempo_carreira + 1
            }
          }
          
          apos_contribuicao = lista_cargos_masculino[[i]]$NU_ANO[k]
          if(is.na(lista_cargos_masculino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]) != TRUE) {
            while(lista_cargos_masculino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] < 25) {
              lista_cargos_masculino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]  = lista_cargos_masculino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] + 1
              apos_contribuicao = apos_contribuicao + 1
            }
          }
          
          
          if(is.na(lista_cargos_masculino[[i]]$IDADE[k]) != TRUE && 
             is.na(lista_cargos_masculino[[i]]$TEMPO_SERV_PUB[k]) != TRUE &&
             is.na(lista_cargos_masculino[[i]]$TEMPO_CARREIRA[k]) != TRUE &&
             is.na(lista_cargos_masculino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]) != TRUE) {
            
            if(lista_cargos_masculino[[i]]$IDADE[k] >= 65 && 
               lista_cargos_masculino[[i]]$TEMPO_SERV_PUB[k] >= 10 && 
               lista_cargos_masculino[[i]]$TEMPO_CARREIRA[k] >= 5 &&
               lista_cargos_masculino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] >= 25) {
              
              condicao = TRUE
              ano_aposentadoria = max(apos_idade, apos_serv_pub, apos_tempo_carreira, apos_contribuicao)
              lista_cargos_masculino[[i]]$ANO_APOSENTADORIA[k] = ano_aposentadoria
            }
            
          } else condicao = TRUE
          
        }
        
        condicao = FALSE
        
      }
    }
  }
  
  
  
  condicao = FALSE
  for(i in 1:length(lista_cargos_feminino)) {
    
    lista_cargos_feminino[[i]]$ANO_APOSENTADORIA = rep(NA, nrow(lista_cargos_feminino[[i]])) 
    
    if(nrow(lista_cargos_feminino[[i]]) > 0) {
      
      for(k in 1:nrow(lista_cargos_feminino[[i]])) {
        
        while(condicao == FALSE) {
          
          apos_idade = lista_cargos_feminino[[i]]$NU_ANO[k]
          if(is.na(lista_cargos_feminino[[i]]$IDADE[k]) != TRUE) {
            while(lista_cargos_feminino[[i]]$IDADE[k] < 62) {
              lista_cargos_feminino[[i]]$IDADE[k] = lista_cargos_feminino[[i]]$IDADE[k] + 1
              apos_idade = apos_idade + 1
            }
          }
          
          apos_serv_pub = lista_cargos_feminino[[i]]$NU_ANO[k]
          if(is.na(lista_cargos_feminino[[i]]$TEMPO_SERV_PUB[k]) != TRUE) {
            while(lista_cargos_feminino[[i]]$TEMPO_SERV_PUB[k] < 10) {
              lista_cargos_feminino[[i]]$TEMPO_SERV_PUB[k]  = lista_cargos_feminino[[i]]$TEMPO_SERV_PUB[k] + 1
              apos_serv_pub = apos_serv_pub + 1
            }
          }
          
          apos_tempo_carreira = lista_cargos_feminino[[i]]$NU_ANO[k]
          if(is.na(lista_cargos_feminino[[i]]$TEMPO_CARREIRA[k]) != TRUE) {
            while(lista_cargos_feminino[[i]]$TEMPO_CARREIRA[k] < 5) {
              lista_cargos_feminino[[i]]$TEMPO_CARREIRA[k]  = lista_cargos_feminino[[i]]$TEMPO_CARREIRA[k] + 1
              apos_tempo_carreira = apos_tempo_carreira + 1
            }
          }
          
          apos_contribuicao = lista_cargos_feminino[[i]]$NU_ANO[k]
          if(is.na(lista_cargos_feminino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]) != TRUE) {
            while(lista_cargos_feminino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] < 25) {
              lista_cargos_feminino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]  = lista_cargos_feminino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] + 1
              apos_contribuicao = apos_contribuicao + 1
            }
          }
          
          
          if(is.na(lista_cargos_feminino[[i]]$IDADE[k]) != TRUE && 
             is.na(lista_cargos_feminino[[i]]$TEMPO_SERV_PUB[k]) != TRUE &&
             is.na(lista_cargos_feminino[[i]]$TEMPO_CARREIRA[k]) != TRUE &&
             is.na(lista_cargos_feminino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k]) != TRUE) {
            
            if(lista_cargos_feminino[[i]]$IDADE[k] >= 62 && 
               lista_cargos_feminino[[i]]$TEMPO_SERV_PUB[k] >= 10 && 
               lista_cargos_feminino[[i]]$TEMPO_CARREIRA[k] >= 5 &&
               lista_cargos_feminino[[i]]$TEMPO_CONTRIBUICAO_TOTAL[k] >= 25) {
              
              condicao = TRUE
              ano_aposentadoria = max(apos_idade, apos_serv_pub, apos_tempo_carreira, apos_contribuicao)
              lista_cargos_feminino[[i]]$ANO_APOSENTADORIA[k] = ano_aposentadoria
            }
            
          } else condicao = TRUE
          
        }
        
        condicao = FALSE
        
      }
    }
  }
  
  
  masculino = bind_rows(lista_cargos_masculino)
  feminino = bind_rows(lista_cargos_feminino)
  
  tabelas = list(masculino, feminino)
  return(tabelas)
  
}