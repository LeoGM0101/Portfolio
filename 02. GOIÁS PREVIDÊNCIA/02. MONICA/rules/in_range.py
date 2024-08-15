# -*- coding: utf-8 -*-
"""
Este script executa o teste range para variáveis selecionadas da base dos inativos.
Consultar o arquivo "Regras do negócio.xlsx" para maiores detalhes sobre os testes.
"""
### Pacotes Externos
import numpy as np

### Pacotes internos
from config import averb, dia, mes, ano
from config import d_cols_in
from syscheck import sys_check_rm

### Criando uma lista com o nome das variáveis que vão ser testadas
list_var = list(d_cols_in.keys())

### Lista com nome dos testes
inat_range = ["inat_range01",
              "inat_range02",
              "inat_range03",
              "inat_range04",
              "inat_range05",
              "inat_range06",
              "inat_range07",
              "inat_range08",
              "inat_range09",
              "inat_range10",
              "inat_range11",
              "inat_range12",
              "inat_range13",
              "inat_range14",
              "inat_range15"]


def inat_range01(inativo):
    """ 
    CO_COMP_MASSA deve ter codificação 1 e 2.
    
    Parameters
    ----------
    intaivo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "CO_COMP_MASSA"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (civil) ou 2 (militar)"
    return teste


def inat_range02(inativo):
    """ 
    CO_TIPO_FUNDO deve ter codificação igual a 1,2 ou 3.
    Parameters
    ----------
    intaivo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "CO_TIPO_FUNDO"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2,3]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1, 2 ou 3."
    return teste


def inat_range03(inativo):
    """ 
    CO_PODER deve ter codificação 1, 2, 3, 4, 5 ou 6.
    
    Parameters
    ----------
    intaivo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "CO_PODER"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2,3,4,5,6]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1,2,3,4,5 ou 6."
    return teste


def inat_range04(inativo):
    """
    CO_TIPO_PODER deve ter codificação igual a 1 ou 2.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "CO_TIPO_PODER"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (Administração Direta) ou 2 (Administração Indireta)."
    return teste


def inat_range05(inativo):
    """
    CO_TIPO_CARGO deve ter codificação igual a 1, 2, 3, 4, 5, 6, 7, ou 8.
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "CO_TIPO_CARGO"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2,3,4,5,6,7,8]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente do intervalo de 1 ao 8."
    return teste


def inat_range06(inativo):
    """
    CO_SEXO_APOSENTADO deve ter codificação igual a 1 ou 2.
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "CO_SEXO_APOSENTADO"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (Feminino) ou 2 (Masculino)"
    return teste


def inat_range07(inativo):
    """
    CO_EST_CIVIL_APOSENTADO deve ter codificação igual a 1,2,3,4,5,6 ou 9.
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "CO_EST_CIVIL_APOSENTADO"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2,3,4,5,6,9]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1,2,3,4,5,6 ou 9"
    return teste


def inat_range08(inativo):
    """
    IN_PARID_SERV deve ter codificação igual a 1 (Há indicador de paridade com servidores ativos) ou 2 (Não há indicador de paridade com servidores ativos).
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "IN_PARID_SERV"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (Há indicador de paridade com servidores ativos) ou 2 (Não há indicador de paridade com servidores ativos)"
    return teste


def inat_range09(inativo):
    """
    CO_CONDICAO_APOSENTADO deve ser igual a 1 (Válido) ou 2 (Inválido).
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "CO_CONDICAO_APOSENTADO"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (Válido) ou 2 (Inválido)"
    return teste


def inat_range10(inativo):
    """
    IN_PREV_COMP deve ser igual a 1 (Com Indicador de Previdência Completar) ou 2 (Sem Indicador de Previdência Completar).
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "IN_PREV_COMP"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (Com Indicador de Previdência Completar) ou 2 (Sem Indicador de Previdência Completar)"
    return teste


def inat_range11(inativo):
    """
    NU_TEMPO_RPPS_MUN deve estar entre 0 e 14.610 dias averbados.
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "NU_TEMPO_RPPS_MUN"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~(df[var].between(0,averb)),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mais de 14.610 dias averbados"
    return teste
    
def inat_range12(inativo):
    """
    NU_TEMPO_RPPS_EST deve estar entre 0 e 14.610 dias averbados.
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "NU_TEMPO_RPPS_EST"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~(df[var].between(0,averb)),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"]= "Mais de 14.610 dias averbados"
    return teste
    
def inat_range13(inativo):
    """
    NU_TEMPO_RPPS_FED deve estar entre 0 e 14.610 dias averbados.
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "NU_TEMPO_RPPS_FED"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~(df[var].between(0,averb)),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"]= "Mais de 14.610 dias averbados"
    return teste
    
def inat_range14(inativo):
    """
    CO_TIPO_POPULACAO deve ser igual a 4 (civis) ou 9 (militares).
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "CO_TIPO_POPULACAO"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([4,9]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"]= "Valor diferente de 4 (Civis) ou 9 (Militares)"
    return teste
    
def inat_range15(inativo):
    """
    CO_TIPO_APOSENTADORIA deve ser igual a 1, 2, 3, 4, 5, 6, 7, 9 ou 10.
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = inativo.copy()
    var = "CO_TIPO_APOSENTADORIA"
    df = sys_check_rm(df, [var], 2)
    teste = df.loc[~df[var].isin([1,2,3,4,5,6,7,9,10]),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"]= "Valor diferente de 1, 2, 3, 4, 5, 6, 7, 9 ou 10"
    return teste