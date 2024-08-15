rm(list=ls())
library(tidyverse)
library(PerformanceAnalytics)
library(hnp)

dados = read.csv("C:/Users/leona/Desktop/Trabalho de Análise de Dados Categóricos/used_cars.csv") %>%
  dplyr::select(-X, -model, -Make)

# for(i in 1:ncol(dados)) {
#   for(k in 1:nrow(dados)) {
#     if(dados[k, i] == "yes"){
#       dados[k, i] = 1
#     } 
#     else if(dados[k, i] == "no") {
#       dados[k, i] = 0
#     } 
#   }
#   dados[, i] = as.numeric(dados[, i])
# }

dados_longos = tidyr::pivot_longer(dados, cols = price, names_to = "Variavel", values_to = "Valor")

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


dados$price_cat = ifelse(dados$price <= median(dados$price), 0, 1)
dados = dados %>%
  dplyr::select(-price)


attach(dados)

ajust = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
              mpg + engineSize, 
            family = binomial(link = "logit"))

anova(ajust, test = "Chisq")
summary(ajust)

ajust2 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
              mpg + engineSize + year*transmission, 
            family = binomial(link = "logit"))

ajust3 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
               mpg + engineSize + year*mileage, 
             family = binomial(link = "logit"))

ajust4 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
               mpg + engineSize + year*fuelType, 
             family = binomial(link = "logit"))

ajust5 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
               mpg + engineSize + year*tax, 
             family = binomial(link = "logit"))

ajust6 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
               mpg + engineSize + year*mpg, 
             family = binomial(link = "logit"))

ajust7 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
               mpg + engineSize + year*engineSize, 
             family = binomial(link = "logit"))

# todas as interações com a variável year deram significativas


ajust8 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
               mpg + engineSize + transmission*mileage, 
             family = binomial(link = "logit"))

ajust9 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
               mpg + engineSize + transmission*fuelType, 
             family = binomial(link = "logit"))

ajust10 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
               mpg + engineSize + transmission*tax, 
             family = binomial(link = "logit"))

ajust11 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
               mpg + engineSize + transmission*mpg, 
             family = binomial(link = "logit"))

ajust12 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
               mpg + engineSize + transmission*engineSize, 
             family = binomial(link = "logit"))


# as interações dos ajustes 9,10,11 e 12 deram significativas

ajust13 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                mpg + engineSize + mileage*fuelType, 
              family = binomial(link = "logit"))

ajust14 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                mpg + engineSize + mileage*tax, 
              family = binomial(link = "logit"))

ajust15 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                mpg + engineSize + mileage*mpg, 
              family = binomial(link = "logit"))

ajust16 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                mpg + engineSize + mileage*engineSize, 
              family = binomial(link = "logit"))


# apenas as interações dos ajustes 13, 14 e 15 foram significativas



ajust17 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                mpg + engineSize + fuelType*tax, 
              family = binomial(link = "logit"))

ajust18 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                mpg + engineSize + fuelType*mpg, 
              family = binomial(link = "logit"))

ajust19 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                mpg + engineSize + fuelType*engineSize, 
              family = binomial(link = "logit"))


#todas as interações da variável fuelType foram significativas



ajust20 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                mpg + engineSize + tax*mpg, 
              family = binomial(link = "logit"))

ajust21 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                mpg + engineSize + tax*engineSize, 
              family = binomial(link = "logit"))


# todas as interações deram significativas

ajust22 = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                mpg + engineSize + engineSize*mpg, 
              family = binomial(link = "logit"))

summary(ajust22)

#a interação é significativa

ajust_final = glm(dados$price_cat ~ year + transmission + mileage + fuelType + tax +
                    mpg + engineSize + year*transmission + year*mileage + year*fuelType +
                    year*tax + year*mpg + year*engineSize + transmission*fuelType +
                    transmission*tax + transmission*mpg + transmission*engineSize + 
                    mileage*fuelType + mileage*tax + mileage*mpg + mileage*engineSize 
                  + fuelType*tax + fuelType*mpg + fuelType*engineSize + tax*mpg + 
                    tax*engineSize + engineSize*mpg, 
                  family = binomial(link = "logit"))

summary(ajust_final)

hnp(ajust_final, halfnormal = FALSE)
