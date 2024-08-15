# -*- coding: utf-8 -*-

"""
Este script executa o teste range para variáveis selecionadas da base dos ativos.
Consultar o arquivo "Regras do negócio.xlsx" para maiores detalhes sobre os testes.
As funções definidas na etapa anterior à plotagem no PDF consiste em 7 colunas, que são:
    1) CPF: CPF do servidor;
    2) VARIÁVEL: Variável que está sendo trabalhada;
    3) VALOR: Valor inconsistente da variável;
    4) BASE: Base que está sendo analisada (ativo, inativo e pensionista);
    5) TESTE: Teste que está sendo executado (range, relational ou trend);
    6) TAG: Tipo de inconsistência da variável (aviso ou erro);
    7) MENSAGEM: Mensagem de erro.
"""

# External libraries
import numpy as np

# Custom libraries
from config import averb, sal_min, sal_max, idade_min, idade_max
from config import d_cols_at
from syscheck import sys_check_rm
from stdlib import calculate_age


# Criando uma lista com o nome das variáveis que vão ser testadas
list_var = list(d_cols_at.keys())

### Lista com nome dos testes
atv_range = ["atv_range01",
             "atv_range02",
             "atv_range03",
             "atv_range04",
             "atv_range05",
             "atv_range06",
             "atv_range07",
             "atv_range08",
             "atv_range09",
             "atv_range10",
             "atv_range11",
             "atv_range12",
             "atv_range13",
             "atv_range14",
             "atv_range15",
             "atv_range16",
             "atv_range17",
             "atv_range18",
             "atv_range19",
             "atv_range20"]
           
def atv_range01(ativo):
    """
    CO_COMP_MASSA  a codificaçao deve ser igual a 1 ou 2.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "CO_COMP_MASSA"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (civil) ou 2 (militar)"
    return teste

def atv_range02(ativo):
    """
    CO_TIPO_FUNDO  a codificaçao deve ser igual a 1, 2 ou 3.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()    
    var = "CO_TIPO_FUNDO"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2,3]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (Fundo em capitalização),2 (Fundo em repartição) ou 3 (Mantidos pelo tesouro)."
    return teste

def atv_range03(ativo):
    """
    CO_PODER a codificaçao deve ser igual a 1, 2, 3, 4, 5 ou 6.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "CO_PODER"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2,3,4,5,6]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1, 2, 3, 4, 5 ou 6."
    return teste

def atv_range04(ativo):
    """
    CO_TIPO_PODER deve ter codificaçao igual a 1 (Administração Direta) ou 2 (Administração Indireta). 
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "CO_TIPO_PODER"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (administração direta) ou 2 (administração indireta)."
    return teste

def atv_range05(ativo):
    """
    CO_TIPO_POPULAÇAO de ter codificaçao igual a 1 (ativos), 2 (ativos iminentes), 3 (outros ativos) ou 8 (militares).
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()    
    var = "CO_TIPO_POPULACAO"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2,3,8]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1, 2, 3 ou 8"
    return teste

def atv_range06(ativo):
    """
    CO_TIPO_CARGO deve ter codificaçao igual a 1, 2, 3, 4, 5, 6, 7 ou 8.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "CO_TIPO_CARGO"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2,3,4,5,6,7,8]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1, 2, 3, 4, 5, 6, 7 ou 8."
    return teste

def atv_range07(ativo):
    """
    CO_CRITERIO_ELEGIBILIDADE deve ter codificaçao igual a 1, 2, 3, 4, 5 ou 8.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "CO_CRITERIO_ELEGIBILIDADE"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2,3,4,5,8]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1, 2, 3, 4, 5 ou 8."
    return teste

def atv_range08(ativo):
    """
    CO_SEXO_SERVIDOR a codificaçao deve ser igual a 1 ou 2.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "CO_SEXO_SERVIDOR"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (feminino) ou 2 (masculino)"
    return teste

def atv_range09(ativo):
    """
    CO_EST_CIVIL_SERVIDOR deve ter codificaçao igual a 1, 2, 3, 4, 5, 6 ou 9.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "CO_EST_CIVIL_SERVIDOR"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2,3,4,5,6,9]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1, 2, 3, 4, 5, 6 ou 9."
    return teste

def atv_range10(ativo):
    """
    IDADE deve estar dentro do intervalo de 18 anos e 75 anos.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado.
        É considerado um erro se o servidore tiver mais de 75 anos e menos de 18 anos, ou um aviso quando for igual a 18 ou 75 anos.
    """
    df = ativo.copy()
    var = "IDADE"
    var1 = "DT_NASC_SERVIDOR"
    df = sys_check_rm(df, [var1], 1)
    df['DT_NASC_SERVIDOR'] = np.datetime_as_string(df['DT_NASC_SERVIDOR'], unit='D')                                   
    df[var] = df['DT_NASC_SERVIDOR'].apply(calculate_age)
    teste = df.loc[~(df[var].between(idade_min,idade_max, inclusive="neither")),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste.loc[teste["VALOR"] >= idade_max, "TAG"] = "Erro"
    teste.loc[teste["VALOR"] <= idade_min, "TAG"] = "Erro"
    teste.loc[teste["VALOR"] == idade_max, "TAG"] = "Aviso"
    teste.loc[teste["VALOR"] == idade_min, "TAG"] = "Aviso"
    teste.loc[teste["VALOR"] > idade_max, "MENSAGEM"] = "Idade superior a 75 anos."
    teste.loc[teste["VALOR"] < idade_min, "MENSAGEM"] = "Idade menor a 18 anos."
    teste.loc[teste["VALOR"] == idade_max, "MENSAGEM"] = "Idade igual a 75 anos."
    teste.loc[teste["VALOR"] == idade_min, "MENSAGEM"] = "Idade igual a 18 anos."
    return teste

def atv_range11(ativo):
    """
    CO_SITUACAO_FUNCIONAL deve ter codificaçao igual a 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ou 11.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "CO_SITUACAO_FUNCIONAL"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2,3,4,5,6,7,8,9,10,11]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de  1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ou 11."
    return teste

def atv_range12(ativo):
    """
    CO_TIPO_VINCULO deve ter codificaçao igual a 1, 2, 3 ou 4.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "CO_TIPO_VINCULO"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2,3,4]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1, 2, 3 ou 4."
    return teste

def atv_range13(ativo):
    """
    CO_TIPO_VINCULO deve ter codificaçao igual a 1.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um aviso.
    """
    df = ativo.copy()
    var = "CO_TIPO_VINCULO"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Aviso"
    teste["MENSAGEM"] = "Valor diferente de 1 (servidor efetivo)."
    return teste

def atv_range14(ativo):
    """
    VL_REMUNERACAO deve estar acima do salario minimo e abaixo do teto funcional.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um aviso.
    """
    df = ativo.copy()
    var = "VL_REMUNERACAO"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~(df[var].between(sal_min,sal_max)),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Aviso"
    teste.loc[teste["VALOR"] > sal_max, "MENSAGEM"] = "Remuneração acima do teto do funcionalismo público."
    teste.loc[teste["VALOR"] < sal_min, "MENSAGEM"] = "Remuneração abaixo do salário mínimo."
    return teste

def atv_range15(ativo):
    """
    IN_ABONO_PERMANENCIA deve ser igual a 1 ou 2.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "IN_ABONO_PERMANENCIA"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (sim) ou 2 (não)"
    return teste

def atv_range16(ativo):
    """
    IN_PREV_COMP deve ser igual a 1 ou 2.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "IN_PREV_COMP"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~df[var].isin([1,2]),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Valor diferente de 1 (sim) ou 2 (não)"
    return teste

def atv_range17(ativo):
    """ 
    NU_TEMPO_RGPS, o tempo de averbação deve somar no máximo 14.610 dias.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "NU_TEMPO_RGPS"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~(df[var].between(0,averb)),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mais de 14.610 dias averbados"
    return teste

def atv_range18(ativo):
    """
    NU_TEMPO_RPPS_MUN, o tempo de averbação deve ser no máximo 14.610 dias.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "NU_TEMPO_RPPS_MUN"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~(df[var].between(0,averb)),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mais de 14.610 dias averbados"
    return teste

def atv_range19(ativo):
    """
    NU_TEMPO_RPPS_EST, tempo de averbação deve ser no máximo 14.610 dias.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "NU_TEMPO_RPPS_EST"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~(df[var].between(0,averb)),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})   
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mais de 14.610 dias averbados"
    return teste

def atv_range20(ativo):
    """
    NU_TEMPO_RPPS_FED, tempo de averbação deve ser no máximo 14.610 dias.
    Parameters
    ----------
    ativo : DataFrame
        DataFrame da base dos ativos.

    Returns
    -------
    teste : DataFrame
        Saída com as observações fora do intervalo estipulado. Essa situação é considerada um erro.
    """
    df = ativo.copy()
    var = "NU_TEMPO_RPPS_FED"
    df = sys_check_rm(df, [var], 1)
    teste = df.loc[~(df[var].between(0,averb)),["ID_SERVIDOR_CPF","ID_SERVIDOR_MATRICULA",var]].reset_index(drop=True)
    teste = teste.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
    teste = teste.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
    teste = teste.rename(columns={var : "VALOR"})    
    teste["VARIÁVEL"] = var
    teste["BASE"] = "Ativos"    
    teste["TESTE"] = "Range"
    teste["TAG"] = "Erro"
    teste["MENSAGEM"] = "Mais de 14.610 dias averbados"
    return teste


