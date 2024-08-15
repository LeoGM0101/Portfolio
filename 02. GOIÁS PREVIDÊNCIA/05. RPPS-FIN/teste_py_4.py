# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
from statsmodels.tsa.exponential_smoothing.ets import ETSModel

def calcular_fatores_crescimento_suavizados(dados_historicos, janela = 5):
    # Suavizar os dados históricos com uma média móvel
    dados_suavizados = [sum(dados_historicos[i:i+janela]) / janela for i in range(len(dados_historicos) - janela + 1)]
    
    # Calcular as variações percentuais mensais
    variacoes_percentuais = [dados_suavizados[i] / dados_suavizados[i-1] - 1 for i in range(1, len(dados_suavizados))]
    
    # Calcular o fator médio de crescimento mensal suavizado
    fator_medio = sum(variacoes_percentuais) / len(variacoes_percentuais)
    
    # Ajustar os fatores de crescimento para que não aumentem tão rapidamente
    calcular_fatores_crescimento_suavizados = [(1 + fator_medio) ** i for i in range(1, 13)]  # Janeiro a Dezembro
    
    return calcular_fatores_crescimento_suavizados[:12]

# Carregar dados do Excel
def carregar_dados_excel(caminho_arquivo, nome_coluna):
    # Carregar dados do Excel usando o pandas
    dados_excel = pd.read_excel(caminho_arquivo)
    
    # Extrair os dados da coluna especificada
    dados_coluna = dados_excel[nome_coluna].tolist()
    
    return dados_coluna

# Caminho do arquivo Excel e nome da planilha
caminho_arquivo = "Z:/GERENCIA/ESTUDOS/2024/04. ÍNDICES DE MENSALIZAÇÃO/02. CÁLCULO/RECEITA/RPPS-FIN/RECEITA_realizada.xlsx"
nome_coluna = "receita"  # Nome da coluna que contém os dados históricos

# Carregar os dados históricos do Excel
dados_historicos = carregar_dados_excel(caminho_arquivo, nome_coluna)

# Calcular os fatores de crescimento
fatores_crescimento_suavizados = calcular_fatores_crescimento_suavizados(dados_historicos)

# Exibir os fatores de crescimento para cada mês 
print("Fatores de crescimento suavizados:")
for mes, fator in enumerate(fatores_crescimento_suavizados, 1):
    print(f"Mês {mes}: {fator:.6f}")


#################### mensalização

#def calcular_valor_janeiro(total_anual, fatores_crescimento_suavizados, dados_historicos):
    # Calcular o valor de janeiro para que não seja menor que o último mês de outubro da série histórica
#    valor_outubro = dados_historicos[-3]
#    valor_janeiro = total_anual / min(fatores_crescimento_suavizados)
    
# Garantir que o valor de janeiro seja maior ou igual ao valor de outubro dos dados históricos
#    valor_janeiro = max(valor_janeiro, valor_outubro)
    
#    return valor_janeiro


def mensalizar_valor_anual(valor_anual, fatores_crescimento_suavizados, dados_historicos):
    # Calcular o valor mensal para cada mês usando os fatores de crescimento
    valores_mensais = [valor_anual * fator for fator in fatores_crescimento_suavizados]
    
    # Ajustar os valores mensais de acordo com as restrições
    for i in range(1, len(valores_mensais)):
        # Restrição: o mês de maio deve ser 4,5% maior que o de abril
        if i == 4:
            valores_mensais[i] = max(valores_mensais[i], valores_mensais[i-1] * 1.0462)
        # Restrição: o mês de dezembro deve ser 60% maior que o de novembro
        elif i == 11:
            valores_mensais[i] = max(valores_mensais[i], valores_mensais[i-1] * 1.6)
    
    # Ajustar o valor de janeiro para que não seja menor que o último mês de outubro da série histórica
#    valor_janeiro = calcular_valor_janeiro(valor_anual, fatores_crescimento_suavizados, dados_historicos)
#    valores_mensais[0] = valor_janeiro
    
    # Ajustar os valores mensais para garantir que a soma total seja igual ao valor anual
    soma_mensal = sum(valores_mensais)
    fator_correcao = valor_anual / soma_mensal
    valores_mensais = [valor * fator_correcao for valor in valores_mensais]
    
    return valores_mensais

# Total anual fornecido
total_anual = 2472927751.25  # substituir pelo valor anual desejado


# Aplicar os fatores de crescimento para mensalizar o valor anual
valores_mensais = mensalizar_valor_anual(total_anual, fatores_crescimento_suavizados, dados_historicos)


# Exibir os valores mensais
meses = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro']
for mes, valor in zip(meses, valores_mensais):
    print(f"{mes}: R$ {valor:.2f}")
