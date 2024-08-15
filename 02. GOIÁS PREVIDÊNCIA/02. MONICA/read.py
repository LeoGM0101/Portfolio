# -*- coding: utf-8 -*-
"""
Script responsável pela leitura dos dataframes, puxando suas
respectivas colunas e definindo o tipo de variável que corresponde a cada coluna.
"""
### Pacotes externos
import pandas as pd


def ler_ativo(caminho):
    #Nome das colunas da base ativos / Alguns atributos com problemas
    d_cols_at = {'NU_ANO' : 'int64',
                 'NU_MES' : 'int64',
                 'CO_IBGE' : 'int64',
                 'NO_ENTE' : 'object',
                 'SG_UF' : 'object',
                 'CO_COMP_MASSA' : 'int64',
                 'CO_TIPO_FUNDO' : 'int64',
                 'NU_CNPJ_ORGAO' : 'object',
                 'NO_ORGAO' : 'object',
                 'CO_PODER' : 'int64',
                 'CO_TIPO_PODER' : 'int64',
                 'CO_TIPO_POPULACAO' : 'int64',
                 'CO_TIPO_CARGO' : 'int64',
                 'CO_CRITERIO_ELEGIBILIDADE' : 'int64',
                 'ID_SERVIDOR_MATRICULA' : 'object',
                 'ID_SERVIDOR_CPF' : 'object',
                 'ID_SERVIDOR_PIS_PASEP' : 'object',
                 'CO_SEXO_SERVIDOR' : 'int64',
                 'CO_EST_CIVIL_SERVIDOR' : 'int64',
                 'DT_NASC_SERVIDOR' : 'datetime64',
                 'CO_SITUACAO_FUNCIONAL' : 'int64',
                 'CO_TIPO_VINCULO' : 'int64',
                 'DT_ING_SERV_PUB' : 'datetime64',
                 'DT_ING_ENTE' : 'datetime64',
                 'DT_ING_CARREIRA' : 'datetime64',
                 'NO_CARREIRA' : 'object',
                 'DT_ING_CARGO' : 'datetime64',
                 'NO_CARGO' : 'object',
                 'VL_BASE_CALCULO' : 'float64',
                 'VL_REMUNERACAO' : 'float64',
                 'VL_CONTRIBUICAO' : 'float64',
                 'IN_ABONO_PERMANENCIA' : 'int64',
                 # 'DT_INICIO_ABONO' : 'datetime64',
                 'DT_INICIO_ABONO' : 'object',                 
                 'IN_PREV_COMP' : 'int64',
                 'VL_TETO_ESPECIFICO' : 'float64',
                 'NU_TEMPO_RGPS' : 'int64',
                 'NU_TEMPO_RPPS_MUN' : 'int64',
                 'NU_TEMPO_RPPS_EST' : 'int64',
                 'NU_TEMPO_RPPS_FED' : 'int64',
                 'NU_DEPENDENTES' : 'int64',
                 # 'DT_PROV_APOSENT' : 'datetime64'}
                 'DT_PROV_APOSENT' : 'object'}


    base = pd.read_excel(caminho,
                      sheet_name='Ativo',
                      dtype = d_cols_at)
    return base
    
def ler_inativo(caminho):
    # Dicinário das colunas da base inativos
    d_cols_in = {'NU_ANO' : 'int64',
                 'NU_MES' : 'int64', 
                 'CO_IBGE' : 'int64',
                 'NO_ENTE' : 'object',
                 'SG_UF' : 'object',
                 'CO_COMP_MASSA' : 'int64',
                 'CO_TIPO_FUNDO' : 'int64',
                 'CNPJ_ORGAO' : 'object',
                 'NO_ORGAO' : 'object',
                 'CO_PODER' : 'int64',
                 'CO_TIPO_PODER' : 'int64',
                 'CO_TIPO_POPULACAO' : 'int64',
                 'CO_TIPO_CARGO' : 'int64',
                 'CO_TIPO_APOSENTADORIA' : 'int64',
                 'ID_APOSENTADO_MATRICULA' : 'object',
                 'ID_APOSENTADO_CPF' : 'object',
                 'ID_APOSENT_PIS_PASEP' : 'object',
                 'CO_SEXO_APOSENTADO' : 'int64',
                 'CO_EST_CIVIL_APOSENTADO' : 'int64',
                 'DT_NASC_APOSENTADO' : 'datetime64',
                 'DT_ING_SERV_PUB' : 'datetime64',
                 'DATA_DE_INGRESSO_NO_ENTE' : 'datetime64',
                 'DT_INICIO_APOSENTADORIA' : 'datetime64',
                 'VL_APOSENTADORIA' : 'float64',
                 'VL_CONTRIBUICAO' : 'float64',
                 'VL_COMPENS_PREVID' : 'float64',
                 'IN_PARID_SERV' : 'int64',
                 'CO_CONDICAO_APOSENTADO' : 'int64',
                 'NU_DEPENDENTES' : 'int64',
                 'NU_TEMPO_RPPS_MUN' : 'int64',
                 'NU_TEMPO_RPPS_EST' : 'int64',
                 'NU_TEMPO_RPPS_FED' : 'int64',
                 'IN_PREV_COMP' : 'int64',
                 'VL_TETO_ESPECIFICO' : 'float64'}
    
    base = pd.read_excel(caminho,
                      sheet_name='Inativo',
                      dtype = d_cols_in)
    return base



