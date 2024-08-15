#Carregando as Bibliotecas
source("Z:/GERENCIA/INVESTIMENTOS/11. PROJETO/3 - VaR/Bibliotecas.R")

#Periodo que sera analisado para calcular o retorno diario de cada fundo e o seu respectivo VaR.
#O ano e o mes estao de acordo com os informes diarios publicados na CVM.
#Caso queira adicionar algum informe diario, basta colocar o ano seguido do mes no vetor abaixo.
#Os informes diarios devem estar em ordem cronologica. Caso adicione algum informe, nao esqueca de salvar o script (ctrl+s).
codigo_fundo = c("202101", "202102", "202103", "202104", "202105", "202106", "202107", "202108", "202109", "202110", "202111", "202112", 
                 "202201", "202202", "202203", "202204", "202205", "202206", "202207", "202208", "202209", "202210", "202211", "202212",
                 "202301", "202302", "202303", "202304", "202305", "202306", "202307", "202308", "202309", "202310", "202311", "202312",
                 "202401", "202402", "202403")

tmp = tempfile()

dados = data.frame()

#Download dos informes diarios.
for(i in 1:length(codigo_fundo)) {
  download.file(url = paste0("https://dados.cvm.gov.br/dados/FI/DOC/INF_DIARIO/DADOS/inf_diario_fi_", codigo_fundo[i],".zip"), destfile = tmp)
  datazip = unzip(tmp, files = paste0("inf_diario_fi_", codigo_fundo[i], ".csv"))
  df = read.csv(datazip, sep = ";", stringsAsFactors = FALSE)
  dados = rbind(dados, df)
}
dados$DT_COMPTC = as.Date(dados$DT_COMPTC, format = "%Y-%m-%d")

#Carregando os CNPJ's dos fundos necessarios.
CNPJs = read_excel("Z:/GERENCIA/INVESTIMENTOS/11. PROJETO/Cadastro Fundos.xlsx") %>%
  select(CNPJ)
CNPJs = as.data.frame(CNPJs)

#Filtrando os fundos do informe diario de acordo com os CNPJ's dos fundos necessarios.
fundos = dados %>%
  arrange(DT_COMPTC) %>%
  filter(CNPJ_FUNDO %in% CNPJs$CNPJ) %>%
  select(DT_COMPTC,CNPJ_FUNDO, VL_QUOTA)