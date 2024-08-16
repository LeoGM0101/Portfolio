range(FHER3.SA)

breaks = seq(18.81, 31.18, by = 0.9)
breaks

FHER3.SA.cut = cut(FHER3.SA, breaks, right=FALSE)
FHER3.SA.table = table(FHER3.SA.cut); FHER3.SA.table

hist(FHER3.SA)
plot_ly(s, type = "histogram")

f = within(f, z = g); f

f = FHER3.SA$FHER3.SA.Adjusted
g = data.frame(SLCE3.SA$SLCE3.SA.Adjusted)
s = data.frame(f); s



dados %>% 
  ggplot(aes(x = FHER3.SA)) +
  geom_histogram(aes(y = ..frequency..), fill = "blue", alpha = .7) +
  geom_density(size = 1.5, alpha = .9, color = "red") +
  theme_minimal() +
  labs(title = "                                            Histograma",
       x = "Preço de fechamento ajustado",
       y = "")


qplot(dados$FHER3.SA,
      geom="histogram",
      binwidth = 5,  
      main = "                         Histograma - Fertilizantes Heringer S.A.", 
      xlab = "Preço de fechamento",  
      fill=I("blue"), 
      col=I("red"), 
      alpha=I(.2),
      xlim=c(0,50))

qplot(dados$FHER3.SA, dados$SLCE3.SA,
      geom="auto",
      binwidth = 5,  
      main = "                                       Gráfico de dispersão", 
      xlab = "FHER3.SA", 
      ylab = "SLCE3.SA",
      col=I("red"), 
      alpha=I(.5),
      xlim=c(0,50))
