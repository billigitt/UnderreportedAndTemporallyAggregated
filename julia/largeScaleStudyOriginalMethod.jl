import Pkg
using Pkg

# Set path to directory this file resides in
cd(dirname(@__FILE__))

# Load the environment and install any required packages
Pkg.activate("../")
Pkg.instantiate()

# Specify packages needed for this script
using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

addprocs(24)
Random.seed!(1)

# Simulate Ebola epidemic. First phase (R=10) is highly transmissible, then quite (R=1.5), then low (R=0.75).
# This is to give a realistic epidemic curve. We assume that the epidemic is reported with a probability of rho.



@everywhere begin
    using Trapz, DataFrames, ProgressMeter
    include("juliaUnderRepFunctions.jl")
    T = 11
    nEpidemics = Int(1e3)
    probReported = 0.1:0.1:0.9 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this 0.4 value is also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
probsConsidered = length(probReported)

    df = DataFrame(
        week = repeat(1:T, outer = nEpidemics*probsConsidered),
        meanRt = fill(NaN, T*nEpidemics*probsConsidered),
        lowerRt = fill(NaN, T*nEpidemics*probsConsidered),
        upperRt = fill(NaN, T*nEpidemics*probsConsidered),
        totalIterations = fill(NaN, T*nEpidemics*probsConsidered),
        runTime = fill(NaN, T*nEpidemics*probsConsidered),
        reportedWeeklyI = fill(NaN, T*nEpidemics*probsConsidered),
        weeklyI = fill(NaN, T*nEpidemics*probsConsidered),
        trueR = fill(NaN, T*nEpidemics*probsConsidered)
    )

    count = 0
    progress = Progress(probsConsidered * nEpidemics; dt=0.1, desc="Progress: ", color=:green, output=stderr, start=0)

end




trueP = 7
defaultP = 7
#the following parameters must be for a weekly parameterisation of the serial interval. The choice of defaultP then corrects this.
wContGamPar = [15.3^2/9.3^2, 9.3^2/(15.3*7)] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
nWeeksForSI = 10
divisionsPerP = Int(1e2)

wTrue = siCalcNew(wContGamPar, trueP, nWeeksForSI, divisionsPerP)
wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
PoissonOrRound = "P" # P/R

priorRShapeAndScale = [1 2]


defaultM = Int(1e3)
maxIter = defaultM*100
criCheck = true

reportedIncidenceMatrix = zeros(nEpidemics*probsConsidered, T)
trueIncidenceMatrix = zeros(nEpidemics, T)
trueWeeklyRMatrix = zeros(nEpidemics, T)

let
k = 0
while (k < nEpidemics)

day1I = 1
trueWeeklyR = rand(Gamma(priorRShapeAndScale[1], priorRShapeAndScale[2]), T)
incidenceOutput = generateIncidenceVaryRho(day1I, trueWeeklyR, wTrue, PoissonOrRound, probReported, trueP)

reportedWeeklyI = get(incidenceOutput, "reportedWeeklyI", 0)
weeklyI = get(incidenceOutput, "weeklyI", 0)

if (sum(reportedWeeklyI .== 0) == 0) & (maximum(reportedWeeklyI) < 10000)
    k += 1
    println(k)
    println(reportedWeeklyI)

    reportedIncidenceMatrix[(k-1)*probsConsidered+1:k*probsConsidered, :] = reportedWeeklyI
    trueIncidenceMatrix[k, :] = weeklyI
    trueWeeklyRMatrix[k, :] = trueWeeklyR

end

end

end

elapsed_time = @elapsed begin

dfNew = @distributed (append!) for i in 1:probsConsidered*nEpidemics
    
    probConsidered = i%probsConsidered
    if probConsidered == 0
        probConsidered = probsConsidered
    end

    x = inferTempAggOnlyR(reportedIncidenceMatrix[i, :], wAssumed, priorRShapeAndScale, defaultM, defaultP, maxIter)

    DataFrame(meanRt = vec(x["means"]), lowerRt = x["cri"][:, 1], upperRt = x["cri"][:, 2], totalIterations = x["totalIterations"], runTime = x["runTime"], reportedWeeklyI = reportedIncidenceMatrix[i, :], weeklyI = trueIncidenceMatrix[div(i-1, probsConsidered)+1, :], trueR = trueWeeklyRMatrix[div(i-1, probsConsidered)+1, :])
end

end

CSV.write("../CSVs/largeScaleStudyOriginalMethodClusterMaxInc500.csv", dfNew)
