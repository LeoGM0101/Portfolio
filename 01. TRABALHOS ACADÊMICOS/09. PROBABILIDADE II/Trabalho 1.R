rm(list=ls())


library(moments)
library(tidyquant)
library(tidyverse)
library(timetk)
library(tibbletime)
library(broom)
library(quantmod)
library(magrittr)
library(plotly)


symbols = c("FHER3.SA","SLCE3.SA")
prices = getSymbols(symbols, src='yahoo',
                    from = "2021-01-01",
                    to = "2021-11-01",
                    auto.assign = TRUE,
                    warnings = FALSE) %>%
  map(~Ad(get(.))) %>%
  reduce(merge) %>%
  'colnames<-'(symbols)

dados = na.omit(prices)

#-----------------------------Retorno Esperado e mediana-----------------------#

median(dados$FHER3.SA)
mean(dados$FHER3.SA)


median(dados$SLCE3.SA)
mean(dados$SLCE3.SA)

#------------------------------------Volatilidade------------------------------#

sd(dados$FHER3.SA)
sd(dados$SLCE3.SA)

#--------------------------------------Quantil---------------------------------#

quantile(dados$FHER3.SA)
quantile(dados$SLCE3.SA)

#------------------------------------------------------------------------------#
qplot(dados$FHER3.SA,
      geom="histogram",
      binwidth = 5,  
      main = "                           Histograma - Fertilizantes Heringer S.A.", 
      xlab = "Preço de fechamento",  
      fill=I("blue"), 
      col=I("red"), 
      alpha=I(.2),
      xlim=c(0,50))


qplot(dados$SLCE3.SA,
      geom="histogram",
      binwidth = 5,  
      main = "                              Histograma - SLC Agrícola S.A.", 
      xlab = "Preço de fechamento",  
      fill=I("blue"), 
      col=I("red"), 
      alpha=I(.2),
      xlim=c(0,50))

skewness(dados$FHER3.SA)
skewness(dados$SLCE3.SA)


par(mfrow=c(1,2))
plot(FHER3.SA$FHER3.SA.Adjusted, 
     main = "\n\n              Fertilizantes Heringer")
plot(SLCE3.SA$SLCE3.SA.Adjusted,
     main = "\n\n                SLC Agrícola S.A")

3.29 / 18.81
27.92 / 43.58

#----------------------------CovariÃ¢ncia e CorrelaÃ§Ã£o--------------------------#

cov(dados$FHER3.SA, dados$SLCE3.SA)
cor(dados$FHER3.SA, dados$SLCE3.SA)
?cor

qplot(dados$FHER3.SA, dados$SLCE3.SA,
      geom="auto",
      binwidth = 5,  
      main = "                                       Gráfico de dispersão", 
      xlab = "FHER3.SA", 
      ylab = "SLCE3.SA",
      col=I("red"), 
      alpha=I(.5),
      xlim=c(0,50))


ggplot(data = dados, aes(FHER3.SA, SLCE3.SA)) +
  geom_point(aes(colour = SLCE3.SA,)) +
  labs(x = "Fertilizantes Heringer (PreÃ§o Ajustado)",
       y = "SLC AgrÃ­cola (PreÃ§o Ajustado)", color = NULL)


#------------------------------------------------------------------------------#

?qplot
