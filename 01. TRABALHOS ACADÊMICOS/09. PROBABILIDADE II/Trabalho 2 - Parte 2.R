rm(list=ls())

library(tibble)
library(dplyr)
library(ggplot2)


n = 10000 # tamanho de cada amostra

soma = tibble(indice = 1:n,
                   exponencial = double(length = n),
                   uniforme = double(length = n),
                   tStudent = double(length = n),
                   poisson = double(length = n)); soma

set.seed(1234)

for(i in 1:n) {
  
  soma$exponencial[i] <- rexp(n)
  soma$uniforme[i] <- runif(n) 
  soma$tStudent[i] <- rt(n, df = 4) 
  soma$poisson[i] <- rpois(n, lambda = 5) 
  
  
}; soma

soma_ = tibble(indice = 1:n,
              exponencial = double(length = n),
              uniforme = double(length = n),
              tStudent = double(length = n),
              poisson = double(length = n)); soma_


sexp <- numeric(n); sexp <- cumsum(soma$exponencial)
suni <- numeric(n); suni <- cumsum(soma$uniforme)
sts <- numeric(n); sts <- cumsum(soma$tStudent)
spoi <- numeric(n); spoi <- cumsum(soma$poisson)


for(i in 1:n) {
  
  soma_$exponencial[i] <- sexp[i]
  soma_$uniforme[i] <- suni[i]
  soma_$tStudent[i] <- sts[i] 
  soma_$poisson[i] <- spoi[i]
}; soma_



soma_ %>% 
  ggplot(aes(x = exponencial)) +
  geom_histogram(aes(y = ..density..), fill = "blue", alpha = .7) +
  geom_density(size = 1.5, alpha = .9, color = "red") +
  theme_minimal() +
  labs(title ="                                                 Exponencial",
       x = "",
       y = "")
soma_ %>% 
  ggplot(aes(x = uniforme)) +
  geom_histogram(aes(y = ..density..), fill = "blue", alpha = .7) +
  geom_density(size = 1.5, alpha = .9, color = "red") +
  theme_minimal() +
  labs(title = "                                                 Uniforme",
       x = "",
       y = "")
soma_ %>% 
  ggplot(aes(x = tStudent)) +
  geom_histogram(aes(y = ..density..), fill = "blue", alpha = .7) +
  geom_density(size = 1.5, alpha = .9, color = "red") +
  theme_minimal() +
  labs(title = "                                                 tStudent",
       x = "",
       y = "")
soma_ %>% 
  ggplot(aes(x = poisson)) +
  geom_histogram(aes(y = ..density..), fill = "blue", alpha = .7) +
  geom_density(size = 1.5, alpha = .9, color = "red") +
  theme_minimal() +
  labs(title = "                                                 Poisson",
       x = "",
       y = "")

