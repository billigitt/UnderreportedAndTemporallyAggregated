#import Pkg
#Pkg.add("Dates")


using Debugger, JuliaInterpreter, Trapz, ProfileView, CSV, DataFrames, Tables, DataFrames, Dates

include("juliaUnderRepFunctions.jl")

df = CSV.read("CSVs/evd_drc_2018-2020_daily.csv", DataFrame)

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

final_df = long_df[142:512, :]

weekly_vec = vec(sum(reshape(final_df.n_sum, 7, 53), dims =1))

T = length(weekly_vec)

defaultP = 1
wContGamPar = [4, 1/10.8] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
divisionsPerP = Int(1e3)
nWeeksForSI = 10

probReported = 0.33:0.1:0.83 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this range of values are also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
numProbsReported = length(probReported)
defaultM = Int(1e5)
maxIter = defaultM
criCheck = true

wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
priorRShapeAndScale = [1 5]


for i in 1:numProbsReported
        x = inferUnderRepAndTempAggRNaive(weekly_vec, wAssumed, priorRShapeAndScale, probReported[i], defaultM, defaultP, maxIter, criCheck)
    
        df1a = DataFrame(
            week = 1:length(x["means"]),
            date = long_df.date_onset[142:7:(512-6)],
            meanRt = vec(x["means"]),
            lowerRt = x["cri"][:, 1],
            upperRt = x["cri"][:, 2],
            totalIterations = x["totalIterations"],
            runTime = x["runTime"],
            reportedWeeklyI = weekly_vec,
        )
    
        CSV.write("testRho" * string(i) * ".csv", df1a)
    end
