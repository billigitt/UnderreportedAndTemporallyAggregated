library(EpiEstim)
library(ggplot2)

incidence <- read.csv("trueDailyIEbolaLongStutter.csv")
T <- length(incidence$dailyI)


t_start <- c(2, seq(from = 8, to = T-6, by = 7))
t_end <- c(7, seq(from = 14, to = T, by = 7))
res <- estimate_R(incidence$dailyI, 
                  method="parametric_si",
                  config = make_config(list(
                    t_start = t_start,
                    t_end = t_end,
                    mean_si = 15.3, 
                    std_si = 9.3))
)

t_start <- res$R$t_start
t_end <- res$R$t_end
meanRt <- res$R$`Mean(R)`
quantile0025 <- res$R$`Quantile.0.025(R)`
quantile005 <- res$R$`Quantile.0.05(R)`
quantile025 <- res$R$`Quantile.0.25(R)`
quantile075 <- res$R$`Quantile.0.75(R)`
quantile095 <- res$R$`Quantile.0.95(R)`
quantile0975 <- res$R$`Quantile.0.975(R)`

df <- data.frame(t_start, t_end, meanRt, quantile0025, quantile005, quantile025, quantile075, quantile095, quantile0975)
write.csv(df, "epiEstimTau7PerfectInfoLongStutterEbolaSimSeed2.csv")