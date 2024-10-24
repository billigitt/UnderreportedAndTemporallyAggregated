# This file is used to generate synthetuc Ebola-like outbreaks with a 'stuttering-start'. The files produced are .csv files with 'Ebola' and 'Stutter' in them. The seed also demonstrates the seed chosen for the random number generation.

using Debugger, JuliaInterpreter, Trapz, ProfileView, CSV, DataFrames, Tables

# Simulate Ebola epidemic. First phase (R=10) is highly transmissible, then quite (R=1.5), then low (R=0.75).
# This is to give a realistic epidemic curve. We assume that the epidemic is reported with a probability of rho.

include("juliaUnderRepFunctions.jl")

Random.seed!(6)


trueP = 7
defaultP = 7
#the following parameters must be for a weekly parameterisation of the serial interval. The choice of defaultP then corrects this.
wContGamPar = [2.71, 5.65/7] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
nWeeksForSI = 10
divisionsPerP = Int(1e2)

wTrue = siCalcNew(wContGamPar, trueP, nWeeksForSI, divisionsPerP)
wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
PoissonOrRound = "P" # P/R
probReported = 0.4 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this 0.4 value is also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
week1I = 1

trueWeeklyRInitial = 1.5
trueWeeklyRFinal = fill(0.75, 5)

thresholdIncidence = Int(1e3) #change to 1e3 for original
thresholdWeeks = Int(75) # change to 75 for original

incidenceOutput = generateStutteringIncidence(week1I, trueWeeklyRInitial, trueWeeklyRFinal, wTrue, PoissonOrRound, probReported, trueP, thresholdIncidence, thresholdWeeks)
T = length(incidenceOutput["weeklyI"])
weeklyI = get(incidenceOutput, "weeklyI", 0)
reportedWeeklyI = get(incidenceOutput, "reportedWeeklyI", 0)
println(wTrue)
println(wAssumed)
println(weeklyI)

defaultM = 1000
priorRShapeAndScale = [1 5]
maxIter = defaultM*10

criCheck = true

println("Starting inference...")

numInf = 30

df = DataFrame(dailyI = incidenceOutput["dailyI"])
CSV.write("trueDailyIEbolaStutterSeed6.csv", df)

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

        x = inferUnderRepAndTempAggR(reportedWeeklyI, wAssumed, priorRShapeAndScale, probReported, defaultM, defaultP, maxIter, criCheck)

        df1a.meanRt[(i-1)*T+1:i*T] = vec(x["means"])
        df1a.lowerRt[(i-1)*T+1:i*T] = x["cri"][:, 1]
        df1a.upperRt[(i-1)*T+1:i*T] = x["cri"][:, 2]
        df1a.totalIterations[(i-1)*T+1:i*T] = x["totalIterations"]
        df1a.runTime[(i-1)*T+1:i*T] = x["runTime"]
        df1a.reportedWeeklyI[(i-1)*T+1:i*T] = reportedWeeklyI
        df1a.weeklyI[(i-1)*T+1:i*T] = weeklyI

end


CSV.write("weightedM1e3StutterEbolaSimSeed6.csv", df1a)

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

        y = inferUnderRepAndTempAggR(reportedWeeklyI, wAssumed, priorRShapeAndScale, probReported, defaultM, defaultP, maxIter, criCheck)

        df1b.meanRt[(i-1)*T+1:i*T] = vec(y["means"])
        df1b.lowerRt[(i-1)*T+1:i*T] = y["cri"][:, 1]
        df1b.upperRt[(i-1)*T+1:i*T] = y["cri"][:, 2]
        df1b.totalIterations[(i-1)*T+1:i*T] = y["totalIterations"]
        df1b.runTime[(i-1)*T+1:i*T] = y["runTime"]
        df1b.reportedWeeklyI[(i-1)*T+1:i*T] = reportedWeeklyI
        df1b.weeklyI[(i-1)*T+1:i*T] = weeklyI

end


CSV.write("weightedM1e4StutterEbolaSimSeed6.csv", df1b)

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

        z = inferUnderRepAndTempAggR(reportedWeeklyI, wAssumed, priorRShapeAndScale, probReported, defaultM, defaultP, maxIter, criCheck)

        df1c.meanRt[(i-1)*T+1:i*T] = vec(z["means"])
        df1c.lowerRt[(i-1)*T+1:i*T] = z["cri"][:, 1]
        df1c.upperRt[(i-1)*T+1:i*T] = z["cri"][:, 2]
        df1c.totalIterations[(i-1)*T+1:i*T] = z["totalIterations"]
        df1c.runTime[(i-1)*T+1:i*T] = z["runTime"]
        df1c.reportedWeeklyI[(i-1)*T+1:i*T] = reportedWeeklyI
        df1c.weeklyI[(i-1)*T+1:i*T] = weeklyI

end


CSV.write("weightedM1e5StutterEbolaSimSeed6.csv", df1c)
