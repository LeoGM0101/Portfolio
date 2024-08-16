rm(list=ls())
library(tidyverse)
library(readxl)
library(gridExtra)

dados = read_excel("C:/Users/leona/Desktop/Trabalho/Questionário de Satisfação (respostas).xlsx")
populacao = read_excel("C:/Users/leona/Desktop/Trabalho/Usuários_CECAS_Amostragem.xlsx", sheet = "Planilha1")

for(i in 1:nrow(dados)) {
  for(j in 1:nrow(populacao)) {
    if(dados$`Número da matrícula`[i] == populacao$Matrícula[j]) {
      dados$Sexo[i] = populacao$Sexo[j]
    }
  }
}

nrow(dados %>% filter(Sexo == "Feminino"))
#------------------------------------------------------------------------------#
tempo_academia = dados%>%
  group_by(Sexo) %>%
  count(`Há quanto tempo você é membro da academia?`) %>%
  rename("Frequencia" = n); tempo_academia

# tempo_academia_descritiva = tempo_academia %>%
#   summarise(Media_Ponderada = sum(Frequencia * `Há quanto tempo você é membro da academia?`) / sum(Frequencia))

horario_academia = dados %>%
  group_by(Sexo) %>%
  count(`Em que horário você costuma realizar seus exercícios físicos na academia?`) %>%
  rename("Frequencia" = n); horario_academia

tabela_contingencia = table(dados$`Qual é o curso de graduação que você faz?`, dados$`Em que horário você costuma realizar seus exercícios físicos na academia?`)
chisq.test(tabela_contingencia)

tabela_contingencia_2 = table(dados$Sexo, dados$`Em que horário você costuma realizar seus exercícios físicos na academia?`)
chisq.test(tabela_contingencia_2)

objetivo = dados %>%
  group_by(Sexo) %>%
  count(`Qual o seu principal objetivo ao realizar exercícios físicos na academia?`) %>%
  rename("Frequencia" = n); objetivo

tabela_contingencia_3 = table(dados$Sexo, dados$`Qual o seu principal objetivo ao realizar exercícios físicos na academia?`)
chisq.test(tabela_contingencia_3)

acompanhamento = dados %>%
  group_by(Sexo) %>%
  count(`Você recebe algum tipo de acompanhamento profissional na academia?`) %>%
  rename("Frequencia" = n); acompanhamento

tabela_contingencia_4 = table(dados$Sexo, dados$`Você recebe algum tipo de acompanhamento profissional na academia?`)
chisq.test(tabela_contingencia_4)

quantidade_aparelhos = dados %>%
  group_by(Sexo) %>%
  count(`Qual o seu grau de satisfação com a quantidade de aparelhos para realizar um treino completo.`) %>%
  rename("Frequencia" = n); quantidade_aparelhos

dist_equipamentos = dados %>%
  group_by(Sexo) %>%
  count(`Qual o seu grau de satisfação com a distribuição dos equipamentos.`) %>%
  rename("Frequencia" = n); dist_equipamentos

variedade = dados %>%
  group_by(Sexo) %>%
  count(`Qual o seu grau de satisfação com a variedade de equipamentos.` ) %>%
  rename("Frequencia" = n); variedade

ventilacao = dados %>% 
  group_by(Sexo) %>%
  count(`Qual o seu grau de satisfação com a ventilação dos ambientes`) %>%
  rename("Frequencia" = n); ventilacao

higiene = dados %>%
  group_by(Sexo) %>%
  count(`Qual o seu grau de satisfação com a higiene do ambiente e equipamentos.`)%>%
  rename("Frequencia" = n); higiene

horarios  = dados %>%
  group_by(Sexo) %>%
  count(`Qual o seu grau de satisfação com os horários ofertados`) %>%
  rename("Frequencia" = n); horarios

#------------------------------------------------------------------------------#

ggplot(tempo_academia, aes(x = `Há quanto tempo você é membro da academia?`, y = Frequencia)) +
  geom_col(fill = "lightgreen") +
  facet_wrap(~ Sexo) + 
  theme_minimal()

ggplot(horario_academia, aes(x =`Em que horário você costuma realizar seus exercícios físicos na academia?`, y = Frequencia)) +
  geom_col(fill = "lightgreen") +
  facet_wrap(~ Sexo) + 
  theme_minimal()


objetivo_homens = objetivo %>% filter(Sexo == "Masculino") %>% mutate(Porcentagem = Frequencia / sum(Frequencia) * 100)
objetivo_mulheres = objetivo %>% filter(Sexo == "Feminino") %>% mutate(Porcentagem = Frequencia / sum(Frequencia) * 100)
grafico_masculino = ggplot(objetivo_homens, aes(x = "", y = Frequencia, fill = `Qual o seu principal objetivo ao realizar exercícios físicos na academia?`)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_void() +
  ggtitle("Objetivos dos Exercícios Físicos - Masculino") +
  theme(legend.position = "right") +
  geom_text(aes(label = paste(round(Porcentagem, 1), "%")), position = position_stack(vjust = 0.5))
grafico_feminino = ggplot(objetivo_mulheres, aes(x = "", y = Frequencia, fill = `Qual o seu principal objetivo ao realizar exercícios físicos na academia?`)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_void() +
  ggtitle("Objetivos dos Exercícios Físicos - Feminino") +
  theme(legend.position = "right") +
  geom_text(aes(label = paste(round(Porcentagem, 1), "%")), position = position_stack(vjust = 0.5))
grid.arrange(grafico_feminino, grafico_masculino, ncol = 2)

ggplot(acompanhamento, aes(x =`Você recebe algum tipo de acompanhamento profissional na academia?`, y = Frequencia)) +
  geom_col(fill = "lightgreen") +
  facet_wrap(~ Sexo) + 
  theme_minimal()

ggplot(quantidade_aparelhos, aes(x =`Qual o seu grau de satisfação com a quantidade de aparelhos para realizar um treino completo.`, y = Frequencia)) +
  geom_col(fill = "lightgreen") +
  facet_wrap(~ Sexo) + 
  theme_minimal()

ggplot(dist_equipamentos, aes(x =`Qual o seu grau de satisfação com a distribuição dos equipamentos.`, y = Frequencia)) +
  geom_col(fill = "lightgreen") +
  facet_wrap(~ Sexo) + 
  theme_minimal()

ggplot(variedade, aes(x =`Qual o seu grau de satisfação com a variedade de equipamentos.`, y = Frequencia)) +
  geom_col(fill = "lightgreen") +
  facet_wrap(~ Sexo) + 
  theme_minimal()

ggplot(ventilacao, aes(x =`Qual o seu grau de satisfação com a ventilação dos ambientes`, y = Frequencia)) +
  geom_col(fill = "lightgreen") +
  facet_wrap(~ Sexo) + 
  theme_minimal()

ggplot(higiene, aes(x =`Qual o seu grau de satisfação com a higiene do ambiente e equipamentos.`, y = Frequencia)) +
  geom_col(fill = "lightgreen") +
  facet_wrap(~ Sexo) + 
  theme_minimal()

ggplot(horarios, aes(x =`Qual o seu grau de satisfação com os horários ofertados`, y = Frequencia)) +
  geom_col(fill = "lightgreen") +
  facet_wrap(~ Sexo) + 
  theme_minimal()

#------------------------------------------------------------------------------#
#Teste de Mann-Whitney
#Ho: Nao ha diferenca significativa entre as distribuicoes das duas amostras;
#Ha: Ha uma diferenca significativa entre as distribuicoes das duas amostras.

dados_homens = dados %>%
  filter(Sexo == "Masculino")
dados_mulheres = dados %>%
  filter(Sexo == "Feminino")

testes = data.frame(Variavel = c("quantidade_aparelhos", "distribuicao_equipamentos", 
                                 "variedade_equipamentos", "ventilacao", "higiene",
                                 "horarios"), Valor_p_MannWhitney = rep(NA, 6))

j = 1
valores = matrix(rep(NA, 6*1000), nrow = 6, ncol = 1000)
df = data.frame(valores)
rejeicoes = data.frame(valores)

for(k in 1:1000) {
  j = 1
  for(i in 12:17) {
    tabela_contingencia_00 = table(dados_homens[[i]], sample(dados_mulheres[[i]], 19))
    df[j, k] = chisq.test(tabela_contingencia_00)$p.value
    j = j + 1
  }
  
  for(l in 1:6) {
  if (df[l, k] < 0.05) {
    rejeicoes[l, k] = 1
  }
  else {rejeicoes[l, k] = 0}  }
}

rejeicoes / 1000
rowMeans(rejeicoes)

j = 1
for(i in 18:23) {
  testes[j, 2] = wilcox.test(dados_homens[[i]], dados_mulheres[[i]])$p.value
  j = j+1
}
