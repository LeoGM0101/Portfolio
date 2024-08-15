rm(list=ls())
library(ggplot2)
library(forecast)
library(readxl)

setwd("Z:/GERENCIA/ESTUDOS/2024/04. ÍNDICES DE MENSALIZAÇÃO/02. CÁLCULO/RPPS-FIN")

despesa_realizada = read_excel("despesa_realizada.xlsx")

ggplot(despesa_realizada, aes(x = mês, y = despesa)) + 
  geom_line() +
  labs(title = "Despesa realizada", x = "Mês", y = "Despesa")

summary(despesa_realizada$despesa)

decomp <- decompose(ts(despesa_realizada$despesa, frequency = 12)) # assumindo uma frequência sazonal mensal
plot(decomp)