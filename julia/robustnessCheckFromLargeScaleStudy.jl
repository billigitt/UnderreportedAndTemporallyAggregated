# This file is used to generate synthetic Ebola-like outbreaks with a 'stuttering-start'. The files produced are .csv files with 'Ebola' and 'Stutter' in them. The seed also demonstrates the seed chosen for the random number generation.

# Set path to directory this file resides in
cd(dirname(@__FILE__))

# Load the environment and install any required packages
Pkg.activate("../")
Pkg.instantiate()

# Specify packages needed for this script
using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

# Simulate Ebola epidemic. First phase (R=10) is highly transmissible, then quite (R=1.5), then low (R=0.75).
# This is to give a realistic epidemic curve. We assume that the epidemic is reported with a probability of rho.

include("juliaUnderRepFunctions.jl")

Random.seed!(1)

inferenceBatch1 = CSV.read("../CSVs/noLimitNewMethodPrior1And3.csv", DataFrame)
ii = 40
reportedWeeklyI = inferenceBatch1.reportedWeeklyI[(1+11*(9*13+4)):(11+11*(9*13+4))]
weeklyI = inferenceBatch1.weeklyI[(1+11*(9*13+4)):(11+11*(9*13+4))]

T = length(reportedWeeklyI)

trueP = 7
defaultP = 7
#the following parameters must be for a weekly parameterisation of the serial interval. The choice of defaultP then corrects this.
wContGamPar = [15.3^2/9.3^2, 9.3^2/(15.3*7)] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
nWeeksForSI = 10
divisionsPerP = Int(1e2)

wTrue = siCalcNew(wContGamPar, trueP, nWeeksForSI, divisionsPerP)
wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
PoissonOrRound = "P" # P/R
probReported = 0.4 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this 0.4 value is also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)

defaultM = 1000
priorRShapeAndScale = [1 3]
maxIter = defaultM*10

criCheck = true

println("Starting inference...")

numInf = 30

df1a = DataFrame(
        week = repeat(1:T, outer = numInf),
        meanRt = fill(NaN, T*numInf),
        lowerRt = fill(NaN, T*numInf),
        upperRt = fill(NaN, T*numInf),
        totalIterations = fill(NaN, T*numInf),
        runTime = fill(NaN, T*numInf),
        reportedWeeklyI = fill(NaN, T*numInf),
        weeklyI = fill(NaN, T*numInf)
)

for i in 1:numInf

        println(i)

        x = inferUnderRepAndTempAggR(reportedWeeklyI, wAssumed, priorRShapeAndScale, probReported, defaultM, defaultP, maxIter, Inf)

        df1a.meanRt[(i-1)*T+1:i*T] = vec(x["means"])
        df1a.lowerRt[(i-1)*T+1:i*T] = x["cri"][:, 1]
        df1a.upperRt[(i-1)*T+1:i*T] = x["cri"][:, 2]
        df1a.totalIterations[(i-1)*T+1:i*T] = x["totalIterations"]
        df1a.runTime[(i-1)*T+1:i*T] = x["runTime"]
        df1a.reportedWeeklyI[(i-1)*T+1:i*T] = reportedWeeklyI
        df1a.weeklyI[(i-1)*T+1:i*T] = weeklyI

end


CSV.write("../CSVs/robustnessCheckFromLargeScaleStudyM1e3.csv", df1a)

defaultM = 10000
maxIter = defaultM*10

df1b = DataFrame(
        week = repeat(1:T, outer = numInf),
        meanRt = fill(NaN, T*numInf),
        lowerRt = fill(NaN, T*numInf),
        upperRt = fill(NaN, T*numInf),
        totalIterations = fill(NaN, T*numInf),
        runTime = fill(NaN, T*numInf),
        reportedWeeklyI = fill(NaN, T*numInf),
        weeklyI = fill(NaN, T*numInf)
)

for i in 1:numInf

        println(i)

        y = inferUnderRepAndTempAggR(reportedWeeklyI, wAssumed, priorRShapeAndScale, probReported, defaultM, defaultP, maxIter, Inf)

        df1b.meanRt[(i-1)*T+1:i*T] = vec(y["means"])
        df1b.lowerRt[(i-1)*T+1:i*T] = y["cri"][:, 1]
        df1b.upperRt[(i-1)*T+1:i*T] = y["cri"][:, 2]
        df1b.totalIterations[(i-1)*T+1:i*T] = y["totalIterations"]
        df1b.runTime[(i-1)*T+1:i*T] = y["runTime"]
        df1b.reportedWeeklyI[(i-1)*T+1:i*T] = reportedWeeklyI
        df1b.weeklyI[(i-1)*T+1:i*T] = weeklyI

end


CSV.write("../CSVs/robustnessCheckFromLargeScaleStudyM1e4.csv", df1b)

defaultM = Int(1e5)
maxIter = defaultM

df1c = DataFrame(
        week = repeat(1:T, outer = numInf),
        meanRt = fill(NaN, T*numInf),
        lowerRt = fill(NaN, T*numInf),
        upperRt = fill(NaN, T*numInf),
        totalIterations = fill(NaN, T*numInf),
        runTime = fill(NaN, T*numInf),
        reportedWeeklyI = fill(NaN, T*numInf),
        weeklyI = fill(NaN, T*numInf)
)

for i in 1:numInf

        println(i)

        z = inferUnderRepAndTempAggR(reportedWeeklyI, wAssumed, priorRShapeAndScale, probReported, defaultM, defaultP, maxIter, Inf)

        df1c.meanRt[(i-1)*T+1:i*T] = vec(z["means"])
        df1c.lowerRt[(i-1)*T+1:i*T] = z["cri"][:, 1]
        df1c.upperRt[(i-1)*T+1:i*T] = z["cri"][:, 2]
        df1c.totalIterations[(i-1)*T+1:i*T] = z["totalIterations"]
        df1c.runTime[(i-1)*T+1:i*T] = z["runTime"]
        df1c.reportedWeeklyI[(i-1)*T+1:i*T] = reportedWeeklyI
        df1c.weeklyI[(i-1)*T+1:i*T] = weeklyI

end


CSV.write("../CSVs/robustnessCheckFromLargeScaleStudyM1e5.csv", df1c)
