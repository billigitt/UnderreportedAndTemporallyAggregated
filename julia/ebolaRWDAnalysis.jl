import Pkg
using Pkg

# Set path to directory this file resides in
cd(dirname(@__FILE__))

# Load the environment and install any required packages
Pkg.activate("../")
Pkg.instantiate()

# Specify packages needed for this script
using QuadGK, Distributions, StatsBase, Random, DataFrames, CSV, Dates, Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter, Tables, Plots

include("juliaUnderRepFunctions.jl")

df = CSV.read("../CSVs/evd_drc_2018-2020_daily.csv", DataFrame)

new_df = combine(groupby(df, :date_onset), :n => sum) # combines all locations into one
sorted_df = sort(new_df, :date_onset) # sort by date

pop!(sorted_df) #remove NA date
sorted_df.date_onset = Date.(sorted_df.date_onset, "yyyy-mm-dd") #chnage format of date

min_date = minimum(sorted_df.date_onset)
max_date = maximum(sorted_df.date_onset) #find min and max dates

all_dates = DataFrame(date_onset = Date(min_date):Day(1):Date(max_date)) #data frame of dates

missing_dates = innerjoin(all_dates, sorted_df, on = :date_onset) #

merged_df = outerjoin(all_dates, sorted_df, on = :date_onset)
merged_df.n_sum = coalesce.(merged_df.n_sum, 0) 
final_df = sort(merged_df, :date_onset)

T = length(final_df.n_sum)

defaultP = 1
wContGamPar = [15.3^2/9.3^2, 9.3^2/(15.3*7)] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
divisionsPerP = Int(1e3)
nWeeksForSI = 10

probReported = 0.2:0.1:1 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this 0.4 value is also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
numProbsReported = length(probReported)
defaultM = Int(1e5)
maxIter = defaultM
criCheck = true

wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
priorRShapeAndScale = [1 3]

for i in 1:numProbsReported
    x = inferUnderRepAndTempAggR(final_df.n_sum, wAssumed, priorRShapeAndScale, probReported[i], defaultM, defaultP, maxIter, criCheck)

    df1a = DataFrame(
        week = 1:length(x["means"]),
        date = final_df.date_onset,
        meanRt = vec(x["means"]),
        lowerRt = x["cri"][:, 1],
        upperRt = x["cri"][:, 2],
        totalIterations = x["totalIterations"],
        runTime = x["runTime"],
        reportedWeeklyI = final_df.n_sum,
    )

    CSV.write("../CSVs/realWorldInferenceEbolaRho" * string(i) * ".csv", df1a)
end
