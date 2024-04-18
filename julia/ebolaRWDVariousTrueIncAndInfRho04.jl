import Pkg
Pkg.add(["QuadGK", "Distributions", "StatsBase", "Random", "DataFrames", "CSV", "Dates", "Distributed", "SharedArrays", "ProgressMeter", "Trapz", "Debugger", "JuliaInterpreter"])

using StatsBase
using Distributions, StatsBase, Random, DataFrames, CSV, Dates,  Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter

workers = 24
seedling = 1

addprocs(workers)
Random.seed!(seedling)

@everywhere begin
    
    using Distributions, StatsBase, Random, DataFrames, CSV, Dates,  Distributed, SharedArrays, ProgressMeter, Trapz, Debugger, JuliaInterpreter



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

    nSims = 1000

    include("juliaUnderRepFunctions.jl")


    final_df = long_df[1:75*7, :]

    weekly_vec = vec(sum(reshape(final_df.n_sum, 7, 75), dims =1))

    trueWeeklyI = zeros(Int, length(weekly_vec), nSims)

    probReported = 0.4

    for i in 1:length(weekly_vec) 

        weeklyI = Int(weekly_vec[i])
        maxVal = Int(round(100 * weeklyI / probReported))
        invBinPMF = likeliCalcInvBin(weeklyI, probReported, maxVal)
        trueWeeklyI[i, :] = sample(0:maxVal, Weights(invBinPMF), nSims, replace = true)

    end

        T = length(weekly_vec)
    
        defaultP = 7
        wContGamPar = [15.3^2/9.3^2, 9.3^2/(15.3*7)] #https://royalsocietypublishing.org/doi/epdf/10.1098/rsif.2023.0374 shape = 15.3^2/9.3^2, scale = 9.3^2/15.3  because (mean, std) = (15.3, 9.3)
        divisionsPerP = Int(1e3)
        nWeeksForSI = 10
        
         # comes from https://www.cdc.gov/mmwr/preview/mmwrhtml/su6303a1.htm?s_cid-su6303a1_w#Appendix-tab4 Table 4, see correction factor
        # this range of values are also corroborated in doi: 10.1371/journal.pntd.0006161 (Dalziel, unreported cases in Ebola)
        defaultM = Int(1e3)
        maxIter = Int(1e5)
        criCheck = true
        
        wAssumed = siCalcNew(wContGamPar, defaultP, nWeeksForSI, divisionsPerP)
        priorRShapeAndScale = [1 5]

    end




##here we need to use old method to infer Rt over all possible true incidence...
    dfNew = @distributed (append!) for i in 1:nSims

        x = inferTempAggOnlyR(trueWeeklyI[:, i], wAssumed, priorRShapeAndScale, defaultM, defaultP, maxIter)
    
        DataFrame(
            week = 1:length(x["means"]),
            date = long_df.date_onset[1:7:(7*75-6)],
            meanRt = vec(x["means"]),
            lowerRt = x["cri"][:, 1],
            upperRt = x["cri"][:, 2],
            totalIterations = x["totalIterations"],
            runTime = x["runTime"],
            reportedWeeklyI = weekly_vec,
            trueWeeklyI = trueWeeklyI[:, i]
        )
    

    end

    CSV.write("ebolaRWDVariousTrueIncAndInfRho04Sims.csv", dfNew)

