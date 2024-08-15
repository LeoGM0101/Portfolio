rm(list=ls())
library(tidyverse)
library(openxlsx)
library(readxl)

setwd("Z:/ArquivosTI")
arquivos_202212_ativos = read_excel("Atuario202212.xlsx", sheet = "Ativo")
arquivos_202301_ativos = read_excel("Atuario202301.xlsx", sheet = "Ativo")

arquivos_202212_inativos = read_excel("Atuario202212.xlsx", sheet = "Inativo")
arquivos_202301_inativos = read_excel("Atuario202301.xlsx", sheet = "Inativo")

#Ativos

arquivos_202212_ativos$IN_PARID_SERV = as.numeric(arquivos_202212_ativos$IN_PARID_SERV)
arquivos_202301_ativos$IN_PARID_SERV = as.numeric(arquivos_202301_ativos$IN_PARID_SERV)

ativos = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(calculo = VL_BASE_CALCULO.y - VL_BASE_CALCULO.x, remuneracao = VL_REMUNERACAO.y - VL_REMUNERACAO.x,
            contribuicao = VL_CONTRIBUICAO.y - VL_CONTRIBUICAO.x, tempo_rgps = NU_TEMPO_RGPS.y - NU_TEMPO_RGPS.x, 
            tempo_rpps_mun = NU_TEMPO_RPPS_MUN.y - NU_TEMPO_RPPS_MUN.x, tempo_rpps_est = NU_TEMPO_RPPS_EST.y - NU_TEMPO_RPPS_EST.x, 
            tempo_rpps_fed = NU_TEMPO_RPPS_FED.y - NU_TEMPO_RPPS_FED.x, dependentes = NU_DEPENDENTES.y - NU_DEPENDENTES.x, 
            teto = VL_TETO_ESPECIFICO.y - VL_TETO_ESPECIFICO.x)

ativos %>% filter(calculo != 0) %>% select(calculo)
ativos %>% filter(remuneracao != 0) %>% select(remuneracao)
ativos %>% filter(contribuicao != 0) %>% select(contribuicao)
ativos %>% filter(tempo_rgps != 0) %>% select(tempo_rgps)
ativos %>% filter(tempo_rpps_mun != 0) %>% select(tempo_rpps_mun)
ativos %>% filter(tempo_rpps_est != 0) %>% select(tempo_rpps_est)
ativos %>% filter(tempo_rpps_fed != 0) %>% select(tempo_rpps_fed)
ativos %>% filter(dependentes != 0) %>% select(dependentes)
ativos %>% filter(teto != 0) %>% select(teto)

ativos_massa = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(massa = CO_COMP_MASSA.y != CO_COMP_MASSA.x) %>%
  filter(massa == TRUE); ativos_sexo #quando TRUE, quer dizer que ha diferença na coluna especificada
                                    #entre a base de janeiro 2023 e a base de dezembro 2022

ativos_fundo = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(fundo = CO_TIPO_FUNDO.y != CO_TIPO_FUNDO.x) %>%
  filter(fundo == TRUE); ativos_sexo; ativos_fundo

ativos_cnpj_orgao = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(cnpj_orgao = NU_CNPJ_ORGAO.y != NU_CNPJ_ORGAO.x) %>%
  filter(cnpj_orgao == TRUE); ativos_cnpj_orgao

ativos_poder = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(poder = CO_PODER.y != CO_PODER.x) %>%
  filter(poder == TRUE); ativos_poder

ativos_tipo_poder = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(tipo_poder = CO_TIPO_PODER.y != CO_TIPO_PODER.x) %>%
  filter(tipo_poder == TRUE); ativos_tipo_poder

ativos_tipo_populacao = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(tipo_populacao = CO_TIPO_POPULACAO.y != CO_TIPO_POPULACAO.x) %>%
  filter(tipo_populacao == TRUE); ativos_tipo_populacao

ativos_tipo_cargo = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(tipo_cargo = CO_TIPO_CARGO.y != CO_TIPO_CARGO.x) %>%
  filter(tipo_cargo == TRUE); ativos_tipo_cargo

ativos_criterio_elegibilidade = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(criterio_elegibilidade = CO_CRITERIO_ELEGIBILIDADE.y != CO_CRITERIO_ELEGIBILIDADE.x) %>%
  filter(criterio_elegibilidade == TRUE); ativos_criterio_elegibilidade

ativos_servidor_matricula = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(servidor_matricula = ID_SERVIDOR_MATRICULA.y != ID_SERVIDOR_MATRICULA.x) %>%
  filter(servidor_matricula == TRUE); ativos_servidor_matricula

ativos_servidor_pis = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(servidor_pis = ID_SERVIDOR_PIS_PASEP.y != ID_SERVIDOR_PIS_PASEP.x) %>%
  filter(servidor_pis == TRUE); ativos_servidor_pis

ativos_sexo = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(sexo = CO_SEXO_SERVIDOR.y != CO_SEXO_SERVIDOR.x) %>%
  filter(sexo == TRUE); ativos_sexo

ativos_est_civil = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(estado_civil = CO_EST_CIVIL_SERVIDOR.y != CO_EST_CIVIL_SERVIDOR.x) %>%
  filter(estado_civil == TRUE); ativos_est_civil

ativos_data_nascimento = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(data_nascimento = DT_NASC_SERVIDOR.y != DT_NASC_SERVIDOR.x) %>%
  filter(data_nascimento == TRUE); ativos_data_nascimento

ativos_situacao_funcional = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(situacao_funcional = CO_SITUACAO_FUNCIONAL.y != CO_SITUACAO_FUNCIONAL.x) %>%
  filter(situacao_funcional == TRUE); ativos_situacao_funcional

ativos_tipo_vinculo = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(tipo_vinculo = CO_TIPO_VINCULO.y != CO_TIPO_VINCULO.x) %>%
  filter(tipo_vinculo == TRUE); ativos_tipo_vinculo

ativos_ingresso = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(ingresso = DT_ING_SERV_PUB.y != DT_ING_SERV_PUB.x) %>%
  filter(ingresso == TRUE); ativos_ingresso

ativos_ing_ente = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(ingresso = DT_ING_ENTE.y != DT_ING_ENTE.x) %>%
  filter(ingresso == TRUE); ativos_ing_ente

ativos_ing_carreira = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(ing_carreira = DT_ING_CARREIRA.y != DT_ING_CARREIRA.x) %>%
  filter(ing_carreira == TRUE); ativos_ing_carreira

ativos_carreira = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(carreira = NO_CARREIRA.y != NO_CARREIRA.x) %>%
  filter(carreira == TRUE); ativos_carreira

ativos_ing_cargo = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(ing_cargo = DT_ING_CARGO.y != DT_ING_CARGO.x) %>%
  filter(ing_cargo == TRUE); ativos_ing_cargo

ativos_cargo = arquivos_202212_ativos %>%
  full_join(arquivos_202301_ativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  summarise(cargo = NO_CARGO.y != NO_CARGO.x) %>%
  filter(cargo == TRUE); ativos_ing_cargo


#Inativos
arquivos_202212_inativos$CO_CONDICAO_APOSENTADO = as.numeric(arquivos_202212_inativos$CO_CONDICAO_APOSENTADO)
arquivos_202301_inativos$CO_CONDICAO_APOSENTADO = as.numeric(arquivos_202301_inativos$CO_CONDICAO_APOSENTADO)
arquivos_202212_inativos$IN_PARID_SERV = as.numeric(arquivos_202212_inativos$IN_PARID_SERV)
arquivos_202301_inativos$IN_PARID_SERV = as.numeric(arquivos_202301_inativos$IN_PARID_SERV)

inativos = arquivos_202212_inativos %>%
  full_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  summarise(aposentadoria = VL_APOSENTADORIA.y - VL_APOSENTADORIA.x, contribuicao = VL_CONTRIBUICAO.y - VL_CONTRIBUICAO.x,
            condicao = CO_CONDICAO_APOSENTADO.y - CO_CONDICAO_APOSENTADO.x, tempo_rpps_mun = NU_TEMPO_RPPS_MUN.y - NU_TEMPO_RPPS_MUN.x, 
            tempo_rpps_est = NU_TEMPO_RPPS_EST.y - NU_TEMPO_RPPS_EST.x, tempo_rpps_fed = NU_TEMPO_RPPS_FED.y - NU_TEMPO_RPPS_FED.x, 
            dependentes = NU_DEPENDENTES.y - NU_DEPENDENTES.x, teto = VL_TETO_ESPECIFICO.y - VL_TETO_ESPECIFICO.x)

inativos %>% filter(aposentadoria != 0) %>% select(aposentadoria)
inativos %>% filter(contribuicao != 0) %>% select(contribuicao)
inativos %>% filter(paridade != 0) %>% select(paridade)
inativos %>% filter(condicao != 0) %>% select(condicao)
inativos %>% filter(tempo_rpps_mun != 0) %>% select(tempo_rpps_mun)
inativos %>% filter(tempo_rpps_est != 0) %>% select(tempo_rpps_est)
inativos %>% filter(tempo_rpps_fed != 0) %>% select(tempo_rpps_fed)
inativos %>% filter(dependentes != 0) %>% select(dependentes)
inativos %>% filter(teto != 0) %>% select(teto)

inativos_sexo = arquivos_202212_inativos %>%
  full_join(arquivos_202301_inativos, by = "ID_SERVIDOR_CPF") %>%
  group_by(ID_SERVIDOR_CPF) %>%
  filter(CO_COMP_MASSA.y != CO_COMP_MASSA.x); inativos_sexo

inativos_paridade = arquivos_202212_inativos %>%
  full_join(arquivos_202301_inativos, by = "ID_APOSENTADO_CPF") %>%
  group_by(ID_APOSENTADO_CPF) %>%
  filter(IN_PARID_SERV.y != IN_PARID_SERV.x); inativos_paridade