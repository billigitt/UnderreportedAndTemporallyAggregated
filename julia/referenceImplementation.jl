#This file is a referenced implementation of the OG2 method. The user can edit the parameters to see how the model behaves under different conditions.
#This file should take a few seconds to run (with the default parameterisation), and will output a plot of the epidemic curve, the true Rt, and the inferred Rt (under the OG2 method).

#NB: The following two lines must be uncommented when initially implementing this file. They can then be re-commented, to speed up the process of running the file.
# import Pkg
# Pkg.add(["QuadGK", "Distributions", "StatsBase", "Random", "DataFrames", "CSV", "Dates", "Distributed", "SharedArrays", "ProgressMeter", "Trapz", "Debugger", "JuliaInterpreter", "Tables", "Plots"])

using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

include("juliaUnderRepFunctions.jl")

#Set seed
Random.seed!(99)

day1I = 10; #edit for higher initial incidence, leading to higher incidence overall
trueWeeklyR = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]; #edit for different true Rt, characterising the epidemic
dailyP = 7 #edit for different temporal resolution of when infections occur [and how that is inferred]
wContGamPar = [15.3^2/9.3^2, 9.3^2/(7*15.3)] #edit for different continuous serial interval
nWeeksForSI = 10
divisionsPerP = Int(1e2)

#Following line computes the discrete serial interval
wDaily = siCalcNew(wContGamPar, dailyP, nWeeksForSI, divisionsPerP)
probReported = 0.5 #edit for different probability of being reported
PoissonOrRound = "P"

#Following line simulates the epidemic with parameters specified above.
incidenceOutput = generateIncidenceVaryRho(day1I, trueWeeklyR, wDaily, PoissonOrRound, probReported, dailyP)

#Extract incidence info
reportedWeeklyI = get(incidenceOutput, "reportedWeeklyI", 0)

#Set inference parameters
priorRShapeAndScale = [1 3] #edit for different Rt prior
defaultM = Int(1e5) #edit for different number of acceptances (in OG2 algorithm) per week. We recommend 100,00.
maxIter = defaultM
maxEntireIterations = Inf

#The following line computes OG2 inference. see juliaUnderRepFunctions.jl for more details.
x = inferUnderRepAndTempAggR(reportedWeeklyI, wDaily, priorRShapeAndScale, probReported, defaultM, dailyP, maxIter, maxEntireIterations)

#Plotting: In 95% of simulations, the true Rt should be within the credible interval. The mean of the credible interval is the central OG2 estimate of Rt.
plot(plot(vec(x["means"]), label = "OG2", ylabel = "Rt"; ribbon = (vec(x["means"]) - x["cri"][:, 1], x["cri"][:, 2] - vec(x["means"]))), plot(bar(1:11, vec(reportedWeeklyI)), legend = false, xlabel = "Time (t weeks)", ylabel = "Reported Incidence"))
plot!(trueWeeklyR, label = "True Rt", xlabel = "Time (t weeks)")
