library(dplyr)
library(readxl)

path <- "Z:\\GERENCIA\\RELATÓRIO DE HIPÓTESES\\2021\\MORTALIDADE\\Tabua_v01.xlsx"

hc <- read_xlsx(path, sheet = 1) #Homens civis
mc <- read_xlsx(path, sheet = 2) #Mulheres civis
hm <- read_xlsx(path, sheet = 3) #Homens militares

db <- list(hc, mc, hm)
titles <- c("Homens civis - IBGE 2019 Ambos os sexos",
            "Homens civis - IBGE 2019 Feminino",
            "Homens civis - IBGE 2019 Masculino",
            "Mulheres civis - IBGE 2019 Ambos os sexos",
            "Mulheres civis - IBGE 2019 Feminino",
            "Mulheres civis - IBGE 2019 Masculino",
            "Homens militares - IBGE 2019 Ambos os sexos",
            "Homens militares - IBGE 2019 Feminino",
            "Homens militares - IBGE 2019 Masculino")

j = 0
for(group in db)
  {
  for(i in 3:5) #Columns 3 to 5 are related to tables expected values
    {
    j = j + 1
    print(titles[j])
    ks.test(pull(group[2]), pull(group[i])) %>%
    print()
    }
  }
# Com um nível de confiança de 5%, pode-se adotara tábua IBGE 2019 separada por sexo.
# Apenas para o civis


j = 6
for(i in 3:5) #Columns 3 to 5 are related to tables expected values
  {
  j = j + 1
  print(titles[j])
  ks.test(pull(db[[3]][2]), pull(db[[3]][i]), alternative = "less") %>%
  print()
  }
# Com um nível de confiança de 5% é possível afirmar que mortalidade os militares
# é superior a mortalidade dos civis