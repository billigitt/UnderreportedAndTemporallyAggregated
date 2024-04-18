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

final_df = long_df[1:(7*75), :]

weekly_vec = vec(sum(reshape(final_df.n_sum, 7, 75), dims =1))

generatingProbReported = 0.4

trueWeeklyI = zeros(Int, length(weekly_vec))

T = length(weekly_vec)

for i in 1:T 

    weeklyI = Int(weekly_vec[i])
    maxVal = Int(round(100 * weeklyI / generatingProbReported))
    invBinPMF = likeliCalcInvBin(weeklyI, generatingProbReported, maxVal)
    trueWeeklyI[i] = sample(0:maxVal, Weights(invBinPMF), 1, replace = true)[1]

end



defaultP = 1
wContGamPar = [15.3^2/9.3^2, 9.3^2/(15.3*7)] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
divisionsPerP = Int(1e3)
nWeeksForSI = 10

probReported = 0.3:0.1:0.9 # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
# this range of values are also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
numProbsReported = length(probReported)
defaultM = Int(1e5)
maxIter = defaultM
criCheck = true

wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
priorRShapeAndScale = [1 5]

recordedWeeklyIMatrix = zeros(Int, numProbsReported, T)

for i in 1:numProbsReported

    #recordedWeeklyIMatrix[i, :] = [rand(Binomial(Int(n), probReported[i])) for n in trueWeeklyI]
    recordedWeeklyIMatrix[i, :] = round.(trueWeeklyI*probReported[i])

end

for i in 1:numProbsReported

        x = inferUnderRepAndTempAggR(recordedWeeklyIMatrix[i, :], wAssumed, priorRShapeAndScale, probReported[i], defaultM, defaultP, maxIter, criCheck)
    
        df1a = DataFrame(
            week = 1:length(x["means"]),
            date = long_df.date_onset[1:7:(7*75-6)],
            meanRt = vec(x["means"]),
            lowerRt = x["cri"][:, 1],
            upperRt = x["cri"][:, 2],
            totalIterations = x["totalIterations"],
            runTime = x["runTime"],
            reportedWeeklyI = recordedWeeklyIMatrix[i, :],
            trueWeeklyI = trueWeeklyI
        )
    
        CSV.write("realWorldInferenceEbolaRho" * string(i) * ".csv", df1a)
    end
