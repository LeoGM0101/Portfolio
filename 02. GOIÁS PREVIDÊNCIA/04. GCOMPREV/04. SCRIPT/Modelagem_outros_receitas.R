#Script by Leonardo Malaquias
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
library(openxlsx)
library(aTSA)

dados_receita = read_excel("Z:/GERENCIA/DEMANDAS/2024/13.GCOMPREV/02. FONTES/1 - BASE DE DADOS UTILIZADAS/Série Histórica - RO x RI - v5.xlsx", sheet = "RO - Receita")
dados_receita$Referência = as.Date(dados_receita$Referência)

# ------------ #
 
# Quantitativo
dados_quant = subset(dados_receita, Referência > "2014-01-01" & Referência < "2019-09-01") %>%
  select(Referência, Quant.)
dados_quant$Quant.= as.numeric(dados_quant$Quant.)
serie = ts(dados_quant$Quant., start = c(2014, 2), frequency = 12)
ts.plot(serie)

testes_estacionariedade = data.frame(`valor_p(teste adf)` = adf.test(serie)$p.value); testes_estacionariedade


testes_tendencia = data.frame(`valor_p(teste ww)` = ww.test(serie)$p.value,
                              `valor_p(teste cs)` = cs.test(serie)$p.value); testes_tendencia

## Decompondo a serie
plot(decompose(serie))



## Suavizacao exponencial
suavizacao_quant = HoltWinters(serie)
suavizacao_2_quant = ets(serie)
summary(suavizacao_quant)
summary(suavizacao_2_quant)
plot(serie)
lines(fitted(suavizacao_quant)[, 1], col = "red")
lines(fitted(suavizacao_2_quant), col = "purple")

## Graficos de autocorrelacao e autocorrelacao parcial
acf(serie)
pacf(serie)


## diferença tendência
ndiffs(serie)

## diferença sazonal
nsdiffs(serie)

## Modelo ARIMA
modelo_quant = auto.arima(serie)
modelo_quant = arima(serie, order = c(1, 1, 0))
summary(modelo_quant)
plot(serie)
lines(fitted(modelo_quant), col = "blue")

plot(serie)
lines(fitted(suavizacao_quant)[, 1], col = "red")
lines(modelo_quant$fitted, col = "blue")

suavizacao_quant$model
modelo_quant$aic

## Resíduos dos modelos
resid_exp = residuals(suavizacao_quant) #Holt-Winters
resid_exp2 = residuals(suavizacao_2_quant)
resid_arima = residuals(modelo_quant)

## Plotando os resíduos
par(mfrow=c(2,2))

plot(resid_exp, main="Resíduos - Suavização Exponencial")
abline(h=0, col="red")
plot(resid_arima, main="Resíduos - ARIMA")
abline(h=0, col="red")

mean(resid_exp)
mean(resid_exp2)
mean(resid_arima) 

par(mfrow=c(1,1))

## ACF dos resíduos
acf(resid_exp, main="ACF Resíduos - Suavização Exponencial")
acf(resid_arima, main="ACF Resíduos - ARIMA")

checkresiduals(suavizacao_quant) # H0: os residuos sao independentes
checkresiduals(suavizacao_2_quant)
checkresiduals(modelo_quant)

ArchTest(resid_exp) # H0: os residuos sao homocedasticos.
ArchTest(resid_exp2)
ArchTest(resid_arima)

shapiro.test(resid_exp) # H0: os residuos seguem uma normal
shapiro.test(resid_exp2)
shapiro.test(resid_arima)

mae_hw = mean(abs(residuals(suavizacao_quant))); mae_hw
mae_ets = mean(abs(residuals(suavizacao_2_quant))); mae_ets
mae_arima = mean(abs(residuals(modelo_quant))); mae_arima



# ------------ #

# Receita liquida
dados_rl = dados_receita %>%
  select(Referência, `Receita Líquida`)
dados_rl = na.omit(dados_rl)
dados_rl$`Receita Líquida`= as.numeric(dados_rl$`Receita Líquida`)
serie = ts(dados_rl$`Receita Líquida`, start = c(2010, 2), frequency = 12)
ts.plot(serie)

testes_estacionariedade = data.frame(`valor_p(teste adf)` = adf.test(serie)$p.value); testes_estacionariedade


testes_tendencia = data.frame(`valor_p(teste ww)` = ww.test(serie)$p.value,
                              `valor_p(teste cs)` = cs.test(serie)$p.value); testes_tendencia

## Decompondo a serie
plot(decompose(serie))



## Suavizacao exponencial
suavizacao_rl = HoltWinters(serie)
suavizacao_2_rl = ets(serie)
summary(suavizacao_rl)
summary(suavizacao_2_rl)
plot(serie)
lines(fitted(suavizacao_rl)[, 1], col = "red")
lines(fitted(suavizacao_2_rl), col = "purple")

## Graficos de autocorrelacao e autocorrelacao parcial
acf(serie)
pacf(serie)


## diferença tendência
ndiffs(serie)

## diferença sazonal
nsdiffs(serie)

## Modelo ARIMA
modelo_rl = auto.arima(serie)
summary(modelo_rl)
plot(serie)
lines(fitted(modelo_rl), col = "blue")

plot(serie)
lines(fitted(suavizacao_rl)[, 1], col = "red")
lines(modelo_rl$fitted, col = "blue")

suavizacao_rl$model
modelo_rl$aic

## Resíduos dos modelos
resid_exp = residuals(suavizacao_rl)
resid_exp2 = residuals(suavizacao_2_rl)
resid_arima = residuals(modelo_rl)

## Plotando os resíduos
par(mfrow=c(2,2))

plot(resid_exp, main="Resíduos - Suavização Holt-Winters")
abline(h=0, col="red")
plot(resid_exp2, main="Resíduos - Suavização Exponencial")
abline(h=0, col="purple")
plot(resid_arima, main="Resíduos - ARIMA")
abline(h=0, col="blue")

mean(resid_exp)
mean(resid_exp2)
mean(resid_arima)

par(mfrow=c(1,1))

## ACF dos resíduos
acf(resid_exp, main="ACF Resíduos - Suavização Exponencial")
acf(resid_arima, main="ACF Resíduos - ARIMA")

modelo_rl = arima(serie, order = c(1, 1, 1))
checkresiduals(suavizacao_rl) # H0: Os residuos sao independentes.
checkresiduals(suavizacao_2_rl) 
checkresiduals(modelo_rl) 

ArchTest(resid_exp) # H0: os residuos sao homocedasticos.
ArchTest(resid_exp2)
ArchTest(resid_arima)

shapiro.test(resid_exp) # H0: os residuos seguem uma normal
shapiro.test(resid_exp2)
shapiro.test(resid_arima)

mae_hw = mean(abs(residuals(suavizacao_rl))); mae_hw
mae_ets = mean(abs(residuals(suavizacao_2_rl))); mae_ets
mae_arima = mean(abs(residuals(modelo))); mae_arima


# ------------ #

# Fluxo Total
dados_ft = dados_receita %>%
  select(Referência, `Fluxo (estoque liquido +passivo liquido - 13)`)
dados_ft = na.omit(dados_ft)
dados_ft$`Fluxo (estoque liquido +passivo liquido - 13)`= as.numeric(dados_ft$`Fluxo (estoque liquido +passivo liquido - 13)`)
dados_ft$`Fluxo (estoque liquido +passivo liquido - 13)`= sqrt(dados_ft$`Fluxo (estoque liquido +passivo liquido - 13)`)
serie = ts(dados_ft$`Fluxo (estoque liquido +passivo liquido - 13)`, start = c(2010, 1), frequency = 12)
ts.plot(serie)

testes_estacionariedade = data.frame(`valor_p(teste adf)` = adf.test(serie)$p.value); testes_estacionariedade


testes_tendencia = data.frame(`valor_p(teste ww)` = ww.test(serie)$p.value,
                              `valor_p(teste cs)` = cs.test(serie)$p.value); testes_tendencia

## Decompondo a serie
plot(decompose(serie)) 



## Suavizacao exponencial
suavizacao_ft = HoltWinters(serie)
suavizacao_2_ft = ets(serie)
summary(suavizacao_ft)
summary(suavizacao_2_ft)
plot(serie)
lines(fitted(suavizacao_ft)[, 1], col = "red")
lines(fitted(suavizacao_2_ft), col = "purple")

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
lines(fitted(suavizacao_ft)[, 1], col = "red")
lines(suavizacao_2_ft$fitted, col = "purple")
lines(modelo$fitted, col = "blue")

suavizacao_2_ft$model
modelo$aic

## Resíduos dos modelos
resid_exp = residuals(suavizacao_ft)
resid_exp2 = residuals(suavizacao_2_ft)
resid_arima = residuals(modelo)

## Plotando os resíduos
par(mfrow=c(2,2))

plot(resid_exp, main="Resíduos - Suavização Exponencial Holt-Winters")
abline(h=0, col="red")
plot(resid_exp, main="Resíduos - Suavização Exponencial")
abline(h=0, col="red")
plot(resid_arima, main="Resíduos - ARIMA")
abline(h=0, col="red")

mean(resid_exp)
mean(resid_exp2)
mean(resid_arima)

par(mfrow=c(1,1))

## ACF dos resíduos
acf(resid_exp, main="ACF Resíduos - Suavização Exponencial")
acf(resid_exp2, main="ACF Resíduos - Suavização Exponencial Holt Winters")
acf(resid_arima, main="ACF Resíduos - ARIMA")

modelo = arima(serie, order = c(1, 0, 0))
checkresiduals(suavizacao_ft) # H0: os residuos sao independentes.
checkresiduals(suavizacao_2_ft)
checkresiduals(modelo)

ArchTest(resid_exp) # H0: os residuos sao homocedasticos.
ArchTest(resid_exp2)
ArchTest(resid_arima)

shapiro.test(resid_exp) # H0: os residuos seguem uma normal
shapiro.test(resid_exp2)
shapiro.test(resid_arima)

mae_hw = mean(abs(residuals(suavizacao_ft))); mae_hw
mae_ets = mean(abs(residuals(suavizacao_2_ft))); mae_ets
mae_arima = mean(abs(residuals(modelo))); mae_arima

# Todos os resíduos são independentes. Apenas os residuos das suavizações exponenciais são homocedasticos. Apenas 
# o resíduo do modelo de Holt-Winters segue uma normal.

#------------#