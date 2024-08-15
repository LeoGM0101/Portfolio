

# External libraries
import time
import pandas as pd

# Starting time counter
start_time = time.time()

# Core scripts
from config import path_utd, path_old, ri_name
from syscheck import sys_check_db
from read import ler_ativo, ler_inativo
from output import relatorio_erros
from mov import mov, write_mov

# Rules scripts
from rules.at_range import *
from rules.at_relational import *
# from rules.at_trend import *
from rules.in_range import *
from rules.in_relational import *
# from rules.in_trend import *

print("Modulos importados --- %s seconds ---" % (time.time() - start_time))

# Importando as bases de dados
# utd means 'up to date', old suffix means itself
at_utd = ler_ativo(path_utd)
print("Lido ativos atuais --- %s seconds ---" % (time.time() - start_time))

# at_old = ler_ativo(path_old)
# print("Lido ativos anteriores --- %s seconds ---" % (time.time() - start_time))

in_utd = ler_inativo(path_utd)
print("Lido inativos atuais --- %s seconds ---" % (time.time() - start_time))

# in_old = ler_inativo(path_old)
# print("Lido inativos anteriores --- %s seconds ---" % (time.time() - start_time))

# Criando uma DataFrame do relatório dew inconsistências vazio
erros = pd.DataFrame(columns=["CPF",
                              "MATRICULA",
                              "VALOR",
                              "VARIÁVEL",
                              "BASE",
                              "TESTE",
                              "TAG",
                              "MENSAGEM"])

erros = erros.append(sys_check_db(at_utd, 1))
erros = erros.append(sys_check_db(in_utd, 2))

# Testes do at_range
for nome_funcao in atv_range:
    minha_funcao = locals()[nome_funcao]
    erros = erros.append(minha_funcao(at_utd))
print("Testes range realizado nos ativos --- %s seconds ---" % (time.time() - start_time))

# Testes do at_relational
for nome_funcao in atv_relational:
    minha_funcao = locals()[nome_funcao]
    erros = erros.append(minha_funcao(at_utd))
print("Testes relational realizado nos ativos --- %s seconds ---" % (time.time() - start_time))

# # Testes do at_trend
# for nome_funcao in atv_trend:
#     minha_funcao = locals()[nome_funcao]
#     erros = erros.append(minha_funcao(at_utd, at_old))
# print("Testes trend realizado nos ativos --- %s seconds ---" % (time.time() - start_time))

# Testes do in_range
for nome_funcao in inat_range:
    minha_funcao = locals()[nome_funcao]
    erros = erros.append(minha_funcao(in_utd))
print("Testes range realizado nos inativos --- %s seconds ---" % (time.time() - start_time))

# Testes do in_relational
for nome_funcao in inat_relational:
    minha_funcao = locals()[nome_funcao]
    erros = erros.append(minha_funcao(in_utd))
print("Testes relational realizado nos inativos --- %s seconds ---" % (time.time() - start_time))
    
# # Testes do in_trend 
# for nome_funcao in inatv_trend:
#     minha_funcao = locals()[nome_funcao]
#     erros = erros.append(minha_funcao(in_utd, in_old))
# print("Testes trend realizado nos inativos --- %s seconds ---" % (time.time() - start_time))

# Plotando o o DataFrame de erros em .xlsx
relatorio_erros(ri_name,"Relatório de Erros", erros)
print("Relatório de erros feito --- %s seconds ---" % (time.time() - start_time))

# # Plotando o a movimentação na planilha do DataFrame de erros em .xlsx
# x, y = mov(at_utd, at_old, 1)
# write_mov(x, y, ri_name,"Relatório de Erros", 1)

# x, y = mov(in_utd, in_old, 2)
# write_mov(x, y, ri_name,"Relatório de Erros", 2)

# del x, y

### Tempo que demora para rodar o código
print("Finalizado --- %s seconds ---" % (time.time() - start_time))

