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

new_df = combine(groupby(df, :date_onset), :n => sum)
sorted_df = sort(new_df, :date_onset)

pop!(sorted_df) #remove NA date
sorted_df.date_onset = Date.(sorted_df.date_onset, "yyyy-mm-dd")

min_date = minimum(sorted_df.date_onset)
max_date = maximum(sorted_df.date_onset)

all_dates = DataFrame(date_onset = Date(min_date):Day(1):Date(max_date))

missing_dates = innerjoin(all_dates, sorted_df, on = :date_onset)

merged_df = outerjoin(all_dates, sorted_df, on = :date_onset)
merged_df.n_sum = coalesce.(merged_df.n_sum, 0) 
long_df = sort(merged_df, :date_onset)

final_df = long_df[1:(7*102), :]

defaultP = 7
wContGamPar = [15.3^2/9.3^2, 9.3^2/(15.3*7)] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
divisionsPerP = Int(1e3)
nWeeksForSI = 10

defaultM = Int(1e3)
maxIter = defaultM*10
maxEntireIter = 1e8
criCheck = true

wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
priorRShapeAndScale = [1 3]

weekly_vec = vec(sum(reshape(final_df.n_sum, 7, 102), dims =1))
weekly_vec_naive = Int.(ceil.(weekly_vec*2.5))
weekly_vec_naive = [weekly_vec_naive; 3] #round(add on the extra case*2.5)

        x = inferTempAggOnlyR(weekly_vec_naive, wAssumed, priorRShapeAndScale, defaultM, defaultP, maxIter, maxEntireIter)
    
        df1a = DataFrame(
            week = 1:length(x["means"]),
            date = [long_df.date_onset[1:7:(7*102-6)]; Date(2020, 04, 16)],
            meanRt = vec(x["means"]),
            lowerRt = x["cri"][:, 1],
            upperRt = x["cri"][:, 2],
            totalIterations = x["totalIterations"],
            runTime = x["runTime"],
            reportedWeeklyI = [weekly_vec; 1] #add on the extra case
        )
    
        CSV.write("../CSVs/realWorldNovelInferenceEbolaSingleNaiveRho04.csv", df1a)

