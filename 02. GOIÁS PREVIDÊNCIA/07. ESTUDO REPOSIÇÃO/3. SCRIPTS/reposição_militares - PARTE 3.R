#Script by Leonardo Malaquias
# estudo de reposicao de servidores considerando apenas militares
# Entrada dos clones

rm(list=ls())
library(tidyverse)
library(readxl)
library(openxlsx)


# Data: 07/2024

## funcao que calcula o ano de aposentadoria de cada servidor
source("Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/3. SCRIPTS/reposição_militares - PARTE 1.R")
estrutura_remuneratoria = read_excel("Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/estruturas_remuneratorias_militares_JUN2024.xlsx")

pracas =c("Soldado - Lei 15.668" ,
          "Cabo - Lei 15.668" ,
          "Terceiro Sargento - Lei 15.668" ,
          "Terceiro Sargento - Lei 15.668 - DECISÃO JUDICIAL",
          "Segundo Sargento - Lei 15.668" ,
          "Segundo Sargento - Lei 15.668 - DECISÃO JUDICIAL" ,
          "Primeiro Sargento - Lei 15.668", 
          "Primeiro Sargento - Lei 15.668 - DECISÃO JUDICIAL" ,
          "Subtenente - Lei 15.668")


## Gerando CPF aleatorio 
gerar_cpf = function() {
  
  cpf = sample(0:9, 9, replace = TRUE)
  
  gerar_dv = function(cpf) {
    pesos1 = c(10:2)
    pesos2 = c(11:2)
    
    dv1 = sum(cpf[1:9] * pesos1) %% 11
    dv1 = ifelse(dv1 < 2, 0, 11 - dv1)
    
    dv2 = sum(c(cpf[1:9], dv1) * pesos2) %% 11
    dv2 = ifelse(dv2 < 2, 0, 11 - dv2)
    
    return(c(dv1, dv2))
  }
  
  dv = gerar_dv(cpf)
  cpf_completo = c(cpf, dv)
  cpf_string = paste0(cpf_completo, collapse = "")
  
  cpf_formatado = paste0(substr(cpf_string, 1, 3), ".", 
                  substr(cpf_string, 4, 6), ".", 
                  substr(cpf_string, 7, 9), "-", 
                  substr(cpf_string, 10, 11))
  
  
  return(cpf_formatado)
}

## Gerando matricula aleatoria 
gerar_matricula = function(){
  
  matricula = sprintf("%010d", sample(0:9999999, 1)) #formata o número para ter exatamente 10 digitos. 
                                                     #Caso o numero nao tenha, a funcao preenche com zeros a esquerda.
  return(matricula)
}

## Gerando PIS aleatorio
gerar_pis = function() {
  pis = paste0(sample(0:9, 11, replace = TRUE), collapse = "")
  pis_formatado = paste0(substr(pis, 1, 3), ".", 
                         substr(pis, 4, 8), ".", 
                         substr(pis, 9, 10), "-", 
                         substr(pis, 11, 11))
  return(pis_formatado)
} 



clones = as.data.frame(matrix(ncol = ncol(militares), nrow = nrow(militares)))
names(clones) = names(militares)
datas = grep("^DT_", names(clones), value = TRUE)
clones[datas] = lapply(clones[datas], as.Date)
colunas_mutaveis = c("ID_SERVIDOR_MATRICULA", "ID_SERVIDOR_CPF", "ID_SERVIDOR_PIS_PASEP", "DT_NASC_SERVIDOR",
                     "DT_ING_SERV_PUB", "DT_ING_ENTE", "DT_ING_CARREIRA", "NO_CARREIRA", "DT_ING_CARGO",
                     "NO_CARGO", "VL_BASE_CALCULO", "VL_REMUNERACAO", "VL_CONTRIBUICAO")

## Gerando os clones

clones = militares %>%
  mutate(
    NO_CARREIRA = if_else(
      NO_CARREIRA %in% pracas,
      estrutura_remuneratoria$NOME_DO_CARGO[1],
      estrutura_remuneratoria$NOME_DO_CARGO[2]
    ),
    NO_CARGO = if_else(
      NO_CARREIRA %in% pracas,
      estrutura_remuneratoria$NOME_DO_CARGO[1],
      estrutura_remuneratoria$NOME_DO_CARGO[2]
    ),
    VL_BASE_CALCULO = if_else(
      NO_CARREIRA %in% pracas,
      estrutura_remuneratoria$SALARIO_INICIAL[1],
      estrutura_remuneratoria$SALARIO_INICIAL[2]
    ),
    VL_REMUNERACAO = VL_BASE_CALCULO,
    VL_CONTRIBUICAO = VL_REMUNERACAO * 0.15,
    DT_ING_ENTE = DT_ING_SERV_PUB,
    DT_ING_CARREIRA = DT_ING_SERV_PUB,
    DT_ING_CARGO = DT_ING_SERV_PUB, 
    DT_NASC_SERVIDOR = as.Date(DT_APOSENTADORIA) - lubridate::years(25),
    DT_ING_SERV_PUB = as.Date(DT_APOSENTADORIA) + lubridate::day(1)
  )

for(i in 1:ncol(militares)) {
  
  for(k in 1:nrow(militares)) {
    
    print(paste("clone:", k, "coluna:", i))
    
    if(names(militares[i]) %in% c("NU_TEMPO_RGPS", "NU_TEMPO_RPPS_MUN", "NU_TEMPO_RPPS_EST", "NU_TEMPO_RPPS_FED",
                                  "NU_DEPENDENTES")) {
      clones[k, i] = 0
      
    } else if(!(names(militares[i]) %in% colunas_mutaveis) && 
              !(names(militares[i]) %in% c("NU_TEMPO_RGPS", "NU_TEMPO_RPPS_MUN", "NU_TEMPO_RPPS_EST", "NU_TEMPO_RPPS_FED",
                                           "NU_DEPENDENTES"))) {
      clones[k, i] = militares[k, i]
      
    } else if(names(militares[i]) == "ID_SERVIDOR_MATRICULA") clones[k, i] = gerar_matricula()
    else if(names(militares[i]) == "ID_SERVIDOR_CPF") clones[k, i] = gerar_cpf()
    else if(names(militares[i]) == "ID_SERVIDOR_PIS_PASEP") clones[k, i] = gerar_pis()
    else if((names(militares[i]) == "DT_ING_ENTE" || 
             names(militares[i]) == "DT_ING_CARREIRA" ||
             names(militares[i]) == "DT_ING_CARGO")) clones[k, i] = clones$DT_ING_SERV_PUB[k]
    
    
  }
  
}

#write.xlsx(clones, file="Z:/GERENCIA/ESTUDOS/2024/11. ESTUDO REPOSIÇÃO/3. SCRIPTS/clones.xlsx")

