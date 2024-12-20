# This file is used to generate synthetuc Ebola-like outbreaks with a 'stuttering-start'. The files produced are .csv files with 'Ebola' and 'Stutter' in them. The seed also demonstrates the seed chosen for the random number generation.

import Pkg
using Pkg

# Set path to directory this file resides in
cd(dirname(@__FILE__))

# Load the environment and install any required packages
Pkg.activate("../")
Pkg.instantiate()

# Specify packages needed for this script
using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

# Simulate Ebola epidemic. First phase (R=10) is highly transmissible, then quite (R=1.5), then low (R=0.75).
# This is to give a realistic epidemic curve. We assume that the epidemic is reported with a probability of rho.

include("juliaUnderRepFunctions.jl")

Random.seed!(1)

inferenceBatch1 = CSV.read("../CSVs/largeScaleStudy.csv", DataFrame)

reportedWeeklyI = inferenceBatch1.reportedWeeklyI[23:33]
weeklyI = inferenceBatch1.weeklyI[23:33]

T = length(reportedWeeklyI)

weeklyP = 1
dailyP = 7
#the following parameters must be for a weekly parameterisation of the serial interval. The choice of defaultP then corrects this.
wContGamPar = [15.3^2/9.3^2, 9.3^2/(7*15.3)] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
nWeeksForSI = 10
divisionsPerP = Int(1e2)

#wDaily = siCalcNew(wContGamPar, dailyP, nWeeksForSI, divisionsPerP)
wWeekly = siCalcNew(wContGamPar, weeklyP, nWeeksForSI, divisionsPerP)

#CSV.write("SIDaily.csv", DataFrame(wDaily = wDaily))
CSV.write("../CSVs/SIWeekly.csv", DataFrame(wWeekly = wWeekly))
