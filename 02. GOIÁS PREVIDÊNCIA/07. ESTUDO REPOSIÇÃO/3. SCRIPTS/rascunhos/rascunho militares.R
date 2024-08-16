install_and_load = function(package) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package, dependencies = TRUE)
    library(package, character.only = TRUE)
  }
}

install_and_load("tidyverse")
install_and_load("lubridate")

condicao = FALSE
for(i in 1:length(cargos_homens_pracas)) {
  
  cargos_homens_pracas[[i]]$ANO_APOSENTADORIA = rep(NA, nrow(cargos_homens_pracas[[i]])) 
  
  if(nrow(cargos_homens_pracas[[i]]) > 0) {
    
    for(k in 1:nrow(cargos_homens_pracas[[i]])) {
      
      while(condicao == FALSE) {
        
        
        data_focal = as.Date("2021/12/31")
        tempo_serv_pub = as.numeric(difftime(data_focal, cargos_homens_pracas[[i]]$DT_ING_SERV_PUB[k], units = "weeks") / 52.1775)
        tempo_carreira = as.numeric(difftime(data_focal, cargos_homens_pracas[[i]]$DT_ING_CARREIRA[k], units = "weeks") / 52.1775)
        
        print(paste("tabela:", i, "linha:", k))
        
        if(tempo_serv_pub < 30) {
          
          if(cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k] >= 25) {
            
            t_serv = (30 - cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k])*1.17 + tempo_serv_pub
            t_car = min((30 - cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k] * 1.03), 5) + tempo_carreira
            
            apos_serv_pub = cargos_homens_pracas[[i]]$NU_ANO[k]
            if(is.na(cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k]) != TRUE) {
              while(cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k] < t_serv) {
                cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k]  = cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k] + 1
                apos_serv_pub = apos_serv_pub + 1
                print(paste("iteracao tempo servico:", cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k]))
              }
            }
            
            apos_tempo_carreira = cargos_homens_pracas[[i]]$NU_ANO[k]
            if(is.na(cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k]) != TRUE) {
              while(cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k] < t_car) {
                cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k]  = cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k] + 1
                apos_tempo_carreira = apos_tempo_carreira + 1
                print(paste("iteracao tempo carreira:", cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k]))
              }
            }
            
            if(is.na(cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k]) != TRUE &&
               is.na(cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k]) != TRUE) {
              
              if(cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k] >= t_serv && 
                 cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k] >= t_car) {
                
                condicao = TRUE
                ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                if(ano_aposentadoria == apos_serv_pub) {
                  
                  ano_aposentadoria = ano_aposentadoria + 2
                  mes_aposentadoria = month(cargos_homens_pracas[[i]]$DT_ING_CARREIRA[k])
                  dia_aposentadoria = day(cargos_homens_pracas[[i]]$DT_ING_CARREIRA[k]) + 1
                  cargos_homens_pracas[[i]]$ANO_APOSENTADORIA[k] = make_date(year = ano_aposentadoria, 
                                                                                     month = mes_aposentadoria, 
                                                                                     day = dia_aposentadoria)
                  
                } else if(ano_aposentadoria == apos_tempo_carreira) {
                  
                  ano_aposentadoria = ano_aposentadoria + 2
                  mes_aposentadoria = month(cargos_homens_pracas[[i]]$DT_ING_CARREIRA[k])
                  dia_aposentadoria = day(cargos_homens_pracas[[i]]$DT_ING_CARREIRA[k]) + 1
                  cargos_homens_pracas[[i]]$ANO_APOSENTADORIA[k] = make_date(year = ano_aposentadoria, 
                                                                                     month = mes_aposentadoria, 
                                                                                     day = dia_aposentadoria)
                }
                
                cargos_homens_pracas[[i]]$ANO_APOSENTADORIA[k] = ano_aposentadoria + 2
              }
              
            } else condicao = TRUE
            
          } else if(cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k] < 25) {
            
            apos_serv_pub = cargos_homens_pracas[[i]]$NU_ANO[k]
            if(is.na(cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k]) != TRUE) {
              while(cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k] < 35) {
                cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k]  = cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k] + 1
                apos_serv_pub = apos_serv_pub + 1
                print(paste("iteracao tempo servico quando t_car < 25:", cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k]))
              }
            }
            
            apos_tempo_carreira = cargos_homens_pracas[[i]]$NU_ANO[k]
            if(is.na(cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k]) != TRUE) {
              while(cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k] < 30) {
                cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k]  = cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k] + 1
                apos_tempo_carreira = apos_tempo_carreira + 1
                print(paste("iteracao tempo carreira quando t_car < 25:", cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k]))
              }
            }
            
            if(is.na(cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k]) != TRUE &&
               is.na(cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k]) != TRUE) {
              
              if(cargos_homens_pracas[[i]]$TEMPO_SERV_PUB[k] >= 35 && 
                 cargos_homens_pracas[[i]]$TEMPO_CARREIRA[k] >= 30) {
                
                condicao = TRUE
                ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                cargos_homens_pracas[[i]]$ANO_APOSENTADORIA[k] = ano_aposentadoria + 2
              }
              
            } else condicao = TRUE
            
          }
          
          
        } else {
          
          cargos_homens_pracas[[i]]$ANO_APOSENTADORIA[k] = 2021 + 2
          condicao = TRUE
          
        }
        
      }
      
      condicao = FALSE
      
    }
  }
}


masculino_praca = bind_rows(cargos_homens_pracas)
