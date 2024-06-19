
try
    
    using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

catch

    import Pkg
    Pkg.add(["QuadGK", "Distributions", "StatsBase", "Random", "DataFrames", "CSV", "Dates", "Distributed", "SharedArrays", "ProgressMeter", "Trapz", "Debugger", "JuliaInterpreter", "Tables", "Plots"])

end

using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

Random.seed!(1)

# Simulate Ebola epidemic. First phase (R=10) is highly transmissible, then quite (R=1.5), then low (R=0.75).
# This is to give a realistic epidemic curve. We assume that the epidemic is reported with a probability of rho.

include("juliaUnderRepFunctions.jl")
T = 11

df = DataFrame(
    week = 1:T,
    meanRt = fill(NaN, T),
    lowerRt = fill(NaN, T),
    upperRt = fill(NaN, T),
    totalIterations = fill(NaN, T),
    runTime = fill(NaN, T),
    reportedWeeklyI = fill(NaN, T),
    weeklyI = fill(NaN, T),
    trueR = fill(NaN, T)
)

trueP = 7
defaultP = 7
#the following parameters must be for a weekly parameterisation of the serial interval. The choice of defaultP then corrects this.
wContGamPar = [15.3^2/9.3^2, 9.3^2/(15.3*7)] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
nWeeksForSI = 10
divisionsPerP = Int(1e2)

wTrue = siCalcNew(wContGamPar, trueP, nWeeksForSI, divisionsPerP)
wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
PoissonOrRound = "P" # P/R

priorRShapeAndScale = [1 5]

newM = Int(1e5)
newMaxIter = newM*10
criCheck = true

OGM = Int(1e3)
OGMaxIter = OGM*10
reportedWeeklyInc = [1 1 1 1 1 1 1 1 1 1 1]

dfNew = DataFrame(
    week = 1:T,
    meanRt = fill(NaN, T),
    lowerRt = fill(NaN, T),
    upperRt = fill(NaN, T),
    totalIterations = fill(NaN, T),
    runTime = fill(NaN, T)
)

dfOG = DataFrame(
    week = 1:T,
    meanRt = fill(NaN, T),
    lowerRt = fill(NaN, T),
    upperRt = fill(NaN, T),
    totalIterations = fill(NaN, T),
    runTime = fill(NaN, T)
)

x = inferUnderRepAndTempAggR(reportedWeeklyInc, wAssumed, priorRShapeAndScale, 0.5, newM, defaultP, newMaxIter, criCheck)
   
println("Finished new method")

y = inferTempAggOnlyR(reportedWeeklyInc, wAssumed, priorRShapeAndScale, OGM, defaultP, OGMaxIter)

dfNew[1:T, :meanRt] = vec(x["means"])
dfNew[1:T, :lowerRt] = x["cri"][:, 1]
dfNew[1:T, :upperRt] = x["cri"][:, 2]
dfNew[1:T, :totalIterations] = x["totalIterations"]
dfNew[1:T, :runTime] = x["runTime"]

dfOG[1:T, :meanRt] = vec(y["means"])
dfOG[1:T, :lowerRt] = y["cri"][:, 1]
dfOG[1:T, :upperRt] = y["cri"][:, 2]
dfOG[1:T, :totalIterations] = y["totalIterations"]
dfOG[1:T, :runTime] = y["runTime"]

CSV.write("studyOf1sIncNew.csv", dfNew)
CSV.write("studyOf1sIncOG.csv", dfOG)