# -*- coding: utf-8 -*-

import pandas as pd

def calcular_fatores_crescimento_suavizados(dados_historicos, janela=5):
    # Suavizar os dados históricos com uma média móvel
    dados_suavizados = [sum(dados_historicos[i:i+janela]) / janela for i in range(len(dados_historicos) - janela + 1)]
    
    # Calcular as variações percentuais mensais
    variacoes_percentuais = [dados_suavizados[i] / dados_suavizados[i-1] - 1 for i in range(1, len(dados_suavizados))]
    
    # Calcular o fator médio de crescimento mensal suavizado
    fator_medio = sum(variacoes_percentuais) / len(variacoes_percentuais)
    
    # Ajustar os fatores de crescimento para que não aumentem tão rapidamente
    fatores_crescimento_suavizados = [(1 + fator_medio) ** i for i in range(1, 13)]  # Janeiro a Dezembro
    
    return fatores_crescimento_suavizados[:12]

def carregar_dados_excel(caminho_arquivo, nome_coluna):
    # Carregar dados do Excel usando o pandas
    dados_excel = pd.read_excel(caminho_arquivo)
    
    # Extrair os dados da coluna especificada
    dados_coluna = dados_excel[nome_coluna].tolist()
    
    return dados_coluna

def mensalizar_valor_anual(valor_anual, fatores_crescimento_suavizados, dados_historicos):
    # Atribuir o valor de janeiro
    valores_mensais = [210387653.96]  # Janeiro
    
    # Calcular o valor mensal para cada mês usando os fatores de crescimento, começando de fevereiro
    for fator in fatores_crescimento_suavizados:
        valores_mensais.append(valores_mensais[-1] * fator)
    
    # Ajustar os valores mensais de fevereiro a dezembro para garantir que a soma total seja igual ao valor anual
    soma_anual_restante = valor_anual - valores_mensais[0]
    soma_mensal_restante = sum(valores_mensais[1:])
    fator_correcao = soma_anual_restante / soma_mensal_restante
    valores_mensais[1:] = [valor * fator_correcao for valor in valores_mensais[1:]]
    
    return valores_mensais

# Caminho do arquivo Excel e nome da coluna
caminho_arquivo = "Z:/GERENCIA/ESTUDOS/2024/04. ÍNDICES DE MENSALIZAÇÃO/02. CÁLCULO/RECEITA/RPPS-FIN/RECEITA_realizada.xlsx"
nome_coluna = "receita"

# Carregar os dados históricos do Excel
dados_historicos = carregar_dados_excel(caminho_arquivo, nome_coluna)

# Calcular os fatores de crescimento suavizados
fatores_crescimento_suavizados = calcular_fatores_crescimento_suavizados(dados_historicos)

# Total anual fornecido
total_anual = 2472927751.25  # substituir pelo valor anual desejado

# Aplicar os fatores de crescimento para mensalizar o valor anual
valores_mensais = mensalizar_valor_anual(total_anual, fatores_crescimento_suavizados, dados_historicos)

# Exibir os valores mensais
meses = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro']
for mes, valor in zip(meses, valores_mensais):
    print(f"{mes}: R$ {valor:.2f}")
