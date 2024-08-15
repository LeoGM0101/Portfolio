# -*- coding: utf-8 -*-
"""
Este script executa o teste trend para variáveis selecionadas da base dos inativos.
Consultar o arquivo "Regras do negócio.xlsx" para maiores detalhes sobre os testes.

sufixo _x corresponde a variavel da base mais atual e 
sufixo _y corresponde a variavel da base mais antiga.

"""

import pandas as pd
from syscheck import sys_check_rm
from config import mes, ano, mes_old, ano_old


inatv_trend = ["inatv_trend01",
               "inatv_trend02",
               "inatv_trend03",
               "inatv_trend04",
               "inatv_trend05",
               "inatv_trend06",
               "inatv_trend07",
               "inatv_trend08",
               "inatv_trend09",
               "inatv_trend10",
               "inatv_trend11",
               "inatv_trend12",
               "inatv_trend13",
               "inatv_trend14",
               "inatv_trend15",
               "inatv_trend16",
               "inatv_trend17",
               "inatv_trend18",
               "inatv_trend19",
               "inatv_trend20",
               "inatv_trend21",
               "inatv_trend22"]

def inatv_trend01(df1,df2):
    """
    Executa o teste de tendência , para a variavel CO_COMP_MASSA,
    Será testado se o aposentado muda de composição de massa de uma competência
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_COMP_MASSA"
    var1 = 'CO_COMP_MASSA_y'
    var2 = 'CO_COMP_MASSA_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("CO_COMP_MASSA_y != CO_COMP_MASSA_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança de composição de massa de uma competência pra outra."
    return teste


def inatv_trend02(df1,df2):
    """
    Executa o teste de tendência , para a variavel CO_TIPO_FUNDO,
    Será testado se o aposentado muda o tipo do fundo de uma competência
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_TIPO_FUNDO"
    var1 = 'CO_TIPO_FUNDO_y'
    var2 = 'CO_TIPO_FUNDO_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("CO_TIPO_FUNDO_y != CO_TIPO_FUNDO_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança de tipo de fundo de uma competência pra outra."
    return teste


def inatv_trend03(df1,df2):
    """
    Executa o teste de tendência , para a variavel CNPJ_ORGAO,
    Será testado se o aposentado muda o cnpj do orgao de uma competência
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CNPJ_ORGAO"
    var1 = 'CNPJ_ORGAO_y'
    var2 = 'CNPJ_ORGAO_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("CNPJ_ORGAO_y != CNPJ_ORGAO_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança de cnpj do orgão de uma competência pra outra."
    return teste


def inatv_trend04(df1,df2):
    """
    Executa o teste de tendência , para a variavel NO_ORGAO,
    Será testado se tem alteração no nome do orgao de uma competencia
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NO_ORGAO"
    var1 = 'NO_ORGAO_y'
    var2 = 'NO_ORGAO_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("NO_ORGAO_y != NO_ORGAO_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança do nome do orgão de uma competência para outra."
    return teste


def inatv_trend05(df1,df2):
    """
    Executa o teste de tendência, para a variavel CO_PODER,
    Será testado se tem alteração no codigo do poder de uma competência
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_PODER"
    var1 = 'CO_PODER_y'
    var2 = 'CO_PODER_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("CO_PODER_y != CO_PODER_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança do codigo de poder de uma competência para outra."
    return teste


def inatv_trend06(df1,df2):
    """
    Executa o teste de tendência , para a variavel CO_TIPO_PODER,
    Será testado se tem alteração no codigo do tipo do poder de uma competência
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_TIPO_PODER"
    var1 = 'CO_TIPO_PODER_y'
    var2 = 'CO_TIPO_PODER_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("CO_TIPO_PODER_y != CO_TIPO_PODER_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança do codigo do tipo de poder de uma competência para outra."
    return teste


def inatv_trend07(df1,df2):
    """
    Executa o teste de tendencia , para a variavel CO_TIPO_POPULACAO,
    Será testado se tem alteração no codigo do tipo do poder de uma competencia
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_TIPO_POPULACAO"
    var1 = 'CO_TIPO_POPULACAO_y'
    var2 = 'CO_TIPO_POPULACAO_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("CO_TIPO_POPULACAO_y != CO_TIPO_POPULACAO_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança do codigo de população de uma competencia para outra."
    return teste


def inatv_trend08(df1,df2):
    """
    Executa o teste de tendencia , para a variavel CO_TIPO_CARGO,
    Será testado se tem alteração no codigo do tipo do cargo de uma competencia
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_TIPO_CARGO"
    var1 = 'CO_TIPO_CARGO_y'
    var2 = 'CO_TIPO_CARGO_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("CO_TIPO_CARGO_y != CO_TIPO_CARGO_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança do codigo de tipo de cargo de uma competencia para outra."
    return teste


def inatv_trend09(df1,df2):
    """
    Executa o teste de tendencia , para a variavel CO_TIPO_APOSENTADORIA,
    Será testado se tem alteração no codigo do tipo da aposentadoria de uma competencia
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_TIPO_APOSENTADORIA"
    var1 = 'CO_TIPO_APOSENTADORIA_y'
    var2 = 'CO_TIPO_APOSENTADORIA_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("CO_TIPO_APOSENTADORIA_y != CO_TIPO_APOSENTADORIA_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança do codigo de tipo de aposentadoria de uma competencia para outra."
    return teste


def inatv_trend10(df1,df2):
    """
    Executa o teste de tendencia , para a variavel ID_APOSENT_PIS_PASEP,
    Será testado se tem alteração no codigo do pis pasep de uma competencia
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "ID_APOSENT_PIS_PASEP"
    var1 = 'ID_APOSENT_PIS_PASEP_y'
    var2 = 'ID_APOSENT_PIS_PASEP_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("ID_APOSENT_PIS_PASEP_y != ID_APOSENT_PIS_PASEP_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança do codigo do pis pasep de uma competencia para outra."
    return teste


def inatv_trend11(df1,df2):
    """
    Executa o teste de tendencia , para a variavel CO_SEXO_APOSENTADO,
    Será testado se tem alteração no codigo do sexo do aposentado de uma competencia
    para outra , o que seria um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_SEXO_APOSENTADO"
    var1 = 'CO_SEXO_APOSENTADO_y'
    var2 = 'CO_SEXO_APOSENTADO_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query("CO_SEXO_APOSENTADO_y != CO_SEXO_APOSENTADO_x")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"]= "Erro"
    teste["MENSAGEM"] = "Mudança do codigo do sexo do aposentado de uma competencia para outra."
    return teste


def inatv_trend12(df1,df2):
    """
    Executa o teste de tendencia , para a variavel CO_EST_CIVIL_APOSENTADO,
    Será testado se a variavel muda de uma base para outra, caso haja mudança
    de qualquer status para solteiro seria um erro, outras mudanças podem ser
    consideradas aviso.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_EST_CIVIL_APOSENTADO"
    var1 = 'CO_EST_CIVIL_APOSENTADO_y'
    var2 = 'CO_EST_CIVIL_APOSENTADO_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "CO_EST_CIVIL_APOSENTADO_x ==1 & CO_EST_CIVIL_APOSENTADO_y != (1,9)")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança de estado civil para solteiro."
    return teste
# não há a regra de "aviso"


def inatv_trend13(df1,df2):
    """
    Executa o teste de tendencia , para a variavel DT_NASC_APOSENTADO,
    Será testado se a variavel muda de uma base para outra, o que seria um 
    erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "DT_NASC_APOSENTADO"
    var1 = 'DT_NASC_APOSENTADO_y'
    var2 = 'DT_NASC_APOSENTADO_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "DT_NASC_APOSENTADO_x != DT_NASC_APOSENTADO_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança de data de nascimento"
    return teste


def inatv_trend14(df1,df2):
    """
    Executa o teste de tendencia , para a variavel DT_ING_SERV_PUB,
    Será testado se a variavel muda de uma base para outra, o que seria um 
    erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "DT_ING_SERV_PUB"
    var1 = 'DT_ING_SERV_PUB_y'
    var2 = 'DT_ING_SERV_PUB_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "DT_ING_SERV_PUB_x != DT_ING_SERV_PUB_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança de data de ingresso no serviço publico."
    return teste


def inatv_trend15(df1,df2):
    """
    Executa o teste de tendencia , para a variavel DT_INICIO_APOSENTADORIA,
    Será testado se a variavel muda de uma base para outra, o que seria um 
    erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "DT_INICIO_APOSENTADORIA"
    var1 = 'DT_INICIO_APOSENTADORIA_y'
    var2 = 'DT_INICIO_APOSENTADORIA_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "DT_INICIO_APOSENTADORIA_x != DT_INICIO_APOSENTADORIA_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança de data de inicio da aposentadoria."
    return teste


def inatv_trend16(df1,df2):
    """
    Executa o teste de tendência , para a variavel IN_PARID_SERV,
    Será testado se a variavel muda de uma base para outra, o que seria um 
    erro, já que o beneficio já foi concedido.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "IN_PARID_SERV"
    var1 = 'IN_PARID_SERV_y'
    var2 = 'IN_PARID_SERV_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "IN_PARID_SERV_x != IN_PARID_SERV_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Aposentado passou a ter ou deixou de ter paridade."
    return teste


def inatv_trend17(df1,df2):
    """
    Executa o teste de tendência , para a variavel CO_CONDICAO_APOSENTADO,
    Será testado se a variável muda de uma base para outra, o que seria um 
    erro. Já que se trata da condição em que ele foi aposentado e nao na atual.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_CONDICAO_APOSENTADO"
    var1 = 'CO_CONDICAO_APOSENTADO_y'
    var2 = 'CO_CONDICAO_APOSENTADO_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "CO_CONDICAO_APOSENTADO_x != CO_CONDICAO_APOSENTADO_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança no codigo da condição do aposentado."
    return teste


def inatv_trend18(df1,df2):
    """
    Executa o teste de tendência , para a variável IN_PREV_COMP,
    Será testado se a variável muda de uma base para outra, o que seria um 
    erro. Por que o beneficio já foi concedido.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "IN_PREV_COMP"
    var1 = 'IN_PREV_COMP_y'
    var2 = 'IN_PREV_COMP_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "IN_PREV_COMP_x != IN_PREV_COMP_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança no codigo de previdencia complementar."
    return teste


def inatv_trend19(df1,df2):
    """
    Executa o teste de tendência , para a variável NU_TEMPO_RPPS_MUN,
    Será testado se a variavel muda de uma base para outra, o que seria um 
    erro. Por que o beneficio já foi concedido, e não faz sentido o servidor perder tempo de averbação.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NU_TEMPO_RPPS_MUN"
    var1 = 'NU_TEMPO_RPPS_MUN_y'
    var2 = 'NU_TEMPO_RPPS_MUN_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "NU_TEMPO_RPPS_MUN_x < NU_TEMPO_RPPS_MUN_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Aposentado perdeu tempo de averbação em comparação com a base mais antiga."
    return teste
# falta o erro de averbação negativa


def inatv_trend20(df1,df2):
    """
    Executa o teste de tendencia , para a variavel NU_TEMPO_RPPS_EST,
    Será testado se a variavel muda de uma base para outra, o que seria um 
    erro. Por que o beneficio já foi concedido, e não faz sentido o servidor perder tempo de averbação.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NU_TEMPO_RPPS_EST"
    var1 = 'NU_TEMPO_RPPS_EST_y'
    var2 = 'NU_TEMPO_RPPS_EST_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "NU_TEMPO_RPPS_EST_x < NU_TEMPO_RPPS_EST_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Aposentado perdeu tempo de averbação em comparação com a base mais antiga."
    return teste
# falta o erro de averbação negativa


def inatv_trend21(df1,df2):
    """
    Executa o teste de tendencia , para a variavel NU_TEMPO_RPPS_FED,
    Será testado se a variavel muda de uma base para outra, o que seria um 
    erro. Por que o beneficio já foi concedido, e não faz sentido o servidor perder tempo de averbação.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NU_TEMPO_RPPS_FED"
    var1 = 'NU_TEMPO_RPPS_FED_y'
    var2 = 'NU_TEMPO_RPPS_FED_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "NU_TEMPO_RPPS_FED_x < NU_TEMPO_RPPS_FED_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Aposentado perdeu tempo de averbação em comparação com a base mais antiga."
    return teste


def inatv_trend22(df1,df2):
    """
    Executa o teste de tendência , para a variável NU_DEPENDENTES,
    Será testado se a variável muda de uma base para outra, o que seria um 
    erro. Por que o beneficio já foi concedido, e não faz sentido o servidor perder tempo de averbação.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NU_DEPENDENTES"
    var1 = 'NU_DEPENDENTES_y'
    var2 = 'NU_DEPENDENTES_x'
    
    df = sys_check_rm(df, [var1, var2], 12)
    
    teste = df.query( "NU_DEPENDENTES_x != NU_DEPENDENTES_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF_x","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Aviso"
    teste["MENSAGEM"] = "Mudança no numero de dependentes."

    return teste