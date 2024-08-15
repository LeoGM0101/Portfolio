# Análise de Sobrevivência do Turnover de uma empresa Russa



# Bibliotecas -------------------------------------------------------------

library(tidyverse)
library(survival)
library(flexsurv)


# Análise Descritiva ------------------------------------------------------

turnover <- read.csv("Employer-Turnover/turnover.csv", stringsAsFactors=TRUE)
sum(is.na.data.frame(turnover))
names(turnover)
attach(turnover)
table(turnover$event)

EKM <- survfit(Surv(stag, event)~1, data = turnover)

ggsurvplot(EKM, data = turnover)


EKM2 <- survfit(Surv(stag, event)~gender, data = turnover)

ggsurvplot(EKM2, 
           data = turnover, 
           ylab="S(t)",
           xlab="Tempo (dias)",
           title="Tempo de sobrevivência estimado via Kaplan-Meyer",
           censor.shape=" ",
           risk.table = F, 
           #risk.table.title="Indivíduos em risco",
           pval = T
)

# gráfico da densidade da frequência do gênero
table(gender)
ggplot(data = turnover, mapping = aes(x = age, fill = gender)) +
    geom_density(stat = "count", alpha = 0.4) +
    labs(x = "Idade", y = "Frequência", fill = "Sexo") +
    scale_fill_discrete(labels = c("Feminino", "Masculino")) +
    theme_bw() + theme(legend.position = "top", legend.direction = "horizontal")

# gráfico da densidade da frequência do tipo formal de trabalho
table(greywage)
ggplot(data = turnover, mapping = aes(x = age, fill = greywage)) +
    geom_density(stat = "count", alpha = 0.4) +
    labs(x = "Idade", y = "Frequência", fill = "Sexo") +
    scale_fill_discrete(labels = c("Feminino", "Masculino")) +
    theme_bw() + theme(legend.position = "top", legend.direction = "horizontal")

# gráfico da densidade da frequência do meio de transporte
table(way)
ggplot(data = turnover, mapping = aes(x = age, fill = way)) +
    geom_density(stat = "count", alpha = 0.4) +
    labs(x = "Idade", y = "Frequência", fill = "Sexo") +
    scale_fill_discrete(labels = c("Feminino", "Masculino")) +
    theme_bw() + theme(legend.position = "top", legend.direction = "horizontal")

# gráfico de barras da indústria/setor de atuação
ggplot(data = turnover, mapping = aes(x = industry)) +
    geom_bar(stat = "count", fill = "lightgrey", color = "black") +
    geom_text(stat='count', aes(label=after_stat(count)), vjust=-0.5)
    theme_bw() + labs(x = "Estadio clinico", y = "Frequência")

# gráfico de barras das profissões
ggplot(data = turnover, mapping = aes(x = profession)) +
    geom_bar(stat = "count", fill = "lightgrey", color = "black") +
    geom_text(stat='count', aes(label=after_stat(count)), vjust=-0.5)
    theme_bw() + labs(x = "Estadio clinico", y = "Frequência")

# gráfico de barras do meio de acesso a vaga de emprego
ggplot(data = turnover, mapping = aes(x = traffic)) +
    geom_bar(stat = "count", fill = "lightgrey", color = "black") +
    geom_text(stat='count', aes(label=after_stat(count)), vjust=-0.5)
    theme_bw() + labs(x = "Estadio clinico", y = "Frequência")



# VERIFICAÇÃO DA PROPORCIONALIDADE GRÁFICAMENTE

# proporcionalidade dos sexos

mod1 <- coxph(Surv(stag[gender=='m'],event[gender=='m'])~1,
              data=turnover,method="breslow")
summary(mod1)
ss=survfit(mod1)
H01=-log(ss$surv)
time1=ss$time

mod2 <- coxph(Surv(stag[gender=='f'],event[gender=='f'])~1,
              data=turnover,method="breslow")
summary(mod2)
ss=survfit(mod2)
H02=-log(ss$surv)
time2=ss$time

plot(time1, log(H01), type='l', main="time x log(H)", lwd=2, col='blue')
lines(time2, log(H02), lty=2, col="red", lwd=2)


# proporcionalidade da idade - usando o valor mediano

md <- median(turnover$age)
turnover <- turnover %>% mutate(factor_age = ifelse(age <= md, 0, 1))

mod1 <- coxph(Surv(stag[factor_age==0],event[factor_age==0])~1,
              data=turnover,method="breslow")
summary(mod1)
ss=survfit(mod1)
s0=round(ss$surv,3)
H01=-log(s0)
time1=ss$time

mod2 <- coxph(Surv(stag[factor_age==1],event[factor_age==1])~1,
              data=turnover,method="breslow")
summary(mod2)
ss=survfit(mod2)
s0=round(ss$surv,3)
H02=-log(s0)
time2=ss$time

plot(time1, log(H01), type='l', ylim=c(-4, 1), lwd=2)
lines(time2, log(H02), lty=2, col="red", lwd=2)

EKM2 <- survfit(Surv(stag, event)~factor_age, data = turnover)

ggsurvplot(EKM2, 
           data = turnover, 
           ylab="S(t)",
           xlab="Tempo (dias)",
           title="Tempo de sobrevivência estimado via Kaplan-Meyer",
           censor.shape=" ",
           risk.table = F, 
           #risk.table.title="Indivíduos em risco",
           pval = T
)




# Modelo de Cox -----------------------------------------------------------

# modelo maximal
fit1 <- coxph(formula = Surv(stag, event) ~ ., data = turnover, x = TRUE, 
              method = "breslow")
summary(fit1)

# modelo proporcional
fit2 <- coxph(formula = Surv(stag, event)~gender+age+industry+traffic+greywage+way+
                  coach+head_gender+extraversion+independ+selfcontrol+factor_age+
                  anxiety+novator, 
              data = turnover, x = TRUE, method = "breslow")
summary(fit2)

# modelo só com as covariáveis significativas
fit3 <- coxph(formula = Surv(stag, event)~age+traffic+greywage+way+coach+selfcontrol+anxiety,
              data = turnover, x = TRUE,method = "breslow")
summary(fit3)

# função de risco acumulado basal
Ht <- basehaz(fit2, centered = F)

## Verificação de proporcionalidade por testes 

# Resíduos de Schoenfeld 
cox.zph(fit1, transform = "identity")

cox.zph(fit2, transform = "identity")
#par(mfrow=c(2,3))
plot(cox.zph(fit2, transform = "identity", terms=T))

cox.zph(fit3, transform = "identity")
#par(mfrow=c(2,3))
plot(cox.zph(fit3, transform = "identity", terms=T))

## Resíduos de Cox-Snell

res_martingal <- resid(fit2,type="martingale")
res_cox_snell <- event - res_martingal     # resíduos de Cox-Snell
ekm <- survfit(Surv(res_cox_snell, event)~1)
#summary(ekm)

par(mfrow=c(1,2))

plot(ekm, mark.time=F, conf.int=F, xlab="residuos", ylab="S(e) estimada")
res <- sort(res_cox_snell)
exp1 <- exp(-res)
lines(res, exp1, lty=3)
legend(1, 0.8, lty=c(1,3), c("Kaplan Meier","Exponencial(1)"), lwd=1, bty="n", cex=0.7)


st <- ekm$surv
t <- ekm$time
sexp1 <- exp(-t)
plot(st, sexp1, xlab="S(e): Kaplan-Meier", ylab= "S(e): Exponencial(1)", pch=16, ylim=c(0,1))
abline(a=0, b=1)


# Modelagem paramétrica ---------------------------------------------------

# ajuste por Kaplan Meyer
ekm <- survfit(Surv(stag, event) ~ 1, data = turnover)
# ajuste do modelo exponencial
mod_exp <- flexsurvreg(Surv(stag, event) ~ 1, dist='exp', data = turnover)
# ajuste do modelo Weibull
mod_weib <- flexsurvreg(Surv(stag, event) ~ 1, dist='weibull', data = turnover)
# ajuste do modelo lognormal
mod_logn <- flexsurvreg(Surv(stag, event) ~ 1, dist='lnorm', data = turnover)
# ajuste do modelo log-logístico
mod_logl <- flexsurvreg(Surv(stag, event) ~ 1, dist = 'llogis', data = turnover)
# ajuste do modelo gama
mod_gam <- flexsurvreg(Surv(stag, event)~1, dist = 'gamma', data = turnover)

# parece que o modelo paramétrico Gamma é o de melhor ajuste
mod_exp$loglik; mod_weib$loglik; mod_logn$loglik; mod_logl$loglik; mod_gam$loglik
mod_exp$AIC; mod_weib$AIC; mod_logn$AIC; mod_logl$AIC; mod_gam$AIC

# parâmetro estimado da exponencial
alpha_exp <- 1/mod_exp$res[1]
# parâmetros estimados da weibul
alpha_weib <- mod_weib$res[2]
gama_weib <- mod_weib$res[1]
# parâmetros estimados da log-normal
mu_ln <- mod_logn$res[1]
sigma_ln <- mod_logn$res[2]
# parâmetros estimados da log-logística
alpha_ll <- mod_logl$res[2]
gama_ll <- mod_logl$res[1]
# parâmetros estinados da gamma
alpha_gam <- mod_gam$res[1]
beta_gam <- mod_gam$res[2]



# função de sobrevivência da exponencial
sobrev_exp <- function(t){exp(-t/alpha_exp)}
# função de sobrevivência da weibul
sobrev_weib <- function(t){exp(-(t/alpha_weib)^gama_weib)}
# função de sobrevivência da log-normal
sobrev_logn <- function(t){pnorm((-log(t)+mu_ln)/sigma_ln)}
# função de sobrevivência da log-logistíca
sobrev_logl <- function(t){1/(1+ (t/alpha_ll)^gama_ll)}
# função de sobrevivência da gamma
sobrev_gam <- function(t) {1 - pgamma(t, shape = alpha_gam, rate = beta_gam) }


# data frame das probabilidades de sobrevivência para cada modelo
sobrev_df <- data.frame(Tempos = ekm$time,
                        KM = round(ekm$surv, 2),
                        Exp = round(sobrev_exp(ekm$time), 2),
                        Weib = round(sobrev_weib(ekm$time), 2),
                        LogN = round(sobrev_logn(ekm$time), 2),
                        LogL = round(sobrev_logl(ekm$time), 2),
                        Gam = round(sobrev_gam(ekm$time), 2))


# gráfico de ajuste da curva de sobrevivência de cada modelo
colors <- c("KM" = 'black', "Exp" = 'brown', "Weib" = 'green',
            "LogN" = 'blue',"LogL" = 'red',"Gam" = 'orange')

ggplot(data = sobrev_df, mapping = aes(x = Tempos)) +
    geom_line(mapping = aes(y = KM, color = 'KM'), size = 1.2) +
    geom_line(mapping = aes(y = Exp, color = "Exp")) +
    geom_line(mapping = aes(y = Weib, color = 'Weib')) +
    geom_line(mapping = aes(y = LogN, color = "LogN")) +
    geom_line(mapping = aes(y = LogL, color = 'LogL')) +
    geom_line(mapping = aes(y = Gam, color = "Gam")) +
    scale_color_manual(values = colors) + theme_bw()


# gráfico de KM versus modelos com ajuste a reta x=y
ggplot(data = sobrev_df, mapping = aes(x = KM)) +
    geom_point(aes(y = Exp, color = 'Exp')) +
    geom_point(aes(y = Weib, color = 'Weib')) +
    geom_point(aes(y = LogN, color = 'LogN')) +
    geom_point(aes(y = LogL, color = 'LogL')) +
    geom_point(aes(y = Gam, color = 'Gam')) +
    geom_abline(aes(intercept=0, slope=1), linewidth=0.8) +
    ylab("S(t) - modelos paramétricos") + xlab("S(t) - Kaplan-Meier") +
    ylim(0, 1) + xlim(0, 1) +
    scale_color_manual(values = colors)


# as covariáveis a serem testadas
covar <- names(turnover[,-c(1,2)])

# obtenção dos modelos para cada covariável por vez
for (i in 1:length(covar)) {
    mod <- flexsurvreg(formula = Surv(stag, event) ~ get(covar[i]), 
                   data = turnover, dist = "gamma")
    print(covar[i])
    print(mod)
}


# modelo com as variáveis significativas individualmente
mod_gam2 <- flexsurvreg(Surv(stag, event) ~ age+profession+traffic+greywage+way+
                            extraversion+selfcontrol+factor_age, 
                        data = turnover, dist = 'gamma')


# modelo com as variáveis significativas em conjunto
mod_gam3 <- flexsurvreg(Surv(stag, event) ~ age+greywage+way, 
                        data = turnover, dist = 'gamma')
