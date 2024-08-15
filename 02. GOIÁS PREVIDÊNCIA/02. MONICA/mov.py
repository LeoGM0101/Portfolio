# -*- coding: utf-8 -*-
"""
Este script executa o teste de movimetação entre duas bases, ou seja, ele nos mostra quem se manteve na base, quem saiu da base e quem entrou na base.
Teste de movimentação para ativos e aposentados.
"""

import pandas as pd
import openpyxl as pyxl


### Funções  

def mov(df1, df2, d_type):
    """
    A função compara duas bases e retorna a quantidade de vínculos exclusivos de cada uma, 
    ou seja, os vínculos que estão na base mais antiga e saíram da mais recente e
    os vínculos que entraram na base mais nova.

    Parameters
    ----------
    df1 : DataFrame
        DataFrame mais recente

    df2 : DataFrame
        DataFrame mais antigo
        
    d_type : Integer
        Código associado a base verificada
        1 - Ativos
        2 - Inativos
        3 - Pensionistas
        4 - Dependentes
        
    Returns
    -------
    entries : DataFrame
        Entradas ocorridas na base selecionada

    departures : DataFrame
        Saídas ocorridas na base selecionada
    """

    df1 = df1.copy()
    df2 = df2.copy()
    
    if d_type == 1:
        df = pd.merge(df1, df2, how='outer', on=['ID_SERVIDOR_CPF', 'ID_SERVIDOR_MATRICULA'], indicator=True)
    elif d_type == 2:
        df = pd.merge(df1, df2, how='outer', on=['ID_APOSENTADO_CPF', 'ID_APOSENTADO_MATRICULA'], indicator=True)

    entries = df[df['_merge'] == 'left_only'].count()["_merge"]    
    departures = df[df['_merge'] == 'right_only'].count()["_merge"]
    
    return entries, departures

def write_mov(entries, departures, arq, plan, d_type):
    """
    A função compara duas bases de inativos e retorna a quantidade de vínculos exclusivos de cada uma, 
    ou seja, os vínculos que estão na base mais antiga e saíram da mais recente e
    os vínculos que entraram na base mais nova.

    Parameters
    ----------
    entries : DataFrame
        DataFrame com vínculos novos na base

    departures : DataFrame
        DataFrame com vínculos que saíram da base
        
    arq : String 
        Pathfile para salvar as modificações
    
    plan : String
        Aba da planilha para salvar as modificações

    d_type : Integer
        Código associado a base verificada
        1 - Ativos
        2 - Inativos
        3 - Pensionistas
        4 - Dependentes
        
    Returns
    -------
    Registro das informações na planilha
    """
    
    wb = pyxl.load_workbook(arq, data_only=True)
    wsErros = wb[plan]

    if d_type == 1:
        wsErros["E5"].value = entries
        wsErros["F5"].value = departures
    elif d_type == 2:
        wsErros["E6"].value = entries
        wsErros["F6"].value = departures        
    
    return wb.save(arq)

