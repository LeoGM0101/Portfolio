#Script by Leonardo Malaquias
# considerar apenas os parametros da reserva remunerada
## considerar apenas o tempo de servico publico (35 anos) e de servico militar (30 anos)
## considerar tambem o aumento gradual do tempo de servico para os militares admitidos a partir de 2022

install_and_load = function(package) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package, dependencies = TRUE)
    library(package, character.only = TRUE)
  }
}

install_and_load("tidyverse")
install_and_load("lubridate")

aposentadoria.militares = function(lista_cargos_masculino_praca, lista_cargos_feminino_praca,
                                   lista_cargos_masculino_oficiais, lista_cargos_feminino_oficiais, verbose = FALSE) {
  

  
  condicao = FALSE
  for(i in 1:length(lista_cargos_masculino_praca)) {
    
    lista_cargos_masculino_praca[[i]]$DT_APOSENTADORIA = as.Date(rep(NA, nrow(lista_cargos_masculino_praca[[i]]))) 
    
    if(nrow(lista_cargos_masculino_praca[[i]]) > 0) {
      
      for(k in 1:nrow(lista_cargos_masculino_praca[[i]])) {
        
        while(condicao == FALSE) {
          
          
          data_focal = as.Date("2021/12/31")
          tempo_serv_pub_2021 = as.numeric(difftime(data_focal, lista_cargos_masculino_praca[[i]]$DT_ING_SERV_PUB[k], units = "days") / 365.25)
          tempo_carreira_2021 = as.numeric(difftime(data_focal, lista_cargos_masculino_praca[[i]]$DT_ING_CARREIRA[k], units = "days") / 365.25)
          
          Idade = as.numeric(difftime(Sys.Date(), lista_cargos_masculino_praca[[i]]$DT_NASC_SERVIDOR[k], units = "days") / 365.25)
          TEMPO_SERV_PUB = as.numeric(difftime(Sys.Date(), lista_cargos_masculino_praca[[i]]$DT_ING_SERV_PUB[k], units = "days") / 365.25)
          TEMPO_CARREIRA = as.numeric(difftime(Sys.Date(), lista_cargos_masculino_praca[[i]]$DT_ING_CARREIRA[k], units = "days") / 365.25)
          
          print(paste("tabela:", i, "linha:", k))
          
          if(tempo_serv_pub_2021 < 30) {
            
            if(tempo_carreira_2021 >= 25) {
              
              t_serv = (30 - tempo_serv_pub_2021)*1.17 + 30
              t_car = min((30 - tempo_carreira_2021 * 1.03), 5) + 30
              
              if(is.na(TEMPO_SERV_PUB) != TRUE) {
                
                ano = floor(t_serv)
                mes = round((t_serv - floor(t_serv))*12)
                dia = round(((t_serv - floor(t_serv))*12 - mes)*30) # e necessario usar o round para usar o operador %m+%
                
                apos_serv_pub = as.Date(lista_cargos_masculino_praca[[i]]$DT_ING_SERV_PUB[k]) %m+% 
                  years(ano) %m+% months(mes) %m+% days(dia)
              }
              
              if(is.na(TEMPO_CARREIRA) != TRUE) {
                
                ano = floor(t_car)
                mes = round((t_car - floor(t_car))*12)
                dia = round(((t_car - floor(t_car))*12 - mes)*30)
                
                apos_tempo_carreira = as.Date(lista_cargos_masculino_praca[[i]]$DT_ING_CARREIRA[k]) %m+% 
                  years(ano) %m+% months(mes) %m+% days(dia)
              }
              
              if(is.na(TEMPO_SERV_PUB) != TRUE &&
                 is.na(TEMPO_CARREIRA) != TRUE) {
                
                condicao = TRUE
                ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                lista_cargos_masculino_praca[[i]]$DT_APOSENTADORIA[k] = seq.Date(ano_aposentadoria, 
                                                                            by = "2 years", 
                                                                            length.out = 2)[2] # adicionando 2 anos na data de aposentadoria
                
                
              } else condicao = TRUE
              
            } else if(tempo_carreira_2021 < 25) {
              
              
              if(is.na(TEMPO_SERV_PUB) != TRUE) {
                apos_serv_pub = seq.Date(as.Date(lista_cargos_masculino_praca[[i]]$DT_ING_SERV_PUB[k]),
                                         by = "35 years",
                                         length.out = 2)[2]
              }
              
              apos_tempo_carreira = lista_cargos_masculino_praca[[i]]$NU_ANO[k]
              if(is.na(TEMPO_CARREIRA) != TRUE) {
                apos_tempo_carreira = seq.Date(as.Date(lista_cargos_masculino_praca[[i]]$DT_ING_CARREIRA[k]),
                                               by = "30 years",
                                               length.out = 2)[2]
              }
              
              if(is.na(TEMPO_SERV_PUB) != TRUE &&
                 is.na(TEMPO_CARREIRA) != TRUE) {
                
                if(apos_serv_pub >= 35 && 
                   apos_tempo_carreira >= 30) {
                  
                  condicao = TRUE
                  ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                  lista_cargos_masculino_praca[[i]]$DT_APOSENTADORIA[k] = seq.Date(ano_aposentadoria, 
                                                                              by = "2 years", 
                                                                              length.out = 2)[2] # adicionando 2 anos na data de aposentadoria
                }
                
              } else condicao = TRUE
              
            }
            
            
          } else {
            
            condicao = TRUE
            lista_cargos_masculino_praca[[i]]$DT_APOSENTADORIA[k] = seq.Date(as.Date("2021-12-31"), 
                                                                        by = "2 years", 
                                                                        length.out = 2)[2]
            
          }
          
        }
        
        condicao = FALSE
        
      }
    }
  }
  
  
  
  condicao = FALSE
  for(i in 1:length(lista_cargos_feminino_praca)) {
    
    lista_cargos_feminino_praca[[i]]$DT_APOSENTADORIA = as.Date(rep(NA, nrow(lista_cargos_feminino_praca[[i]]))) 
    
    if(nrow(lista_cargos_feminino_praca[[i]]) > 0) {
      
      for(k in 1:nrow(lista_cargos_feminino_praca[[i]])) {
        
        while(condicao == FALSE) {
          
          
          data_focal = as.Date("2021/12/31")
          tempo_serv_pub_2021 = as.numeric(difftime(data_focal, lista_cargos_feminino_praca[[i]]$DT_ING_SERV_PUB[k], units = "days") / 365.25)
          tempo_carreira_2021 = as.numeric(difftime(data_focal, lista_cargos_feminino_praca[[i]]$DT_ING_CARREIRA[k], units = "days") / 365.25)
          
          Idade = as.numeric(difftime(Sys.Date(), lista_cargos_feminino_praca[[i]]$DT_NASC_SERVIDOR[k], units = "days") / 365.25)
          TEMPO_SERV_PUB = as.numeric(difftime(Sys.Date(), lista_cargos_feminino_praca[[i]]$DT_ING_SERV_PUB[k], units = "days") / 365.25)
          TEMPO_CARREIRA = as.numeric(difftime(Sys.Date(), lista_cargos_feminino_praca[[i]]$DT_ING_CARREIRA[k], units = "days") / 365.25)
          
          print(paste("tabela:", i, "linha:", k))
          
          if(tempo_serv_pub_2021 < 30) {
            
            if(tempo_carreira_2021 >= 25) {
              
              t_serv = (30 - tempo_serv_pub_2021)*1.17 + 30
              t_car = min((30 - tempo_carreira_2021 * 1.03), 5) + 30
              
              if(is.na(TEMPO_SERV_PUB) != TRUE) {
                
                ano = floor(t_serv)
                mes = round((t_serv - floor(t_serv))*12)
                dia = round(((t_serv - floor(t_serv))*12 - mes)*30) # e necessario usar o round para usar o operador %m+%
                
                apos_serv_pub = as.Date(lista_cargos_feminino_praca[[i]]$DT_ING_SERV_PUB[k]) %m+% 
                  years(ano) %m+% months(mes) %m+% days(dia)
              }
              
              if(is.na(TEMPO_CARREIRA) != TRUE) {
                
                ano = floor(t_car)
                mes = round((t_car - floor(t_car))*12)
                dia = round(((t_car - floor(t_car))*12 - mes)*30)
                
                apos_tempo_carreira = as.Date(lista_cargos_feminino_praca[[i]]$DT_ING_CARREIRA[k]) %m+% 
                  years(ano) %m+% months(mes) %m+% days(dia)
              }
              
              if(is.na(TEMPO_SERV_PUB) != TRUE &&
                 is.na(TEMPO_CARREIRA) != TRUE) {
                
                condicao = TRUE
                ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                lista_cargos_feminino_praca[[i]]$DT_APOSENTADORIA[k] = seq.Date(ano_aposentadoria, 
                                                                            by = "2 years", 
                                                                            length.out = 2)[2] # adicionando 2 anos na data de aposentadoria
                
                
              } else condicao = TRUE
              
            } else if(tempo_carreira_2021 < 25) {
              
              
              if(is.na(TEMPO_SERV_PUB) != TRUE) {
                apos_serv_pub = seq.Date(as.Date(lista_cargos_feminino_praca[[i]]$DT_ING_SERV_PUB[k]),
                                         by = "35 years",
                                         length.out = 2)[2]
              }
              
              apos_tempo_carreira = lista_cargos_feminino_praca[[i]]$NU_ANO[k]
              if(is.na(TEMPO_CARREIRA) != TRUE) {
                apos_tempo_carreira = seq.Date(as.Date(lista_cargos_feminino_praca[[i]]$DT_ING_CARREIRA[k]),
                                               by = "30 years",
                                               length.out = 2)[2]
              }
              
              if(is.na(TEMPO_SERV_PUB) != TRUE &&
                 is.na(TEMPO_CARREIRA) != TRUE) {
                
                if(apos_serv_pub >= 35 && 
                   apos_tempo_carreira >= 30) {
                  
                  condicao = TRUE
                  ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                  lista_cargos_feminino_praca[[i]]$DT_APOSENTADORIA[k] = seq.Date(ano_aposentadoria, 
                                                                              by = "2 years", 
                                                                              length.out = 2)[2] # adicionando 2 anos na data de aposentadoria
                }
                
              } else condicao = TRUE
              
            }
            
            
          } else {
            
            condicao = TRUE
            lista_cargos_feminino_praca[[i]]$DT_APOSENTADORIA[k] = seq.Date(as.Date("2021-12-31"), 
                                                                        by = "2 years", 
                                                                        length.out = 2)[2]
            
          }
          
        }
        
        condicao = FALSE
        
      }
    }
  }
  
  
  
  ####### OFICIAIS ####### 
  
  condicao = FALSE
  for(i in 1:length(lista_cargos_masculino_oficiais)) {
    
    lista_cargos_masculino_oficiais[[i]]$DT_APOSENTADORIA = as.Date(rep(NA, nrow(lista_cargos_masculino_oficiais[[i]]))) 
    
    if(nrow(lista_cargos_masculino_oficiais[[i]]) > 0) {
      
      for(k in 1:nrow(lista_cargos_masculino_oficiais[[i]])) {
        
        while(condicao == FALSE) {
          
          
          data_focal = as.Date("2021/12/31")
          tempo_serv_pub_2021 = as.numeric(difftime(data_focal, lista_cargos_masculino_oficiais[[i]]$DT_ING_SERV_PUB[k], units = "days") / 365.25)
          tempo_carreira_2021 = as.numeric(difftime(data_focal, lista_cargos_masculino_oficiais[[i]]$DT_ING_CARREIRA[k], units = "days") / 365.25)
          
          Idade = as.numeric(difftime(Sys.Date(), lista_cargos_masculino_oficiais[[i]]$DT_NASC_SERVIDOR[k], units = "days") / 365.25)
          TEMPO_SERV_PUB = as.numeric(difftime(Sys.Date(), lista_cargos_masculino_oficiais[[i]]$DT_ING_SERV_PUB[k], units = "days") / 365.25)
          TEMPO_CARREIRA = as.numeric(difftime(Sys.Date(), lista_cargos_masculino_oficiais[[i]]$DT_ING_CARREIRA[k], units = "days") / 365.25)
          
          print(paste("tabela:", i, "linha:", k))
          
          if(tempo_serv_pub_2021 < 30) {
            
            if(tempo_carreira_2021 >= 25) {
              
              t_serv = (30 - tempo_serv_pub_2021)*1.17 + 30
              t_car = min((30 - tempo_carreira_2021 * 1.03), 5) + 30
              
              if(is.na(TEMPO_SERV_PUB) != TRUE) {
                
                ano = floor(t_serv)
                mes = round((t_serv - floor(t_serv))*12)
                dia = round(((t_serv - floor(t_serv))*12 - mes)*30) # e necessario usar o round para usar o operador %m+%
                
                apos_serv_pub = as.Date(lista_cargos_masculino_oficiais[[i]]$DT_ING_SERV_PUB[k]) %m+% 
                  years(ano) %m+% months(mes) %m+% days(dia)
              }
              
              if(is.na(TEMPO_CARREIRA) != TRUE) {
                
                ano = floor(t_car)
                mes = round((t_car - floor(t_car))*12)
                dia = round(((t_car - floor(t_car))*12 - mes)*30)
                
                apos_tempo_carreira = as.Date(lista_cargos_masculino_oficiais[[i]]$DT_ING_CARREIRA[k]) %m+% 
                  years(ano) %m+% months(mes) %m+% days(dia)
              }
              
              if(is.na(TEMPO_SERV_PUB) != TRUE &&
                 is.na(TEMPO_CARREIRA) != TRUE) {
                
                condicao = TRUE
                ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                lista_cargos_masculino_oficiais[[i]]$DT_APOSENTADORIA[k] = seq.Date(ano_aposentadoria, 
                                                                            by = "2 years", 
                                                                            length.out = 2)[2] # adicionando 2 anos na data de aposentadoria
                
                
              } else condicao = TRUE
              
            } else if(tempo_carreira_2021 < 25) {
              
              
              if(is.na(TEMPO_SERV_PUB) != TRUE) {
                apos_serv_pub = seq.Date(as.Date(lista_cargos_masculino_oficiais[[i]]$DT_ING_SERV_PUB[k]),
                                         by = "35 years",
                                         length.out = 2)[2]
              }
              
              apos_tempo_carreira = lista_cargos_masculino_oficiais[[i]]$NU_ANO[k]
              if(is.na(TEMPO_CARREIRA) != TRUE) {
                apos_tempo_carreira = seq.Date(as.Date(lista_cargos_masculino_oficiais[[i]]$DT_ING_CARREIRA[k]),
                                               by = "30 years",
                                               length.out = 2)[2]
              }
              
              if(is.na(TEMPO_SERV_PUB) != TRUE &&
                 is.na(TEMPO_CARREIRA) != TRUE) {
                
                if(apos_serv_pub >= 35 && 
                   apos_tempo_carreira >= 30) {
                  
                  condicao = TRUE
                  ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                  lista_cargos_masculino_oficiais[[i]]$DT_APOSENTADORIA[k] = seq.Date(ano_aposentadoria, 
                                                                              by = "2 years", 
                                                                              length.out = 2)[2] # adicionando 2 anos na data de aposentadoria
                }
                
              } else condicao = TRUE
              
            }
            
            
          } else {
            
            condicao = TRUE
            lista_cargos_masculino_oficiais[[i]]$DT_APOSENTADORIA[k] = seq.Date(as.Date("2021-12-31"), 
                                                                        by = "2 years", 
                                                                        length.out = 2)[2]
            
          }
          
        }
        
        condicao = FALSE
        
      }
    }
  }
  
  
  
  condicao = FALSE
  for(i in 1:length(lista_cargos_feminino_oficiais)) {
    
    lista_cargos_feminino_oficiais[[i]]$DT_APOSENTADORIA = as.Date(rep(NA, nrow(lista_cargos_feminino_oficiais[[i]]))) 
    
    if(nrow(lista_cargos_feminino_oficiais[[i]]) > 0) {
      
      for(k in 1:nrow(lista_cargos_feminino_oficiais[[i]])) {
        
        while(condicao == FALSE) {
          
          
          data_focal = as.Date("2021/12/31")
          tempo_serv_pub_2021 = as.numeric(difftime(data_focal, lista_cargos_feminino_oficiais[[i]]$DT_ING_SERV_PUB[k], units = "days") / 365.25)
          tempo_carreira_2021 = as.numeric(difftime(data_focal, lista_cargos_feminino_oficiais[[i]]$DT_ING_CARREIRA[k], units = "days") / 365.25)
          
          Idade = as.numeric(difftime(Sys.Date(), lista_cargos_feminino_oficiais[[i]]$DT_NASC_SERVIDOR[k], units = "days") / 365.25)
          TEMPO_SERV_PUB = as.numeric(difftime(Sys.Date(), lista_cargos_feminino_oficiais[[i]]$DT_ING_SERV_PUB[k], units = "days") / 365.25)
          TEMPO_CARREIRA = as.numeric(difftime(Sys.Date(), lista_cargos_feminino_oficiais[[i]]$DT_ING_CARREIRA[k], units = "days") / 365.25)
          
          print(paste("tabela:", i, "linha:", k))
          
          if(tempo_serv_pub_2021 < 30) {
            
            if(tempo_carreira_2021 >= 25) {
              
              t_serv = (30 - tempo_serv_pub_2021)*1.17 + 30
              t_car = min((30 - tempo_carreira_2021 * 1.03), 5) + 30
              
              if(is.na(TEMPO_SERV_PUB) != TRUE) {
                
                ano = floor(t_serv)
                mes = round((t_serv - floor(t_serv))*12)
                dia = round(((t_serv - floor(t_serv))*12 - mes)*30) # e necessario usar o round para usar o operador %m+%
                
                apos_serv_pub = as.Date(lista_cargos_feminino_oficiais[[i]]$DT_ING_SERV_PUB[k]) %m+% 
                  years(ano) %m+% months(mes) %m+% days(dia)
              }
              
              if(is.na(TEMPO_CARREIRA) != TRUE) {
                
                ano = floor(t_car)
                mes = round((t_car - floor(t_car))*12)
                dia = round(((t_car - floor(t_car))*12 - mes)*30)
                
                apos_tempo_carreira = as.Date(lista_cargos_feminino_oficiais[[i]]$DT_ING_CARREIRA[k]) %m+% 
                  years(ano) %m+% months(mes) %m+% days(dia)
              }
              
              if(is.na(TEMPO_SERV_PUB) != TRUE &&
                 is.na(TEMPO_CARREIRA) != TRUE) {
                
                condicao = TRUE
                ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                lista_cargos_feminino_oficiais[[i]]$DT_APOSENTADORIA[k] = seq.Date(ano_aposentadoria, 
                                                                            by = "2 years", 
                                                                            length.out = 2)[2] # adicionando 2 anos na data de aposentadoria
                
                
              } else condicao = TRUE
              
            } else if(tempo_carreira_2021 < 25) {
              
              
              if(is.na(TEMPO_SERV_PUB) != TRUE) {
                apos_serv_pub = seq.Date(as.Date(lista_cargos_feminino_oficiais[[i]]$DT_ING_SERV_PUB[k]),
                                         by = "35 years",
                                         length.out = 2)[2]
              }
              
              apos_tempo_carreira = lista_cargos_feminino_oficiais[[i]]$NU_ANO[k]
              if(is.na(TEMPO_CARREIRA) != TRUE) {
                apos_tempo_carreira = seq.Date(as.Date(lista_cargos_feminino_oficiais[[i]]$DT_ING_CARREIRA[k]),
                                               by = "30 years",
                                               length.out = 2)[2]
              }
              
              if(is.na(TEMPO_SERV_PUB) != TRUE &&
                 is.na(TEMPO_CARREIRA) != TRUE) {
                
                if(apos_serv_pub >= 35 && 
                   apos_tempo_carreira >= 30) {
                  
                  condicao = TRUE
                  ano_aposentadoria = max(apos_serv_pub, apos_tempo_carreira)
                  lista_cargos_feminino_oficiais[[i]]$DT_APOSENTADORIA[k] = seq.Date(ano_aposentadoria, 
                                                                              by = "2 years", 
                                                                              length.out = 2)[2] # adicionando 2 anos na data de aposentadoria
                }
                
              } else condicao = TRUE
              
            }
            
            
          } else {
            
            condicao = TRUE
            lista_cargos_feminino_oficiais[[i]]$DT_APOSENTADORIA[k] = seq.Date(as.Date("2021-12-31"), 
                                                                        by = "2 years", 
                                                                        length.out = 2)[2]
            
          }
          
        }
        
        condicao = FALSE
        
      }
    }
  }
  
  
  
  masculino_praca = bind_rows(lista_cargos_masculino_praca)
  feminino_praca = bind_rows(lista_cargos_feminino_praca)
  
  masculino_oficial = bind_rows(lista_cargos_masculino_oficiais)
  feminino_oficial = bind_rows(lista_cargos_feminino_oficiais)
  
  tabelas = list(masculino_praca, feminino_praca, masculino_oficial, feminino_oficial)
  return(tabelas)
   
}
