library(tidyverse)
library(readxl)
library(gdata)
library(MortalityLaws)
library(openxlsx)

#.libPaths()

# Importação 
Atuario2021 <- read_excel("Z:/GERENCIA/FONTES/01. BASES ATUARIAIS/2022-01-BD-SPREV.xlsx")
ativos=Atuario2021
ativos$data_focal =  rep( as.Date("2021/12/30"), length(ativos$ID_SERVIDOR_CPF))


ativos= ativos %>% 
  distinct ( ativos$ID_SERVIDOR_CPF, .keep_all = TRUE)


ativos$idade= lubridate::year(ativos$data_focal)- lubridate:: year(ativos$DT_NASC_SERVIDOR)

ativos= filter(ativos,between(idade,18,75))

ativos$idadeente = lubridate::year(ativos$data_focal)- lubridate:: year(ativos$DT_ING_ENTE)



Atuario122021b <- read_excel("Z:/GERENCIA/FONTES/01. BASES ATUARIAIS/2022-01-BD-SPREV.xlsx", 
                                        sheet = "Inativo" , col_types = c("numeric", 
                                                                          "numeric",
                                                                          "numeric",
                                                                          "text",
                                                                          "text", 
                                                                          "numeric",
                                                                          "numeric",
                                                                          "text",
                                                                          "text", 
                                                                          "numeric",
                                                                          "numeric",
                                                                          "numeric", 
                                                                          "numeric",
                                                                          "numeric",
                                                                          "numeric", 
                                                                          "text",
                                                                          "text", 
                                                                          "numeric",
                                                                          "numeric", 
                                                                          "date",
                                                                          "date",
                                                                          "date",
                                                                          "date",
                                                                          "numeric", 
                                                                          "text",
                                                                          "numeric",
                                                                          "numeric",
                                                                          "numeric", 
                                                                          "numeric",
                                                                          "numeric",
                                                                          "numeric", 
                                                                          "numeric",
                                                                          "numeric",
                                                                          "numeric"))


inativos = Atuario122021b

inativos$data_focal =  rep( as.Date("2021/12/30"), length(inativos$ID_APOSENTADO_CPF))
inativos$idade= lubridate::year(inativos$data_focal)- lubridate:: year(inativos$DT_NASC_APOSENTADO)

inativos= inativos %>% 
  distinct ( inativos$ID_APOSENTADO_CPF, .keep_all = TRUE)

inativos = filter(inativos , inativos$CO_TIPO_APOSENTADORIA != 4 )
inativos$idadebeneficio = lubridate::year(inativos$DT_INICIO_APOSENTADORIA)- lubridate:: year(inativos$DT_NASC_APOSENTADO)
inativos = filter(inativos , between(inativos$idadebeneficio, 40,75))



falecidos03082021 <- read_excel("Z:/GERENCIA/FONTES/03. FALECIDOS/2021-08-03-Falecidos.xlsx", 
                                col_types = c("text", "numeric", "text", 
                                              "numeric", "numeric", "date", "date", 
                                              "numeric", "text"))




falecidos2020 = falecidos03082021
#falecidos2020 = falecidos19062021
falecidos2020$idade_fal = difftime(falecidos2020$DT_OBITO_SERVIDOR,falecidos2020$DT_NASC_SERVIDOR, unit = "days")
falecidos2020$idade_fal = as.numeric(falecidos2020$idade_fal)
falecidos2020$idade_fal = floor(falecidos2020$idade_fal/365.25)
#falecidos2020$idade_fal= lubridate::year(falecidos2020$DATA_FALECIMENTO)- lubridate:: year(falecidos2020$DATA_NASCIMENTO)
library(gdata)

str(ativos)

####
#falecidos2020=rename.vars(falecidos2020,from="ID_SERVIDOR_CPF", to= "CPF")
#falecidos2020=rename.vars(falecidos2020,from="NUMR_cpf", to= "CPF")
#falecidos2020=rename.vars(falecidos2020,from="DT_NASC_SERVIDOR", to= "DT_NASC_SERVIDOR")
falecidos2020=rename.vars(falecidos2020,from="DT_OBITO_SERVIDOR", to= "DATA_FALECIMENTO")
falecidos2020=rename.vars(falecidos2020,from="MILITAR?", to= "CO_COMP_MASSA")
#falecidos2020=rename.vars(falecidos2020,from="CO_SEXO_SERVIDOR", to= "SEXO")



ativos$DATA_FALECIMENTO  =  rep( as.Date("2200/12/30") , length(ativos$ID_SERVIDOR_CPF))
inativos$DATA_FALECIMENTO  =  rep( as.Date("2200/12/30") , length(inativos$ID_APOSENTADO_CPF))


ativos = rename.vars(ativos, from = "DT_ING_ENTE", to = "DATA_INGRESSO_ENTE")




falecidos2020$DATA_INGRESSO_ENTE =  rep( as.Date("2200/12/30") , length(falecidos2020$ID_SERVIDOR_CPF))
#falecidos2020=rename.vars(falecidos2020,from="`MILITAR?`", to= "COMPOSICAO_DA_MASSA")
falecidos2020=rename.vars(falecidos2020,from="idade_fal", to= "idade")


inativos = rename.vars(inativos, from = "ID_APOSENTADO_CPF" , to = "ID_SERVIDOR_CPF")
inativos = rename.vars(inativos, from = "DT_NASC_APOSENTADO" , to = "DT_NASC_SERVIDOR")
inativos = rename.vars(inativos, from = "CO_SEXO_APOSENTADO" , to = "CO_SEXO_SERVIDOR")
inativos = rename.vars(inativos, from = "DATA_DE_INGRESSO_NO_ENTE" , to = "DATA_INGRESSO_ENTE")
#falecidos2020 <- falecidos2020 %>% 
# dplyr::mutate(COMPOSICAO_DA_MASSA= ifelse( lubridate:: year(falecidos2020$COMPOSICAO_DA_MASSA) == 2, 1, 2))

for ( i in 1:length(falecidos2020$ID_SERVIDOR_CPF) ) {  if( falecidos2020$CO_COMP_MASSA[i] == 1 ){
  falecidos2020$CO_COMP_MASSA[i]= 2
  
}
  
  
  else  {  falecidos2020$CO_COMP_MASSA[i] = 1
  }
  
  falecidos2020$CO_COMP_MASSA
  
}











fal=  falecidos2020%>%
  select(idade,ID_SERVIDOR_CPF,CO_SEXO_SERVIDOR,DT_NASC_SERVIDOR,DATA_FALECIMENTO,CO_COMP_MASSA,DATA_INGRESSO_ENTE)

at= ativos%>%
  select(idade,ID_SERVIDOR_CPF,CO_SEXO_SERVIDOR,DT_NASC_SERVIDOR,DATA_FALECIMENTO,CO_COMP_MASSA,DATA_INGRESSO_ENTE)

ina= inativos%>%
  select(idade,ID_SERVIDOR_CPF,CO_SEXO_SERVIDOR,DT_NASC_SERVIDOR,DATA_FALECIMENTO,CO_COMP_MASSA,DATA_INGRESSO_ENTE)













#ina = rename.vars(ina, from ="DATA_INICIO_BENEFICIO" , to = "DATA_INGRESSO_ENTE")


total=rbind(at,fal,ina)


tot2021=  total %>% 
  distinct ( total$ID_SERVIDOR_CPF, .keep_all = TRUE)






tot2021 <- tot2021 %>% 
  dplyr::mutate(status= ifelse( lubridate:: year(tot2021$DATA_FALECIMENTO) == 2200, "vivos", "falecidos"))

tot2021 <- tot2021 %>% 
  dplyr::mutate(status1= ifelse( lubridate:: year(tot2021$DATA_FALECIMENTO) == 2200, 1, 0))





# 1 vivo , 0 falecido 

# 2017 a 2021 

#tot2020 = filter(tot2020,  between(  lubridate:: year(tot2020$DATA_FALECIMENTO), 2017,2020 ) | status == "vivos" )
tot2021 = filter(tot2021,    lubridate:: year(tot2021$DATA_FALECIMENTO) ==2021 | status == "vivos" )

#2021

#Homens Civis 



Tabuam2021 = filter(tot2021, lubridate:: year ( tot2021$DATA_FALECIMENTO) == 2021  | lubridate:: year ( tot2021$DATA_FALECIMENTO) == 2200    )
Tabuam2021 = filter(Tabuam2021 , CO_SEXO_SERVIDOR ==2  & CO_COMP_MASSA == 1)
mativos= filter(Tabuam2021 , status == "vivos")  
mfalecidos = filter(Tabuam2021 , status == "falecidos")

mativos= mativos %>%
  group_by(idade) %>%
  count()

mfalecidos= mfalecidos%>%
  group_by(idade) %>%
  count()

x=data.frame(idade=c(1:118))
mtotal_vivos=0
mtotal = full_join(x,mativos,by="idade")
mtotal = full_join(mtotal,mfalecidos,by="idade")


mtotal=mtotal %>% 
  mutate_all(coalesce,0) 


mtotal=rename.vars(mtotal,from="n.x", to= "Vivos")
mtotal=rename.vars(mtotal,from="n.y", to= "Falecidos")



mtotal$total = mtotal$Vivos+ mtotal$Falecidos




write.xlsx( mtotal, 'homenscivis2021.xlsx')


# homens militares 

# 2021 



Tabuam22021 = filter(tot2021, lubridate:: year ( tot2021$DATA_FALECIMENTO) == 2021  | lubridate:: year ( tot2021$DATA_FALECIMENTO) == 2200)
Tabuam22021 = filter(Tabuam22021 , CO_SEXO_SERVIDOR ==2  & CO_COMP_MASSA == 2)
m2ativos= filter(Tabuam22021 , status == "vivos")  
m2falecidos = filter(Tabuam22021 , status == "falecidos")

m2ativos= m2ativos %>%
  group_by(idade) %>%
  count()

m2falecidos= m2falecidos%>%
  group_by(idade) %>%
  count()

x=data.frame(idade=c(1:111))
m2total_vivos=0
m2total = full_join(x,m2ativos,by="idade")
m2total = full_join(m2total,m2falecidos,by="idade")


m2total=m2total %>% 
  mutate_all(coalesce,0) 
m2total

m2total=rename.vars(m2total,from="n.x", to= "Vivos")
m2total=rename.vars(m2total,from="n.y", to= "Falecidos")



m2total$total = m2total$Vivos+ m2total$Falecidos

write.xlsx( m2total, 'homensmilitares2021.xlsx')

# Mulheres Civis 
#2021
Tabuaf2021 = filter(tot2021, lubridate:: year ( tot2021$DATA_FALECIMENTO) == 2021  | lubridate:: year ( tot2021$DATA_FALECIMENTO) == 2200    )
Tabuaf2021 = filter(Tabuaf2021 ,  CO_SEXO_SERVIDOR ==1  & CO_COMP_MASSA == 1)
fativos= filter(Tabuaf2021 , status == "vivos")  
ffalecidos = filter(Tabuaf2021 , status == "falecidos")


fativos= fativos %>%
  group_by(idade) %>%
  count()

ffalecidos= ffalecidos%>%
  group_by(idade) %>%
  count()

x=data.frame(idade=c(1:111))
ftotal_vivos=0
ftotal2 = full_join(x,fativos,by="idade")
ftotal2 = full_join(ftotal2,ffalecidos,by="idade")


ftotal2=ftotal2 %>% 
  mutate_all(coalesce,0) 


ftotal2=rename.vars(ftotal2,from="n.x", to= "Vivos")
ftotal2=rename.vars(ftotal2,from="n.y", to= "Falecidos")




ftotal2$total =  ftotal2$Vivos + ftotal2$Falecidos 


write.xlsx( ftotal2, 'mulheres2021.xlsx')








## ESTIMAÇÂO 





#Tabuam2020 = filter(tot, lubridate:: year ( tot$DATA_FALECIMENTO) == 2020  | lubridate:: year ( tot$DATA_FALECIMENTO) == 2200    )
#Tabuam2020 = filter(Tabuam2020 , SEXO ==2  & COMPOSICAO_DA_MASSA == 1)


# 2021

mtot=filter(mtotal, between(mtotal$idade, 21 ,105))
# Homens civis 


Ests=MortalityLaw(x=mtotal$idade,Dx = mtotal$Falecidos, Ex= mtotal$total ,law = "rogersplanck" , opt.method = "LF2")

summary(Ests)

plot(Ests)

T3= LifeTable(x = mtotal$idade, qx = fitted(Ests))
T3$lt



# FIxando as idades 



Ests1=MortalityLaw(x=mtot$idade,Dx = mtot$Falecidos, Ex= mtot$total ,law = "makeham" , opt.method = "LF2" )
summary(Ests1)

plot(Ests1)


T1= LifeTable(x = mtot$idade, qx = fitted(Ests1))
T1$lt


Ests2=MortalityLaw(x=mtot$idade,Dx = mtot$Falecidos, Ex= mtot$total ,law = "beard_makeham" , opt.method = "LF2" )

summary(Ests2)

plot(Ests2)



T2= LifeTable(x = mtot$idade, qx = fitted(Ests2))
T2$lt
# Esperança de vida 54 anos a partir dos 21 






Ests3=MortalityLaw(x=mtot$idade,Dx = mtot$Falecidos, Ex = mtot$total ,law = "beard" , opt.method = "LF2")

summary(Ests3)
plot(Ests3)

T4= LifeTable(x = mtot$idade, qx = fitted(Ests3))
T4$lt


# Esperança de vida 75 anos a partir de 0 


# Esperança de vida 55 anos a partir de 21


Ests5=MortalityLaw(x=mtot$idade,Dx = mtot$Falecidos, Ex = mtot$total ,law = "ggompertz" , opt.method = "LF2")


summary(Ests5)
plot(Ests5)


T5= LifeTable(x = mtot$idade, qx = fitted(Ests5))
T5$lt




#qx = data.frame(gamma-Gompertz = c(T5$lt$qx),beard = c(T4$lt$qx), beard_makeham= c (T2$lt$qx), makeham=c(T1$lt$qx))


qx = data.frame(cbind(T5$lt$qx,T4$lt$qx,T2$lt$qx, T1$lt$qx))

qx = rename.vars(qx, from= "X1", to = "gamma-Gompertz")
qx = rename.vars(qx, from= "X2", to = "beard")
qx = rename.vars(qx, from= "X3", to = "beard_makeham")
qx = rename.vars(qx, from= "X4", to = " makeham")

qx$falecidos = mtot$Falecidos
qx$total = mtot$total

write.xlsx(qx,"Homens2021.xlsx")





# Homem militar 2021 
m2tot = filter(m2total, between(m2total$idade,20,98))


Ests1=MortalityLaw(x=m2tot$idade,Dx = m2tot$Falecidos, Ex = m2tot$total ,law = "ggompertz" , opt.method = "LF2")


summary(Ests1)
plot(Ests1)


T1= LifeTable(x = m2tot$idade, qx = fitted(Ests1))
T1$lt


#write.xlsx( T2$lt , "Homemmilitar.xlsx")


#residuos = rstudent(Ests2)

Ests2=MortalityLaw(x=m2tot$idade,Dx = m2tot$Falecidos, Ex = m2tot$total ,law = "beard_makeham" , opt.method = "LF2")


summary(Ests2)

plot(Ests2)

Ests2$residuals

T2= LifeTable(x = m2tot$idade, qx = fitted(Ests2))
T2$lt


Ests3=MortalityLaw(x=m2tot$idade,Dx = m2tot$Falecidos, Ex = m2tot$total ,law = "beard" , opt.method = "LF2")


summary(Ests3)

plot(Ests3)


T3= LifeTable(x = m2tot$idade, qx = fitted(Ests3))
T3$lt



Ests4=MortalityLaw(x=m2tot$idade,Dx = m2tot$Falecidos, Ex = m2tot$total ,law = "makeham" , opt.method = "LF2")


summary(Ests4)

plot(Ests4)


T4= LifeTable(x = m2tot$idade, qx = fitted(Ests4))
T4$lt



qx3 = data.frame(cbind(T1$lt$qx,T3$lt$qx,T2$lt$qx, T4$lt$qx))



qx3 = rename.vars(qx3, from= "X1", to = "gamma-Gompertz")
qx3 = rename.vars(qx3, from= "X2", to = "beard")
qx3 = rename.vars(qx3, from= "X3", to = "beard_makeham")
qx3 = rename.vars(qx3, from= "X4", to = " makeham")



qx3$falecidos = m2tot$Falecidos
qx3$total = m2tot$total

write.xlsx(qx3,"Militares2021.xlsx")






# Mulher Civil 2021 

ftot=filter(ftotal2, between( ftotal2$idade, 21,105))



Ests4f = MortalityLaw(x=ftot$idade,Dx = ftot$Falecidos, Ex = ftot$total ,law = "makeham" , opt.method = "LF2")


summary(Ests4f)
plot(Ests4f)


T2f= LifeTable(x = ftot$idade, qx = fitted(Ests4f))
T2f$lt


Ests5f=MortalityLaw(x=ftot$idade,Dx = ftot$Falecidos, Ex = ftot$total ,law = "ggompertz" , opt.method = "LF2")



summary(Ests5f)
plot(Ests5f)

Ests5f$residuals
Ests5f$deviance

T5f= LifeTable(x = ftot$idade, qx = fitted(Ests5f))
T5f$lt



Ests3f=MortalityLaw(x=ftot$idade,Dx = ftot$Falecidos, Ex = ftot$total ,law = "beard_makeham" , opt.method = "LF2")

summary(Ests3f)
plot(Ests3f)
Ests3f$deviance


T4f= LifeTable(x = ftot$idade, qx = fitted(Ests3f))
T4f$lt

 


Ests3f=MortalityLaw(x=ftot$idade,Dx = ftot$Falecidos, Ex = ftot$total ,law = "beard" , opt.method = "LF2")

summary(Ests3f)
plot(Ests3f)


T3f= LifeTable(x = ftot$idade, qx = fitted(Ests3f))
T3f$lt

qx2 = data.frame(cbind(T5f$lt$qx,T3f$lt$qx,T4f$lt$qx, T2f$lt$qx))



qx2 = rename.vars(qx2, from= "X1", to = "gamma-Gompertz")
qx2 = rename.vars(qx2, from= "X2", to = "beard")
qx2 = rename.vars(qx2, from= "X3", to = "beard_makeham")
qx2 = rename.vars(qx2, from= "X4", to = " makeham")



qx2$falecidos = ftot$Falecidos
qx2$total = ftot$total

write.xlsx(qx2,"Mulheres2021.xlsx")




# Testes 


#Teste <- read_excel("Excluir depois.xlsx")


#ks.test(Teste$qxtabua,Teste$qxibge)

#ks.test(Teste$qxtabuaf,Teste$qxibgef)



ks.test(Excluir_depois$qxibge, Excluir_depois$qxtabuaf)



ks.test(taxa$qxtabua,taxa$qxibge)




mtot2021 = mtot

m2tot2021 = m2tot

ftot2021 = ftot