# -*- coding: utf-8 -*-
"""
Este script executa o teste relacional para variáveis selecionadas da base dos inativos.
Consultar o arquivo "Regras do negócio.xlsx" para maiores detalhes sobre os testes.
"""
 
import pandas as pd 
import numpy as np
import datetime
from datetime import  timedelta
from config import  sal_min, idade_min, idade_max, averb, aliquota_civil, aliquota_militares
from syscheck import sys_check_rm


inat_relational = ["inat_relational01",
                   "inat_relational02",
                   "inat_relational03",
                   "inat_relational04",
                   "inat_relational05",
                   "inat_relational06",
                   "inat_relational07",
                   "inat_relational08",
                   "inat_relational09",
                   "inat_relational10",
                   "inat_relational11",
                   "inat_relational12"]


def inat_relational01(inativo):
    """
    Verificando se o CNPJ_ORGAO está comum para mais de um NO_ORGAO.
    Parameters : 
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 
        'CNPJ_ORGAO' e 'NO_ORGAO'.
    """
    df = inativo.copy()
    
    v_cnpjs = df.CNPJ_ORGAO.unique()
    
    var1 = 'NO_ORGAO'
    var2 = 'CNPJ_ORGAO'
    
    df = sys_check_rm(df, [var1, var2], 2)
    
    error = pd.DataFrame(columns=["CPF", "VALOR",
                              "VARIÁVEL","BASE",
                              "TESTE", "TAG",
                              "MENSAGEM"])
 
    for cnpj in v_cnpjs:  # loop para verificar cnpjs duplicados
        no_orgao = df.loc[df.CNPJ_ORGAO == cnpj, var1].unique()
        if len(no_orgao) > 1:
            test = df.loc[df.CNPJ_ORGAO == cnpj,
                         ["ID_APOSENTADO_CPF", "ID_APOSENTADO_MATRICULA",var2]]
            test = test.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
            test = test.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
            s = test[var1]
            s2 = test[var2]
            v1=[]
            for i in range(len(s)):
                v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))          
            test["VALOR"]= v1
            test["VARIÁVEL"] = var2
            test["BASE"] = "Inativos"
            test["TESTE"] = "Relational"
            test["TAG"] = "Erro"
            test["MENSAGEM"] = "Mais de um orgão com o mesmo CNPJ."
            error.append(test).reset_index(drop=True)
       
    return error


def inat_relational02(inativo):
    """
    Verificando se o NO_ORGAO está comum para mais de um CNPJ_ORGAO.
    Parameters : 
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 
        'NO_ORGAO' e 'CNPJ_ORGAO'.
    """
    df = inativo.copy()
    
    v_orgaos = df.NO_ORGAO.unique()

    var1 = 'CNPJ_ORGAO'    
    var2 = 'NO_ORGAO'
    
    df = sys_check_rm(df, [var1, var2], 2)

    error = pd.DataFrame(columns=["CPF", "VALOR",
                              "VARIÁVEL","BASE",
                              "TESTE", "TAG",
                              "MENSAGEM"])
  
    for orgao in v_orgaos:
        nu_cnpj = df.loc[df.CNPJ_ORGAO == orgao, var1].unique()
        if len(nu_cnpj) > 1:
            test = df.loc[df.NO_ORGAO == orgao,
                         ["ID_APOSENTADO_CPF", "ID_APOSENTADO_MATRICULA", var2]]
            test = test.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
            test = test.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
            s = test[var1]
            s2 = test[var2]
            v1=[]
            for i in range(len(s)):
                v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))          
            test["VALOR"]= v1
            test["VARIÁVEL"] = var2
            test["BASE"] = "Inativos"
            test["TESTE"] = "Relational"
            test["TAG"] = "Erro"
            test["MENSAGEM"] = "Mais de um CNPJ com para o mesmo órgão"
            error.append(test).reset_index(drop=True)
            
    return error


def inat_relational03(inativo):
    """
    Verificando se o CO_PODER possui mais de um código CNPJ_ORGAO.
    Parameters : 
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'CO_PODER' e 'CNPJ_ORGAO'.
    """
    df = inativo.copy()
    
    v_cnpjs = df.CNPJ_ORGAO.unique()

    var1 = 'CO_PODER'
    var2 = 'CNPJ_ORGAO'
    
    df = sys_check_rm(df, [var1, var2], 2)
    
    error = pd.DataFrame(columns=["CPF", "VALOR",
                              "VARIÁVEL","BASE",
                              "TESTE", "TAG",
                              "MENSAGEM"])
    
    for cnpj in v_cnpjs:
        co_poder = df.loc[df.CNPJ_ORGAO == cnpj, var1].unique()
        if len(co_poder) > 1:
            test = df.loc[df.CO_PODER == co_poder,
                         ["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA", var2]]
            test = test.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
            test = test.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
            s = test[var1]
            s2 = test[var2]
            v1=[]
            for i in range(len(s)):
                v1.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))          
            test["VALOR"]= v1
            test["VARIÁVEL"] = var2
            test["BASE"] = "Inativos"
            test["TESTE"] = "Relational"
            test["TAG"] = "Erro"
            test["MENSAGEM"] = "Mais de um poder associado ao mesmo CNPJ."
            error.append(test).reset_index(drop=True)
            
    return error


def inat_relational04(inativo):
    """
    Quando CO_TIPO_POPULACAO for igual a 4, CO_COMP_MASSA deve ser igual a 1;
    Quando CO_TIPO_POPULACAO for igual a 9, CO_COMP_MASSA deve ser igual a 2.
    
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente.
    """
    df = inativo.copy()
    
    var1 = 'CO_TIPO_POPULACAO'
    var2 = 'CO_COMP_MASSA'
    
    df = sys_check_rm(df, [var1, var2], 2)
        
    teste= df.query("CO_TIPO_POPULACAO == 4 &  CO_COMP_MASSA!= 1 | CO_TIPO_POPULACAO == 9 &  CO_COMP_MASSA!= 2").reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= var
    teste["VARIÁVEL"] = var1+" & "+var2
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Código tipo de população não corresponde ao Código da Composição de Massa"
    return teste
  

def inat_relational05(inativo):
    
    """
    Quando CO_TIPO_CARGO for igual a 1, 2, 3, 4, 5, 6, 7, CO_COMP_MASSA deve ser igual a 1;
    Quando CO_TIPO_CARGO for igual a 8, CO_COMP_MASSA deve ser igual a 2.
    
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente.
    """
    df = inativo.copy()
    
    var1 = 'CO_TIPO_CARGO'
    var2 = 'CO_COMP_MASSA'
    
    df = sys_check_rm(df, [var1, var2], 2)
    
    teste= df.query("CO_TIPO_CARGO>7 & CO_COMP_MASSA ==1| CO_TIPO_CARGO!=8 & CO_COMP_MASSA ==2 | CO_TIPO_CARGO==8 & CO_COMP_MASSA !=2").reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= var
    teste["VARIÁVEL"] = var1+" & "+var2
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Código do Tipo de Cargo não corresponde a Código de Composição de Massa"
    return teste


def inat_relational06(inativo):
    """
    Quando CO_TIPO_APOSENTADORIA for igual a 1, 2, 3, 4, 5, 6, 7, CO_COMP_MASSA deve ser igual a 1;
    Quando CO_TIPO_APOSENTADORIA for igual a 9 e 10, CO_COMP_MASSA deve ser igual a 2.
    
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente.
    """
    df = inativo.copy()
    
    var1 = 'CO_TIPO_APOSENTADORIA'
    var2 = 'CO_COMP_MASSA'
    
    df = sys_check_rm(df, [var1, var2], 2)
    
    teste= df.query("CO_COMP_MASSA ==1  & CO_TIPO_APOSENTADORIA > 7 | CO_COMP_MASSA ==2 & CO_TIPO_APOSENTADORIA <9 ").reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= var
    teste["VARIÁVEL"] = var1+" & "+var2
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Tipo de Aposentadoria não corresponde a Código de Momposição de Massa"
    return teste


def inat_relational07(inativo):
    """
    Quando a DT_ING_SERV_PUB deve ser a partir de 18 anos e no máximo 75 anos.
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente.
    """
    df = inativo.copy()
    
    var1 = 'DT_NASC_APOSENTADO'
    var2 = 'DT_ING_SERV_PUB'
    
    df = sys_check_rm(df, [var1, var2], 2)
    
    df['DT_NASC_APOSENTADO'] = np.datetime_as_string(df['DT_NASC_APOSENTADO'], unit='D')
    df['DT_ING_SERV_PUB'] = np.datetime_as_string(df['DT_ING_SERV_PUB'], unit='D')
    df['IDADE_ING_SERV_PUB'] = df['DT_ING_SERV_PUB'].apply(lambda x: datetime.datetime.strptime(x, '%Y-%m-%d')) - df['DT_NASC_APOSENTADO'].apply(lambda x: datetime.datetime.strptime(x, '%Y-%m-%d'))
    df['IDADE_ING_SERV_PUB'] =   df['IDADE_ING_SERV_PUB']//timedelta(days=365.2425)
    df['IDADE_ING_SERV_PUB'] =  df['IDADE_ING_SERV_PUB'].apply(lambda x: float(x))
    teste= df.query("IDADE_ING_SERV_PUB <18 | IDADE_ING_SERV_PUB >75")#.reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= var
    teste["VARIÁVEL"] = var1+" & "+var2
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Erro"
    teste.loc[df['IDADE_ING_SERV_PUB'] >= idade_max, "MENSAGEM"] = "Idade de ingresso no serviço publico igual ou superior a 75"
    teste.loc[df['IDADE_ING_SERV_PUB'] <= idade_min, "MENSAGEM"] = "Idade de ingresso no serviço publico menor ou igual a 18"
    teste.reset_index(drop=True)
    return teste


def inat_relational08(inativo):
    """
    Quando a IDADE_ING_ENTE deve ser a partir de 18 anos e no máximo 75 anos.

    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente.
    """
    df = inativo.copy()
    
    var1 = 'DT_NASC_APOSENTADO'
    var2 = 'DATA_DE_INGRESSO_NO_ENTE'
    
    df = sys_check_rm(df, [var1, var2], 2)
    
    df['DT_NASC_APOSENTADO'] = np.datetime_as_string(df['DT_NASC_APOSENTADO'], unit='D')
    df['DATA_DE_INGRESSO_NO_ENTE'] = np.datetime_as_string(df['DATA_DE_INGRESSO_NO_ENTE'], unit='D')
    df['IDADE_ING_ENTE'] = df['DATA_DE_INGRESSO_NO_ENTE'].apply(lambda x: datetime.datetime.strptime(x, '%Y-%m-%d')) - df['DT_NASC_APOSENTADO'].apply(lambda x: datetime.datetime.strptime(x, '%Y-%m-%d'))
    df['IDADE_ING_ENTE'] =   df['IDADE_ING_ENTE']//timedelta(days=365.2425)
    df['IDADE_ING_ENTE'] =  df['IDADE_ING_ENTE'].apply(lambda x: float(x))
    df= df.query("IDADE_ING_ENTE <18 | IDADE_ING_ENTE >75").reset_index(drop=True)
    teste = df
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= var
    teste["VARIÁVEL"] = var1+" & "+var2
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Relational"
    teste.loc[df['IDADE_ING_ENTE'] >= idade_max, "TAG"] = "Erro"
    teste.loc[df['IDADE_ING_ENTE'] <= idade_min, "TAG"] = "Aviso"
    teste.loc[df['IDADE_ING_ENTE'] >= idade_max, "MENSAGEM"] = "Idade de ingresso no serviço publico igual ou superior a 75"
    teste.loc[df['IDADE_ING_ENTE'] <= idade_min, "MENSAGEM"] = "Idade de ingresso no serviço publico menor ou igual a 18"
    return teste

#DT_INICIO_APOSENTADORIA
def inat_relational09(inativo): 
    """
    Quando a IDADE_INICIO_APOSENTADORIA deve ser a partir de 18 anos e no máximo 75 anos.
    
    Parameters : 
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos. Formato SPREV

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'DT_INICIO_APOSENTADORIA' e 'DT_NASC_APOSENTADO'.
    """

    df = inativo.copy()
    
    var1 = 'DT_NASC_APOSENTADO'
    var2 = 'DT_INICIO_APOSENTADORIA'
    
    df = sys_check_rm(df, [var1, var2], 2)

    df['DT_NASC_APOSENTADO'] = np.datetime_as_string(df['DT_NASC_APOSENTADO'], unit='D')
    df['DT_INICIO_APOSENTADORIA'] = np.datetime_as_string(df['DT_INICIO_APOSENTADORIA'], unit='D')
    df['IDADE_INICIO_APOSENTADORIA'] = df['DT_INICIO_APOSENTADORIA'].apply(lambda x: datetime.datetime.strptime(x, '%Y-%m-%d')) - df['DT_NASC_APOSENTADO'].apply(lambda x: datetime.datetime.strptime(x, '%Y-%m-%d'))
    df['IDADE_INICIO_APOSENTADORIA'] =   df['IDADE_INICIO_APOSENTADORIA']//timedelta(days=365.2425)
    df['IDADE_INICIO_APOSENTADORIA'] =  df['IDADE_INICIO_APOSENTADORIA'].apply(lambda x: float(x))
    df= df.query("IDADE_INICIO_APOSENTADORIA <18 | IDADE_INICIO_APOSENTADORIA >75").reset_index(drop=True)
    teste = df
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VALOR"]= var
    teste["VARIÁVEL"] = var1+" & "+var2
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Relational"
    teste.loc[df['IDADE_INICIO_APOSENTADORIA'] >= idade_max, "TAG"] = "Erro"
    teste.loc[df['IDADE_INICIO_APOSENTADORIA'] <= idade_min, "TAG"] = "Aviso"
    teste.loc[df['IDADE_INICIO_APOSENTADORIA'] >= idade_max, "MENSAGEM"] = "Idade de inicio de aposentadoria igual ou superior a 75"
    teste.loc[df['IDADE_INICIO_APOSENTADORIA'] <= idade_min, "MENSAGEM"] = "Idade de inicio de aposentadoria menor ou igual a 18"
    return teste


def inat_relational10(inativo):
    """
    O VL_CONTRIBUICAO deve ser inferior ou igual ao valor VL_APOSENTADORIA.
    
    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente em relação a 'VL_CONTRIBUICAO' e 'VL_APOSENTADORIA'..
    """
    df = inativo.copy()
    
    var1 = 'VL_CONTRIBUICAO'
    var2 = 'VL_APOSENTADORIA'
    
    df = sys_check_rm(df, [var1, var2], 2)
    #Retirar o salario minimo depois 
    contribuicao_erro_civil = df.query("CO_COMP_MASSA ==1").copy()
    contribuicao_erro_civil['contribuicao'] = ((contribuicao_erro_civil['VL_APOSENTADORIA']) - sal_min ) * aliquota_civil
    contribuicao_erro_civil['contribuicao'] = round(contribuicao_erro_civil['contribuicao'], 2)
    contribuicao_erro_civil.query('abs(contribuicao - VL_CONTRIBUICAO) > 0.02')
    contribuicao_erro_militar = df.query("CO_COMP_MASSA ==2").copy()
    contribuicao_erro_militar['contribuicao'] = ((contribuicao_erro_militar['VL_APOSENTADORIA'])- sal_min ) * aliquota_militares
    contribuicao_erro_militar['contribuicao'] = round(contribuicao_erro_militar['contribuicao'], 2)
    contribuicao_erro_militar.query('abs(contribuicao - VL_CONTRIBUICAO) > 0.02')
    contribuicao_erro= pd.concat([contribuicao_erro_militar, contribuicao_erro_civil])
    teste= contribuicao_erro.query("contribuicao != VL_CONTRIBUICAO").reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = var1+" & "+var2
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Variavel valor de contribuição maior que o valor da aposentadoria."
    return teste


def inat_relational11(inativo):
    """ DATA_DE_INGRESSO_NO_ENTE deve ser inferior a Data limite para IN_PARID_SERV que é: 31/12/2003

    Parameters
    ----------
    inativo : DataFrame
        DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente.
    """
    df= inativo.copy()
    
    var1 = 'DATA_DE_INGRESSO_NO_ENTE'
    var2 = 'IN_PARID_SERV'
    
    df = sys_check_rm(df, [var1, var2], 2)
    
    df = df.query("IN_PARID_SERV ==1").copy()
    df['data_limite'] = datetime.date(2003,12,31)
    df['DATA_DE_INGRESSO_NO_ENTE'] = np.datetime_as_string(df['DATA_DE_INGRESSO_NO_ENTE'], unit='D')
    df['ING_ENTE'] = df['DATA_DE_INGRESSO_NO_ENTE'].apply(lambda x: datetime.datetime.strptime(x, '%Y-%m-%d')) 
    teste=df.query("ING_ENTE> data_limite").reset_index(drop=True)
    s = teste[var1]
    s2 = teste[var2]
    var=[]
    for i in range(len(s)):
        var.append( '%s,%s'%(s.iloc[i],s2.iloc[i]))
    teste = teste[["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA"]]
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = var1+" & "+var2
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Data de entrada no ente não dá direito a paridade, e o aposentado possui paridade"
    return teste




# TOTAL_AVERBACAO
def inat_relational12(inativo):
    """
    TOTAL_AVERBACAO deve estar entre 0 e 14.610 dias averbados.
    Teste verifica a conformidade do intervalo da soma das averbações
    
    Parameters
    ----------
    inativo : DataFrame
    DataFrame da base dos inativos.

    Returns
    -------
    teste : DataFrame
        Saída com cada observação inconsistente.
    """
    df = inativo.copy()
    
    var = "TOTAL_AVERBACAO"
    var1 = "NU_TEMPO_RPPS_MUN"
    var2 = "NU_TEMPO_RPPS_EST"
    var3 = "NU_TEMPO_RPPS_FED"
    
    df = sys_check_rm(df, [var1, var2, var3], 2)

    ### Criando variável que representa a soma das averbações
    averb_list = ["NU_TEMPO_RPPS_MUN", "NU_TEMPO_RPPS_EST", "NU_TEMPO_RPPS_FED"]
    df[var] = df[averb_list].sum(axis = 1)

    teste = df.loc[~(df[var].between(0,averb)),["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var,var1,var2,var3]].reset_index(drop=True)
  
    s = teste[var1]
    s2 = teste[var2]
    s3 = teste[var3]
    var=[]
    for i in range(len(s)):
        var.append('%s,%s,%s'%(s.iloc[i],s2.iloc[i],s3.iloc[i]))
        
    teste = teste.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
    teste["VARIÁVEL"] = var1+" & "+var2 + "&"+ var3
    teste["VALOR"]= var
    teste["BASE"] = "Inativos"
    teste["TESTE"] = "Relational"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"]= "Mais de 14.610 dias averbados"
    return teste
