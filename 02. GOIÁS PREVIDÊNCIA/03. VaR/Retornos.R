#Carregando os fundos de investimento
source("Z:/GERENCIA/INVESTIMENTOS/11. PROJETO/3 - VaR/Fundos/Fundos.R")

#Separando os fundos de acordo com seus respectivos CNPJ's. Cada fundo sera
#armazenado como um elemento da lista.

fundos_separados = fundos %>%
  split(fundos$CNPJ_FUNDO)

#calculando os retornos

retornos = list()

for(i in 1:length(CNPJs$CNPJ)) {
  fundo = fundos_separados[[i]]
  
  #Criando a coluna retorno e preenchendo-a com o valor 0.
  fundo$retorno = numeric(nrow(fundo))
  
  for(k in 2:nrow(fundo)) {
    
    #Caso o valor da quota do dia ou do dia anterior for igual a zero ou igual a
    #NA, o retorno daquele dia sera igual a 0. Caso contrario, o calculo do retorno
    #sera feito normalmente.
    
    if(is.na(fundo$VL_QUOTA[k]) || is.na(fundo$VL_QUOTA[k-1]) || 
       is.null(fundo$VL_QUOTA[k]) || is.null(fundo$VL_QUOTA[k-1])) {
      fundo$retorno[k] = 0
    } else {
      quota = fundo$VL_QUOTA[k]
      quota_ontem = fundo$VL_QUOTA[k-1]
      fundo$retorno[k] = round((quota / quota_ontem) - 1, digits = 10)
    }
    
  }
  retornos[[i]] = fundo
  
}

retornos = lapply(retornos, function(fundo) {
  
  #Transformando a tabela de tal forma que as datas continuem sendo a primeira coluna
  #da tabela e a segunda coluna seja a coluna dos retornos e
  #tenha como nome o CNPJ do fundo em questao.
  
  fundo = dcast(fundo, DT_COMPTC ~ CNPJ_FUNDO, value.var = "retorno")
  return(fundo)
})

#Juntando todos os elementos da lista de retornos de tal forma que a variavel
#"retornos" se transforme em um unico data.frame contendo as datas e os retornos
#de cada fundo. A funcao Reduce serve para fazer uma operacao envolvendo lista de
#vetores e retornar como um valor unico.

retornos = Reduce(function(x, y) full_join(x, y, by = "DT_COMPTC"), retornos)


