import Pkg
using Pkg

Pkg.instantiate()

using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots


idx = parse(Int64, ENV["SLURM_ARRAY_TASK_ID"])

incidenceAndTrueR = CSV.read("../CSVs/largeScaleStudyIncidencesAndTrueRsMaxInc1e4.csv", DataFrame)
Random.seed!(1)

# Simulate Ebola epidemic. First phase (R=10) is highly transmissible, then quite (R=1.5), then low (R=0.75).
# This is to give a realistic epidemic curve. We assume that the epidemic is reported with a probability of rho.

include("juliaUnderRepFunctions.jl")
T = 11
nEpidemics = Int(1e1)
probReported = 0.1:0.1:0.9 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this 0.4 value is also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
probsConsidered = length(probReported)

incidenceAndTrueR = incidenceAndTrueR[probsConsidered*T*(idx-1)*10+1: probsConsidered*T*idx*10, :]

dfNew = DataFrame(
    week = repeat(1:T, outer = nEpidemics*probsConsidered),
    meanRt = fill(NaN, T*nEpidemics*probsConsidered),
    lowerRt = fill(NaN, T*nEpidemics*probsConsidered),
    upperRt = fill(NaN, T*nEpidemics*probsConsidered),
    totalIterations = fill(NaN, T*nEpidemics*probsConsidered),
    runTime = fill(NaN, T*nEpidemics*probsConsidered)
)

count = 0
progress = Progress(probsConsidered * nEpidemics; dt=0.1, desc="Progress: ", color=:green, output=stderr, start=0)

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

for i in 1:probsConsidered*nEpidemics
    
    probConsidered = i%probsConsidered
    if probConsidered == 0
        probConsidered = probsConsidered
    end

    x = inferUnderRepAndTempAggR(incidenceAndTrueR.reportedWeeklyI[((i-1)*T+1):(i*T)], wAssumed, priorRShapeAndScale, probReported[probConsidered], defaultM, defaultP, maxIter, criCheck)
   
    dfNew[(i-1)*T+1:i*T, :meanRt] = vec(x["means"])
    dfNew[(i-1)*T+1:i*T, :lowerRt] = x["cri"][:, 1]
    dfNew[(i-1)*T+1:i*T, :upperRt] = x["cri"][:, 2]
    dfNew[(i-1)*T+1:i*T, :totalIterations] = x["totalIterations"]
    dfNew[(i-1)*T+1:i*T, :runTime] = x["runTime"]

end

CSV.write("largeScaleStudyClusterMaxInc1e4_$idx.csv", dfNew)
