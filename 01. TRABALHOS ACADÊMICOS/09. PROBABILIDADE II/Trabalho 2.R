rm(list=ls())

library(tibble)
library(dplyr)
library(ggplot2)


x_bar = 2000 # numero de medias que serao calculadas
n = 2000 # tamanho de cada amostra cuja medias sera calculada

simulacao = tibble(indice = 1:x_bar,
                    exponencial = double(length = x_bar),
                    uniforme = double(length = x_bar),
                    tStudent = double(length = x_bar),
                    poisson = double(length = x_bar)); simulacao

set.seed(1234)

for(i in 1:x_bar) {
  
  simulacao$exponencial[i] <- rexp(x_bar) %>% mean()
  simulacao$uniforme[i] <- runif(x_bar) %>% mean()
  simulacao$tStudent[i] <- rt(x_bar, df = 4) %>% mean() # medias de uma t com 4 graus de liberdade
  simulacao$poisson[i] <- rpois(x_bar, lambda = 5) %>% mean() # medias de uma poisson(10)
  
  
}; simulacao



simulacao %>% 
  ggplot(aes(x = exponencial)) +
  geom_histogram(aes(y = ..density..), fill = "blue", alpha = .7) +
  geom_density(size = 1.5, alpha = .9, color = "red") +
  theme_minimal() +
  labs(title ="                                                 Exponencial",
       x = "",
       y = "")
simulacao %>% 
  ggplot(aes(x = uniforme)) +
  geom_histogram(aes(y = ..density..), fill = "blue", alpha = .7) +
  geom_density(size = 1.5, alpha = .9, color = "red") +
  theme_minimal() +
  labs(title = "                                                 Uniforme",
       x = "",
       y = "")
simulacao %>% 
  ggplot(aes(x = tStudent)) +
  geom_histogram(aes(y = ..density..), fill = "blue", alpha = .7) +
  geom_density(size = 1.5, alpha = .9, color = "red") +
  theme_minimal() +
  labs(title = "                                                 tStudent",
       x = "",
       y = "")
simulacao %>% 
  ggplot(aes(x = poisson)) +
  geom_histogram(aes(y = ..density..), fill = "blue", alpha = .7) +
  geom_density(size = 1.5, alpha = .9, color = "red") +
  theme_minimal() +
  labs(title = "                                                 Poisson",
       x = "",
       y = "")

