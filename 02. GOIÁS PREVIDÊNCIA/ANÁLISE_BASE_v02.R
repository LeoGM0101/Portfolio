rm(list=ls())
library(tidyverse)
library(openxlsx)
library(readxl)

setwd("Z:/ArquivosTI")

#Ativos
arquivos_202212_ativos = read_excel("Atuario202301.xlsx", sheet = "Ativo")
arquivos_202301_ativos = read_excel("Atuario202302.xlsx", sheet = "Ativo")

# arquivos_202212_ativos$IN_PARID_SERV = as.numeric(arquivos_202212_ativos$IN_PARID_SERV)
# arquivos_202301_ativos$IN_PARID_SERV = as.numeric(arquivos_202301_ativos$IN_PARID_SERV)


ativos = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(calculo = VL_BASE_CALCULO.y - VL_BASE_CALCULO.x, remuneracao = VL_REMUNERACAO.y - VL_REMUNERACAO.x,
            contribuicao = VL_CONTRIBUICAO.y - VL_CONTRIBUICAO.x, tempo_rgps = NU_TEMPO_RGPS.y - NU_TEMPO_RGPS.x, 
            tempo_rpps_mun = NU_TEMPO_RPPS_MUN.y - NU_TEMPO_RPPS_MUN.x, tempo_rpps_est = NU_TEMPO_RPPS_EST.y - NU_TEMPO_RPPS_EST.x, 
            tempo_rpps_fed = NU_TEMPO_RPPS_FED.y - NU_TEMPO_RPPS_FED.x)

ativos %>% filter(calculo != 0) %>% select(calculo)
ativos %>% filter(remuneracao != 0) %>% select(remuneracao)
ativos %>% filter(contribuicao != 0) %>% select(contribuicao)
ativos %>% filter(tempo_rgps != 0) %>% select(tempo_rgps)
ativos %>% filter(tempo_rpps_mun != 0) %>% select(tempo_rpps_mun)
ativos %>% filter(tempo_rpps_est != 0) %>% select(tempo_rpps_est)
ativos %>% filter(tempo_rpps_fed != 0) %>% select(tempo_rpps_fed)

ativos_massa = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(massa = CO_COMP_MASSA.y != CO_COMP_MASSA.x) %>%
  filter(massa == TRUE); ativos_massa #quando TRUE, quer dizer que ha diferença entre a base de 
                                     #janeiro 2023 e a base de dezembro 2022

ativos_fundo = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(fundo = CO_TIPO_FUNDO.y != CO_TIPO_FUNDO.x) %>%
  filter(fundo == TRUE); ativos_fundo; ativos_fundo

ativos_cnpj_orgao = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(cnpj_orgao = NU_CNPJ_ORGAO.y != NU_CNPJ_ORGAO.x) %>%
  filter(cnpj_orgao == TRUE); ativos_cnpj_orgao

ativos_poder = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(poder = CO_PODER.y != CO_PODER.x) %>%
  filter(poder == TRUE); ativos_poder

ativos_tipo_poder = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(tipo_poder = CO_TIPO_PODER.y != CO_TIPO_PODER.x) %>%
  filter(tipo_poder == TRUE); ativos_tipo_poder

ativos_tipo_populacao = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(tipo_populacao = CO_TIPO_POPULACAO.y != CO_TIPO_POPULACAO.x) %>%
  filter(tipo_populacao == TRUE); ativos_tipo_populacao

ativos_tipo_cargo = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(tipo_cargo = CO_TIPO_CARGO.y != CO_TIPO_CARGO.x) %>%
  filter(tipo_cargo == TRUE); ativos_tipo_cargo

ativos_criterio_elegibilidade = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(criterio_elegibilidade = CO_CRITERIO_ELEGIBILIDADE.y != CO_CRITERIO_ELEGIBILIDADE.x) %>%
  filter(criterio_elegibilidade == TRUE); ativos_criterio_elegibilidade

ativos_servidor_matricula = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(servidor_matricula = ID_SERVIDOR_MATRICULA.y != ID_SERVIDOR_MATRICULA.x) %>%
  filter(servidor_matricula == TRUE); ativos_servidor_matricula

ativos_servidor_pis = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(servidor_pis = ID_SERVIDOR_PIS_PASEP.y != ID_SERVIDOR_PIS_PASEP.x) %>%
  filter(servidor_pis == TRUE); ativos_servidor_pis

ativos_sexo = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(sexo = CO_SEXO_SERVIDOR.y != CO_SEXO_SERVIDOR.x) %>%
  filter(sexo == TRUE); ativos_sexo

ativos_est_civil = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(estado_civil = CO_EST_CIVIL_SERVIDOR.y != CO_EST_CIVIL_SERVIDOR.x) %>%
  filter(estado_civil == TRUE); ativos_est_civil

ativos_data_nascimento = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(data_nascimento = DT_NASC_SERVIDOR.y != DT_NASC_SERVIDOR.x) %>%
  filter(data_nascimento == TRUE); ativos_data_nascimento

ativos_situacao_funcional = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(situacao_funcional = CO_SITUACAO_FUNCIONAL.y != CO_SITUACAO_FUNCIONAL.x) %>%
  filter(situacao_funcional == TRUE); ativos_situacao_funcional

ativos_tipo_vinculo = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(tipo_vinculo = CO_TIPO_VINCULO.y != CO_TIPO_VINCULO.x) %>%
  filter(tipo_vinculo == TRUE); ativos_tipo_vinculo

ativos_ingresso = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(ingresso = DT_ING_SERV_PUB.y != DT_ING_SERV_PUB.x) %>%
  filter(ingresso == TRUE); ativos_ingresso

ativos_ing_ente = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(ingresso = DT_ING_ENTE.y != DT_ING_ENTE.x) %>%
  filter(ingresso == TRUE); ativos_ing_ente

ativos_ing_carreira = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(ing_carreira = DT_ING_CARREIRA.y != DT_ING_CARREIRA.x) %>%
  filter(ing_carreira == TRUE); ativos_ing_carreira

ativos_carreira = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(carreira = NO_CARREIRA.y != NO_CARREIRA.x) %>%
  filter(carreira == TRUE); ativos_carreira

ativos_ing_cargo = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(ing_cargo = DT_ING_CARGO.y != DT_ING_CARGO.x) %>%
  filter(ing_cargo == TRUE); ativos_ing_cargo

ativos_cargo = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(cargo = NO_CARGO.y != NO_CARGO.x) %>%
  filter(cargo == TRUE); ativos_ing_cargo

ativos_numero_dependentes = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(dependentes = NU_DEPENDENTES.y != NU_DEPENDENTES.x) %>%
  filter(dependentes == TRUE); ativos_numero_dependentes

ativos_teto_especifico = arquivos_202212_ativos %>%
  inner_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(teto = VL_TETO_ESPECIFICO.y != VL_TETO_ESPECIFICO.x) %>%
  filter(teto == TRUE); ativos_teto_especifico


#Inativos
rm(list=ls())
arquivos_202212_inativos = read_excel("Atuario202212.xlsx", sheet = "Inativo")
arquivos_202301_inativos = read_excel("Atuario202301.xlsx", sheet = "Inativo")

inativos = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(aposentadoria = VL_APOSENTADORIA.y - VL_APOSENTADORIA.x, contribuicao = VL_CONTRIBUICAO.y - VL_CONTRIBUICAO.x, 
            tempo_rpps_mun = NU_TEMPO_RPPS_MUN.y - NU_TEMPO_RPPS_MUN.x, tempo_rpps_est = NU_TEMPO_RPPS_EST.y - NU_TEMPO_RPPS_EST.x, 
            tempo_rpps_fed = NU_TEMPO_RPPS_FED.y - NU_TEMPO_RPPS_FED.x)

inativos %>% filter(aposentadoria != 0) %>% select(aposentadoria)
inativos %>% filter(contribuicao != 0) %>% select(contribuicao)
inativos %>% filter(tempo_rpps_mun != 0) %>% select(tempo_rpps_mun)
inativos %>% filter(tempo_rpps_est != 0) %>% select(tempo_rpps_est)
inativos %>% filter(tempo_rpps_fed != 0) %>% select(tempo_rpps_fed)

inativos_massa = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(massa = CO_COMP_MASSA.y != CO_COMP_MASSA.x) %>%
  filter(massa == TRUE); inativos_massa #quando TRUE, quer dizer que ha diferença entre a base de 
#janeiro 2023 e a base de dezembro 2022

inativos_fundo = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(fundo = CO_TIPO_FUNDO.y != CO_TIPO_FUNDO.x) %>%
  filter(fundo == TRUE); inativos_fundo; inativos_fundo

inativos_cnpj_orgao = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(cnpj_orgao = CNPJ_ORGAO.y != CNPJ_ORGAO.x) %>%
  filter(cnpj_orgao == TRUE); inativos_cnpj_orgao

inativos_poder = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(poder = CO_PODER.y != CO_PODER.x) %>%
  filter(poder == TRUE); inativos_poder

inativos_tipo_poder = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(tipo_poder = CO_TIPO_PODER.y != CO_TIPO_PODER.x) %>%
  filter(tipo_poder == TRUE); inativos_tipo_poder

inativos_tipo_populacao = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(tipo_populacao = CO_TIPO_POPULACAO.y != CO_TIPO_POPULACAO.x) %>%
  filter(tipo_populacao == TRUE); inativos_tipo_populacao

inativos_tipo_cargo = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(tipo_cargo = CO_TIPO_CARGO.y != CO_TIPO_CARGO.x) %>%
  filter(tipo_cargo == TRUE); inativos_tipo_cargo

inativos_tipo_APOSENTADOria = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(tipo_APOSENTADOria = CO_TIPO_APOSENTADORIA.y != CO_TIPO_APOSENTADORIA.x) %>%
  filter(tipo_APOSENTADOria == TRUE); inativos_tipo_APOSENTADOria

inativos_APOSENTADO_matricula = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(APOSENTADO_matricula = ID_APOSENTADO_MATRICULA.y != ID_APOSENTADO_MATRICULA.x) %>%
  filter(APOSENTADO_matricula == TRUE); inativos_APOSENTADO_matricula

inativos_APOSENTADO_pis = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(APOSENTADO_pis = ID_APOSENT_PIS_PASEP.y != ID_APOSENT_PIS_PASEP.x) %>%
  filter(APOSENTADO_pis == TRUE); inativos_APOSENTADO_pis

inativos_sexo = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(sexo = CO_SEXO_APOSENTADO.y != CO_SEXO_APOSENTADO.x) %>%
  filter(sexo == TRUE); inativos_sexo

inativos_est_civil = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(estado_civil = CO_EST_CIVIL_APOSENTADO.y != CO_EST_CIVIL_APOSENTADO.x) %>%
  filter(estado_civil == TRUE); inativos_est_civil

inativos_data_nascimento = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(data_nascimento = DT_NASC_APOSENTADO.y != DT_NASC_APOSENTADO.x) %>%
  filter(data_nascimento == TRUE); inativos_data_nascimento

inativos_ingresso = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(ingresso = DT_ING_SERV_PUB.y != DT_ING_SERV_PUB.x) %>%
  filter(ingresso == TRUE); inativos_ingresso

inativos_ing_ente = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(ingresso = DATA_DE_INGRESSO_NO_ENTE.y != DATA_DE_INGRESSO_NO_ENTE.x) %>%
  filter(ingresso == TRUE); inativos_ing_ente

inativos_ing_carreira = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(ing_carreira = DATA_DE_INGRESSO_NO_ENTE.y != DATA_DE_INGRESSO_NO_ENTE.x) %>%
  filter(ing_carreira == TRUE); inativos_ing_carreira

inativos_inicio_aposentadoria = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(inicio_aposentadoria = DT_INICIO_APOSENTADORIA.y != DT_INICIO_APOSENTADORIA.x) %>%
  filter(inicio_aposentadoria == TRUE); inativos_inicio_aposentadoria

inativos_ing_serv_pub = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(ing_serv_pub = DT_ING_SERV_PUB.y != DT_ING_SERV_PUB.x) %>%
  filter(ing_serv_pub == TRUE); inativos_ing_serv_pub

inativos_condicao_APOSENTADO = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(condicao = CO_CONDICAO_APOSENTADO.y != CO_CONDICAO_APOSENTADO.x) %>%
  filter(condicao == TRUE); inativos_condicao_APOSENTADO

inativos_numero_dependentes = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(dependentes = NU_DEPENDENTES.y != NU_DEPENDENTES.x) %>%
  filter(dependentes == TRUE); inativos_numero_dependentes

inativos_teto_especifico = arquivos_202212_inativos %>%
  inner_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(teto = VL_TETO_ESPECIFICO.y != VL_TETO_ESPECIFICO.x) %>%
  filter(teto == TRUE); inativos_teto_especifico
