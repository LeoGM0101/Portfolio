#librarys
rm(list=ls())
library(stringr)
library(plotly)
library(fPortfolio)
#library(install)
library(tidyverse)
library(readxl)
library(lubridate)
library(mondate)
library(gdata)
library(lpSolve)
library(lpSolveAPI)
library(ggplot2)
library(openxlsx)
library(tseries)
require(lubridate)
library(forecast)
library(tidyverse)
library(gridExtra)
library(KernSmooth)
library(quantmod)
library(PerformanceAnalytics)
library(magrittr)
library(timetk)

setwd("Z:/GERENCIA/INVESTIMENTOS/02. RELATÓRIO DE INVESTIMENTOS/2022/05. MODELO DE CONTROLE/01. SCRIPTS/RETORNO e BENCH 12.2021")

##### caracters usado na analise, preencher de acordo com o mes de analise.#####
dias_uteis = 1:23 # sempre prencher de acordo com o aquivo os dias uteis .
Ano_base = 2023
Mes_base = 13 # mes de referencia da base
Meses_calculados = 13 # quantidade de meseses que iremos analisar
Data_base = dmy("01/01/2023")  #Data_fechamento = ao ultimo dia util do mes anterior
fund_register = "Fronteira_Markowitz_v14.xlsm"
cvm_link =  "https://dados.cvm.gov.br/dados/FI/DOC/INF_DIARIO/DADOS/"   #sempre verificar se o site esta ativo.
cvm_link2 = "inf_diario_fi_"  # incio do nome do arquivo
CNPJS = c("07.111.384/0001-69",# Obtendo os fundos de analise e retirando o fundo que ta apresentando problemas
          "25.078.994/0001-90",# Apenas 1 fundo dentre os cadastrados apresenta problema, por isso foi retirado.
          "14.964.240/0001-10",
          "28.578.897/0001-54",
          "11.060.913/0001-10",
          "35.536.532/0001-22",
          "14.507.699/0001-95",
          "38.236.242/0001-51")

########### Incio da analise#
dias_uteis = as.character( dias_uteis) # dias uteis como caracter  
options(scipen = 999)

# lendo a aba de cadastro
s2 <- read_excel("Z:/GERENCIA/INVESTIMENTOS/02. RELATÓRIO DE INVESTIMENTOS/2022/05. MODELO DE CONTROLE/02. DESIGN/Analise-v06.xlsx", sheet = "CADASTRO_NEW")

# saldo do fundo ? o do ultimo dia util do mes 
Saldo_Fundos <- read_excel("Z:/GERENCIA/INVESTIMENTOS/02. RELATÓRIO DE INVESTIMENTOS/2022/06. RELATÓRIO MENSAL/09. SETEMBRO/DistribuicoesAplicacoes_setembro2022.xlsx", sheet = "21")
Saldo_Fundos = Saldo_Fundos %>% drop_na(Coluna1) # retirando os nulos
Saldo_Fundos = Saldo_Fundos[Saldo_Fundos['CO_FUNDO'] == 1782, ]
CNPJS = unique(Saldo_Fundos$Coluna1) # selecionando CNPJs sem repetir


Saldo_Fundos$SALDO = replace(x = Saldo_Fundos$SALDO, list = is.na(Saldo_Fundos$SALDO), values = 0)
Saldo_Fundos$APLICAÇÃO = replace(x = Saldo_Fundos$APLICAÇÃO, list = is.na(Saldo_Fundos$APLICAÇÃO), values = 0)
Saldo_Fundos$RESGATE = replace(x = Saldo_Fundos$RESGATE, list = is.na(Saldo_Fundos$RESGATE), values = 0)
class(Saldo_Fundos$SALDO)

# Capitulo 3 do arquivo 
cadastro = s2[s2$CNPJ_1 %in% CNPJS, ]
Nome_fundo = cadastro$NOME
Bench = cadastro$Bench
my_enquad = cadastro$ENQUADRAMENTO
my_enquad2 = cadastro$`Limite do Enquadramento Legal`
resgate = cadastro$Resgate
taxa_adm = cadastro$`Taxa Administrativa`
Segment = cadastro$SEGMENTO

s = list()
distrib_enquad = c()

for (i in 1:length(cadastro$CNPJ)) {
  
  s[[i]] = filter(Saldo_Fundos, Saldo_Fundos$CNPJ == cadastro$CNPJ[i])
  distrib_enquad[i] = sum(s[[i]]$SALDO)/sum(Saldo_Fundos$SALDO)
  
}

Secao3 = data.frame(Ativos = Nome_fundo,
                    CNPJ = cadastro$CNPJ,
                    RESGATE= resgate,
                    TAXA_ADM = taxa_adm,
                    ENQUADRAMENTO_LEGAL= my_enquad,
                    LIMITE_DO_ENQUADRAMENTO_LEGAL = my_enquad2,
                    DISTRIBUICAO_DA_CARTEIRA_POR_ENQUADRAMENTO_LEGAL = distrib_enquad,
                    SEGMENTO = Segment)

write.xlsx(Secao3, "Secao3_relatorio.xlsx") # criando o arquivo

# Sec?o 4 

Saldo_Fundos_anterior <- read_excel("Z:/GERENCIA/INVESTIMENTOS/02. RELATÓRIO DE INVESTIMENTOS/2022/02. LAYOUT CADASTRAL/DistribuicoesAplicacoesTeste_v01.xlsx", sheet = "29-07-2022")

Saldo_Fundos_anterior$SALDO = replace(x = Saldo_Fundos_anterior$SALDO, list = is.na(Saldo_Fundos_anterior$SALDO), values = 0)
Saldo_Fundos_anterior$APLICAÇÃO = replace(x = Saldo_Fundos_anterior$APLICAÇÃO, list = is.na(Saldo_Fundos_anterior$APLICAÇÃO), values = 0)
Saldo_Fundos_anterior$RESGATE = replace(x = Saldo_Fundos_anterior$RESGATE, list = is.na(Saldo_Fundos_anterior$RESGATE), values = 0)
Saldo_Fundos_anterior = filter(Saldo_Fundos_anterior, Saldo_Fundos_anterior$CO_FUNDO == 1782)

Fundos = list()
Fundos_ant = list()
my_sald_atual = c()
my_sald_ant = c()
my_aplic = c()
my_rend = c()
my_withd = c()
my_seg = c()
Saldo = Saldo_Fundos$SALDO
Perc_enquad = c()
seg_perc = c()
Fundos_seg = list()

my_rend_mes = c()
my_rend_ano = c()

for (i in 1:length(CNPJS)) {
  
  Fundos[[i]] = filter(Saldo_Fundos, Saldo_Fundos$CNPJ == CNPJS[i])
  
  my_sald_atual[i] = sum(Fundos[[i]]$SALDO)
  
  Fundos_ant[[i]] = filter(Saldo_Fundos_anterior, Saldo_Fundos_anterior$CNPJ == CNPJS[i])
  my_sald_ant[i]= sum(Fundos_ant[[i]]$SALDO)
  
  
}

Fundos_list = list()
Fundos_aplic = list()
dias_uteis = 1:23

dias_uteis =as.character( dias_uteis)
#aplic_resg= function(dias_uteis){

for (i in 1:23) {
  
  Fundos_aplic[[i]] = read_excel("Z:/GERENCIA/INVESTIMENTOS/02. RELATÓRIO DE INVESTIMENTOS/2022/07. RELATORIO DIARIO/DistribuicoesAplicacoes_agosto2022.xlsx", sheet = dias_uteis[i])
  Fundos_aplic[[i]] =  filter(Fundos_aplic[[i]], Fundos_aplic[[i]]$CNPJ != "N/A")
  Fundos_aplic[[i]] = filter(Fundos_aplic[[i]], Fundos_aplic[[i]]$CO_FUNDO == 1782)
  
  Fundos_aplic[[i]]$APLICAÇÃO = replace(x = Fundos_aplic[[i]]$APLICAÇÃO, list = is.na(Fundos_aplic[[i]]$APLICAÇÃO), values = 0)
  Fundos_aplic[[i]]$RESGATE = replace(x = Fundos_aplic[[i]]$RESGATE, list = is.na(Fundos_aplic[[i]]$RESGATE), values = 0)
  #Fundos_aplic[[i]] = filter(Fundos_aplic[[i]],Fundos_aplic[[i]]$APLICA??O !=0 | Fundos_aplic[[i]]$RESGATE !=0)
  
  
}

j=1
Fundos_list = rbind(Fundos_aplic[[1]],Fundos_aplic[[2]])

for (j in 3:23) {
  Fundos_list = rbind(Fundos_list, Fundos_aplic[[3]])
}
Fundos_list_final = list()

j=1
for (j in 1:length(CNPJS)) {
  
  Fundos_list_final[[j]] = filter(Fundos_list, Fundos_list$CNPJ == CNPJS[j])
  
  my_aplic[j]= sum(Fundos_list_final[[j]]$APLICAÇÃO)
  my_withd[j]= sum(Fundos_list_final[[j]]$RESGATE)
  my_rend[j] = (my_sald_atual[j])-(my_sald_ant[j]+my_aplic[j]+my_withd[j])
  
  
}


setwd("Z:/GERENCIA/INVESTIMENTOS/02. RELATÓRIO DE INVESTIMENTOS/2022/05. MODELO DE CONTROLE/01. SCRIPTS/RENTABILIDADE-e-RISCOS")

Ano_base = 2022
Mes_base = 8
Meses_calculados = 8
Data_base = dmy("01/08/2022")
#Data_fechamento = "29/07/2022"
fund_register = "Fundos_cadastrados.xlsx"
cvm_link =  "https://dados.cvm.gov.br/dados/FI/DOC/INF_DIARIO/DADOS/"   #"http://dados.cvm.gov.br/dados/FI/DOC/INF_DIARIO/DADOS/inf_diario_fi_" # o link nao existe, troquei porem esou na duvida se esta certo o que peguei
cvm_link2 = "inf_diario_fi_"   # o erro ta aquiiiiiiiiiiii
Valor_quota=0
rentabilidade_ano= c()
rentabilidade_mes = c()
my_dt = list()
my_dt2=list()
my_data =0
dt_min=list()
dt_max=list()
dt_max_mes_anterior= list()
dt_mes_anterior= list()

# criando a lista de datas para nomear os links
suffix_cvm = function(Meses_calculados,Data_base){
  Anos=0
  Meses=0
  #Starting dates
  Meses[1] = format(mondate(Data_base, "%m"))
  Anos[1] = format(mondate(Data_base, "%Y"))
  
  #Creating suffix to be used in cvm link
  suffix = rep(0, Meses_calculados)
  suffix[1] = paste0(Anos[1], Meses[1])
  
  for (i in 1:(Meses_calculados-1))
  {
    Meses[i+1] = format(mondate(Data_base- months(i), "%m"))
    Anos[i+1] = format(mondate(Data_base- months(i), "%Y"))
    suffix[i+1] = paste0(Anos[i+1], Meses[i+1])
  }
  
  return(suffix)
}

suffix = suffix_cvm(Meses_calculados ,Data_base)

n = Meses_calculados
#Download_CVM = function(n, suffix)
#{

  #Temporary file to be created
#  tempdir()
  
  tmp = tempfile()
  caminho = setwd("Z:/GERENCIA/INVESTIMENTOS/02. RELATÓRIO DE INVESTIMENTOS/2022/05. MODELO DE CONTROLE/01. SCRIPTS/")
  #lista = list()
  lista = 0
  mydta = paste0(cvm_link2, suffix)
  myurl = paste0(cvm_link, mydta,".zip")
  #tempfile(paste0(mydta, ".zip"))
  
  for (i in 1:n){
    #destination = ""
    download.file(url = myurl[i], destfile = tmp)   #    EMPAQUEIIIIIII DESTFILE
    dtzip = unzip(tmp, files = "CVM_todos.csv")
    dados = read.csv2(dtzip)
    
    # lista[[i]] = read_delim(mydta[i],
    #                         delim = ";",
    #                         escape_double = FALSE,
    #                         col_types = cols(DT_COMPTC = col_character()),
    #                         trim_ws = TRUE)
  }
  
download.file(url = "https://dados.cvm.gov.br/dados/FI/DOC/INF_DIARIO/DADOS/inf_diario_fi_202210.zip", destfile = tmp) 
datazip = unzip(tmp, files = "inf_diario_fi_202210.csv")
dado_teste = read_csv(datazip)

#  return(lista)
#}
  
my_dt = Download_CVM(Meses_calculados, suffix)

Read_CVM = function(n, suffix)
{
  lista = list()
  mydta = paste0(cvm_link2, suffix,".csv")
  
  for (i in 1:n){
    #lista[[i]] = read_delim(mydta[i],
    #                       delim = ";",
    #                       escape_double = FALSE,
    #                      col_types = cols(DT_COMPTC = col_character()),
    #                      trim_ws = TRUE)
    
    lista = do.call(rbind.data.frame, lapply(list.files(path = ".", pattern = "csv"),
                                             read.csv, sep = ";"))
  }
  return(lista)
}

my_dt = Read_CVM(Meses_calculados, suffix)

read_funds = function(fund_register)
{
  Fundos <- read_excel(fund_register, sheet = "CADASTRO")
  Fundos <- Fundos %>%
    select(`Nome do fundo`,
           CNPJ,
           Resgate,
           Bench,
           `Taxa Administrativa`,
           `Grau de Risco`,
           `Enquadramento Legal`,
           `Limite do Enquadramento Legal`,
           Segmento
    ) %>%
    rename.vars(from = "CNPJ",
                to = "CNPJ_FUNDO")
  Fundos$Restricao_segmento= Fundos$`Limite do Enquadramento Legal`
  Fundos$Data_analise = paste0("0",Mes_base,"/",Ano_base)
  
  #Blacklist
  Fundos = filter(Fundos, Fundos$CNPJ_FUNDO != "35.292.597/0001-70")
  #Fundos = filter(Fundos, Fundos$CNPJ_FUNDO != "10.740.658/0001-93")
  Fundos = filter(Fundos, Fundos$CNPJ_FUNDO != "45.443.475/0001-90")
  
  Fundos = filter(Fundos, Fundos$CNPJ_FUNDO != "44.683.378/0001-02")
  
  return(Fundos)
}

Fundos = read_funds(fund_register)

otimizacao = function(my_dt, Fundos)
{
  Desvio = 0
  dt = 0
  vl_quota = 0
  for (i in 1:length(my_dt))
  {
    rentabilidademedia[i] = mean(my_dt[[i]]$rentabilidade)
    Desvio[i] = sd(my_dt[[i]]$rentabilidade) 
    dt = filter(my_dt[[i]], my_dt[[i]]$DT_COMPTC == max(my_dt[[i]]$DT_COMPTC))
    my_data[i]= dt$VL_PATRIM_LIQ[1]
    vl_quota[i] = my_dt[[i]]$VL_QUOTA[1]
  }
  
  for (i in 1:length(my_dt))
    my_dt[[i]] = my_dt[[i]] %>% select(rentabilidade)
  
  teste = my_dt[[1]]
  
  for (j in 2:length(my_dt))
    teste = cbind(teste,my_dt[[j]])
  
  
  for (k in 1:length(Fundos$`Nome do fundo`)) 
    names(teste)[k]<- unique(Fundos$`Nome do fundo`)[k] 
  
  
  
  rentabilidade <- as.timeSeries(teste) #tangecyPortfolio() only accepts time.series object.
  
  
  constraints <- c('maxsumW[Restricoes(Fundos$`Enquadramento Legal`,"Art. 7º, IV, a")]=0.39',
                   'maxsumW[Restricoes(Fundos$`Enquadramento Legal`,"Art. 8º, I, a")]=0.29',
                   'maxsumW[Restricoes(Fundos$`Enquadramento Legal`,"Art. 8º, II, a")]=0.19',
                   'maxsumW[Restricoes(Fundos$`Enquadramento Legal`,"Art. 8º, III")]=0.09',
                   'maxsumW[Restricoes(Fundos$`Enquadramento Legal`,"Art. 9º-A, III")]=0.09',
                   'maxsumW[Restricoes(Fundos$`Enquadramento Legal`,"Art. 7º, VII, b")]=0.04',
                   'maxsumW[Restricoes(Fundos$`Enquadramento Legal`,"Art. 7º, III")]=0.59',
                   'maxsumW[Restricoes(Fundos$Segmento,"Renda variável")]=0.29',
                   'maxsumW[Restricoes(Fundos$Segmento,"Exterior")]=0.09')
  
  
  
  portfolio.eficiente <- tangencyPortfolio(rentabilidade, spec = portfolioSpec(), constraints)
  
  Markowitz = data.frame(Fundos = Fundos$`Nome do fundo`,
                         Bench = Fundos$Bench,
                         Resgate = Fundos$Resgate,
                         Taxa_Administrativa =Fundos$`Taxa Administrativa`,
                         CNPJ = Fundos$CNPJ_FUNDO,
                         Grau_de_Risco = Fundos$`Grau de Risco`,
                         Enquadramento_legal = Fundos$`Enquadramento Legal`,
                         Limite_do_Enquadramento_Legal = Fundos$`Limite do Enquadramento Legal`,
                         Segmento = Fundos$Segmento,
                         Restricao_segmento = Fundos$Restricao_segmento,
                         Max_recursos = 0.14*my_data,
                         Rentabilidade_Media = rentabilidademedia,
                         Desvio = Desvio,
                         Recursosporcentagem = portfolio.eficiente@portfolio@portfolio$weights,
                         Valor_Quota = vl_quota ,
                         Data_analise = Fundos$Data_analise)
  
  Markowitz$Recursos = Markowitz$Max_recursos*Markowitz$Recursosporcentagem
  
  return(Markowitz)
}

Markowitz = otimizacao(my_dt2,Fundos)

write.xlsx(Markowitz,"Carteira_markowitz_v02.xlsx")

install.packages("PerformanceAnalytics")

returns <- log()

## Historical

var_historical <- VaR(R = returns, p = 0.95, method = "historical")

var_historical

var_gaussian <- VaR(R = returns, p = 0.95, method = "gaussian")

var_gaussian

# Definimos os pesos do portf?lio

w <- c(, , )

# Calcula o VaR com o portfolio

VaR(returns, p = 0.99, weights = w,
    portfolio_method = "component")

#Fundos = read_funds(fund_register)

my_dt2 = Analise_CNPJ(my_dt)

#for (i in 1:length(my_dt)) {
#  my_dt[[i]] = my_dt[[i]][1:412,]
#}

data =  as.Date.character(my_dt2[[1]]$DT_COMPTC)

my_dt3 = my_dt2[[1]]$VL_QUOTA

dt =0

i=1

for (i in 2:length(my_dt2)) {
  dt =  my_dt2[[i]] %>% select(VL_QUOTA) 
  my_dt3 = cbind(my_dt3,dt)
}

#returns <- log(my_dt3)

#returns2 = as.xts(returns) 
returns = xts(my_dt3 , order.by = data )

returns2 <- Return.calculate(returns, method = "log") %>%
  na.omit() 

returns3 <- Return.calculate(returns, method = "discrete") %>%
  na.omit() 


var<- VaR(R = returns2, p = 0.95, method = "gaussian")

var

w = c((27.613178678020300000/100),
      (42.9056101134357/100),
      (20.3329874527769/100),
      (9.00000000000064/100),
      (0.009661249758806410/100),
      (0.066982638446196400/100),
      (0.031115382660024200/100),
      (0.040464484901937600/100))

#w <- c(0.0272, 0.3524, 0.2236,0.3957,0.0003,0.0001,0.000049,0.000464,0.000132)
# Calcula o VaR com o portfolio

VaR(returns2, p = 0.95, weights = w,
    portfolio_method = "component")

var2 <- VaR(R = returns2, p = 0.95, method = "historical")

var2

VaR(returns3, p = 0.95, weights = w,
    portfolio_method = "component")

