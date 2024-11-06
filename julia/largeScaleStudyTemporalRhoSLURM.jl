try
    
    using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

catch

    import Pkg
    Pkg.add(["QuadGK", "Distributions", "StatsBase", "Random", "DataFrames", "CSV", "Dates", "Distributed", "SharedArrays", "ProgressMeter", "Trapz", "Debugger", "JuliaInterpreter", "Tables", "Plots"])

end

using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

idx = parse(Int64, ENV["SLURM_ARRAY_TASK_ID"])

incidenceAndTrueR = CSV.read("../CSVs/largeScaleStudyIncidencesAndTrueRsNoLimitPrior1And3FirstDay1IncreasingRho.csv", DataFrame)
Random.seed!(1)

include("juliaUnderRepFunctions.jl")
T = 11
nEpidemics = Int(2e1)

inferredTemporalRho = [0.1 0.1 0.1 0.1 0.5 0.5 0.5 0.9 0.9 0.9 0.9]

incidenceAndTrueR = incidenceAndTrueR[T*(idx-1)*10+1:T*idx*10, :]

dfNew = DataFrame(
    week = repeat(1:T, outer = nEpidemics),
    meanRt = fill(NaN, T*nEpidemics),
    lowerRt = fill(NaN, T*nEpidemics),
    upperRt = fill(NaN, T*nEpidemics),
    totalIterations = fill(NaN, T*nEpidemics),
    runTime = fill(NaN, T*nEpidemics),
    reportedIncidence = fill(NaN, T*nEpidemics) 
)

count = 0
progress = Progress(nEpidemics; dt=0.1, desc="Progress: ", color=:green, output=stderr, start=0)

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

defaultM = Int(1e5)
maxIter = defaultM*10
criCheck = true

for i in 1:nEpidemics

    x = inferUnderRepAndTempAggRTemporalRho(incidenceAndTrueR.reportedWeeklyI[((i-1)*T+1):(i*T)], wAssumed, priorRShapeAndScale, inferredTemporalRho, defaultM, defaultP, maxIter)
   
    dfNew[(i-1)*T+1:i*T, :meanRt] = vec(x["means"])
    dfNew[(i-1)*T+1:i*T, :lowerRt] = x["cri"][:, 1]
    dfNew[(i-1)*T+1:i*T, :upperRt] = x["cri"][:, 2]
    dfNew[(i-1)*T+1:i*T, :totalIterations] = x["totalIterations"]
    dfNew[(i-1)*T+1:i*T, :runTime] = x["runTime"]
    dfNew[(i-1)*T+1:i*T, :reportedIncidence] = incidenceAndTrueR.reportedWeeklyI[((i-1)*T+1):(i*T)]
    
end

CSV.write("largeScaleStudyClusterNoLimitTemporalRhoOG2_$idx.csv", dfNew)
