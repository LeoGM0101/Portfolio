# -*- coding: utf-8 -*-
"""
Este script compila as funções que transportam os objetos criados pelos códi-
gos em outro arquivo diferentes, podendo ser um .xlsx, .csv ou .pdf.
"""
from config import data, data_old, report_template_path
import openpyxl as pyxl

# import win32com.client

def copy_template(path_template, new_file_name):
    wb = pyxl.load_workbook(path_template, data_only=True)
    wb.save(new_file_name)

def relatorio_erros(arq, plan, DataFrame):
    """
    Parameters
    ----------
    arq : string
        Arquivo .xlsx onde o DataFrame será escrito.
    plan : string
        Planilha do arquivo .xlsx em que o DataFrame será escrito.
    DataFrame : DataFrame
        DataFrame de erros.

    Returns
    -------
    Um arquivo com o nome arq preenchido com os DataFrames de erros.
    """
    
    copy_template(report_template_path, arq)
    wb = pyxl.load_workbook(arq, data_only=True)
    wsErros = wb[plan]

    for i in range(len(DataFrame["CPF"])):
        
        row = str(i + 11)
        wsErros["A" + row].value = DataFrame.CPF.values[i]
        wsErros["B" + row].value = DataFrame.MATRICULA.values[i]
        wsErros["C" + row].value = DataFrame.VALOR.values[i]
        wsErros["D" + row].value = DataFrame.VARIÁVEL.values[i]
        wsErros["E" + row].value = DataFrame.BASE.values[i]
        wsErros["F" + row].value = DataFrame.TESTE.values[i]
        wsErros["G" + row].value = DataFrame.TAG.values[i]
        wsErros["H" + row].value = DataFrame.MENSAGEM.values[i]
        
    wsErros["E3"].value = data
    wsErros["F3"].value = data_old
    
    return wb.save(arq)