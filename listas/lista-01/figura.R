dados <- read.csv("airquality.csv")

pdf("figura.pdf", width = 7, height = 5)
boxplot(
  Temp ~ Month,
  data = dados,
  xlab = "Mês",
  ylab = "Temperatura (°F)",
  main = "Distribuição da Temperatura por Mês (Nova York, 1973)",
  col = "lightblue",
  names = c("Maio", "Junho", "Julho", "Agosto", "Setembro")
)
dev.off()
