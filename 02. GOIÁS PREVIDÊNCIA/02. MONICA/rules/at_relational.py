# -*- coding: utf-8 -*-

'''
Este script executa o teste relational para variáveis selecionadas da base dos ativos.
Consultar o arquivo "Regras do negócio.xlsx" para maiores detalhes sobre os testes.

'''

### IMPORTANDO PACOTES
import pandas as pd
from config import idade_min, idade_max, averb
from config import d_cols_at
from syscheck import sys_check_rm

list_var = list(d_cols_at.keys())

### Lista com nome dos testes
atv_relational = ["atv_relational01",
                  "atv_relational02",
                  "atv_relational03",
                  "atv_relational04",
                  "atv_relational05",
                  "atv_relational06",
                  "atv_relational07",
                  "atv_relational08",
                  "atv_relational09",
                  "atv_relational10",
                  "atv_relational11",
                  #"atv_relational12",
                  "atv_relational13",
                  "atv_relational14",
                  "atv_relational15"]


def atv_relational01(ativo):
    """
    Quando CO_COMP_MASSA é igual a 1, CO_TIPO_POPULACAO deve ser igual a 1,2 ou 3;
    Quando CO_COMP_MASSA é igual a 2, CO_TIPO_POPULACAO deve ser igual a 8.
    Parameters : 
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV.

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'CO_COMP_MASSA' e
        'CO_TIPO_POPULACAO'.

    """
    
    df = ativo.copy()    
    
    var1 = 'CO_COMP_MASSA'
    var2 = 'CO_TIPO_POPULACAO'
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    #Criando submassas
    
    df_massa_1 = df.loc[df[var1].isin([1]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    df_massa_2 = df.loc[df[var1].isin([2]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    
    
    
    #Fazendo testes com as respectivas submassas
    teste1 = df_massa_1.loc[~df_massa_1[var2].isin([1,2,3]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    teste2 = df_massa_2.loc[~df_massa_2[var2].isin([8]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    s = teste1[var1]
    s2 = teste1[var2]
    v1=[]
    for i in range(len(s)):
        v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
        
    s = teste2[var1]
    s2 = teste2[var2]
    v2=[]
    for i in range(len(s)):
        v2.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    
    #Dataframe de insconsistencais com a submassa 1
    teste1 = teste1.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste1 = teste1.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste1["VALOR"]= v1
    teste1["VARIÁVEL"] =  var1 + "  &  " + var2
    teste1["BASE"] = "Ativos"
    teste1["TESTE"] = "Relational"
    teste1["TAG"] = "Erro"
    teste1["MENSAGEM"] = "Composição da massa civil associada a tipo de população militar"

    #Dataframe de insconsistencais com a submassa 2
    teste2 = teste2.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste2 = teste2.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste2["VALOR"]= v2
    teste2["VARIÁVEL"] =  var1 + "  &  " + var2
    teste2["BASE"] = "Ativos"
    teste2["TESTE"] = "Relational"
    teste2["TAG"] = "Erro"
    teste2["MENSAGEM"] = "Composição da massa militar associada a tipo de população civil"
        
    
    #Juntando submassas
    teste  = teste1
    teste.append(teste2)
    del teste[var1]
    del teste[var2]
    
    return teste

def atv_relational02(ativo):
    """
    Verificando se o CNPJ está comum para mais de um ORGÃO.
    Parameters : 
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 
        'NU_CNPJ_ORGAO' e 'NO_ORGAO'.
    """
    df = ativo.copy()
    
    v_cnpjs = df.NU_CNPJ_ORGAO.unique()
    
    var1 = 'NO_ORGAO'
    var2 = 'NU_CNPJ_ORGAO'
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    error = pd.DataFrame(columns=["CPF","MATRICULA" "VALOR",
                              "VARIÁVEL","BASE",
                              "TESTE", "TAG",
                              "MENSAGEM"])
    
    for cnpj in v_cnpjs:  # loop para verificar cnpjs duplicados
        no_orgao = df.loc[df.NU_CNPJ_ORGAO == cnpj, var1].unique()
        if len(no_orgao) > 1:
            test = df.loc[df.NU_CNPJ_ORGAO == cnpj,
                         ["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]]
            test = test.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
            test = test.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
            s = test[var1]
            s2 = test[var2]
            v1=[]
            for i in range(len(s)):
                v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))          
            test["VALOR"]= v1
            test["VARIÁVEL"] =  var1 + "  &  " + var2
            test["BASE"] = "Ativos"
            test["TESTE"] = "Relational"
            test["TAG"] = "Aviso"
            test["MENSAGEM"] = "Mais de um orgão com o mesmo CNPJ."
            del test[var1]
            del test[var2]
            error.append(test).reset_index(drop=True)
            
    return error


def atv_relational03(ativo):
    """
    Verificando se o Orgão está comum para mais de um CNPJ.
    Parameters : 
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 
        'NO_ORGAO' e 'NU_CNPJ_ORGAO'.
    """
    df = ativo.copy()
    
    v_orgaos = df.NO_ORGAO.unique()

    var1 = 'NU_CNPJ_ORGAO'    
    var2 = 'NO_ORGAO'
    
    df = sys_check_rm(df, [var1, var2], 1)

    
    error = pd.DataFrame(columns=["CPF","MATRICULA","VALOR",
                              "VARIÁVEL","BASE",
                              "TESTE", "TAG",
                              "MENSAGEM"])
    for orgao in v_orgaos:
        nu_cnpj = df.loc[df.NU_CNPJ_ORGAO == orgao, var1].unique()
        if len(nu_cnpj) > 1:
            test = df.loc[df.NO_ORGAO == orgao,
                         ["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]]
            test = test.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
            test = test.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
            s = test[var1]
            s2 = test[var2]
            v1=[]
            for i in range(len(s)):
                v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))          
            test["VALOR"]= v1
            test["VARIÁVEL"] =  var1 + "  &  " + var2
            test["BASE"] = "Ativos"
            test["TESTE"] = "Relational"
            test["TAG"] = "Erro"
            test["MENSAGEM"] = "Mais de um CNPJ para o mesmo órgão"
            del test[var1]
            del test[var2]
            error.append(test).reset_index(drop=True)
            
    return error


def atv_relational04(ativo):
    """
    Verificando se o CNPJ possui mais de um código Poder.
    Parameters : 
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'CO_PODER' e 'NU_CNPJ_ORGAO'.
    """
    df = ativo.copy()
    
    v_cnpjs = df.NU_CNPJ_ORGAO.unique()

    var1 = 'CO_PODER'
    var2 = 'NU_CNPJ_ORGAO'
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    error = pd.DataFrame(columns=["CPF", "VALOR",
                              "VARIÁVEL","BASE",
                              "TESTE", "TAG",
                              "MENSAGEM"])
    
    for cnpj in v_cnpjs:
        co_poder = df.loc[df.NU_CNPJ_ORGAO == cnpj, var1].unique()
        if len(co_poder) > 1:
            test = df.loc[df.CO_PODER == co_poder,
                         ["ID_SERVIDOR_CPF", "ID_SERVIDOR_MATRICULA", var1 , var2]]
            test = test.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
            test = test.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
            s = test[var1]
            s2 = test[var2]
            v1=[]
            for i in range(len(s)):
                v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))          
            test["VALOR"]= v1
            test["VARIÁVEL"] =  var1 + "  &  " + var2
            test["BASE"] = "Ativos"
            test["TESTE"] = "Relational"
            test["TAG"] = "Erro"
            test["MENSAGEM"] = "Mais de um poder associado ao mesmo CNPJ."
            del test[var1]
            del test[var2]
            error.append(test).reset_index(drop=True)
            
    return error


def atv_relational05(ativo):
    """
    Quando CO_TIPO_POPULACAO for igual a 1, 2 ou 3, CO_COMP_MASSA deve ser igual a 1;
    Quando CO_TIPO_POPULACAO for igual a 8, CO_COMP_MASSA deve ser igual a 2;

    Parameters : 
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'CO_TIPO_POPULACAO' e 'CO_COMP_MASSA'.
    """
    
    df = ativo.copy()    
    
    var1 = 'CO_TIPO_POPULACAO'
    var2 = 'CO_COMP_MASSA'
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    #Criando submassas
    df_massa_1 = df.loc[df[var1].isin([1,2,3]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    df_massa_2 = df.loc[df[var1].isin([8]),["ID_SERVIDOR_CPF", "ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    
    #Fazendo testes com as respectivas submassas
    teste1 = df_massa_1.loc[~df_massa_1[var2].isin([1]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    teste2 = df_massa_2.loc[~df_massa_2[var2].isin([2]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    
    
    #Data.frame de insconsistencais com a submassa 1
    teste1 = teste1.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste1 = teste1.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})

    teste1["VARIÁVEL"] = var1 + "  &  " + var2
    teste1["BASE"] = "Ativos"
    teste1["TESTE"] = "Relational"
    teste1["TAG"] = "Erro"
    teste1["MENSAGEM"] = "Tipo de população servidores ativos associada a composição da massa militar"

    #Data.frame de insconsistencais com a submassa 2
    teste2 = teste2.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste2 = teste2.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste2 = teste2.rename(columns={var2 : "VALOR"})
    teste2["VARIÁVEL"] = var1 + "  &  " + var2
    teste2["BASE"] = "Ativos"
    teste2["TESTE"] = "Relational"
    teste2["TAG"] = "Erro"
    teste2["MENSAGEM"] = "Tipo de população servidores militares ativos associada a composição da massa civil"
    
    #Juntando submassas
    teste  = teste1
    teste.append(teste2)
    del teste[var1]
    del teste[var2]
    
    return teste
   
   
def atv_relational06(ativo):
    """
    Quando CO_TIPO_CARGO for igual a 1, 2, 3, 4, 5, 6, 7, CO_COMP_MASSA deve ser igual a 1;
    Quando CO_TIPO_CARGO for igual a 8, CO_COMP_MASSA deve ser igual a 2.
    
    Parameters : 
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'CO_TIPO_CARGO' e 'CO_COMP_MASSA'.

    """
    
    df = ativo.copy()    
    
    var1 = 'CO_TIPO_CARGO'
    var2 = 'CO_COMP_MASSA'
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    #Criando submassas
    df_massa_1 = df.loc[df[var1].isin([1,2,3,4,5,6,7]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    df_massa_2 = df.loc[df[var1].isin([8]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    
    #Fazendo testes com as respectivas submassas
    teste1 = df_massa_1.loc[~df_massa_1[var2].isin([1]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    teste2 = df_massa_2.loc[~df_massa_2[var2].isin([2]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    s = teste1[var1]
    s2 = teste1[var2]
    v1=[]
    for i in range(len(s)):
        v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
        
    s = teste2[var1]
    s2 = teste2[var2]
    v2=[]
    for i in range(len(s)):
        v2.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    
    #Dataframe de insconsistencais com a submassa 1
    teste1 = teste1.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste1 = teste1.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste1["VALOR"]= v1
    teste1["VARIÁVEL"] = var1 + "  &  " + var2
    teste1["BASE"] = "Ativos"
    teste1["TESTE"] = "Relational"
    teste1["TAG"] = "Erro"
    teste1["MENSAGEM"] = "Tipo de cargo servidores ativos civis associada a composição da massa militar"

    #Dataframe de insconsistencais com a submassa 2
    teste2 = teste2.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste2 = teste2.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste2["VALOR"]= v2
    teste2["VARIÁVEL"] = var1 + "  &  " + var2
    teste2["BASE"] = "Ativos"
    teste2["TESTE"] = "Relational"
    teste2["TAG"] = "Erro"
    teste2["MENSAGEM"] = "Tipo de cargo de militares em atividade associada a composição da massa civil"
    
    #Juntando submassas
    teste  = teste1
    teste.append(teste2)
    del teste[var1]
    del teste[var2]
    
    return teste

### CO_CRITERIO_ELEGIBILIDADE
    #1)VARIÁVEL RELACIONADA: NO_CARGO; NO_CARREIRA #NAO IMPLEMENTADO. VIDE REGRAS DE NEGÓCIO

    #2)VARIÁVEL RELACIONADA: CO_COMP_MASSA

def atv_relational07(ativo):
    """
    Quando CO_CRITERIO_ELEGIBILIDADE for igual a 1, 2, 3, 4, 5, CO_COMP_MASSA deve ser igual a 1.
    Quando CO_CRITERIO_ELEGIBILIDADE for igual a 8,CO_COMP_MASSA deve ser igual a 2.
    
    Parameters :
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'CO_CRITERIO_ELEGIBILIDADE' e 'CO_COMP_MASSA'.
    """
    
    df = ativo.copy()    
    
    var1 = 'CO_CRITERIO_ELEGIBILIDADE'
    var2 = 'CO_COMP_MASSA'
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    #Criando submassas
    df_massa_1 = df.loc[df[var1].isin([1,2,3,4,5]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    df_massa_2 = df.loc[df[var1].isin([8]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    
    #Fazendo testes com as respectivas submassas
    teste1 = df_massa_1.loc[~df_massa_1[var2].isin([1]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    teste2 = df_massa_2.loc[~df_massa_2[var2].isin([2]),["ID_SERVIDOR_CPF", "ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    s = teste1[var1]
    s2 = teste1[var2]
    v1=[]
    for i in range(len(s)):
        v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
        
    s = teste2[var1]
    s2 = teste2[var2]
    v2=[]
    for i in range(len(s)):
        v2.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    
    #Dataframe de insconsistencais com a submassa 1
    teste1 = teste1.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste1 = teste1.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste1["VALOR"]= v1
    teste1["VARIÁVEL"] = var1 + "  &  " + var2
    teste1["BASE"] = "Ativos"
    teste1["TESTE"] = "Relational"
    teste1["TAG"] = "Erro"
    teste1["MENSAGEM"] = "Criterio de elegibilidade servidores ativos civis associada a composição da massa militar"

    #Dataframe de insconsistencais com a submassa 2
    teste2 = teste2.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste2 = teste2.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste2["VALOR"]= v2
    teste2["VARIÁVEL"] = var1 + "  &  " + var2
    teste2["BASE"] = "Ativos"
    teste2["TESTE"] = "Relational"
    teste2["TAG"] = "Erro"
    teste2["MENSAGEM"] = "Criterio de elegibilidade militares associada a composição da massa civis"
    
    #Juntando submassas
    teste  = teste1
    teste.append(teste2)
    del teste[var1]
    del teste[var2]
    
    return teste


def atv_relational08(ativo):
    """
    Quando a ID_ING_SERV_PUB(Idade de ingresso no serviço) deve ser a partir de 18 anos e no máximo 75 anos.
    
    Parameters :
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'DT_ING_SERV_PUB' e 'DT_NASC_SERVIDOR'.

    """
        
    df = ativo.copy()

    var = "ID_ING_SERV_PUB"
    
    var1 = "DT_ING_SERV_PUB"
    var2 = "DT_NASC_SERVIDOR"
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    df[var] = (df['DT_ING_SERV_PUB'] - df['DT_NASC_SERVIDOR']).dt.days // 365.25 #Calculando a idade
      
    df = df.loc[~(df[var].between(idade_min,idade_max, inclusive="left")),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var,var1,var2]].reset_index(drop=True)
    teste = df
    s = teste[var1]
    s2 = teste[var2]
    v1=[]
    for i in range(len(s)):
        v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= v1
    teste["VARIÁVEL"] = var1 + "  &  " + var2 
    # Vide linha acima, repensar como apresentar variáveis construídas
    # [YURI]
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Aviso"
    teste.loc[teste[var] >= idade_max, "MENSAGEM"] = "Idade de ingresso no serviço público igual ou superior a 75"
    teste.loc[teste[var] <= idade_min, "MENSAGEM"] = "Idade de ingresso no serviço público menor ou igual a 18"
    del teste[var]
    del teste[var1]
    del teste[var2]
    
    return teste


def atv_relational09(ativo):
    """
    Quando a ID_ING_ENTE (Idade de ingresso no ente) deve ser a partir de 18 anos e no máximo 75 anos.
    
    Parameters :
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'DT_ING_ENTE' e 'DT_NASC_SERVIDOR'.
    """
        
    df = ativo.copy()
    
    var = "ID_ING_ENTE"
    
    var1 = "DT_ING_ENTE"
    var2 = "DT_NASC_SERVIDOR"
    
    df = sys_check_rm(df, [var1, var2], 1)

    df[var] = (df['DT_ING_ENTE'] - df['DT_NASC_SERVIDOR']).dt.days//365.25
   
    teste= df.loc[~(df[var].between(idade_min,idade_max, inclusive="left")),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var,var1,var2]].reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    v1=[]
    for i in range(len(s)):
        v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= v1
    teste["VARIÁVEL"] = var1 + "  &  " + var2
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Aviso"
    teste.loc[teste[var] >= idade_max, "MENSAGEM"] = "Idade de ingresso no ente igual ou superior a 75"
    teste.loc[teste[var] <= idade_min, "MENSAGEM"] = "Idade de ingresso no ente  menor ou igual a 18"
    del teste[var]
    del teste[var1]
    del teste[var2]
    
    return teste


def atv_relational10(ativo):
    """
    Quando a ID_ING_CARREIRA deve ser a partir de 18 anos e no máximo 75 anos.
    
    Parameters : 
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'DT_ING_CARREIRA' e 'DT_NASC_SERVIDOR'.

    """
    df = ativo.copy()
    
    var = "ID_ING_CARREIRA"
    
    var1 = "DT_ING_CARREIRA"
    var2 = "DT_NASC_SERVIDOR"
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    df[var] = (df['DT_ING_CARREIRA'] - df['DT_NASC_SERVIDOR']).dt.days // 365.25

    teste = df.loc[~(df[var].between(idade_min,idade_max, inclusive="left")),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var,var1,var2]].reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    v1=[]
    for i in range(len(s)):
        v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= v1
    teste["VARIÁVEL"] = var1 + "  &  " + var2
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Aviso"
    teste.loc[teste[var] >= idade_max, "MENSAGEM"] = "Idade de ingresso na carreira igual ou superior a 75"
    teste.loc[teste[var] <= idade_min, "MENSAGEM"] = "Idade de ingresso na carreira menor ou igual a 18"
    del teste[var]
    del teste[var1]
    del teste[var2]

    return teste


def atv_relational11(ativo):
    """
    Quando a DT_ING_CARGO deve ser a partir de 18 anos e no máximo 75 anos.
    
    Parameters : 
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'DT_ING_CARGO' e 'DT_NASC_SERVIDOR'.
    """

    df = ativo.copy()
    
    var = "ID_ING_CARGO"
    
    var1 = "DT_ING_CARGO"
    var2 = "DT_NASC_SERVIDOR"
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    df[var] = (df['DT_ING_CARGO'] - df['DT_NASC_SERVIDOR']).dt.days // 365.25

    teste = df.loc[~(df[var].between(idade_min,idade_max, inclusive="left")),["ID_SERVIDOR_CPF", "ID_SERVIDOR_MATRICULA",var,var1,var2]].reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    v1=[]
    for i in range(len(s)):
        v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= v1
    teste["VARIÁVEL"] = var1 + "  &  " + var2
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Aviso"
    teste.loc[teste[var] >= idade_max, "MENSAGEM"] = "Idade de ingresso no cargo igual ou superior a 75."
    teste.loc[teste[var] <= idade_min, "MENSAGEM"] = "Idade de ingresso no cargo menor ou igual a 18."
    del teste[var]
    del teste[var1]
    del teste[var2]
    
    return teste


### VL_CONTRIBUICAO
     #1)VARIÁVEL RELACIONADA: VL_BASE_CALCULO# (base de calculo obtem valores erroneos)
     #Revisar [YURI]
# def atv_relational12(ativo):
    # """
    # O VL_CONTRIBUICAO deve ser inferior ou igual ao valor VL_BASE_CALCULO .
    
    # Parameters :
    # ----------
    # ativo : DataFrame
        # DataFrame da base dos ativos. Formato SPREV

    # Returns
    # -------
    # teste : DataFrame
        # Saída com cada observação inconsistente em relação a 'ID_ING_CARGO' e 'DT_NASC_SERVIDOR'.

    # """
    # df = ativo.copy()

    # #Elaborando o teste.
    # var = df['VL_CONTRIBUICAO']> df['VL_BASE_CALCULO'].reset_index(drop=True)
    # teste =  var
    # #Dataframe de insconsistencais com a submassa 1
    # teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    # teste = teste.rename(columns={var : "VALOR"})
    # teste["VARIÁVEL"] = var
    # teste["BASE"] = "Ativos"
    # teste["TESTE"] = "Relational"
    # teste["TAG"] = "Erro"
    # teste["MENSAGEM"] = " Valor da contribuição deve ser menor que o valor da base de calculo, porém o erro pode ser causado pelo erro na base."
    
    # return teste


def atv_relational13(ativo):
    """
    Servidor codificado como 1 em IN_PREV_COMP não pode pertencer a composição de massa militar.
    Parameters : 
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'IN_PREV_COMP' e 'CO_COMP_MASSA'.

    """
    
    df = ativo.copy()    
    
    var1 = 'IN_PREV_COMP'
    var2 = 'CO_COMP_MASSA'
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    #Criando submassas
    df_massa = df.loc[df[var1].isin([1]),
                     ["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    
    #Fazendo testes com as respectivas submassas
    teste = df_massa.loc[~df_massa[var2].isin([1]),
                        ["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA" , var1 , var2]].reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    v1=[]
    for i in range(len(s)):
        v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    
    #Dataframe de insconsistencais com a submassa 1
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= v1
    teste["VARIÁVEL"] = var1 + "  &  " + var2
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Indicador de previdência complemmentar associado a composição da massa militar"
    del teste[var1]
    del teste[var2]

    return teste


def atv_relational14(ativo):
    """
    IN_PREV_COMP não pode ser vinculado ao fundo financeiro.
    Parameters : 
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'IN_PREV_COMP' e 'CO_COMP_MASSA'.

    """
    
    df = ativo.copy()    
    
    var1 = 'IN_PREV_COMP'
    var2 = 'CO_TIPO_FUNDO'
    
    df = sys_check_rm(df, [var1, var2], 1)
    
    #Criando submassas
    df_massa = df.loc[df[var1].isin([1]),
                     ["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    
    #Fazendo testes com as respectivas submassas
    teste = df_massa.loc[~df_massa[var2].isin([1]),
                        ["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA", var1 , var2]].reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    v1=[]
    for i in range(len(s)):
        v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    
    #Dataframe de insconsistencais com a submassa 1
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= v1
    teste["VARIÁVEL"] = var1 + "  &  " + var2
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Servidor com indicação de previdência complementar vinculado ao fundo financeiro"
    del teste[var1]
    del teste[var2]

    return teste


def atv_relational15(ativo):
    """
    Teste verifica a conformidade do intervalo da soma das averbações
    O tempo de averbação deve somar no máximo 14.610 dias.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente.
    """
    df = ativo.copy()
    
    var = "TEMPO_TOTAL"
    var1 = "NU_TEMPO_RPPS_MUN"
    var2 = "NU_TEMPO_RPPS_EST"
    var3 = "NU_TEMPO_RPPS_FED"
    var4 = "NU_TEMPO_RGPS"
    
    df = sys_check_rm(df, [var1, var2, var3, var4], 1)

    ### Criando variável que representa a soma das averbações
    averb_list = ["NU_TEMPO_RGPS", "NU_TEMPO_RPPS_MUN", "NU_TEMPO_RPPS_EST", "NU_TEMPO_RPPS_FED"]
    df[var] = df[averb_list].sum(axis = 1)

    teste = df.loc[~(df[var].between(0,averb)),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var,var1,var2,var3,var4]].reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    s3 = teste[var3]
    s4 = teste[var4]
    v1=[]
    for i in range(len(s)):
        v1.append( '%s,%s,%s,%s'%(s.iloc[i],s2.iloc[i],s3.iloc[i],s4.iloc[i]))
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= v1
    teste["VARIÁVEL"] = var1 + "  &  " + var2 +  "  &  " + var3 + "  &  " + var4
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mais de 14.610 dias averbados"
    del teste[var]
    del teste[var1]
    del teste[var2]
    del teste[var3]
    del teste[var4]
    return teste

