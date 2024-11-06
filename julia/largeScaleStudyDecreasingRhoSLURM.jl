try
    
    using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

catch

    import Pkg
    Pkg.add(["QuadGK", "Distributions", "StatsBase", "Random", "DataFrames", "CSV", "Dates", "Distributed", "SharedArrays", "ProgressMeter", "Trapz", "Debugger", "JuliaInterpreter", "Tables", "Plots"])

end

using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

idx = parse(Int64, ENV["SLURM_ARRAY_TASK_ID"])

incidenceAndTrueR = CSV.read("../CSVs/largeScaleStudyIncidencesAndTrueRsNoLimitPrior1And3FirstDay1DecreasingRho.csv", DataFrame)
Random.seed!(1)

include("juliaUnderRepFunctions.jl")
T = 11

inferredTemporalRho = [0.9 0.9 0.9 0.9 0.5 0.5 0.5 0.1 0.1 0.1 0.1]

incidenceAndTrueR = incidenceAndTrueR[T*(idx-1)+1:T*idx, :]

dfNew = DataFrame(
    week = 1:T,
    meanRt = fill(NaN, T),
    lowerRt = fill(NaN, T),
    upperRt = fill(NaN, T),
    totalIterations = fill(NaN, T),
    runTime = fill(NaN, T),
    reportedIncidence = fill(NaN, T) 
)

count = 0

trueP = 7
defaultP = 7
#the following parameters must be for a weekly parameterisation of the serial interval. The choice of defaultP then corrects this.
wContGamPar = [15.3^2/9.3^2, 9.3^2/(15.3*7)] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
nWeeksForSI = 10
divisionsPerP = Int(1e2)

wTrue = siCalcNew(wContGamPar, trueP, nWeeksForSI, divisionsPerP)
wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
PoissonOrRound = "P" # P/R

priorRShapeAndScale = [1 3]

defaultM = Int(1e5)
maxIter = defaultM*10
criCheck = true

    x = inferUnderRepAndTempAggRTemporalRho(incidenceAndTrueR.reportedWeeklyI, wAssumed, priorRShapeAndScale, inferredTemporalRho, defaultM, defaultP, maxIter)
   
    dfNew[1:T, :meanRt] = vec(x["means"])
    dfNew[1:T, :lowerRt] = x["cri"][:, 1]
    dfNew[1:T, :upperRt] = x["cri"][:, 2]
    dfNew[1:T, :totalIterations] = x["totalIterations"]
    dfNew[1:T, :runTime] = x["runTime"]
    dfNew[1:T, :reportedIncidence] = incidenceAndTrueR.reportedWeeklyI


CSV.write("largeScaleStudyClusterNoLimitDecreasingRhoOG2_$idx.csv", dfNew)
