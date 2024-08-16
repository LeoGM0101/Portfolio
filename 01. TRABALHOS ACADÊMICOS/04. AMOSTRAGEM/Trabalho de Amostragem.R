rm(list=ls())
library(tidyverse)
library(readxl)
library(openxlsx)
setwd("C:/Users/leona/Desktop/Quantitativo da População")
dados_1 = dados = read_excel("Usuários_CECAS_Amostragem.xlsx")
dados_1$Sexo[dados_1$Sexo == "Feminino"] = "Mulheres"
dados_1$Sexo[dados_1$Sexo == "Masculino"] = "Homens"
dados = read_excel("Usuários_CECAS_Amostragem.xlsx", sheet = "Planilha2")
dados$Sexo[dados$Sexo == "Feminino"] = "Mulheres"
dados$Sexo[dados$Sexo == "Masculino"] = "Homens"
tabelas = createWorkbook()

# dados = dados %>%
#   distinct(Matrícula, Sexo, Curso, `Unidade Acadêmica`, `Faixa Etária Do Estudante`, 
#            `Escola Pública`, `Estado De Nascimento Do Estudante`)

frequencia = dados_1 %>%
  group_by(Sexo) %>%
  count(Sexo) %>%
  mutate(porcentagem = n/1229) 

addWorksheet(tabelas, "frequencia")
writeData(tabelas, "frequencia", frequencia)

ggplot(frequencia, aes(x = Sexo, y = porcentagem, fill = Sexo)) +
  geom_bar(stat = "identity") +
  labs(title = "Frequencias Homens x Mulheres",
       x = "Sexo",
       y = "Frequencia Relativa") + theme_classic()

sexo = dados %>%
  group_by(Sexo) %>%
  count(Sexo)

addWorksheet(tabelas, "Sexo")
writeData(tabelas, "Sexo", sexo)

ggplot(sexo, aes(x = Sexo, y = n, fill = Sexo)) +
  geom_bar(stat = "identity") +
  labs(title = "Quantitativo Masculino x Feminino",
       x = "Sexo",
       y = "Frequencia") + theme_classic()


curso = dados %>%
  group_by(Curso) %>%
  count(Curso) %>%
  mutate(porcentagem = (n/148)) %>%
  arrange(desc(n))
  
sum(as.vector(curso$n))

addWorksheet(tabelas, "Curso")
writeData(tabelas, "Curso", curso)

ggplot(curso, aes(x = Curso, y = n)) +
  geom_bar(stat = "identity", fill = "springgreen4") +
  labs(title = "Quantitativo dos Cursos",
       x = "Cursos",
       y = "Frequencia") + theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  

unidade = dados %>%
  group_by(`Unidade Acadêmica`) %>%
  count(`Unidade Acadêmica`) %>%
  mutate(porcentagem = n/148) %>%
  arrange(desc(n))

dados %>%
  group_by(`Unidade Acadêmica`) %>%
  summarise(media = mean(`Unidade Acadêmica`))

addWorksheet(tabelas, "Unidade Acadêmica")
writeData(tabelas, "Unidade Acadêmica", unidade)

ggplot(unidade, aes(x = `Unidade Acadêmica`, y = n)) +
  geom_bar(stat = "identity", fill = "tomato1") +
  labs(title = "Quantitativo das Unidades Acadêmicas",
       x = "Unidade Acadêmica",
       y = "Frequencia") + theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

faixa_etaria = dados %>%
  group_by(`Faixa Etária Do Estudante`) %>%
  count(`Faixa Etária Do Estudante`) %>%
  mutate(porcentagem = (n/148)*100) %>%
  arrange(desc(n))

addWorksheet(tabelas, "Faixa Etária Do Estudante")
writeData(tabelas, "Faixa Etária Do Estudante", faixa_etaria)

ggplot(faixa_etaria, aes(x = `Faixa Etária Do Estudante`, y = porcentagem)) +
  geom_bar(stat = "identity", fill = "slategray4") +
  labs(title = "Faixa Etária Dos Discentes",
       x = "Faixa Etária Do Estudante",
       y = "Percentual") + theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(dados, aes(x = `Faixa Etária Do Estudante`, y = Idade)) +
  geom_boxplot() +
  labs(x = "Faixa Etária",
       y = "Idade") +
  facet_wrap(~ Sexo)
  


escola_publica = dados %>%
  group_by(`Escola Pública`) %>%
  count(`Escola Pública`)

addWorksheet(tabelas, "Escola Pública")
writeData(tabelas, "Escola Pública", escola_publica)

ggplot(escola_publica, aes(x = `Escola Pública`, y = n, fill = `Escola Pública`)) +
  geom_bar(stat = "identity") +
  labs(title = "Comparativo entre Escola Pública x Escola Particular",
       x = "Escola Pública",
       y = "Frequencia") + theme_classic()

estado_nascimento = dados %>%
  group_by(`Estado De Nascimento Do Estudante`) %>%
  count(`Estado De Nascimento Do Estudante`) %>%
  arrange(desc(n))

addWorksheet(tabelas, "Estado De Nascimento")
writeData(tabelas, "Estado De Nascimento", estado_nascimento)

ggplot(estado_nascimento, aes(x = `Estado De Nascimento Do Estudante`, y = n)) +
  geom_bar(stat = "identity", fill = "sienna3") +
  labs(title = "Quantitativo do Estado De Nascimento Dos Estudantes",
       x = "Estado De Nascimento Do Estudante",
       y = "Frequencia") + theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

grau_academico = dados %>%
  group_by(`Grau Acadêmico`) %>%
  count(`Grau Acadêmico`) %>%
  arrange(desc(n))

ggplot(grau_academico, aes(x = `Grau Acadêmico`, y = n, fill = `Grau Acadêmico`)) +
  geom_bar(stat = "identity") +
  labs(title = "Grau Acadêmico dos Discentes",
       x = "Grau Acadêmico",
       y = "Frequencia") + theme_classic() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())
  
campus = dados %>%
  group_by(`Câmpus`) %>%
  count(`Câmpus`) %>%
  arrange(desc(n))

ggplot(campus, aes(x = `Câmpus`, y = n, fill = `Câmpus`)) +
  geom_bar(stat = "identity") +
  labs(title = "Câmpus dos Discentes",
       x = "Câmpus",
       y = "Frequencia") + theme_classic()

idade = dados %>%
  group_by(`Idade`) %>%
  count(`Idade`) %>%
  mutate(porcentagem = n/148) %>%
  arrange(desc(n))

dados %>% summarise(media = mean(Idade))

ggplot(dados, aes(x = Idade)) +
  geom_histogram(binwidth = 1, fill = "slategray4", color = "black") +
  labs(title = "Histograma da Idade dos Alunos",
       x = "Idade",
       y = "Frequência") +
  theme_minimal()



saveWorkbook(tabelas, "tabelas.xlsx")


str(dados)
