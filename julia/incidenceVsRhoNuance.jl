rhoValues = 0.05:0.05:0.95
numRhos = length(rhoValues)
maxIncidence = 100

numRows = numRhos*maxIncidence
numCols = 2

values = repeat(1:maxIncidence, inner = (numRhos,))

reportedWeeklyI = hcat(values, values)

defaultM = Int(1e5)
defaultP = 7
wContGamPar = [4, 1/10.8] 
nWeeksForSI = 10
divisionsPerP = Int(1e2)
wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
priorRShapeAndScale = [1 5]
maxIter = defaultM
criCheck = true

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

        j = i%numRhos

        if j == 0
                j = numRhos
        end

        z = inferUnderRepAndTempAggR(reportedWeeklyI[:, i], wAssumed, priorRShapeAndScale, rhoValues[j], defaultM, defaultP, maxIter, criCheck)

        df1c.meanRt[(i-1)*T+1:i*T] = vec(z["means"])
        df1c.lowerRt[(i-1)*T+1:i*T] = z["cri"][:, 1]
        df1c.upperRt[(i-1)*T+1:i*T] = z["cri"][:, 2]
        df1c.totalIterations[(i-1)*T+1:i*T] = z["totalIterations"]
        df1c.runTime[(i-1)*T+1:i*T] = z["runTime"]
        df1c.reportedWeeklyI[(i-1)*T+1:i*T] = reportedWeeklyI
        df1c.weeklyI[(i-1)*T+1:i*T] = weeklyI

end