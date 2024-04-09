library(EpiEstim)
library(ggplot2)

## EpiEstim Perfect Information

study1 <- read.csv("../../CSVs/largeScaleStudy.csv")
study2 <- read.csv("../../CSVs/largeScaleStudy2.csv")
study3 <- read.csv("../../CSVs/largeScaleStudy4.csv")
study4 <- read.csv("../../CSVs/largeScaleStudy5.csv")

study <- rbind(study1, study2, study3, study4)
reportedWeeklyIncidences <- study$reportedWeeklyI

meanRt <- rep(0, 9*6000)
quantile0025 <- rep(0, 9*6000)
quantile0975 <- rep(0, 9*6000)

#NB: The estimate_R function does not allow you to infer R_2, and so for T=11, we have 

t_start <- 2:11
t_end <- 2:11

for (i in 1:6000){
  
  res <- estimate_R(reportedWeeklyIncidences[(1+(i-1)*11):(i*11)], 
                    method="parametric_si",
                    config = make_config(list(
                      t_start = t_start,
                      t_end = t_end,
                      mean_si = 15.3/7, 
                      std_si = 9.3/7)))

  meanRt[(1+(i-1)*9):(i*9)] <- res$R$`Mean(R)`
  quantile0025[(1+(i-1)*9):(i*9)] <- res$R$`Quantile.0.025(R)`
  quantile0975[(1+(i-1)*9):(i*9)] <- res$R$`Quantile.0.975(R)`
    
}

df <- data.frame(t_start, t_end, meanRt, quantile0025, quantile0975)
write.csv(df, "epiEstimImperfectInfoLargeScaleStudy.csv")