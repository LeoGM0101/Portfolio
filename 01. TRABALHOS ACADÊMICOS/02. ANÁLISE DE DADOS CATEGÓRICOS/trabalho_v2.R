rm(list=ls())
library(tidyverse)
library(caret)
library(PerformanceAnalytics)
library(hnp)
library(pROC)

# Objetivo: saber se foi concedido ou não empréstimo pessoal com base nas covariáveis do conjunto de dados.

# ID: ID do cliente
# Idade: Idade do Cliente
# Experiência: Experiência do Cliente
# Renda: Renda do Cliente
# CEP: CEP de residência do cliente
# Família: Número de familiares do cliente
# CCAvg: pontuação média do cartão de crédito
# Educação: Educação do cliente
# Hipoteca: Hipoteca contraída ou não contraída pelo cliente
# Empréstimo pessoal: 0 = Nenhum empréstimo pessoal concedido, 1 = empréstimo pessoal concedido
# Conta de Valores Mobiliários: Ter ou não ter uma Conta de Valores Mobiliários
# Conta CD: Ter ou não ter uma conta CD
# Online: Ter ou não ter serviços bancários online
# Cartão de Crédito: Ter ou não cartão de crédito



dados = read.csv("C:/Users/70306177110/Desktop/Trabalho de Análise de Dados Categóricos/bankloan.csv") %>%
  dplyr::select(-ID)

treino$Education = as.factor(treino$Education)

for(i in 9:ncol(treino)) {
  treino[, i] = as.factor(treino[, i])
}


indice = createDataPartition(dados$Personal.Loan, p = 0.8, list = FALSE)
treino = dados[indice, ]
teste = dados[-indice, ]

teste$Education = as.factor(teste$Education)

for(i in 9:ncol(teste)) {
  teste[, i] = as.factor(teste[, i])
}



dados_longos = tidyr::pivot_longer(treino, cols = c("Age", "Income", "Mortgage"), names_to = "Variavel", values_to = "Valor")

estatisticas_descritivas = dados_longos %>%
  group_by(Variavel) %>%
  summarise(Media = mean(Valor),
            Mediana = median(Valor),
            Desvio_Padrao = sd(Valor),
            `IQR` = IQR(Valor),
            Curtose = kurtosis(Valor),
            Simetria = skewness(Valor),
            Minimo = min(Valor),
            Maximo = max(Valor),
            outliers_inferiores = sum(Valor < quantile(Valor, 0.25) - 1.5 * IQR(Valor)),
            outliers_superiores = sum(Valor > quantile(Valor, 0.75) + 1.5 * IQR(Valor))); estatisticas_descritivas

ggplot(dados_longos, aes(x = Variavel, y = Valor)) +
  geom_boxplot() +
  facet_wrap(~ Variavel, scales = "free") +
  labs(x = "Valores", y = "Frequências", title = "Boxplots das Variáveis") +
  theme_minimal()

ggplot(dados_longos, aes(x = Valor)) +
  geom_histogram(color = "black", fill = "lightblue") +
  facet_wrap(~ Variavel, scales = "free") +
  labs(x = "Valores", y = "Frequências", title = "Histogramas das Variáveis") +
  theme_minimal()


ajust = glm(Personal.Loan ~ 1, data = treino,
            family = binomial(link = "logit"))
ajust1 = glm(Personal.Loan ~ ., data = treino,
            family = binomial(link = "logit"))
ajust_efeitos = step(ajust1, direction = "both")

anova(ajust, ajust1, ajust_efeitos, test = "Chisq")
summary(ajust_efeitos)


ajust3 = glm(Personal.Loan ~ Income + Family + CCAvg + Education +
               Securities.Account + CD.Account + Online + CreditCard, data=treino,
            family = binomial(link = "logit"))
summary(ajust3)

anova(ajust, ajust_efeitos, ajust3, test = "Chisq")

# o modelo ajust_efeitos apresentou o deviance um pouco inferior


ajust_inicial = glm(Personal.Loan ~ .^2, data = treino,
                      family = binomial(link = "logit"))
summary(ajust_inicial)

ajust_stepwise = step(ajust_inicial, direction = "both")
summary(ajust_stepwise)

ajust_final = glm(Personal.Loan ~ Age + Experience + Income + 
                    CCAvg + Mortgage + Securities.Account + CD.Account + 
                    Online + CreditCard + Age:Family + 
                    Age:CCAvg + Age:Education + Age:Mortgage + Experience:Family + Experience:Education + 
                    Income:Family + Income:CCAvg + Income:Education + ZIP.Code:Education + 
                    Family:CCAvg + Family:Education + Family:Mortgage + Family:Securities.Account + 
                    Family:CD.Account + CCAvg:Education + CCAvg:Online + Securities.Account:Online + 
                    Online:CreditCard, data = treino,
                  family = binomial(link = "logit"))

summary(ajust_final)


anova(ajust_inicial, ajust_stepwise, ajust_final, test = "Chisq")
anova(ajust, ajust_efeitos, ajust_stepwise, test = "Chisq")

# O modelo ajust_stepwise apresenta o menor deviance dentre todos os outros modelos.


# graficos dos residuos de pearson
resp = data.frame(indice = 1:nrow(treino),
                  residuos = residuals(ajust_stepwise, type = "pearson"))
ggplot(resp, aes(x = indice, y = residuos)) +
  geom_point() +
  geom_hline(yintercept = 0) +
  ylim(-5, 10) +
  labs(x = "Índice", y = "Resíduos")

hnp(ajust_stepwise, halfnormal = FALSE)

set.seed(2024)
predicao = predict(ajust_stepwise, newdata = teste, type = "response")
teste$predicao = predicao
roc(teste$Personal.Loan, teste$predicao, plot = TRUE, percent = TRUE, print.auc = TRUE)


hnp(ajust_efeitos, halfnormal = FALSE)
predicao_efeitosprin = predict(ajust_efeitos, newdata = teste, type = "response")
teste$predicao_efeitosprin = predicao_efeitosprin
roc(teste$Personal.Loan, teste$predicao_efeitosprin, plot = TRUE, percent = TRUE, print.auc = TRUE)

# AUC de ambos são praticamente iguais.

summary(ajust_efeitos)
