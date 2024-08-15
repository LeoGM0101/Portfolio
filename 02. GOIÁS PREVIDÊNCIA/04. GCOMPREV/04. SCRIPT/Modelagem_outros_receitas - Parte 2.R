#Script by Leonardo Malaquias
source("Z:/GERENCIA/DEMANDAS/2024/13.GCOMPREV/04. SCRIPT/Modelagem_outros_receitas.R")
par(mfrow=c(1,1))

# Quantitativo

## Treino
dados_quant_treino = subset(dados_quant, Referência <= "2017-12-01")

serie_quant = ts(dados_quant_treino$Quant., start = c(2014, 2), frequency = 12)
ts.plot(serie)

suavizacao_quant = HoltWinters(serie_quant)
suavizacao_2_quant = ets(serie_quant)
summary(suavizacao_quant)
summary(suavizacao_2_quant)

modelo_quant = auto.arima(serie_quant)
summary(modelo_quant)


## Teste
dados_quant_teste = subset(dados_quant, Referência >= "2018-01-01")
serie_quant_teste = ts(dados_quant_teste$Quant., start = c(2018, 1), frequency = 12)

pred_quant_suavizacao = forecast::forecast(suavizacao_quant, h = length(serie_quant_teste))
pred_quant_suavizacao2 = forecast::forecast(suavizacao_2_quant, h = length(serie_quant_teste))
pred_quant_arima = forecast::forecast(modelo_quant, h = length(serie_quant_teste))

comparacao_quant = data.frame(data = dados_quant_teste$Referência,
                                 Previsoes_Suavizacao_HoltWinters = pred_quant_suavizacao$mean,
                                 Previsoes_Suavizacao_Exponencial = pred_quant_suavizacao2$mean,
                                 Previsoes_ARIMA = pred_quant_arima$mean,
                                 `Valores de Teste` = serie_quant_teste); comparacao_quant

eqmedio_HoltWinters_quant = sqrt(mean((pred_quant_suavizacao$mean - serie_quant_teste)^2)); eqmedio_HoltWinters_quant
eqmedio_Exponencial_quant = sqrt(mean((pred_quant_suavizacao2$mean - serie_quant_teste)^2)); eqmedio_Exponencial_quant
eqmedio_arima_temp = sqrt(mean((pred_quant_arima$mean - serie_quant_teste)^2)); eqmedio_arima_temp


ggplot(comparacao_quant, aes(x = seq(1, 20, 1))) +
  geom_line(aes(y = Previsoes_Suavizacao_HoltWinters, color = "Previsoes_Suavizacao_HoltWinters"), linetype = "solid") +
  geom_line(aes(y = Previsoes_Suavizacao_Exponencial, color = "Previsoes_Suavizacao_Exponencial"), linetype = "solid") +
  geom_line(aes(y = Previsoes_ARIMA, color = "Previsoes_ARIMA"), linetype = "solid") +
  geom_line(aes(y = Valores.de.Teste, color = "Valores de Teste"), linetype = "solid") +
  labs(x = "Periodo", y = "Quantitativo", 
       title = "Previsões do Quantitativo")

# O modelo de Suavização Exponencial de Holt-Winters se saiu melhor no treino para o quantitativo.

# Projeção
serie_Quant_final = ts(dados_quant$Quant., start = c(2014, 2), frequency = 12)
modelo_final_quant = HoltWinters(serie_Quant_final)
previsao_quant = forecast::forecast(modelo_final_quant, h = 100)
plot(previsao_quant)

tabela_quant = data.frame(data = seq(from = as.Date("2019-09-01"), to = as.Date("2027-12-31"), by = "month"),
                           Quantitativo = previsao_quant$mean, 
                          `Quantitativo (Limite Superior)` = previsao_quant$upper,
                          `Quantitativo (Limite Inferior)` = previsao_quant$lower); tabela_quant

#------------#

# Receita Líquida

## Treino 
dados_rl_treino = subset(dados_rl, Referência <= "2021-06-01") # 80% dos dados

serie_rl = ts(dados_rl_treino$`Receita Líquida`, start = c(2010, 2), frequency = 12)
ts.plot(serie_rl)

suavizacao_rl = HoltWinters(serie_rl)
suavizacao_2_rl = ets(serie_rl)
summary(suavizacao_rl)
summary(suavizacao_2_rl)

modelo_rl = auto.arima(serie_rl)
summary(modelo_rl)


## Teste
dados_rl_teste = subset(dados_rl, Referência > "2021-06-01")
serie_rl_teste = ts(dados_rl_teste$`Receita Líquida`, start = c(2021, 6), frequency = 12)

pred_rl_suavizacao = forecast::forecast(suavizacao_rl, h = length(serie_rl_teste))
pred_rl_suavizacao2 = forecast::forecast(suavizacao_2_rl, h = length(serie_rl_teste))
pred_rl_arima = forecast::forecast(modelo_rl, h = length(serie_rl_teste))

comparacao_rl = data.frame(data = dados_rl_teste$Referência,
                              Previsoes_Suavizacao_HoltWinters = pred_rl_suavizacao$mean,
                              Previsoes_Suavizacao_Exponencial = pred_rl_suavizacao2$mean,
                              Previsoes_ARIMA = pred_rl_arima$mean,
                              `Valores de Teste` = serie_rl_teste); comparacao_rl

eqmedio_HoltWinters_quant = sqrt(mean((pred_rl_suavizacao$mean - serie_rl_teste)^2)); eqmedio_HoltWinters_quant
eqmedio_Exponencial_quant = sqrt(mean((pred_rl_suavizacao2$mean - serie_rl_teste)^2)); eqmedio_Exponencial_quant
eqmedio_arima_temp = sqrt(mean((pred_rl_arima$mean - serie_rl_teste)^2)); eqmedio_arima_temp


ggplot(comparacao_rl, aes(x = seq(1, 34, 1))) +
  geom_line(aes(y = Previsoes_Suavizacao_HoltWinters, color = "Previsoes_Suavizacao_HoltWinters"), linetype = "solid") +
  geom_line(aes(y = Previsoes_Suavizacao_Exponencial, color = "Previsoes_Suavizacao_Exponencial"), linetype = "solid") +
  geom_line(aes(y = Previsoes_ARIMA, color = "Previsoes_ARIMA"), linetype = "solid") +
  geom_line(aes(y = Valores.de.Teste, color = "Valores de Teste"), linetype = "solid") +
  labs(x = "Periodo", y = "Quantitativo", 
       title = "Previsões do Quantitativo")

# O modelo ARIMA se saiu melhor no treino para a Receita Líquida.

# Projeção
serie_rl_final = ts(dados_rl$`Receita Líquida`, start = c(2010, 2), frequency = 12)
modelo_final_rl = auto.arima(serie_rl_final)
plot(serie_rl_final)
lines(fitted(modelo_final_rl), col = "red")

previsao_rl = forecast::forecast(modelo_final_rl, h = 44)
plot(previsao_rl)

tabela_rl = data.frame(data = seq(from = as.Date("2024-05-01"), to = as.Date("2027-12-31"), by = "month"),
                            `Receita Líquida` = previsao_rl$mean,
                            `Receita Líquida (Limite Superior)` = previsao_rl$upper,
                            `Receita Líquida (Limite Inferior)` = previsao_rl$lower); tabela_rl



#------------#

# Fluxo Total

## Treino
dados_ft_treino = subset(dados_ft, Referência <= "2017-09-01")
dados_ft_treino$`Fluxo (estoque liquido +passivo liquido - 13)` = sqrt(dados_ft_treino$`Fluxo (estoque liquido +passivo liquido - 13)`)

serie_ft = ts(dados_ft_treino$`Fluxo (estoque liquido +passivo liquido - 13)`, start = c(2010, 2), frequency = 12)
ts.plot(serie_ft)

suavizacao_ft = HoltWinters(serie_ft)
suavizacao_2_ft = ets(serie_ft)
summary(suavizacao_ft)
summary(suavizacao_2_ft)

modelo_ft = auto.arima(serie_ft)
summary(modelo_ft)


## Teste
dados_ft_teste = subset(dados_ft, Referência > "2017-09-01")
dados_ft_teste = na.omit(dados_ft_teste)
dados_ft_teste$`Fluxo (estoque liquido +passivo liquido - 13)` = sqrt(dados_ft_teste$`Fluxo (estoque liquido +passivo liquido - 13)`)
serie_ft_teste = ts(dados_ft_teste$`Fluxo (estoque liquido +passivo liquido - 13)`, start = c(2017, 10), frequency = 12)

pred_ft_suavizacao = forecast::forecast(suavizacao_ft, h = length(serie_ft_teste))
pred_ft_suavizacao2 = forecast::forecast(suavizacao_2_ft, h = length(serie_ft_teste))
pred_ft_arima = forecast::forecast(modelo_ft, h = length(serie_ft_teste))

comparacao_ft = data.frame(data = dados_ft_teste$Referência,
                           Previsoes_Suavizacao_HoltWinters = pred_ft_suavizacao$mean,
                           Previsoes_Suavizacao_Exponencial = pred_ft_suavizacao2$mean,
                           Previsoes_ARIMA = pred_ft_arima$mean,
                           `Valores de Teste` = serie_ft_teste); comparacao_ft

eqmedio_HoltWinters_ft = sqrt(mean((pred_ft_suavizacao$mean - serie_ft_teste)^2)); eqmedio_HoltWinters_ft
eqmedio_Exponencial_ft = sqrt(mean((pred_ft_suavizacao2$mean - serie_ft_teste)^2)); eqmedio_Exponencial_ft
eqmedio_arima_ft = sqrt(mean((pred_ft_arima$mean - serie_ft_teste)^2)); eqmedio_arima_ft


ggplot(comparacao_ft, aes(x = seq(1, 23, 1))) +
  geom_line(aes(y = Previsoes_Suavizacao_HoltWinters, color = "Previsoes_Suavizacao_HoltWinters"), linetype = "solid") +
  geom_line(aes(y = Previsoes_Suavizacao_Exponencial, color = "Previsoes_Suavizacao_Exponencial"), linetype = "solid") +
  geom_line(aes(y = Previsoes_ARIMA, color = "Previsoes_ARIMA"), linetype = "solid") +
  geom_line(aes(y = Valores.de.Teste, color = "Valores de Teste"), linetype = "solid") +
  labs(x = "Periodo", y = "Quantitativo", 
       title = "Previsões do Quantitativo")

# O modelo de Suavização Exponencial se saiu melhor no treino para o Fluxo Total. Entretanto, 
# a análise gráfica apontou uma melhor perfomance do modelo de Holt-Winters e a análise de 
# resíduos apontou que o modelo de Holt-Winters seguiu todos os requisitos e apresentou a menor 
# raiz quadrada da média dos erros quadráticos.

# Projeção
serie_ft_final = ts(dados_ft$`Fluxo (estoque liquido +passivo liquido - 13)`, start = c(2010, 2), frequency = 12)
serie_ft_final = na.omit(serie_ft_final)
modelo_final_ft = HoltWinters(serie_ft_final)
plot(modelo_final_ft)
previsao_ft = forecast::forecast(modelo_final_ft, h = 100)
plot(previsao_ft)

# previsao_ft$mean = (previsao_ft$mean)^2
# previsao_ft$lower = (previsao_ft$lower)^2
# previsao_ft$upper = (previsao_ft$upper)^2


tabela_ft = data.frame(data = seq(from = as.Date("2019-09-01"), to = as.Date("2027-12-31"), by = "month"),
                       `Fluxo Total` = previsao_ft$mean,
                       `Fluxo Total (Limite Superior)` = previsao_ft$upper,
                       `Fluxo Total (Limite Inferior)` = previsao_ft$lower); tabela_ft

#------------#

wb = createWorkbook()
addWorksheet(wb, "Dados Quantitativo")
writeData(wb, "Dados Quantitativo", dados_quant)
addWorksheet(wb, "Projeção Quantitativo")
writeData(wb, "Projeção Quantitativo", tabela_quant)

addWorksheet(wb, "Dados Receita Líquida")
writeData(wb, "Dados Receita Líquida", dados_rl)
addWorksheet(wb, "Projeção Receita Líquida")
writeData(wb, "Projeção Receita Líquida", tabela_rl)

addWorksheet(wb, "Dados Fluxo total")
writeData(wb, "Dados Fluxo total", dados_ft)
addWorksheet(wb, "Projeção Fluxo total")
writeData(wb, "Projeção Fluxo total", tabela_ft)

saveWorkbook(wb, "Z:/GERENCIA/DEMANDAS/2024/13.GCOMPREV/Projeções.xlsx", overwrite = TRUE)

receita = createWorkbook()
addWorksheet(receita, "Projeção Receita Líquida")
writeData(receita, "Projeção Receita Líquida", tabela_rl)
saveWorkbook(receita, "Z:/GERENCIA/DEMANDAS/2024/13.GCOMPREV/Projeção Receita.xlsx", overwrite = TRUE)





# --------------------------------------#

# Projeção
serie_rl_final = ts(dados_rl$`Receita Líquida`, start = c(2010, 2), frequency = 12)
modelo_final_rl = HoltWinters(serie_rl_final)
plot(serie_rl_final)
lines(fitted(modelo_final_rl), col = "red")

previsao_rl = forecast::forecast(modelo_final_rl, h = 44)
plot(previsao_rl)

tabela_rl = data.frame(data = seq(from = as.Date("2024-05-01"), to = as.Date("2027-12-31"), by = "month"),
                       `Receita Líquida` = previsao_rl$mean,
                       `Receita Líquida (Limite Superior)` = previsao_rl$upper,
                       `Receita Líquida (Limite Inferior)` = previsao_rl$lower); tabela_rl


receita_holt = createWorkbook()
addWorksheet(receita_holt, "Projeção Receita Líquida")
writeData(receita_holt, "Projeção Receita Líquida", tabela_rl)
saveWorkbook(receita_holt, "Z:/GERENCIA/DEMANDAS/2024/13.GCOMPREV/receita_holt.xlsx", overwrite = TRUE)


