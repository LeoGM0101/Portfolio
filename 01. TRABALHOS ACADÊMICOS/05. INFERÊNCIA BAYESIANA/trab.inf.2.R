### Questão 3

# c)

rm(list=ls())
library(ggplot2)
library(coda)
library(MCMCpack)
# Sequência observada
Y = c(2, 5, 0, 1, 0, 0, 2, 1, 9, 8, 8, 10, 12, 14, 4)
n = length(Y)

# Parâmetros da distribuição a priori Gama (vaga)
a = 1
b = 1
c = 1
d = 1

# Configurações do MCMC
num_iter = 10000
tune = 2  # Parâmetro de ajuste para a proposta do Metropolis-Hastings

# Inicializar as cadeias
lambda_chain = numeric(num_iter)
phi_chain = numeric(num_iter)
m_chain = numeric(num_iter)

# Inicializar os valores
set.seed(42)
lambda_chain[1] = rgamma(1, a, b)
phi_chain[1] = rgamma(1, c, d)
m_chain[1] = sample(1:n, 1)


for (iter in 2:num_iter) {
  # Atualizar lambda
  m_current = m_chain[iter - 1]
  lambda_shape = sum(Y[1:m_current]) + a
  lambda_rate = m_current + b
  lambda_chain[iter] = rgamma(1, lambda_shape, lambda_rate)
  
  # Atualizar phi
  phi_shape = sum(Y[(m_current + 1):n]) + c
  phi_rate = (n - m_current) + d
  phi_chain[iter] = rgamma(1, phi_shape, phi_rate)
  
  # Atualizar m usando Metropolis-Hastings
  lambda_current = lambda_chain[iter]
  phi_current = phi_chain[iter]
  
  a = max(1, m_current - tune)
  b = min(n, m_current + tune)
  m_proposal = sample(a:b, 1)
  
  log_posterior_current = sum(dpois(Y[1:m_current], lambda_current, log = TRUE)) +
    sum(dpois(Y[(m_current + 1):n], phi_current, log = TRUE))
  
  log_posterior_proposal = sum(dpois(Y[1:m_proposal], lambda_current, log = TRUE)) +
    sum(dpois(Y[(m_proposal + 1):n], phi_current, log = TRUE))
  
  acceptance_ratio = exp(log_posterior_proposal - log_posterior_current)
  
  if (runif(1) < acceptance_ratio) {
    m_chain[iter] = m_proposal
  } else {
    m_chain[iter] = m_current
  }
}

# Remover os primeiros valores da cadeia (burn-in)
burn_in = 2000
lambda_chain = lambda_chain[-(1:burn_in)]
phi_chain = phi_chain[-(1:burn_in)]
m_chain = m_chain[-(1:burn_in)]


# Estatísticas descritivas e traceplot
mcmc_chain = mcmc(cbind(m_chain, lambda_chain, phi_chain))
summary(mcmc_chain)
plot(mcmc_chain)
autocorr.plot(mcmc_chain)

# Converter as cadeias para data frames
df_m = data.frame(iter = 1:length(m_chain), m = m_chain)
df_lambda = data.frame(iter = 1:length(lambda_chain), lambda = lambda_chain)
df_phi = data.frame(iter = 1:length(phi_chain), phi = phi_chain)

# Histograma da distribuição posteriori de m
ggplot(df_m, aes(x = m)) +
  geom_histogram(binwidth = 1, fill = "lightblue", color = "black") +
  geom_vline(xintercept = 8, color = "red", linetype = "solid", linewidth = 1) +
  geom_vline(xintercept = mean(df_m$m), color = "blue", linetype = "dashed", linewidth = 1) +
  labs(title = "Distribuição Posteriori de m", x = "m", y = "Frequência") +
  theme_minimal()

# Densidade da distribuição posteriori de m
ggplot(df_m, aes(x = m)) +
  geom_density(fill = "lightblue") +
  geom_vline(xintercept = 8, color = "red", linetype = "solid", linewidth = 1) +
  geom_vline(xintercept = mean(df_m$m), color = "blue", linetype = "dashed", linewidth = 1) +
  labs(title = "Densidade da Distribuição Posteriori de m", x = "m", y = "Densidade") +
  theme_minimal()

# d)

# Cálculo das estimativas pontuais
rbind(media_lambda = mean(lambda_chain),
  modiana_lambda = median(lambda_chain),
  desvio_lambda = sd(lambda_chain))

rbind(media_phi = mean(phi_chain),
  mediana_phi = median(phi_chain),
  desvio = sd(phi_chain))

rbind(media_m = mean(m_chain),
  mediana_m = median(m_chain),
  sd_m = sd(m_chain))

# Cálculo dos intervalos de credibilidade de 95%
rbind(cred_lambda= quantile(lambda_chain, c(0.025, 0.975)),
 cred_phi = quantile(phi_chain, c(0.025, 0.975)),
 cred_m = quantile(m_chain, c(0.025, 0.975)))

# Cálculo dos intervalos HPD de 95%
rbind(hpd_lambda = HPDinterval(as.mcmc(lambda_chain), prob = 0.95),
      hpd_phi = HPDinterval(as.mcmc(phi_chain), prob = 0.95),
      hpd_m = HPDinterval(as.mcmc(m_chain), prob = 0.95))


summary(mcmc_chain)
