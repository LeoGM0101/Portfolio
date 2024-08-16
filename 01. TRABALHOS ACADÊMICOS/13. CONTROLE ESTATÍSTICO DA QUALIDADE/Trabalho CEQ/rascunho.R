rm(list = ls())

water_potability <- read.csv("water_potability.csv")
n <- 0
samples <- list()




while (n < 30) {
  n <- n + 1
  sample <- sample_n(water_potability, 100)
  samples[[n]] <- sample
  
}


