rm(list=ls())
library(RPostgres)

con = dbConnect(Postgres(), dbname = "trabalho de banco de dados",
                 host = "localhost", port = 5432,
                 user = "postgres", password = "leo123")

query = "SELECT Players, Assists, Ratings FROM jogadores ORDER BY Assists DESC LIMIT 10;"
df = dbGetQuery(con, query); df

dbDisconnect(con)
