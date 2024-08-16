install_and_load = function(package) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package, dependencies = TRUE)
    library(package, character.only = TRUE)
  }
}

install_and_load("tidyverse")
install_and_load("lubridate")



condicao = FALSE
for(i in 1:length(cargos_homens_oficiais)) {
  
  cargos_homens_oficiais[[i]]$ANO_APOSENTADORIA = as.Date(rep(NA, nrow(cargos_homens_oficiais[[i]]))) 
  
  if(nrow(cargos_homens_oficiais[[i]]) > 0) {
    
    for(k in 1:nrow(cargos_homens_oficiais[[i]])) {
      
      while(condicao == FALSE) {
        
        
        data_focal = as.Date("2021/12/31")
        tempo_serv_pub_2021 = as.numeric(difftime(data_focal, cargos_homens_oficiais[[i]]$DT_ING_SERV_PUB[k], units = "days") / 365.25)
        tempo_carreira_2021 = as.numeric(difftime(data_focal, cargos_homens_oficiais[[i]]$DT_ING_CARREIRA[k], units = "days") / 365.25)
        
        Idade = as.numeric(difftime(Sys.Date(), cargos_homens_oficiais[[i]]$DT_NASC_SERVIDOR[k], units = "days") / 365.25)
        TEMPO_SERV_PUB = as.numeric(difftime(Sys.Date(), cargos_homens_oficiais[[i]]$DT_ING_SERV_PUB[k], units = "days") / 365.25)
        TEMPO_CARREIRA = as.numeric(difftime(Sys.Date(), cargos_homens_oficiais[[i]]$DT_ING_CARREIRA[k], units = "days") / 365.25)
        
        print(paste("tabela:", i, "linha:", k))
        
        if(tempo_serv_pub_2021 < 30) {
          
          if(TEMPO_CARREIRA >= 25) {
            
            t_serv = (30 - TEMPO_SERV_PUB)*1.17 + 30
            t_car = min((30 - TEMPO_CARREIRA * 1.03), 5) + 30
            
            if(is.na(TEMPO_SERV_PUB) != TRUE) {
            apos_serv_pub = as.Date(cargos_homens_oficiais[[i]]$DT_ING_SERV_PUB[k]) + t_serv*365.25
            }
            
            if(is.na(TEMPO_CARREIRA) != TRUE) {
              apos_tempo_carreira = as.Date(cargos_homens_oficiais[[i]]$DT_ING_CARREIRA[k]) + t_car*365.25
            }
            
            if(is.na(TEMPO_SERV_PUB) != TRUE &&
               is.na(TEMPO_CARREIRA) != TRUE) {
              
              condicao = TRUE
              ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
              cargos_homens_oficiais[[i]]$ANO_APOSENTADORIA[k] = seq.Date(ano_aposentadoria, 
                                                                          by = "2 years", 
                                                                          length.out = 2)[2] # adicionando 2 anos na data de aposentadoria

              
            } else condicao = TRUE
            
          } else if(TEMPO_CARREIRA < 25) {

              
              if(is.na(TEMPO_SERV_PUB) != TRUE) {
                apos_serv_pub = as.Date(cargos_homens_oficiais[[i]]$DT_ING_SERV_PUB[k]) + 35*365.25
              }
              
              apos_tempo_carreira = cargos_homens_oficiais[[i]]$NU_ANO[k]
              if(is.na(TEMPO_CARREIRA) != TRUE) {
                apos_tempo_carreira = as.Date(cargos_homens_oficiais[[i]]$DT_ING_CARREIRA[k]) + 30*365.25
              }
              
              if(is.na(TEMPO_SERV_PUB) != TRUE &&
                 is.na(TEMPO_CARREIRA) != TRUE) {
                
                if(apos_serv_pub >= 35 && 
                   apos_tempo_carreira >= 30) {
                  
                  condicao = TRUE
                  ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                  cargos_homens_oficiais[[i]]$ANO_APOSENTADORIA[k] = seq.Date(ano_aposentadoria, 
                                                                            by = "2 years", 
                                                                            length.out = 2)[2] # adicionando 2 anos na data de aposentadoria
                }
                
              } else condicao = TRUE
            
          }
          
          
        } else {
          
          condicao = TRUE
          cargos_homens_oficiais[[i]]$ANO_APOSENTADORIA[k] = seq.Date(as.Date("2021-12-31"), 
                                                                    by = "2 years", 
                                                                    length.out = 2)[2]
          
        }
        
      }
      
      condicao = FALSE
      
    }
  }
}


masculino_praca = bind_rows(cargos_homens_oficiais)
