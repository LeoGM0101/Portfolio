source("Trabalho de Séries Temporais.R")
dados_teste = read.csv("DailyDelhiClimateTest.csv") %>%
  mutate(ano = year(date),
         mes = month(date),
         dia = day(date))
serie_meanTemp_teste = ts(dados_teste$meantemp, start = c(2017, 1), frequency = 365)
serie_humidity_teste = ts(dados_teste$humidity, start = c(2017, 1), frequency = 365)

#------------------------------------------------------------------------------#
#Previsoes
pred_Temp = forecast(modelo_Temp, h = length(serie_meanTemp_teste))
pred_humidity = forecast(modelo_humidity, h = length(serie_humidity_teste))

pred_Temp_suavizacao = forecast(suavizacao_temp, h = length(serie_meanTemp_teste))
pred_humidity_suavizacao = forecast(suavizacao_humidity, h = length(serie_humidity_teste))

comparacao_meanTemp = data.frame(ano = dados_teste$ano,
                                 mes = dados_teste$mes,
                                 dia = dados_teste$dia,
                                 Previsoes_SARIMA = pred_Temp$mean,
                                 Previsoes_Suavizacao = pred_Temp_suavizacao$mean,
                                 `Valores de Teste` = serie_meanTemp_teste)
head(comparacao_meanTemp, 7)
eqmedio_sarima_temp = sqrt(mean((pred_Temp$mean - serie_meanTemp_teste)^2))
eqmedio_sarima_temp
eqmedio_suavizacao_temp = sqrt(mean((pred_Temp_suavizacao$mean - serie_meanTemp_teste)^2))
eqmedio_suavizacao_temp


ggplot(comparacao_meanTemp, aes(x = seq(1, 114, 1))) +
  geom_line(aes(y = Previsoes_SARIMA, color = "Previsoes_SARIMA"), linetype = "dashed") +
  geom_line(aes(y = Previsoes_Suavizacao, color = "Previsoes_Suavizacao"), linetype = "dashed") +
  geom_line(aes(y = Valores.de.Teste, color = "Valores de Teste"), linetype = "dashed") +
  labs(x = "Periodo", y = "Previsoes da Temperatura Media", 
       title = "Previsões da Temperatura Media")


comparacao_humidity = data.frame(ano = dados_teste$ano,
                                 mes = dados_teste$mes,
                                 dia = dados_teste$dia, 
                                 Previsoes_SARIMA = pred_humidity$mean,
                                 Previsoes_Suavizacao = pred_humidity_suavizacao$mean,
                                 `Valores de Teste` = serie_humidity_teste)
head(comparacao_humidity, 7)

eqmedio_sarima_humidity = sqrt(mean((pred_humidity$mean - serie_humidity_teste)^2))
eqmedio_sarima_humidity
eqmedio_suavizacao_humidity = sqrt(mean((pred_humidity_suavizacao$mean - serie_humidity_teste)^2))
eqmedio_suavizacao_humidity


ggplot(comparacao_humidity, aes(x = seq(1, 114, 1))) +
  geom_line(aes(y = Previsoes_SARIMA, color = "Previsoes_SARIMA"), linetype = "dashed") +
  geom_line(aes(y = Previsoes_Suavizacao, color = "Previsoes_Suavizacao"), linetype = "dashed") +
  geom_line(aes(y = Valores.de.Teste, color = "Valores de Teste"), linetype = "dashed") +
  labs(x = "Periodo", y = "Previsoes da Umidade", 
       title = "Previsões da Umidade")
