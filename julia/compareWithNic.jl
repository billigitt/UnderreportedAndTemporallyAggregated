# This file is used to generate synthetuc Ebola-like outbreaks with a 'stuttering-start'. The files produced are .csv files with 'Ebola' and 'Stutter' in them. The seed also demonstrates the seed chosen for the random number generation.

using Debugger, JuliaInterpreter, Trapz, ProfileView, CSV, DataFrames, Tables

# Simulate Ebola epidemic. First phase (R=10) is highly transmissible, then quite (R=1.5), then low (R=0.75).
# This is to give a realistic epidemic curve. We assume that the epidemic is reported with a probability of rho.

include("juliaUnderRepFunctions.jl")

Random.seed!(6)


trueP = 1008
defaultP = 7

wContGamPar = [4, 1/10.8] 
nWeeksForSI = 10
divisionsPerP = Int(1e2)

wTrue = siCalcNew(wContGamPar, trueP, nWeeksForSI, divisionsPerP)
wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
PoissonOrRound = "P" # P/R
probReportedTrue = 0.01 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this 0.4 value is also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
week1I = 1
probReported = 0.33:0.1:0.83

trueWeeklyR = [fill(1.5, 6); fill(0.75, 5)]

incidenceOutput = generateIncidence(week1I, trueWeeklyR, wTrue, PoissonOrRound, probReportedTrue, trueP)
T = length(incidenceOutput["weeklyI"])
weeklyI = get(incidenceOutput, "weeklyI", 0)
reportedWeeklyI = get(incidenceOutput, "reportedWeeklyI", 0)
println(wTrue)
println(wAssumed)
println(weeklyI)

priorRShapeAndScale = [1 5]

criCheck = true

println("Starting inference...")

numInf = length(probReported)


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

        z = inferUnderRepAndTempAggR(reportedWeeklyI, wAssumed, priorRShapeAndScale, probReported[i], defaultM, defaultP, maxIter, criCheck)

        df1c.meanRt[(i-1)*T+1:i*T] = vec(z["means"])
        df1c.lowerRt[(i-1)*T+1:i*T] = z["cri"][:, 1]
        df1c.upperRt[(i-1)*T+1:i*T] = z["cri"][:, 2]
        df1c.totalIterations[(i-1)*T+1:i*T] = z["totalIterations"]
        df1c.runTime[(i-1)*T+1:i*T] = z["runTime"]
        df1c.reportedWeeklyI[(i-1)*T+1:i*T] = reportedWeeklyI
        df1c.weeklyI[(i-1)*T+1:i*T] = weeklyI

end


CSV.write("compareWithNic.csv", df1c)
