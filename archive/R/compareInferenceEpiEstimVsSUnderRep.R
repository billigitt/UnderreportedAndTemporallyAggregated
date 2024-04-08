#In this document, we seek to compare EpiEstim (with Perfect Information), our method, and the true Rt.
library(ggplot2)
library(dplyr)
library(forcats)

library(viridis)

epiEstimInference <- read.csv("epiEstimTau7PerfectInfoStutterEbolaSimSeed1.csv")

simM1e3Inference <- read.csv("weightedM1e3StutterEbolaSimSeed1.csv")
simM1e4Inference <- read.csv("weightedM1e4StutterEbolaSimSeed1.csv")
simM1e5Inference <- read.csv("weightedM1e5StutterEbolaSimSeed1.csv")

T <- max(simM1e3Inference$week)
time <- rep(1:T, 2)

meanRt <- c(rep(NaN, 2), epiEstimInference$meanRt, simM1e3Inference$meanRt[1:T])
lower <- c(rep(NaN, 2), epiEstimInference$quantile0025, simM1e3Inference$lowerRt[1:T])
upper <- c(rep(NaN, 2), epiEstimInference$quantile0975, simM1e3Inference$upperRt[1:T])
model <- c(rep("EpiEstim Perfect Info", T), rep("Sim M=1000", T))

## plot single inference of EpiEstim Vs Simulation

df1 <- data.frame(time, model, meanRt, lower, upper)

ggplot(df1, aes(x = time, y = meanRt, color = model)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper, fill = model), alpha = 0.2, linewidth = 0) +
  geom_errorbar(aes(x=time, ymin=lower, ymax=upper, color= model), width=0.3)+
  labs(title = "Rt inference with Credible Intervals for different P (M=1000)", x = "Time", y = "Mean Value") +
  theme_minimal()

## plot distribution of means

M <- rep(c(1e3, 1e4, 1e5), each = 30*10)
time <- rep((1):10, 3*30)
meanRt <- c(head(simM1e3Inference$meanRt, 10), head(simM1e4Inference$meanRt, 10), head(simM1e5Inference$meanRt, 10))
lowerRt <- c(head(simM1e3Inference$lowerRt, 10), head(simM1e4Inference$lowerRt, 10), head(simM1e5Inference$lowerRt, 10))
upperRt <- c(head(simM1e3Inference$upperRt, 10), head(simM1e4Inference$upperRt, 10), head(simM1e5Inference$upperRt, 10))
df2 <- data.frame(time, M, meanRt, lowerRt, upperRt)
df2$M <- as.factor(df2$M)
df2$time <- as.factor(df2$time)

ggplot(df2, aes(x = time, y = meanRt, color = M)) +
  geom_violin(aes(x=time, y=meanRt, fill=M), width=1.0)+
  labs(title = "Investigating varaition between inferences with same epidemics.", x = "Time", y = "Mean Value") +
  theme_minimal()

ggplot(df2, aes(x = time, y = lowerRt, color = M)) +
  geom_violin()+
  labs(title = "Investigating varaition between inferences with same epidemics.", x = "Time", y = "Mean Value") +
  theme_minimal()
