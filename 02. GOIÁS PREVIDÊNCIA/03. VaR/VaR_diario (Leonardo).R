#Calculando os retornos dos fundos. Verifique se a data do informe diario esta de acordo
#com o ultimo informe diario publicado. Caso nao esteja, atualize o periodo no script Fundos.R
source("Z:/GERENCIA/INVESTIMENTOS/11. PROJETO/3 - VaR/Retornos.R")

#------------------------------------------------------------------------------#

#Para calcular o VaR e necessario antes fazer um teste de normalidade para verificar 
#se os retornos de cada fundo se aproximam de uma distribuicao normal. Caso a resposta seja positiva, 
#utiliza-se o calculo do VaR parametrico (gaussiano), caso contrário é utilizado o
#VaR historico. O teste de normalidade utilizado sera o teste Shapiro-Wilk, onde:
#H0: os dados seguem a distribuicao normal
#Ha: os dados nao seguem a distribuicao normal

teste = c()


for(i in 2:length(retornos)) {
   
  teste[i-1] = shapiro.test(retornos[[i]])$p.value
   
}

#Transformando os retornos diarios em serie temporal, onde os nomes das linhas serao
#as datas.
datas = retornos$DT_COMPTC
apenas_retornos = as.matrix(retornos[, 2:39])
retornos_xts = xts(apenas_retornos, order.by = datas)

#Determine o nivel de significancia. Por conveniencia do mercado, o nivel de significancia
#mais utilizado e o de 5% (consequentemente, o nivel de confianca e de 95%).
nivel_significancia = 0.05

#Calculando o VaR de acordo com o teste de hipotese feito para cada fundo. Aqui sera criado
#uma matriz de uma linha onde o numero de colunas estara de acordo com o numero de fundos utilizados.

var = matrix(nrow = 1, ncol = length(teste))

for(i in 1:length(teste)) {
  
  if(teste[i] <= 0.05 || is.na(teste[i])) {
    #VaR nao parametrico (os resultados estao em porcentagem)
    quantil[,i] = quantile(retornos_xts[, i], nivel_significancia, na.rm = TRUE)
    var[,i] = mean(retornos_xts[,i]) - quantil[,i]
    
  } else {
    #VaR parametrico (os resultados estao em porcentagem)
    media = mean(retornos_xts[,i], na.rm = TRUE)
    desvio_padrao = sd(retornos_xts[,i], na.rm = TRUE)
    quantil[,i] = qnorm(nivel_significancia, mean = media, sd = desvio_padrao)
    var[,i] = media - quantil[,i]
    
  }
  
}
colnames(var) = colnames(retornos_xts)

#Os valores do VaR estao no formato de porcentagem e calcula a perda minima esperada
#em um dia. Para saber o valor do VaR em termos monetarios, multiplique o resultado pelo valor do investimento.


#Construindo o grafico da densidade dos retornos de um fundo e seu respectivo VaR.
#Os graficos serao salvos na pasta "Graficos", que esta contida dentro da pasta "VaR".

for(i in 1:length(CNPJs$CNPJ)) {
  
  caminho = paste0("Z:/GERENCIA/INVESTIMENTOS/11. PROJETO/3 - VaR/Graficos/VaR diario/grafico_", i,".pdf")
  fundo_cnpj = colnames(var)[i]
  retornos_do_fundo = retornos[, fundo_cnpj]
  q = quantile(retornos[, fundo_cnpj], nivel_significancia, na.rm = TRUE)
  x = ggplot(data.frame(x = retornos[, fundo_cnpj]), aes(x = x)) +
    geom_density() +
    geom_vline(aes(xintercept = q, color="Quantil")) + scale_color_manual(values = ("Quantil" = "red")) + labs(color = "") +
    ggtitle(paste("Densidade dos retornos diarios do fundo", fundo_cnpj)) +
    xlab("Retorno diario") + ylab("Densidade") +
    labs(subtitle = paste("VaR", (1-nivel_significancia)*100,"%"),
         caption = "Dados: CVM | Elaboração: GPREV")
  pdf(caminho)
  print(x)
  dev.off()
  
}

var_final = var %>%
  t() %>%
  as.data.frame() %>%
  rename(VaR = V1) %>%
  rownames_to_column(var = "CNPJs") %>%
  as.data.frame()

  
write.xlsx(var_final,"Z:/GERENCIA/INVESTIMENTOS/11. PROJETO/3 - VaR/VaR_diario.xlsx")
