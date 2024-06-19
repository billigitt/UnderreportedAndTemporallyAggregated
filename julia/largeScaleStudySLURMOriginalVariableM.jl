
try
    
    using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

catch

    import Pkg
    Pkg.add(["QuadGK", "Distributions", "StatsBase", "Random", "DataFrames", "CSV", "Dates", "Distributed", "SharedArrays", "ProgressMeter", "Trapz", "Debugger", "JuliaInterpreter", "Tables", "Plots"])

end

using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

idx = parse(Int64, ENV["SLURM_ARRAY_TASK_ID"])


incidenceAndTrueR = CSV.read("../CSVs/largeScaleStudyIncidencesAndTrueRsNoLimitPrior1And3FirstDay1.csv", DataFrame)
newInference = CSV.read("../CSVs/noLimitNewMethod/largeScaleStudyNewClusterNoLimitPrior1And3FirstDay1_$idx.csv", DataFrame)
originalInferenceM10 = CSV.read("../CSVs/noLimitOriginalMethodConstantM/largeScaleStudyOriginalMethodClusterNoLimitPrior1And3FirstDay1_$idx.csv", DataFrame)
Random.seed!(idx*99)

# Simulate Ebola epidemic. First phase (R=10) is highly transmissible, then quite (R=1.5), then low (R=0.75).
# This is to give a realistic epidemic curve. We assume that the epidemic is reported with a probability of rho.

include("juliaUnderRepFunctions.jl")
T = 11
nEpidemics = 1100
probReported = 0.1:0.1:0.9 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this 0.4 value is also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
probsConsidered = length(probReported)
maxEntireIterations = Inf

dfNew = DataFrame(
    week = repeat(1:T, outer = nEpidemics*probsConsidered),
    meanRt = fill(NaN, T*nEpidemics*probsConsidered),
    lowerRt = fill(NaN, T*nEpidemics*probsConsidered),
    upperRt = fill(NaN, T*nEpidemics*probsConsidered),
    totalIterations = fill(NaN, T*nEpidemics*probsConsidered),
    runTime = fill(NaN, T*nEpidemics*probsConsidered),
    reportedWeeklyI = fill(NaN, T*nEpidemics*probsConsidered),
    weeklyI = fill(NaN, T*nEpidemics*probsConsidered),
    trueR = fill(NaN, T*nEpidemics*probsConsidered),
    M = fill(NaN, T*nEpidemics*probsConsidered)
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

priorRShapeAndScale = [1 3]

criCheck = true

inferenceIdx = probsConsidered*10*(idx-1)+1:probsConsidered*10*idx


for i in inferenceIdx

    defaultM = Int(1e1)

    probConsidered = i%probsConsidered
    if probConsidered == 0
        probConsidered = probsConsidered
    end


    # Here, we do a rough calculation to scale the number of iterations in the orginal inference (with M=10) to the number of iterations in the new inference (so that the comaprisons are roughly fair)
    entireIterationsNew = newInference.totalIterations[((i-1)*T+1):(i*T)]
    entireIterationsNew = sum(entireIterationsNew)

    entireIterationsOriginal = originalInferenceM10.totalIterations[((i-1)*T+1):(i*T)]
    entireIterationsOriginal = sum(entireIterationsOriginal)

    ratio = 1.25*entireIterationsNew/entireIterationsOriginal
    # We use the ceil function in the event that the ratio is v. small, and thus advoids setting M=0.
    

    initial = true

    while (entireIterationsOriginal < entireIterationsNew) || initial

        defaultM = Int(ceil(ratio*defaultM))
        maxIter = defaultM*100

        x = inferTempAggOnlyR(incidenceAndTrueR.reportedWeeklyI[((i-1)*T+1):(i*T)], wAssumed, priorRShapeAndScale, defaultM, defaultP, maxIter, maxEntireIterations)

        dfNew[((i-1)*T+1):(i*T), :meanRt] = vec(x["means"])
        dfNew[((i-1)*T+1):(i*T), :lowerRt] = x["cri"][:, 1]
        dfNew[((i-1)*T+1):(i*T), :upperRt] = x["cri"][:, 2]
        dfNew[((i-1)*T+1):(i*T), :totalIterations] = x["totalIterations"]
        dfNew[((i-1)*T+1):(i*T), :runTime] = x["runTime"]
        dfNew[((i-1)*T+1):(i*T), :reportedWeeklyI] = incidenceAndTrueR.reportedWeeklyI[((i-1)*T+1):(i*T)]
        dfNew[((i-1)*T+1):(i*T), :weeklyI] = incidenceAndTrueR.weeklyI[((i-1)*T+1):(i*T)]
        dfNew[((i-1)*T+1):(i*T), :trueR] = incidenceAndTrueR.trueR[((i-1)*T+1):(i*T)]
        dfNew[((i-1)*T+1):(i*T), :M] = fill(defaultM, T)

        entireIterationsOriginal = sum(x["totalIterations"])

        initial = false
        ratio = 1.25*entireIterationsNew/entireIterationsOriginal

    end

end

fileName = "largeScaleStudyOriginalMethodClusterNoLimitPrior1And3FirstDay1VariableM_$idx.csv"

CSV.write(fileName, dfNew)