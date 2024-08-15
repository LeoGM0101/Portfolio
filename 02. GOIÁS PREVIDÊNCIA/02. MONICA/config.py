# -*- coding: utf-8 -*-
"""
Este script corresponde à delimitação de valores a certas variáveis.
Caso a análise de averbação, por exemplo, mude, é mais tranquilo fazer isso em um script apenas. 
"""

## Ordinary setup
# Data focal base mais antiga  
dia_old = 30
mes_old = 6
ano_old = 2021
data_old = str(dia_old) + "/" + str(mes_old)  + "/" + str(ano_old)

#Data focal base mais atual 
dia = 31
mes = 5
ano = 2023
data = str(dia) + "/" + str(mes)  + "/" + str(ano)

ri_name = 'Resultados_GOIASPREV_maio.xlsx' # Nome do arquivo a ser criado
path_utd = '2023-12-BD-SPREV.xlsx' # Caminho dos dados atuais
path_old = '2022-11-BD-SPREV.xlsx' # Caminho dos dados antigos
averb = 14610 # Averbação máxima
sal_min = 1412 # Salário mínimo
sal_max = 41650.92 # Teto do funcionalismo público - 05/01/2024
idade_min = 18 # Idade mínima para entrada no RPPS estadual
idade_max = 75 # Idade de aposentadoria compulsória
aliquota_civil = 0.16 # Aliquota contribuição para os civis - 05/01/2024
aliquota_militares = 0.11 # Aliquota contribuição para os militares - 05/01/2024


## Non-ordinary setup
report_template_path = 'templates/goiasprev_ri_template.xlsx'

#Tipos das variáveis da base ativos na ordem
d_cols_at = {"NU_ANO" : "<class 'numpy.int64'>",
             "NU_MES" : "<class 'numpy.int64'>",
             "CO_IBGE" : "<class 'numpy.int64'>",
             "NO_ENTE" : "<class 'str'>",
             "SG_UF" : "<class 'str'>",
             "CO_COMP_MASSA" : "<class 'numpy.int64'>",
             "CO_TIPO_FUNDO" : "<class 'numpy.int64'>",
             "NU_CNPJ_ORGAO" : "<class 'str'>",
             "NO_ORGAO" : "<class 'str'>",
             "CO_PODER" : "<class 'numpy.int64'>",
             "CO_TIPO_PODER" : "<class 'numpy.int64'>",
             "CO_TIPO_POPULACAO" : "<class 'numpy.int64'>",
             "CO_TIPO_CARGO" : "<class 'numpy.int64'>",
             "CO_CRITERIO_ELEGIBILIDADE" : "<class 'numpy.int64'>",
             "ID_SERVIDOR_MATRICULA" : "<class 'str'>",
             "ID_SERVIDOR_CPF" : "<class 'str'>",
             "ID_SERVIDOR_PIS_PASEP" : "<class 'str'>",
             "CO_SEXO_SERVIDOR" : "<class 'numpy.int64'>",
             "CO_EST_CIVIL_SERVIDOR" : "<class 'numpy.int64'>",
             "DT_NASC_SERVIDOR" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>",
             "CO_SITUACAO_FUNCIONAL" : "<class 'numpy.int64'>",
             "CO_TIPO_VINCULO" : "<class 'numpy.int64'>",
             "DT_ING_SERV_PUB" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>",
             "DT_ING_ENTE" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>",
             "DT_ING_CARREIRA" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>",
             "NO_CARREIRA" : "<class 'str'>",
             "DT_ING_CARGO" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>",
             "NO_CARGO" : "<class 'str'>",
             "VL_BASE_CALCULO" : "<class 'numpy.float64'>",
             "VL_REMUNERACAO" : "<class 'numpy.float64'>",
             "VL_CONTRIBUICAO" : "<class 'numpy.float64'>",
             "IN_ABONO_PERMANENCIA" : "<class 'numpy.int64'>",
             "DT_INICIO_ABONO" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>",
             "IN_PREV_COMP" : "<class 'numpy.int64'>",
             "VL_TETO_ESPECIFICO" : "<class 'numpy.float64'>",
             "NU_TEMPO_RGPS" : "<class 'numpy.int64'>",
             "NU_TEMPO_RPPS_MUN" : "<class 'numpy.int64'>",
             "NU_TEMPO_RPPS_EST" : "<class 'numpy.int64'>",
             "NU_TEMPO_RPPS_FED" : "<class 'numpy.int64'>",
             "NU_DEPENDENTES" : "<class 'numpy.int64'>",
             "IN_PREV_COMP" : "<class 'numpy.int64'>",
             "DT_PROV_APOSENT" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>"}

#Tipos das variáveis da base inativos na ordem
d_cols_in = {"NU_ANO" : "<class 'numpy.int64'>",
             "NU_MES" : "<class 'numpy.int64'>",
             "CO_IBGE" : "<class 'numpy.int64'>",
             "NO_ENTE" : "<class 'str'>",
             "SG_UF" : "<class 'str'>",
             "CO_COMP_MASSA" : "<class 'numpy.int64'>",
             "CO_TIPO_FUNDO" : "<class 'numpy.int64'>",
             "CNPJ_ORGAO" : "<class 'str'>",
             "NO_ORGAO" : "<class 'str'>",
             "CO_PODER" : "<class 'numpy.int64'>",
             "CO_TIPO_PODER" : "<class 'numpy.int64'>",
             "CO_TIPO_POPULACAO" : "<class 'numpy.int64'>",
             "CO_TIPO_CARGO" : "<class 'numpy.int64'>",
             "CO_TIPO_APOSENTADORIA" : "<class 'numpy.int64'>",
             "ID_APOSENTADO_MATRICULA" : "<class 'str'>",
             "ID_APOSENTADO_CPF" : "<class 'str'>",
             "ID_APOSENT_PIS_PASEP" : "<class 'str'>",
             "CO_SEXO_APOSENTADO" : "<class 'numpy.int64'>",
             "CO_EST_CIVIL_APOSENTADO" : "<class 'numpy.int64'>",
             "DT_NASC_APOSENTADO" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>",
             "DT_ING_SERV_PUB" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>",
             "DATA_DE_INGRESSO_NO_ENTE" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>",
             "DT_INICIO_APOSENTADORIA" : "<class 'pandas._libs.tslibs.timestamps.Timestamp'>",
             "VL_APOSENTADORIA" : "<class 'numpy.float64'>",
             "VL_CONTRIBUICAO" : "<class 'numpy.float64'>",
             "VL_COMPENS_PREVID" : "<class 'numpy.float64'>",
             "IN_PARID_SERV" : "<class 'numpy.int64'>",
             "CO_CONDICAO_APOSENTADO" : "<class 'numpy.int64'>",
             "NU_DEPENDENTES" : "<class 'numpy.int64'>",
             "NU_TEMPO_RPPS_MUN" : "<class 'numpy.int64'>",
             "NU_TEMPO_RPPS_EST" : "<class 'numpy.int64'>",
             "NU_TEMPO_RPPS_FED" : "<class 'numpy.int64'>",
             "IN_PREV_COMP" : "<class 'numpy.int64'>",
             "VL_TETO_ESPECIFICO" : "<class 'numpy.float64'>"}

