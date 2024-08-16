#Exercicio 3.32
rm(list = ls())
library(agricolae)

wafer_position = factor(c(1, 1, 1,
                   2, 2, 2,
                   3, 3, 3,
                   4, 4, 4))
uniformity = c(2.76, 5.67, 4.49,
               1.43, 1.70, 2.19,
               2.34, 1.97, 1.47,
               0.94, 1.36, 1.65)
dados = data.frame(wafer_position, uniformity)

mod = aov(uniformity ~  wafer_position, data=dados)
summary(mod)

qqnorm(rstandard(mod))
qqline(rstandard(mod))
shapiro.test(rstandard(mod))

plot(fitted(mod), rstandard(mod), pch=16)

tukey.test = agricolae::HSD.test(mod, trt = 'wafer_position'); tukey.test

#------------------------------------------------------------------------------#
#Exercicio 4.14
rm(list = ls())
library(agricolae)
obs_1 = c(8, 4, 5, 6,
        14, 5, 6, 9,
        14, 6, 9, 2,
        17, 9, 3, 6)
dados_1 = data.frame(stirring_rate = c(rep("5", 4), rep("10", 4), rep("15", 4), rep("20", 4)),
                   furnace = rep(seq(1, 4, 1), 4),
                   obs_1)
dados_1$stirring_rate = as.factor(dados_1$stirring_rate)
dados_1$furnace = as.factor(dados_1$furnace)

mod = aov(obs ~  stirring_rate + furnace, data=dados)
summary(mod)

qqnorm(rstandard(mod))
qqline(rstandard(mod))
shapiro.test(rstandard(mod))

plot(fitted(mod), rstandard(mod), pch=16)

tukey.test = agricolae::HSD.test(mod, trt = 'stirring_rate'); tukey.test

#------------------------------------------------------------------------------#
#Exercicio 4.36 - Quadrados latinos
rm(list = ls())
library(agricolae)

obs = c(8, 7, 1, 7, 3,
        11, 2, 7, 3, 8,
        4, 9, 10, 1, 5,
        6, 8, 6, 6, 10,
        4, 2, 3, 8, 8)
ingredients = c("A", "B", "D", "C", "E",
                "C", "E", "A", "D", "B",
                "B", "A", "C", "E", "D",
                "D", "C", "E", "B", "A",
                "E", "D", "B", "A", "C")

dados = data.frame(batch = c(rep("1", 5), rep("2", 5), rep("3", 5), rep("4", 5), rep("5", 5)),
                   day = rep(seq(1, 5, 1), 5),
                   ingredients, obs)
dados$batch = as.factor(dados$batch)
dados$day = as.factor(dados$day)
dados$ingredients = as.factor(dados$ingredients)

mod = aov(obs ~ batch + day + ingredients, data = dados)
summary(mod)

qqnorm(rstandard(mod))
qqline(rstandard(mod))
shapiro.test(rstandard(mod))

plot(fitted(mod), rstandard(mod), pch=16)

tukey.test = agricolae::HSD.test(mod, trt = 'ingredients'); tukey.test

#------------------------------------------------------------------------------#
#Esquemas Fatoriais
#ex. 5.26
rm(list = ls())
library(agricolae)

brand_of_battery = c("A", "A", "A", "A", "A", "A",
                     "B", "B", "B", "B", "B", "B")
device = c("Radio", "Camera", "DVD Player", "Radio", "Camera", "DVD Player",
           "Radio", "Camera", "DVD Player", "Radio", "Camera", "DVD Player")
obs = c(8.6, 7.9, 5.4, 
        8.2, 8.4, 5.7,
        9.4, 8.5, 5.8,
        8.8, 8.9, 5.9)

dados = data.frame(brand_of_battery, device, obs)
dados$brand_of_battery = as.factor(dados$brand_of_battery)
dados$device = as.factor(dados$device)

modelo = aov(obs ~ brand_of_battery * device, data = dados)
summary(modelo)

#------------------------------------------------------------------------------#
#Delineamento casualizado em blocos com Esquemas Fatoriais
#ex. 5.27 (onde cada replicacao representa um bloco)
rm(list = ls())
library(agricolae)

clubs = c("old", "old", "old", "old", "old", "old", "old", "old", "old",
          "new", "new", "new", "new", "new", "new", "new", "new", "new")
curse = c("ahwatukee", "karsten", "foothills", "ahwatukee", "karsten", "foothills", "ahwatukee", "karsten", "foothills",
          "ahwatukee", "karsten", "foothills", "ahwatukee", "karsten", "foothills", "ahwatukee", "karsten", "foothills")
obs = c(90, 91, 88, 87, 93, 86, 86, 90, 90,
        88, 90, 86, 87, 91, 85, 85, 88, 88)
repeticoes = as.factor(rep(c(1, 1, 1,
               2, 2, 2,
               3, 3, 3), 2))

dados = data.frame(clubs, curse, repeticoes, obs)

modelo = aov(obs ~ clubs * curse + repeticoes, data = dados)
summary(modelo)

qqnorm(rstandard(modelo))
qqline(rstandard(modelo))
shapiro.test(rstandard(modelo))

#------------------------------------------------------------------------------#
#Polinomios Ortogonais
#Ex. 3.12
rm(list = ls())
library(agricolae)

dosage = c(20, 20, 20, 20,
           30, 30, 30, 30,
           40, 40, 40, 40)
obs = c(24, 28, 37, 30,
        37, 44, 31, 35,
        42, 47, 52, 38)
dados_1 = data.frame(dosage, obs)

dados_1$dosage = factor(dados_1$dosage)
contrasts(dados_1$dosage) = contr.poly(3)
contrasts(dados_1$dosage)

mod_ANOVA = aov(obs ~ dosage, data = dados_1)
summary(mod_ANOVA, split = list("dosage"= 
                                  list(
                                    "Linear"= 1, 
                                    "Qudratico" = 2, 
                                    "Cubico" =3) ) )

#------------------------------------------------------------------------------#
#Esquema de delineamento de parcelas subdividas
#ex. 14.20
rm(list = ls())
library(agricolae)
library(ExpDes.pt)


application_method = c("method1", "method1", "method1", "method1", "method1", "method1", "method1", "method1", "method1", "method1", "method1", "method1",
                       "method2", "method2", "method2", "method2", "method2", "method2", "method2", "method2", "method2", "method2", "method2", "method2",
                       "method3", "method3", "method3", "method3", "method3", "method3", "method3", "method3", "method3", "method3", "method3", "method3")
mix = rep(c("mix1", "mix1", "mix1",
            "mix2", "mix2", "mix2",
            "mix3", "mix3", "mix3",
            "mix4", "mix4", "mix4"), 3)
day = rep(c("day1", "day2", "day3",
            "day1", "day2", "day3",
            "day1", "day2", "day3"), 4)
# blocos = rep(c("bloco1", "bloco1", "bloco1", "bloco1",
#                "bloco2", "bloco2", "bloco2", "bloco2",
#                "bloco3", "bloco3", "bloco3", "bloco3"), 3)
parcelas = rep(c("parcela1", "parcela2", "parcela3", 
                 "parcela1", "parcela2", "parcela3",
                 "parcela1", "parcela2", "parcela3"), 4)
obs = c(64.5, 65.2, 66.2, 
        66.3, 65, 66.5,
        74.1, 73.8, 72.3,
        66.5, 64.8, 67.7,
        68.3, 69.2, 69,
        69.5, 70.3, 69,
        73.8, 74.5, 75.4,
        70, 68.3, 68.6,
        70.3, 71.2, 70.8,
        73.1, 72.8, 74.2, 
        78, 79.1, 80.1,
        72.3, 71.5, 72.4)

dados_1 = data.frame(application_method, mix, day, obs)

psub2.dbc(dados_1$application_method, dados_1$mix, dados_1$day, dados_1$obs)

# dados_1$day = factor(dados_1$day)
# dados_1$application_method = factor(dados_1$application_method)
# dados_1$mix = factor(dados_1$mix)
# dados_1$parcelas = factor(dados_1$parcelas)
# 
# modelo = aov(obs ~ day + mix*application_method + Error(parcelas), data = dados_1)
# summary(modelo)


