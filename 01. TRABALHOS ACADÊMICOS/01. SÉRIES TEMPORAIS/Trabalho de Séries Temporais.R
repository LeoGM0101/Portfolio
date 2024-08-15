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

setwd("C:/Users/leona/Documents/Estatística/9 Semestre/Séries Temporais")
dados = read.csv("DailyDelhiClimateTrain.csv")
dados =  head(dados, n = nrow(dados) - 1)
#------------------------------------------------------------------------------#
#Analise Exploratoria dos dados
dados_longos = tidyr::pivot_longer(dados, cols = c(meantemp, humidity), names_to = "Variavel", values_to = "Valor")

estatisticas_descritivas = dados_longos %>%
  group_by(Variavel) %>%
  summarise(Media = mean(Valor),
            Mediana = median(Valor),
            Desvio_Padrao = sd(Valor),
            `IQR` = IQR(Valor),
            Curtose = kurtosis(Valor),
            Simetria = skewness(Valor),
            Minimo = min(Valor),
            Maximo = max(Valor)); estatisticas_descritivas

testes_normalidade = dados_longos %>%
  group_by(Variavel) %>%
  summarise(valor_p = shapiro.test(Valor)$p.value); testes_normalidade

ggplot(dados_longos, aes(x = Valor)) +
  geom_histogram(color = "black", fill = "lightblue") +
  facet_wrap(~ Variavel, scales = "free") +
  labs(x = "Valores", y = "Frequências", title = "Histogramas das Variáveis") +
  theme_minimal()

outliers = dados_longos %>%
  group_by(Variavel) %>%
  summarise( outliers_inferiores = sum(Valor < quantile(Valor, 0.25) - 1.5 * IQR(Valor)),
             outliers_superiores = sum(Valor > quantile(Valor, 0.75) + 1.5 * IQR(Valor))); outliers

ggplot(dados_longos, aes(x = Variavel, y = Valor)) +
  geom_boxplot() +
  facet_wrap(~ Variavel, scales = "free") +
  labs(x = "Valores", y = "Frequências", title = "Boxplots das Variáveis") +
  theme_minimal()

ggplot(dados_longos, aes(x = Variavel, color = Variavel)) +
  geom_density() +
  labs(y = "Densidade", title = "Gráfico de Densidade das Variáveis") +
  theme_minimal() +
  theme(axis.text.x = element_blank())

#------------------------------------------------------------------------------#
#Avaliando a estacionariedade desses dados
dados_1 = read.csv("DailyDelhiClimateTrain.csv") %>%
  mutate(ano = year(date),
         mes = month(date),
         dia = day(date))
dados_1 =  head(dados_1, n = nrow(dados_1) - 1)

serie_meanTemp = ts(dados_1$meantemp, start = c(2013, 1), frequency = 365)
serie_humidity = ts(dados_1$humidity, start = c(2013, 1), frequency = 365)

ts.plot(serie_meanTemp)
ts.plot(serie_humidity)

testes_estacionariedade = data.frame(Variaveis = c(colnames(dados_1)[2], colnames(dados_1)[3]),
                                     `valor_p(teste adf)` = c(adf.test(serie_meanTemp)$p.value, adf.test(serie_humidity)$p.value),
                                     `valor_p(teste pp)` = c(pp.test(serie_meanTemp)$p.value, pp.test(serie_humidity)$p.value))
testes_estacionariedade
### Teste de Dickey-Fuller aumentado
### 
### Hipótese nula:         Os dados sao nao-estacionarios
### Hipótese alternativa:  Os dados sao estacionarios

#------------------------------------------------------------------------------#
#Analisando os componentes da decomposição da série
testes_tendencia = data.frame(Variaveis = c(colnames(dados_1)[2], colnames(dados_1)[3]),
                                     `valor_p(teste ww)` = c(ww.test(serie_meanTemp)$p.value, ww.test(serie_humidity)$p.value),
                                     `valor_p(teste cs)` = c(cs.test(serie_meanTemp)$p.value, cs.test(serie_humidity)$p.value))
testes_tendencia
### Teste de Teste de Cox & Stuart
### 
### Hipótese nula:         Os dados nao tem tendencia
### Hipótese alternativa:  Os dados apresentam qualquer tipo de tendencia, seja decrescente ou crescente
decomposicao_temp = plot(decompose(serie_meanTemp)); decomposicao_temp
decomposicao_humidity = plot(decompose(serie_humidity)); decomposicao_humidity

#------------------------------------------------------------------------------#
#Suavizacao exponencial
suavizacao_temp = stlf(serie_meanTemp, method = "ets")
summary(suavizacao_temp)
plot(suavizacao_temp)
suavizacao_humidity = stlf(serie_humidity, method = "ets")
summary(suavizacao_humidity)
plot(suavizacao_humidity)
     
#------------------------------------------------------------------------------#
#Graficos de autocorrelacao e autocorrelacao parcial
acf(serie_meanTemp)
acf(serie_humidity)
pacf(serie_meanTemp)
plot(pacf(serie_humidity))

#------------------------------------------------------------------------------#
#Modelo


### diferença tendência
ndiffs(serie_meanTemp)
ndiffs(serie_humidity)

### diferença sazonal
nsdiffs(serie_meanTemp)
nsdiffs(serie_humidity)

#------------------------------------------------------------------------------#

### ajuste do modelo para serie_meanTemp
ggtsdisplay(serie_meanTemp)
adf.test(diff(serie_meanTemp, difference = 1))

modelo_Temp = Arima(serie_meanTemp, order=c(3,1,1), seasonal = list(order = c(0, 1, 0), period = 365))
summary(modelo_Temp)

ggtsdisplay(serie_humidity)
modelo_humidity = Arima(serie_humidity, order=c(2,0,0), list(order = c(0, 1, 0), period = 365) )
summary(modelo_humidity)

#------------------------------------------------------------------------------#
