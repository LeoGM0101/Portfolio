rm(list=ls())

install.packages("moments")
install.packages("tidyquant")
install.packages("tidyverse")
install.packages("timetk")
install.packages("tibbletime")
install.packages("broom")
install.packages("quantmod")
install.packages("ggplot2")
install.packages("plotly",dependencies = T)
install.packages("httr",dependencies = T)
install.packages("magrittr",dependencies = T)

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
                     from = "2020-04-20",
                     to = "2021-11-01",
                     auto.assign = TRUE,
                     warnings = FALSE) %>%
  map(~Ad(get(.))) %>%
  reduce(merge) %>%
  'colnames<-'(symbols)

FHER3.SA = na.omit(FHER3.SA)
SLCE3.SA = na.omit(SLCE3.SA)

#-----------------------------Retorno Esperado e mediana-----------------------#

median(FHER3.SA$FHER3.SA.Adjusted)
mean(FHER3.SA$FHER3.SA.Adjusted)


median(SLCE3.SA$SLCE3.SA.Adjusted)
mean(SLCE3.SA$SLCE3.SA.Adjusted)

#------------------------------------Volatilidade------------------------------#

sd(FHER3.SA$FHER3.SA.Adjusted)
sd(SLCE3.SA$SLCE3.SA.Adjusted)

#--------------------------------------Quantil---------------------------------#

quantile(FHER3.SA$FHER3.SA.Adjusted)
quantile(SLCE3.SA$SLCE3.SA.Adjusted)

#------------------------------------------------------------------------------#
fit<-density(FHER3.SA$FHER3.SA.Adjusted)

hist(dados$FHER3.SA,
     col = "lightblue",
     main = "Fertilizantes Heringer S.A. - Preço Ajustado",
     xlab = "Preço de fechamento ajustado", ylab = "Frequência",
     breaks = 20)

hist(SLCE3.SA$SLCE3.SA.Adjusted,
     col = "lightblue",
     main = "SLC Agrícola S.A. - Preço Ajustado",
     xlab = "Preço de fechamento ajustado", ylab = "Frequência",
     breaks = 20)

skewness(FHER3.SA$FHER3.SA.Adjusted)
skewness(SLCE3.SA$SLCE3.SA.Adjusted)


par(mfrow=c(1,2))
plot(FHER3.SA$FHER3.SA.Adjusted, 
     main = "Fertilizantes Heringer S.A. - Preço Ajustado")
plot(SLCE3.SA$SLCE3.SA.Adjusted,
     main = "SLC Agrícola S.A. - Preço Ajustado")

#----------------------------Covariância e Correlação--------------------------#

cov(FHER3.SA$FHER3.SA.Adjusted, SLCE3.SA$SLCE3.SA.Adjusted)
cor(FHER3.SA$FHER3.SA.Adjusted, SLCE3.SA$SLCE3.SA.Adjusted)

#------------------------------------------------------------------------------#