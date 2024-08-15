# Autor: Leonardo Malaquias
rm(list=ls())
library(readxl)
library(tidyverse)
library(tidyr)
library(moments)
library(tseries)
library(trend)
library(lubridate)
library(forecast)
library(stats)
library(lmtest)
library(FinTS)

dados_receita = read_excel("Z:/GERENCIA/DEMANDAS/2024/13.GCOMPREV/02. FONTES/1 - BASE DE DADOS UTILIZADAS/Série Histórica - RO x RI - v4.xlsx", sheet = "RO - Receita")
dados_receita$Referência = as.Date(dados_receita$Referência)

# ------------ #
 
# Quantitativo
dados_quant = subset(dados_receita, Referência > "2014-01-01" & Referência < "2019-09-01")
dados_quant$Quant.= as.numeric(dados_quant$Quant.)
serie = ts(dados_quant$Quant., start = c(2014, 2), frequency = 12)
ts.plot(serie)

testes_estacionariedade = data.frame(`valor_p(teste adf)` = adf.test(serie)$p.value,
                                     `valor_p(teste pp)` = pp.test(serie)$p.value); testes_estacionariedade


testes_tendencia = data.frame(`valor_p(teste ww)` = ww.test(serie)$p.value,
                              `valor_p(teste cs)` = cs.test(serie)$p.value); testes_tendencia

## Decompondo a serie
plot(decompose(serie))



## Suavizacao exponencial
suavizacao = stlf(serie, method = "ets")
summary(suavizacao)
plot(serie)
lines(fitted(suavizacao), col = "red")

## Graficos de autocorrelacao e autocorrelacao parcial
acf(serie)
pacf(serie)


## diferença tendência
ndiffs(serie)

## diferença sazonal
nsdiffs(serie)

## Modelo ARIMA
modelo = auto.arima(serie)
summary(modelo)
plot(serie)
lines(fitted(modelo), col = "blue")

plot(serie)
lines(suavizacao$fitted, col = "red")
lines(modelo$fitted, col = "blue")

suavizacao$model
modelo$aic

## Resíduos dos modelos
resid_exp = residuals(suavizacao)
resid_arima = residuals(modelo)

## Plotando os resíduos
par(mfrow=c(2,2))

plot(resid_exp, main="Resíduos - Suavização Exponencial")
abline(h=0, col="red")
plot(resid_arima, main="Resíduos - ARIMA")
abline(h=0, col="red")

mean(resid_exp)
mean(resid_arima)

## ACF dos resíduos
acf(resid_exp, main="ACF Resíduos - Suavização Exponencial")
acf(resid_arima, main="ACF Resíduos - ARIMA")

Box.test(resid_exp, lag = 1, type = "Ljung-Box") # H0: os residuos sao independentes.
Box.test(resid_arima^2, lag = 1, type = "Ljung-Box") #checkresiduals(modelo)
ArchTest(resid_exp, lags = 12) # H0: os residuos sao homocedasticos.
ArchTest(resid_arima, lags = 12)



# ------------ #

# Receita liquida
dados_rl = dados_receita %>%
  select(Referência, `Receita Líquida`)
dados_rl = na.omit(dados_rl)
dados_rl$`Receita Líquida`= as.numeric(dados_rl$`Receita Líquida`)
serie = ts(dados_rl$`Receita Líquida`, start = c(2010, 1), frequency = 12)
ts.plot(serie)

testes_estacionariedade = data.frame(`valor_p(teste adf)` = adf.test(serie)$p.value,
                                     `valor_p(teste pp)` = pp.test(serie)$p.value); testes_estacionariedade


testes_tendencia = data.frame(`valor_p(teste ww)` = ww.test(serie)$p.value,
                              `valor_p(teste cs)` = cs.test(serie)$p.value); testes_tendencia

## Decompondo a serie
plot(decompose(serie))



## Suavizacao exponencial
suavizacao = stlf(serie, method = "ets")
summary(suavizacao)
plot(serie)
lines(fitted(suavizacao), col = "red")

## Graficos de autocorrelacao e autocorrelacao parcial
acf(serie)
pacf(serie)


## diferença tendência
ndiffs(serie)

## diferença sazonal
nsdiffs(serie)

## Modelo ARIMA
modelo = auto.arima(serie)
summary(modelo)
plot(serie)
lines(fitted(modelo), col = "blue")

plot(serie)
lines(suavizacao$fitted, col = "red")
lines(modelo$fitted, col = "blue")

suavizacao$model
modelo$aic

## Resíduos dos modelos
resid_exp = residuals(suavizacao)
resid_arima = residuals(modelo)

## Plotando os resíduos
par(mfrow=c(2,2))

plot(resid_exp, main="Resíduos - Suavização Exponencial")
abline(h=0, col="red")
plot(resid_arima, main="Resíduos - ARIMA")
abline(h=0, col="red")

mean(resid_exp)
mean(resid_arima)

## ACF dos resíduos
acf(resid_exp, main="ACF Resíduos - Suavização Exponencial")
acf(resid_arima, main="ACF Resíduos - ARIMA")

Box.test(resid_exp, lag = 1, type = "Ljung-Box") # H0: os residuos sao independentes.
Box.test(resid_arima^2, lag = 1, type = "Ljung-Box") #checkresiduals(modelo)
ArchTest(resid_exp, lags = 12) # H0: os residuos sao homocedasticos.
ArchTest(resid_arima, lags = 12)



# ------------ #

# Fluxo Total
dados_ft = dados_receita %>%
  select(Referência, `Fluxo (estoque liquido +passivo liquido - 13)`)
dados_ft = na.omit(dados_ft)
dados_ft$`Fluxo (estoque liquido +passivo liquido - 13)`= as.numeric(dados_ft$`Fluxo (estoque liquido +passivo liquido - 13)`)
serie = ts(dados_ft$`Fluxo (estoque liquido +passivo liquido - 13)`, start = c(2010, 1), frequency = 12)
ts.plot(serie)

testes_estacionariedade = data.frame(`valor_p(teste adf)` = adf.test(serie)$p.value,
                                     `valor_p(teste pp)` = pp.test(serie)$p.value); testes_estacionariedade


testes_tendencia = data.frame(`valor_p(teste ww)` = ww.test(serie)$p.value,
                              `valor_p(teste cs)` = cs.test(serie)$p.value); testes_tendencia

## Decompondo a serie
plot(decompose(serie))



## Suavizacao exponencial
suavizacao = stlf(serie, method = "ets")
summary(suavizacao)
plot(serie)
lines(fitted(suavizacao), col = "red")

## Graficos de autocorrelacao e autocorrelacao parcial
acf(serie)
pacf(serie)


## diferença tendência
ndiffs(serie)

## diferença sazonal
nsdiffs(serie)

## Modelo ARIMA
modelo = auto.arima(serie)
summary(modelo)
plot(serie)
lines(fitted(modelo), col = "blue")

plot(serie)
lines(suavizacao$fitted, col = "red")
lines(modelo$fitted, col = "blue")

suavizacao$model
modelo$aic

## Resíduos dos modelos
resid_exp = residuals(suavizacao)
resid_arima = residuals(modelo)

## Plotando os resíduos
par(mfrow=c(2,2))

plot(resid_exp, main="Resíduos - Suavização Exponencial")
abline(h=0, col="red")
plot(resid_arima, main="Resíduos - ARIMA")
abline(h=0, col="red")

mean(resid_exp)
mean(resid_arima)

## ACF dos resíduos
acf(resid_exp, main="ACF Resíduos - Suavização Exponencial")
acf(resid_arima, main="ACF Resíduos - ARIMA")

Box.test(resid_exp, lag = 1, type = "Ljung-Box") # H0: os residuos sao independentes.
Box.test(resid_arima^2, lag = 1, type = "Ljung-Box") #checkresiduals(modelo)
ArchTest(resid_exp, lags = 12) # H0: os residuos sao homocedasticos.
ArchTest(resid_arima, lags = 12)

