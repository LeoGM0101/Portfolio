"""
Este script executa análises adicionais que não estão inclusas em "Regras do negócios.xlsx".
A análise só está sendo feita para os ativos, com posterior inclusão da base dos inativos e pensionsitas.
Os testes são:
    1) Contador de NAs;
    2) Classificador de variáveis.
"""

### Pacotes externos
import pandas as pd
from config import d_cols_at, d_cols_in


def check_col_qtd(df, d_type):
    """
    O layout da SPREV presume que as colunas apresentadas na planilhas
    contemplem todas as coluna contidos em seu dicionário.
    
    O objetivo da função é apontar quais colunas estão ausentes.

    Parameters
    ----------
    df : DataFrame
    Base de dados, no layout da SPREV.

    d_type : Integer
        Código associado a base verificada
        1 - Ativos
        2 - Inativos
        3 - Pensionistas
        4 - Dependentes
        5 - Ativos falecidos
        6 - Aposentados falecidos
        7 - Pensionistas falecidos

    Returns
    -------
    test : Bool
    Confirmação de se quantidade de colunas está correta.
    """
    df = df.copy()
    
    if d_type == 1:
        test = df.shape[1] == len(d_cols_at)
    elif d_type == 2:
        test = df.shape[1] == len(d_cols_in)    
    
    return test


def check_col_order(df, code):
    """
    O layout da SPREV presume que as colunas apresentadas na planilhas estajam
    em uma ordem específica pré-determinada.
    
    Deve-se usar antes a função 'check_col_qtd_at', para ver se o
    input está adequado.
    
    O objetivo da função é apontar quais colunas estão fora de ordem.

    Parameters
    ----------
    df : DataFrame
    Base de dados, no layout da SPREV.
    
    code : Integer
        Código associado a base verificada
        1 - Ativos
        2 - Inativos
        3 - Pensionistas
        4 - Dependentes
        5 - Ativos falecidos
        6 - Aposentados falecidos
        7 - Pensionistas falecidos

    Returns
    -------
    my_df: DataFrame
    """
    df = df.copy()
    
    var_found_order = pd.Series(list(df.columns.values))
    
    if code == 1:
        var_expec_order = pd.Series(list(d_cols_at.keys()))
    elif code == 2:
        var_expec_order = pd.Series(list(d_cols_in.keys()))

    test_result = var_expec_order == var_found_order
    
    my_df = pd.concat([var_found_order, var_expec_order, test_result],
                      axis = 1)
    
    return(test_result.all())


def sys_check_rm(database, l_colnames, code):
    """
    Função para remover as colunas contendo elementos fora do formato
    
    O propósito é filtrar da base as linhas que não atendem os
    requisitos mínimos para uso nos testes de intervalo, relacionais e
    de tendência.
    
    Parameters
    ----------
    database : DataFrame
        DataFrame da base a ser utilizada.
    l_colnames : List
        Lista contendo os nomes das colunas a serem verificadas
    code : Integer
        Código associado a base verificada
        1 - Ativos
        2 - Inativos
        3 - Pensionistas
        4 - Dependentes
        5 - Ativos falecidos
        6 - Aposentados falecidos
        7 - Pensionistas falecidos
        11 - Ativos (trend)
        12 - Inativos (trend)

    Returns
    -------
    df : DataFrame
        Base filtra apenas com valores válidos para as colunas listadas na
        l_colnames
    """

    # #Function to unnest a list of lists
    # def flatten(t):
    #     return [item for sublist in t for item in sublist]
    
    if code == 1:
        ref = d_cols_at.copy()
    elif code == 2:
        ref = d_cols_in.copy()
    elif code == 11:
        ref = d_cols_at.copy()
     
        mykeys = list(ref.keys())
        keys_x = [sub + "_x" for sub in mykeys]
        keys_y = [sub + "_y" for sub in mykeys]
        
        for x, y, k in zip(keys_x, keys_y, mykeys):
            ref[x] = ref[k]
            ref[y] = ref[k]
        
    elif code == 12:
        ref = d_cols_in.copy()
     
        mykeys = list(ref.keys())
        keys_x = [sub + "_x" for sub in mykeys]
        keys_y = [sub + "_y" for sub in mykeys]
        
        for x, y, k in zip(keys_x, keys_y, mykeys):
            ref[x] = ref[k]
            ref[y] = ref[k]

    df = database.copy()
    n = len(df)
    f = []
    
    for colname in l_colnames:
        for nrow in range(n):
            if str(type(df.loc[nrow, colname])) != ref[colname]:
                f.append(nrow)
     
    #Unique values sorted
    idx_filter = sorted(list(set(f)))
    return df.drop(idx_filter).reset_index(drop=True)
    
def sys_check_db(database, d_type):
    """
    Função para remover as colunas contendo elementos fora do formato
    
    O propósito é filtrar da base as linhas que não atendem os
    requisitos mínimos para uso nos testes de intervalo, relacionais e
    de tendência.
    
    Parameters
    ----------
    database : DataFrame
        DataFrame da base a ser utilizada.
    l_colnames : List
        Lista contendo os nomes das colunas a serem verificadas
    code : Integer
        Código associado a base verificada
        1 - Ativos
        2 - Inativos
        3 - Pensionistas
        4 - Dependentes
        5 - Ativos falecidos
        6 - Aposentados falecidos
        7 - Pensionistas falecidos

    Returns
    -------
    df : DataFrame
        Base filtra apenas com valores válidos para as colunas listadas na
        l_colnames
    """

    # #Function to unnest a list of lists
    # def flatten(t):
    #     return [item for sublist in t for item in sublist]
    
    if d_type == 1:
        ref = d_cols_at.copy()
    elif d_type == 2:
        ref = d_cols_in.copy()
        
    df = database.copy()
    n = len(df)

    erros = pd.DataFrame(columns=["CPF",
                          "MATRICULA",
                          "VALOR",
                          "VARIÁVEL",
                          "BASE",
                          "TESTE",
                          "TAG",
                          "MENSAGEM"])    

    
    def report(df, d_type, my_idx, var):  
        
        df = df.copy()

        if d_type == 1:
            test = df.loc[df.index.isin(my_idx), ["ID_SERVIDOR_CPF", "ID_SERVIDOR_MATRICULA", var]].copy()
            test = test.rename(columns={"ID_SERVIDOR_CPF" : "CPF"})
            test = test.rename(columns={"ID_SERVIDOR_MATRICULA" : "MATRICULA"})
            test["BASE"] = "Ativos"
        elif d_type == 2:
            test = df.loc[df.index.isin(my_idx), ["ID_APOSENTADO_CPF","ID_APOSENTADO_MATRICULA",var]].copy()
            test = test.rename(columns={"ID_APOSENTADO_CPF" : "CPF"})
            test = test.rename(columns={"ID_APOSENTADO_MATRICULA" : "MATRICULA"})
            test["BASE"] = "Inativos"
        
        test = test.rename(columns={var : "VALOR"})
        test["VARIÁVEL"] = var
        test["TESTE"] = "Format check"
        test["TAG"] = "Erro"
        test["MENSAGEM"] = "Campo preenchido em formato inválido ou nulo"

        return test
    

    for colname in df.columns:
        f = []
        if colname not in ["ID_SERVIDOR_CPF",
                           "ID_SERVIDOR_MATRICULA",
                           "DT_INICIO_ABONO",
                           "ID_APOSENTADO_CPF",
                           "ID_APOSENTADO_MATRICULA"]:
            
            for nrow in range(n):
                if str(type(df.loc[nrow, colname])) != ref[colname]:
                    f.append(nrow)
                    
            r = report(df, d_type, f, colname)
            erros = erros.append(r)
    
    return erros.reset_index(drop=True)
    