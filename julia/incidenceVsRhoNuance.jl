import Pkg
using Pkg

Pkg.instantiate()

using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

include("juliaUnderRepFunctions.jl")

rhoValues = 0.05:0.05:0.95
numRhos = length(rhoValues)
maxIncidence = 10

numRows = numRhos*maxIncidence
numCols = 2
T = numCols

valuesInc = repeat(1:maxIncidence, inner = (numRhos,))

reportedWeeklyI = hcat(valuesInc, valuesInc)

defaultM = Int(1e5)
defaultP = 7
wContGamPar = [2.71, 5.65/7]
nWeeksForSI = 10
divisionsPerP = Int(1e2)
wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
priorRShapeAndScale = [1 5]
maxIter = defaultM
criCheck = true

df1c = DataFrame(
        week = repeat(1:T, outer = numRows),
        meanRt = fill(NaN, T*numRows),
        lowerRt = fill(NaN, T*numRows),
        upperRt = fill(NaN, T*numRows),
        reportedWeeklyI = fill(NaN, T*numRows)
)

for i in 1:numRows

        println(i)

        j = i%numRhos

        if j == 0
                j = numRhos
        end

        z = inferUnderRepAndTempAggR(reportedWeeklyI[i, :], wAssumed, priorRShapeAndScale, rhoValues[j], defaultM, defaultP, maxIter, criCheck)

        df1c.meanRt[(i-1)*T+1:i*T] = vec(z["means"])
        df1c.lowerRt[(i-1)*T+1:i*T] = z["cri"][:, 1]
        df1c.upperRt[(i-1)*T+1:i*T] = z["cri"][:, 2]
        df1c.reportedWeeklyI[(i-1)*T+1:i*T] = reportedWeeklyI[i,:]

end
