rm(list=ls())
library(readxl)
library(tidyverse)
library(corrplot)
library(olsrr)
library(lmtest)
library(car)
library(stats)
library(performance)
dados = read_excel("C:/Users/leona/Documents/Estatística/8 Semestre/Modelos de Regressão/base de dados trabalho/data_akbilgic_2.xlsx")
str(dados)

#------------------------------------------------------------------------------#
#Checando a linearidade
variaveis = dados %>%
  select(EM, SP, NIKKEI, FTSE)

plot(x = variaveis$SP, y = variaveis$EM)
abline(lm(EM ~ SP, data = variaveis), col = "red")
plot(x = variaveis$FTSE, y = variaveis$EM)
abline(lm(EM ~ FTSE, data = variaveis), col = "red")
plot(x = variaveis$NIKKEI, y = variaveis$EM)
abline(lm(EM ~ NIKKEI, data = variaveis), col = "red")

#------------------------------------------------------------------------------#
#Aplicando o Modelo de Regressao Linear Multipla

modelo = lm(EM ~ SP + FTSE + NIKKEI, data = variaveis)
summary(modelo)
anova(modelo)

#------------------------------------------------------------------------------#
#Analise dos Residuos


#Testes para a Normalidade dos Residuos
ks.test(modelo$residuals, "pnorm", mean=mean(modelo$residuals), sd=sd(modelo$residuals))
ols_plot_resid_hist(modelo) #histograma dos residuos

#Teste para a heterocedasticidade dos residuos
par(mfrow=c(2,2))
plot(modelo)
lmtest::bptest(modelo) #H0: os residuos sao homocesdasticos
check_heteroscedasticity(modelo)

#Teste para a autocorrelacao dos residuos
par(mfrow=c(1,1))
acf(modelo$residuals, type = "correlation")
lmtest::dwtest(modelo) #H0: nao existe autocorrelaçao

check_model(modelo)

#------------------------------------------------------------------------------#
#Multicolinearidade

corrplot(cor(variaveis), method = "number")
vif(modelo)

#------------------------------------------------------------------------------#
