import Pkg
using Pkg

Pkg.instantiate()

using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

Random.seed!(1)

# Simulate Ebola epidemic. First phase (R=10) is highly transmissible, then quite (R=1.5), then low (R=0.75).
# This is to give a realistic epidemic curve. We assume that the epidemic is reported with a probability of rho.

include("juliaUnderRepFunctions.jl")
T = 11
nEpidemics = Int(1100)
probReported = 0.1:0.1:0.9 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this 0.4 value is also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
probsConsidered = length(probReported)

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

priorRShapeAndScale = [1 3]

# defaultM = Int(1e3)
# maxIter = defaultM*100
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

#(sum(reportedWeeklyI .== 0)/prod(size(reportedWeeklyI)) <= 0.05) & (maximum(reportedWeeklyI) < 1e2) & (sum(reportedWeeklyI[:, 1] .== 0)==0) & (maximum(reportedWeeklyI[:,11]) < 5e1)
if (sum(reportedWeeklyI .== 0)/prod(size(reportedWeeklyI)) <= 0.05) & (sum(reportedWeeklyI[:, 1] .== 0)==0)
    k += 1
    println(reportedWeeklyI)

    reportedIncidenceMatrix[(k-1)*probsConsidered+1:k*probsConsidered, :] = reportedWeeklyI
    trueIncidenceMatrix[k, :] = weeklyI
    trueWeeklyRMatrix[k, :] = trueWeeklyR

    println(k)

end

end

end

df = DataFrame(
    reportedWeeklyI = fill(NaN, T*nEpidemics*probsConsidered),
    weeklyI = fill(NaN, T*nEpidemics*probsConsidered),
    trueR = fill(NaN, T*nEpidemics*probsConsidered)
)

for i in 1:probsConsidered*nEpidemics
    
    probConsidered = i%probsConsidered
    if probConsidered == 0
        probConsidered = probsConsidered
    end

    df[(i-1)*T+1:i*T, :reportedWeeklyI] = reportedIncidenceMatrix[i, :]
    df[(i-1)*T+1:i*T, :weeklyI] = trueIncidenceMatrix[div(i-1, probsConsidered)+1, :]
    df[(i-1)*T+1:i*T, :trueR] = trueWeeklyRMatrix[div(i-1, probsConsidered)+1, :]

end

CSV.write("CSVs/largeScaleStudyIncidencesAndTrueRsNoLimitPrior1And3FirstDay1.csv", df)
