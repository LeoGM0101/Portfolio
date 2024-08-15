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


dados = read_excel("Z:/GERENCIA/DEMANDAS/2024/13.GCOMPREV/02. FONTES/2 - FONTES DA COMPENSAÇÃO PREVIDENCIÁRIA/acumulado serie_v2.xlsx")
dados$data = as.Date(dados$data)

serie = ts(dados$acumulado, start = c(2012, 1), frequency = 12)
ts.plot(serie)

testes_estacionariedade = data.frame(`valor_p(teste adf)` = adf.test(serie)$p.value,
                                     `valor_p(teste pp)` = pp.test(serie)$p.value)
testes_estacionariedade


testes_tendencia = data.frame(`valor_p(teste ww)` = ww.test(serie)$p.value,
                              `valor_p(teste cs)` = cs.test(serie)$p.value)
testes_tendencia


decomposicao_serie = plot(decompose(serie))



#Suavizacao exponencial
suavizacao = stlf(serie, method = "ets")
summary(suavizacao)
plot(serie)
lines(fitted(suavizacao), col = "red")

#Graficos de autocorrelacao e autocorrelacao parcial
acf(serie)
pacf(serie)


### diferença tendência
ndiffs(serie)

### diferença sazonal
nsdiffs(serie)

modelo = auto.arima(serie)
summary(modelo)
plot(serie)
lines(fitted(modelo), col = "blue")

plot(serie)
lines(suavizacao$fitted, col = "red")
lines(modelo$fitted, col = "blue")

comparacao = data.frame(Data = dados$data,
                                 Observado = dados$acumulado,
                                 ajustado_suavizacao = fitted(suavizacao), 
                                 ajustado_arima =fitted(modelo))

erroabsoluto_suavizacao = mean(abs(comparacao$Observado - comparacao$ajustado_suavizacao)); erroabsoluto_suavizacao
erroabsoluto_arima = mean(abs(comparacao$Observado - comparacao$ajustado_arima)); erroabsoluto_arima

metricas = data.frame(mae_suavizacao = mean(abs(comparacao$Observado - comparacao$ajustado_suavizacao)),
                      mae_arima = mean(abs(comparacao$Observado - comparacao$ajustado_arima)),
                      mse_suavizacao = mean((comparacao$Observado - comparacao$ajustado_suavizacao)^2), 
                      mse_arima = mean((comparacao$Observado - comparacao$ajustado_arima)^2)); metricas

#mae = media do erro absoluto
#mse media dos erros quadrados

# MAE inferior no ARIMA: Se os erros grandes não são tão críticos para seu contexto e você se importa mais com a precisão 
# média, o modelo ARIMA pode ser mais adequado.
# MSE inferior na Suavização Exponencial: Se grandes erros são particularmente problemáticos no seu contexto, 
# você pode preferir o modelo de suavização exponencial, pois ele minimiza mais os erros maiores.


#Previsoes
pred_suavizacao = forecast(suavizacao); pred_suavizacao
plot(pred_suavizacao)
pred_arima = forecast(modelo); pred_arima
plot(pred_arima)
