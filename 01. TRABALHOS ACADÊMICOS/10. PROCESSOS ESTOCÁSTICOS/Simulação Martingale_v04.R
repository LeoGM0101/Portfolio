library(tidyverse)
rm(list = ls())
set.seed(2023)

martingale = function(max_jogadas){
  #Condições iniciais
  dinheiro = 100
  aposta = 1
  i = 1

  while (dinheiro < 200 && dinheiro > 0 && i < max_jogadas){
    #-1: preto, 1: vermelho
    color = sample(c(-1, 1), 1, replace = T, c(19/37, 18/37))
    if (color == 1){
      #Ganhou!
      dinheiro = dinheiro + aposta
      aposta = 1
    } else {
      #Perdeu!
      dinheiro = dinheiro - aposta
      aposta = aposta * 2
    }
    i = i + 1
  }
  # Send back the amount winnings/losses
  return(dinheiro)
}

# Simulações

n = 1000
resultados = c()


#15 jogadas
for(i in 1:n) {
  resultados[i] = martingale(15)
}

#Estatísticas descritivas

tabela_resultados = data.frame(resultados)
tabela_final = tabela_resultados %>%
  mutate("sucesso ou fracasso" = ifelse(resultados >= 100, "sucesso", "fracasso"))
sucessos = filter(tabela_resultados, resultados >= 100)
fracassos = filter(tabela_resultados, resultados < 100)

summary(sucessos)
IQR(sucessos$resultados) #amplitude interquartil
summary(fracassos)
IQR(fracassos$resultados)

ggplot(tabela_final, aes(y = resultados, fill = `sucesso ou fracasso`)) +
  geom_boxplot() +
  ggtitle("Processo de Martingale com aposta ilimitada - 15 jogadas") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(), 
        plot.title = element_text(hjust = 0.5))

x = ggplot(sucessos, aes(x = resultados)) +
  geom_histogram(color = "blue", fill = "lightblue") +
  geom_vline(aes(xintercept = mean(resultados)),
             color="blue", linetype="dashed", size=1) +
  ggtitle("Processo de Martingale com aposta ilimitada - 15 jogadas (sucesso)") +
  theme(plot.title = element_text(hjust = 0.5))

y = ggplot(fracassos, aes(x = resultados)) +
  geom_histogram(color = "red4", fill = "red2") +
  geom_vline(aes(xintercept = mean(resultados)),
             color="red", linetype="dashed", size=1) +
  ggtitle("Processo de Martingale com aposta ilimitada - 15 jogadas (fracasso)") +
  theme(plot.title = element_text(hjust = 0.5))

gridExtra::grid.arrange(x, y)



#100 jogadas
for(i in 1:n) {
  resultados[i] = martingale(100)
}

#Estatísticas descritivas

tabela_resultados = data.frame(resultados)
tabela_final = tabela_resultados %>%
  mutate("sucesso ou fracasso" = ifelse(resultados >= 100, "sucesso", "fracasso"))
sucessos = filter(tabela_resultados, resultados >= 100)
fracassos = filter(tabela_resultados, resultados < 100)

summary(sucessos)
IQR(sucessos$resultados) #amplitude interquartil
summary(fracassos)
IQR(fracassos$resultados)

ggplot(tabela_final, aes(y = resultados, fill = `sucesso ou fracasso`)) +
  geom_boxplot() +
  ggtitle("Processo de Martingale com aposta ilimitada - 100 jogadas") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(), 
        plot.title = element_text(hjust = 0.5))


x = ggplot(sucessos, aes(x = resultados)) +
  geom_histogram(color = "blue", fill = "lightblue") +
  geom_vline(aes(xintercept = mean(resultados)),
             color="blue", linetype="dashed", size=1) +
  ggtitle("Processo de Martingale com aposta ilimitada - 100 jogadas (sucesso)") +
  theme(plot.title = element_text(hjust = 0.5))

y = ggplot(fracassos, aes(x = resultados)) +
  geom_histogram(color = "red4", fill = "red2") +
  geom_vline(aes(xintercept = mean(resultados)),
             color="red", linetype="dashed", size=1) +
  ggtitle("Processo de Martingale com aposta ilimitada - 100 jogadas (fracasso)") +
  theme(plot.title = element_text(hjust = 0.5))

gridExtra::grid.arrange(x, y)


#------------------------------------------------------------------------------#
#Processo de Martingale com aposta limitada

martingale_2 = function(max_jogadas, max_aposta){
  #Condições iniciais
  dinheiro = 100
  aposta = 1
  i = 1
  
  while (dinheiro < 200 && dinheiro > 0 && i < max_jogadas){
    #-1: preto, 1: vermelho
    color = sample(c(-1, 1), 1, replace = T, c(19/37, 18/37))
    if (color == 1){
      #Ganhou!
      dinheiro = dinheiro + aposta
      aposta = 1
    } else {
      #Perdeu!
      dinheiro = dinheiro - aposta
      if(aposta*2 > max_aposta) {
        aposta = aposta
      } else aposta = aposta*2
    }
    i = i + 1
  }
  # Send back the amount winnings/losses
  return(dinheiro)
}

# Simulações

#15 jogadas
for(i in 1:n) {
  resultados[i] = martingale_2(15, 16)
}

#Estatísticas descritivas

tabela_resultados = data.frame(resultados)
tabela_final = tabela_resultados %>%
  mutate("sucesso ou fracasso" = ifelse(resultados >= 100, "sucesso", "fracasso"))
sucessos = filter(tabela_resultados, resultados >= 100)
fracassos = filter(tabela_resultados, resultados < 100)

summary(sucessos)
IQR(sucessos$resultados) #amplitude interquartil
summary(fracassos)
IQR(fracassos$resultados)

ggplot(tabela_final, aes(y = resultados, fill = `sucesso ou fracasso`)) +
  geom_boxplot() +
  ggtitle("Processo de Martingale com limite de aposta - 15 jogadas") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(), 
        plot.title = element_text(hjust = 0.5))

x = ggplot(sucessos, aes(x = resultados)) +
  geom_histogram(color = "blue", fill = "lightblue") +
  geom_vline(aes(xintercept = mean(resultados)),
             color="blue", linetype="dashed", size=1) +
  ggtitle("Processo de Martingale com limite de aposta - 15 jogadas (sucesso)") +
  theme(plot.title = element_text(hjust = 0.5))

y = ggplot(fracassos, aes(x = resultados)) +
  geom_histogram(color = "red4", fill = "red2") +
  geom_vline(aes(xintercept = mean(resultados)),
             color="red", linetype="dashed", size=1) +
  ggtitle("Processo de Martingale com limite de aposta - 15 jogadas (fracasso)") +
  theme(plot.title = element_text(hjust = 0.5))

gridExtra::grid.arrange(x, y)




#100 jogadas
for(i in 1:n) {
  resultados[i] = martingale_2(100, 16)
}

#Estatísticas descritivas

tabela_resultados = data.frame(resultados)
tabela_final = tabela_resultados %>%
  mutate("sucesso ou fracasso" = ifelse(resultados >= 100, "sucesso", "fracasso"))
sucessos = filter(tabela_resultados, resultados >= 100)
fracassos = filter(tabela_resultados, resultados < 100)

summary(sucessos)
IQR(sucessos$resultados) #amplitude interquartil
summary(fracassos)
IQR(fracassos$resultados)

ggplot(tabela_final, aes(y = resultados, fill = `sucesso ou fracasso`)) +
  geom_boxplot() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  ggtitle("Processo de Martingale com limite de aposta - 100 jogadas") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(), 
        plot.title = element_text(hjust = 0.5))

x = ggplot(sucessos, aes(x = resultados)) +
  geom_histogram(color = "blue", fill = "lightblue") +
  geom_vline(aes(xintercept = mean(resultados)),
             color="blue", linetype="dashed", size=1) +
  ggtitle("Processo de Martingale com limite de aposta - 100 jogadas (sucesso)") +
  theme(plot.title = element_text(hjust = 0.5))

y = ggplot(fracassos, aes(x = resultados)) +
  geom_histogram(color = "red4", fill = "red2") +
  geom_vline(aes(xintercept = mean(resultados)),
             color="red", linetype="dashed", size=1) +
  ggtitle("Processo de Martingale com limite de aposta - 100 jogadas (fracasso)") +
  theme(plot.title = element_text(hjust = 0.5))

gridExtra::grid.arrange(x, y)
