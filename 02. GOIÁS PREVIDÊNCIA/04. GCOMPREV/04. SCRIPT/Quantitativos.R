#Script by Leonardo Malaquias

rm(list=ls())
library(tidyverse)
library(forecast)

banco.de.dados.RGPS = read_excel("Z:/GERENCIA/DEMANDAS/2024/13.GCOMPREV/02. FONTES/1 - BASE DE DADOS UTILIZADAS/
                                 Banco de dados RGPS_V02.xlsx")
banco.de.dados.RPPS = read_excel("Z:/GERENCIA/DEMANDAS/2024/13.GCOMPREV/02. FONTES/1 - BASE DE DADOS UTILIZADAS/
                                 Banco de dados RPPS_V02.xlsx")


#------------------------------------------------------------------------------#
# Quantitativo do RGPS

total_valor_despesa = sum(banco.de.dados.RGPS$VALOR_DESPESA)
total_despesa = sum(banco.de.dados.RGPS$DESPESA)
total_enviados = sum(banco.de.dados.RGPS$ENVIADOS)

media_valor_despesa = round(mean(banco.de.dados.RGPS$VALOR_DESPESA), 2)
media_despesa = round(mean(banco.de.dados.RGPS$DESPESA), 2)
media_enviados = round(mean(banco.de.dados.RGPS$ENVIADOS), 2)

desvio_valor_despesa = round(sd(banco.de.dados.RGPS$VALOR_DESPESA), 2)
desvio_despesa = round(sd(banco.de.dados.RGPS$DESPESA), 2)
desvio_enviados = round(sd(banco.de.dados.RGPS$ENVIADOS), 2)

#------------------------------------------------------------------------------#
# Quantitativo do RPPS

total_valor_receita = sum(banco.de.dados.RPPS$VALOR_RECEITA)
total_receita = sum(banco.de.dados.RPPS$RECEITA)
total_enviados = sum(banco.de.dados.RPPS$ENVIADOS)

media_valor_receita = round(mean(banco.de.dados.RPPS$VALOR_RECEITA), 2)
media_receita = round(mean(banco.de.dados.RPPS$RECEITA), 2)
media_enviados = round(mean(banco.de.dados.RPPS$ENVIADOS), 2)

desvio_valor_receita = round(sd(banco.de.dados.RPPS$VALOR_RECEITA), 2)
desvio_receita = round(sd(banco.de.dados.RPPS$RECEITA), 2)
desvio_enviados = round(sd(banco.de.dados.RPPS$ENVIADOS), 2)

#------------------------------------------------------------------------------#

serie_despesa = ts(banco.de.dados.RGPS$DESPESA, start = c(2012, 1), frequency = 12)
modelo_despesa = auto.arima(serie_despesa)

previsao_despesa = forecast(modelo_despesa)
plot(previsao_despesa)

