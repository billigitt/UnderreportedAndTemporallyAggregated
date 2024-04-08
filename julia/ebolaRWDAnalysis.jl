#import Pkg
#Pkg.add("Dates")


using Debugger, JuliaInterpreter, Trapz, ProfileView, CSV, DataFrames, Tables, DataFrames, Dates

include("juliaUnderRepFunctions.jl")

df = CSV.read("evd_drc_2018-2020_daily.csv", DataFrame)

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
final_df = sort(merged_df, :date_onset)

T = length(final_df.n_sum)

defaultP = 1
wContGamPar = [2.71, 5.65/7] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
divisionsPerP = Int(1e3)
nWeeksForSI = 10

probReported = 0.4 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this 0.4 value is also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
defaultM = Int(1e5)
maxIter = defaultM
criCheck = true

wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
priorRShapeAndScale = [1 5]

x = inferUnderRepAndTempAggR(final_df.n_sum, wAssumed, priorRShapeAndScale, probReported, defaultM, defaultP, maxIter, criCheck)

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

# df1b = DataFrame(
#         week = repeat(2:T, inner=defaultM),
#         likelihood = zeros(defaultM*(T-1)),
#         rPosterior = zeros(defaultM*(T-1)),
#         acceptance = repeat(1:defaultM, outer = T-1)
# )

# for k in 2:T
#     df1b.likelihood[(k-2)*defaultM+1:(k-1)*defaultM] = x["likelihood"][k, :]
#     df1b.rPosterior[(k-2)*defaultM+1:(k-1)*defaultM] = x["rPosterior"][k, :]
# end

CSV.write("realWorldInferenceEbola.csv", df1a)
# CSV.write("realWorldInferenceEbolaExtra.csv", df1b)