# -*- coding: utf-8 -*-
"""
Created on Tue Nov  9 11:09:21 2021

Script designed to provide support functions to the rest of program.

@author: Yuri Santos
"""

# External libraries
import datetime

# Custom libraries
from config import dia, mes, ano

def calculate_age(born):
    """
    Função que calcula a idade da observação e inclui tal variável na base.
    Parameters
    ----------
    born : datetime64[ns]
        Born represents the day that the observation was born.

    Returns
    -------
    An integer
        Returns the age with the last day of a month as focal date.
    """
    born = datetime.datetime.strptime(born, "%Y-%m-%d").date()
    today = datetime.date(ano,mes,dia)
    return today.year - born.year - ((today.month, today.day) < (born.month, born.day))