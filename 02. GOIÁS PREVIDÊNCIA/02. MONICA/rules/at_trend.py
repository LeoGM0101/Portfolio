# -*- coding: utf-8 -*-
"""
Este script executa o teste trend para variáveis selecionadas da base dos 
ativos.
Consultar o arquivo "Regras do negócio.xlsx" para maiores detalhes sobre os
testes.

sufixo _x corresponde a variavel da base mais atual e 
sufixo _y corresponde a variavel da base mais antiga.

Script com uma severa dificultade de manutenção (Yuri)
"""

import pandas as pd
from syscheck import sys_check_rm
from config import *

atv_trend = ["atv_trend01",
             "atv_trend02",
             "atv_trend03",
             "atv_trend04",
             "atv_trend05",
             "atv_trend06",
             "atv_trend07",
             "atv_trend08",
             "atv_trend09",
             "atv_trend10",
             "atv_trend11",
             "atv_trend12",
             "atv_trend13",
             "atv_trend14",
             "atv_trend15",
             "atv_trend16",
             "atv_trend17"]


def atv_trend01(df1,df2):
    """
    Executa o teste de tendência , para a variavel CO_TIPO_FUNDO,
    Será testado se o servidor Muda do fundo previdenciario para o fundo
    financeiro de uma base pra outra o que seria um erro , a mudança contraria
    é possivel acontecer.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
      
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    
    v= "CO_TIPO_FUNDO"
    var1 = 'CO_TIPO_FUNDO_y'
    var2 = 'CO_TIPO_FUNDO_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    
    teste= df.query("CO_TIPO_FUNDO_y == 2  & CO_TIPO_FUNDO_x == 1 | CO_TIPO_FUNDO_y == 1 & CO_TIPO_FUNDO_x == 2")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append('%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] =  v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = ''
    teste["MENSAGEM"] = ''
    teste.loc[df["CO_TIPO_FUNDO_y"] == 2, "TAG"] = "Erro"
    teste.loc[df["CO_TIPO_FUNDO_y"] == 1, "TAG"] = "Aviso"
    teste.loc[df["CO_TIPO_FUNDO_y"] == 2, "MENSAGEM"] =  "Mudança do fundo previdenciario para o fundo financeiro"
    teste.loc[df["CO_TIPO_FUNDO_y"] == 1, "MENSAGEM"] =  "Mudança do fundo financeiro para fundo previdenciario"
    return teste


def atv_trend02(df1,df2):
    """
    Executa o teste de tendência , para a variavel ID_SERVIDOR_PIS_PASEP,
    Será testado se a variavel muda de uma base para outra, o que é um erro
    pois não deve haver nenhuma mudança.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1,df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "ID_SERVIDOR_PIS_PASEP"
    var1 = 'ID_SERVIDOR_PIS_PASEP_y'
    var2 = 'ID_SERVIDOR_PIS_PASEP_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    
    teste = df.query("ID_SERVIDOR_PIS_PASEP_x != ID_SERVIDOR_PIS_PASEP_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança do pis pasep entre uma base e outra."
    return teste

def atv_trend03(df1,df2):
    """
    Executa o teste de tendência, para a variavel CO_SEXO_SERVIDOR,
    Será testado se a variavel muda de uma base para outra, o que seria um 
    erro. Por que a variavel se trata do sexo que a pessoa nasceu.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_SEXO_SERVIDOR"
    var1 = 'CO_SEXO_SERVIDOR_y'
    var2 = 'CO_SEXO_SERVIDOR_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query("CO_SEXO_SERVIDOR_x != CO_SEXO_SERVIDOR_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança do sexo de nascimento do servidor entre uma base e outra."
    return teste

def atv_trend04(df1,df2):
    """
    Executa o teste de tendência , para a variavel CO_EST_CIVIL_SERVIDOR,
    Será testado se a variavel muda de uma base para outra , o que pode ser 
    um erro, se ele sair de algum estado civil para solteiro.
    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_EST_CIVIL_SERVIDOR"
    var1 = 'CO_EST_CIVIL_SERVIDOR_y'
    var2 = 'CO_EST_CIVIL_SERVIDOR_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "CO_EST_CIVIL_SERVIDOR_x ==1 & CO_EST_CIVIL_SERVIDOR_y != (1,9)")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança de estado civil para solteiro."
    return teste
# Falta a regra de aviso de qualquer outra alteração de status civil.

def atv_trend05(df1,df2):
    """
    Executa o teste de tendência , para a variavel DT_NASC_SERVIDOR,
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
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "DT_NASC_SERVIDOR"
    var1 = 'DT_NASC_SERVIDOR_y'
    var2 = 'DT_NASC_SERVIDOR_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "DT_NASC_SERVIDOR_x != DT_NASC_SERVIDOR_y ")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x","ID_SERVIDOR_MATRICULA"]]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")" 
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança de data de nascimento."
    return teste

def atv_trend06(df1,df2):
    """
    Executa o teste de tendência , para a variavel DT_ING_SERV_PUB,
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
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "DT_ING_SERV_PUB"
    var1 = 'DT_ING_SERV_PUB_y'
    var2 = 'DT_ING_SERV_PUB_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "DT_ING_SERV_PUB_x != DT_ING_SERV_PUB_y ")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x", 'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança da data de ingresso no serviço publico."
    return teste

def atv_trend07(df1,df2):
    """
    Executa o teste de tendência, para a variavel DT_ING_CARREIRA,
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
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "DT_ING_CARREIRA"
    var1 = 'DT_ING_CARREIRA_y'
    var2 = 'DT_ING_CARREIRA_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "DT_ING_CARREIRA_x != DT_ING_CARREIRA_y ")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança da data de ingresso na carreira."
    return teste
# Falta o aviso

def atv_trend08(df1,df2):
    """
    Executa o teste de tendência , para a variavel DT_ING_ENTE,
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
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "DT_ING_ENTE"
    var1 = 'DT_ING_ENTE_y'
    var2 = 'DT_ING_ENTE_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "DT_ING_ENTE_x != DT_ING_ENTE_y ")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mudança da data de ingresso no ente."
    return teste


def atv_trend09(df1,df2):
    """
    Executa o teste de tendência , para a variavel NO_CARREIRA,
    Será testado se a variavel muda de uma base para outra, e que pode ser 
    erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NO_CARREIRA"
    var1 = 'NO_CARREIRA_y'
    var2 = 'NO_CARREIRA_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "NO_CARREIRA_x != NO_CARREIRA_y ")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    df = df[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Aviso"
    teste["MENSAGEM"] = "Mudança no nome da carreira"
    return teste

def atv_trend10(df1,df2):
    """
    Executa o teste de tendência , para a variavel VL_REMUNERACAO,
    Será testado se a variavel muda de uma base para outra, pode ocorrer 
    mudança, por isso é um aviso.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "VL_REMUNERACAO"
    var1 = 'VL_REMUNERACAO_y'
    var2 = 'VL_REMUNERACAO_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "VL_REMUNERACAO_x != VL_REMUNERACAO_y ")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Aviso"
    teste["MENSAGEM"] = "Mudança no valor da remuneração"
    return teste


def atv_trend11(df1,df2):
    """
    Executa o teste de tendência , para a variavel IN_ABONO_PERMANENCIA,
    Será testado se a variavel muda de uma base para outra, e que pode ser 
    erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "IN_ABONO_PERMANENCIA"
    var1 = 'IN_ABONO_PERMANENCIA_y'
    var2 = 'IN_ABONO_PERMANENCIA_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "IN_ABONO_PERMANENCIA_x ==1 & IN_ABONO_PERMANENCIA_y !=1 | IN_ABONO_PERMANENCIA_x ==2 & IN_ABONO_PERMANENCIA_y ==1 ")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    # teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = ''
    teste["MENSAGEM"] = ''
    teste.loc[teste["IN_ABONO_PERMANENCIA_x"]== 1, "TAG"] = "Erro"
    teste.loc[teste["IN_ABONO_PERMANENCIA_x"]== 2, "TAG"] = "Aviso"
    teste.loc[teste["IN_ABONO_PERMANENCIA_x"] == 1, "MENSAGEM"] = "Servidor tinha abono permanencia e deixou de ter"
    teste.loc[teste["IN_ABONO_PERMANENCIA_x"] == 2, "MENSAGEM"] = "Servidor não tinha abono permanencia e passou a ter"
    teste = teste[['CPF','MATRICULA','VARIÁVEL','VALOR','BASE','TESTE','TAG','MENSAGEM']]
    return teste


def atv_trend12(df1,df2):
    """
    Executa o teste de tendência , para a variavel NU_TEMPO_RGPS,
    Será testado se a variavel diminui de uma base para outra, e que pode ser 
    erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NU_TEMPO_RGPS"
    var1 = 'NU_TEMPO_RGPS_y'
    var2 = 'NU_TEMPO_RGPS_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "NU_TEMPO_RGPS_x < NU_TEMPO_RGPS_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Aviso"
    teste["MENSAGEM"] = "Desaverbação de uma base para outra ou seja a averbação da base mais atual é menor do que a averbação da base mais antiga."
    return teste


def atv_trend13(df1,df2):
    """
    Executa o teste de tendência , para a variavel NU_TEMPO_RPPS_MUN,
    Será testado se a variavel diminui de uma base para outra, e que pode ser 
    erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NU_TEMPO_RPPS_MUN"
    var1 = 'NU_TEMPO_RPPS_MUN_y'
    var2 = 'NU_TEMPO_RPPS_MUN_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "NU_TEMPO_RPPS_MUN_x < NU_TEMPO_RPPS_MUN_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Aviso"
    teste["MENSAGEM"] = "Desaverbação de uma base para outra ou seja a averbação da base mais atual é menor do que a averbação da base mais antiga."
    return teste


def atv_trend14(df1,df2):
    """
    Executa o teste de tendência , para a variavel NU_TEMPO_RPPS_EST,
    Será testado se a variavel diminui de uma base para outra, e que pode ser 
    erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NU_TEMPO_RPPS_EST"
    var1 = 'NU_TEMPO_RPPS_EST_y'
    var2 = 'NU_TEMPO_RPPS_EST_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "NU_TEMPO_RPPS_EST_x < NU_TEMPO_RPPS_EST_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Aviso"
    teste["MENSAGEM"] = "Desaverbação de uma base para outra ou seja a averbação da base mais atual é menor do que a averbação da base mais antiga."
    return teste


def atv_trend15(df1,df2):
    """
    Executa o teste de tendência , para a variavel NU_TEMPO_RPPS_FED,
    Será testado se a variavel diminui de uma base para outra, e que pode ser 
    erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NU_TEMPO_RPPS_FED"
    var1 = 'NU_TEMPO_RPPS_FED_y'
    var2 = 'NU_TEMPO_RPPS_FED_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "NU_TEMPO_RPPS_FED_x < NU_TEMPO_RPPS_FED_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Aviso"
    teste["MENSAGEM"] = "Desaverbação de uma base para outra ou seja a averbação da base mais atual é menor do que a averbação da base mais antiga."
    return teste


def atv_trend16(df1,df2):
    """
    Executa o teste de tendência , para a variavel NU_DEPENDENTES,
    Será testado se a variavel diminui ou aumenta de uma base para outra,
    o que pode ser erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "NU_DEPENDENTES"
    var1 = 'NU_DEPENDENTES_y'
    var2 = 'NU_DEPENDENTES_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query( "NU_DEPENDENTES_x < NU_DEPENDENTES_y")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Aviso"
    teste["MENSAGEM"] = "Redução ou aumento do número de dependentes"
    return teste


def atv_trend17(df1,df2):
    """
    Executa o teste de tendência , para a variavel CO_COMP_MASSA,
    Será testado se o servidor muda de composição de massa de uma base para 
    a outra , o que pode ser um erro.

    Parameters
    ----------
    df : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_MATRICULA'], indicator=True)
    df = df[(df['_merge']=='both')].reset_index(drop=True)
    v = "CO_COMP_MASSA"
    var1 = 'CO_COMP_MASSA_y'
    var2 = 'CO_COMP_MASSA_x'
    
    df = sys_check_rm(df, [var1, var2], 11)
    teste = df.query("CO_COMP_MASSA_y ==2  & CO_COMP_MASSA_x ==1 | CO_COMP_MASSA_y ==1 & CO_COMP_MASSA_x ==2")
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_SERVIDOR_CPF_x",'ID_SERVIDOR_MATRICULA']]
    teste = teste.rename(columns={"ID_SERVIDOR_CPF_x" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = v + "(" + str(mes_old) + "/"+ str(ano_old) + ")" + " & " + v+ "(" + str(mes) + "/"+ str(ano) + ")"
    teste["VALOR"]= var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Trend"
    teste["TAG"] = "Aviso"
    teste["MENSAGEM"] = " Mudança na composição de massa. "
    return teste




