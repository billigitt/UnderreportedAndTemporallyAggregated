using Random, QuadGK, Distributions, Trapz

using StatsBase


function inferUnderRepAndTempAggRStableCrI(weeklyRepI, w, priorRShapeScale, rho, P, tol)


    totalWeeks = length(weeklyRepI)
    lengthSerial = length(w)

    #pre-allocation
    storedI = zeros(Int, P*totalWeeks, M)
    storedITimet = storedI
    sampleI = zeros(Int, P*totalWeeks, maxIter)
    likelihood = ones(totalWeeks, M)
    rPosterior = ones(totalWeeks, M)


    diagnostics = Dict()
    runTime = zeros(totalWeeks)
    totalIterations = zeros(totalWeeks)

    for t in 2:totalWeeks

        # re-set acceptance and iteration counts
        st_time = time_ns()
        acc = 0
        iter = 1
        k = 1

        criTmp = [100 100] # arbitrary values that are hopefully overwritten!!

        # as Nic suggests, faster to do this sampling in one go
        if (t >= 3)

            sampleIdx = sample(1:M, Weights(likelihood[t-1, :]), maxIter, replace = true)
            sampleI = storedI[:, sampleIdx]     

        elseif (t == 2)

            weeklyI1 = Int(weeklyI[1])
            maxVal = Int(round(100 * weeklyI1 / probReported))
            invBinPMF = likeliCalcInvBin(weeklyI1, probReported, maxVal)

            trueWeeklyI1 = sample(1:maxVal, Weights(invBinPMF), maxIter, replace = true)
            sampleI[1:P, :] = generateMultinomialSamples(trueWeeklyI1, P)

        end

        #sampling R in one go is a good idea regardless of t
        sampleR = rand(Gamma(priorRShapeScale[1], priorRShapeScale[2]), maxIter)

        logicalStable = false

        while (logicalStable == false)

            # take samples of incidence and reproduction number
            simI = sampleI[:, iter]
            simR = sampleR[iter]
            for j in 1:P

                timeConsidered = min((t - 1) * P + j - 1, lengthSerial)

                infectiousPressure = sum(simI[((t - 1) * P + j - 1):-1:((t - 1) * P + j - timeConsidered)] .* w[1:timeConsidered])

                simI[(t-1)*P+j] = rand(Poisson(infectiousPressure*simR))

            end

            weeklySimI = sum(simI[((t-1)*P+1):(t*P)])

            likelihoodTmp = pdf.(Binomial.(weeklySimI, rho), weeklyRepI[t])

            if (likelihoodTmp > 0)

                acc += 1
                likelihood[t, acc] = likelihoodTmp
                rPosterior[t, acc] = simR
                storedITimet[:, acc] = simI

            end
            iter += 1

            if (acc%100 == 0)

                criNew[i, 1] = quantile(rPosterior[1:acc, i], Weights(likelihood[1:acc, i]), 0.025)
                criNew[i, 2] = quantile(rPosterior[1:acc, i], Weights(likelihood[1:acc, i]), 0.975)

                logicalStable = (abs(criNew[i, 1] - criTmp[i, 1]) < tol) & (abs(criNew[i, 2] - criTmp[i, 2]) < tol)

                criTmp = criNew[i, :]

            end

            if ((iter == maxIter) & (acc < M))

                println("Warning: maximum number of iterations reached at week ", t, " with ", acc, " samples")
            
                iter = 1 #? basically sampling from same initial samples. Is there a better way?
                k += 1

            end
        end
        storedI = storedITimet
        stop_time = time_ns()
        runTime[t] = (stop_time - st_time) / 1e9
        totalIterations[t] = iter + (k - 1) * maxIter

    end

    #calculate summary statistics
    means = sum(rPosterior .* likelihood, dims=2) ./ sum(likelihood, dims=2)
    means[1] = NaN

    cri = fill(NaN, totalWeeks, 2)
    for i in 2:totalWeeks
        cri[i, 1] = quantile(rPosterior[:, i], Weights(likelihood[:, i]), 0.025)
        cri[i, 2] = quantile(rPosterior[:, i], Weights(likelihood[:, i]), 0.975)
    end

    dictionary = Dict([("means", means), ("cri", cri), ("storedI", storedI), ("likelihood", likelihood), ("rPosterior", rPosterior), ("runTime", runTime), ("totalIterations", totalIterations)])

end

function inferUnderRepAndTempAggRNaive(weeklyRepI, w, priorRShapeScale, rho, M, P, maxIter, criCheck)

    #remove criCheck?
        totalWeeks = length(weeklyRepI)
        lengthSerial = length(w)
    
        #pre-allocation
        storedI = zeros(Int, P*totalWeeks, M)
        storedITimet = storedI
        sampleI = zeros(Int, P*totalWeeks, maxIter)
        likelihood = ones(totalWeeks, M)
        rPosterior = ones(totalWeeks, M)
    
        runTime = zeros(totalWeeks)
        totalIterations = zeros(totalWeeks)
        criTemp = fill(NaN, totalWeeks, M, 2)
        meanTemp = fill(NaN, totalWeeks, M)
    
        for t in 2:totalWeeks
    
            # re-set acceptance and iteration counts
            st_time = time_ns()
            acc = 0
            iter = 1
            k = 1
    
            # as Nic suggests, faster to do this sampling in one go
            if (t >= 3)
    
                sampleIdx = sample(1:M, Weights(likelihood[t-1, :]), maxIter, replace = true)
                sampleI = storedI[:, sampleIdx]
    
            elseif (t == 2)
    
                weeklyI1 = Int(weeklyRepI[1])
                sampleI[1:P, :] = generateMultinomialSamples(fill(Int(round(weeklyRepI[1]/rho)), maxIter), P)
    
            end
    
            #sampling R in one go is a good idea regardless of t
            sampleR = rand(Gamma(priorRShapeScale[1], priorRShapeScale[2]), maxIter)
    
    
            while (acc < M)
    
                # take samples of incidence and reproduction number
                simI = sampleI[:, iter]
                simR = sampleR[iter]
                for j in 1:P
    
                    timeConsidered = min((t - 1) * P + j - 1, lengthSerial)
    
                    infectiousPressure = sum(simI[((t - 1) * P + j - 1):-1:((t - 1) * P + j - timeConsidered)] .* w[1:timeConsidered])
    
                    simI[(t-1)*P+j] = rand(Poisson(infectiousPressure*simR))
    
                end
    
                weeklySimI = sum(simI[((t-1)*P+1):(t*P)])
    
                likelihoodTmp = pdf.(Binomial.(weeklySimI, rho), weeklyRepI[t])
    
                if (likelihoodTmp > 0)
    
                    acc += 1
                    likelihood[t, acc] = likelihoodTmp
                    rPosterior[t, acc] = simR
                    storedITimet[:, acc] = simI
    
                    # if (criCheck == true) & (acc>1) & (sum(likelihood[t, 1:acc])> 1)
    
                    #     #criTemp is the credible interval calculated for each iteration
                    #     criTemp[t, acc, 1] = quantile(rPosterior[t, 1:acc], Weights(likelihood[t, 1:acc]), 0.025)
                    #     criTemp[t, acc, 2] = quantile(rPosterior[t, 1:acc], Weights(likelihood[t, 1:acc]), 0.975)
                    #     meanTemp[t, acc] = sum(rPosterior[t, 1:acc] .* likelihood[t, 1:acc]) ./ sum(likelihood[t, 1:acc])
    
                    # end
    
                end
                
                iter += 1
    
                if ((iter == maxIter) & (acc < M))
    
                    println("Warning: maximum number of iterations reached at week ", t, " with ", acc, " samples")
                
                    iter = 1 #? basically sampling from same initial samples. Is there a better way?
                    k += 1
    
                end
            end
            storedI = storedITimet
            stop_time = time_ns()
            runTime[t] = (stop_time - st_time) / 1e9
            totalIterations[t] = iter + (k - 1) * maxIter
    
        end
    
        #calculate summary statistics
        means = sum(rPosterior .* likelihood, dims=2) ./ sum(likelihood, dims=2)
        means[1] = NaN
    
        cri = fill(NaN, totalWeeks, 2)
        for i in 2:totalWeeks
            cri[i, 1] = quantile(rPosterior[i, :], Weights(likelihood[i, :]), 0.025)
            cri[i, 2] = quantile(rPosterior[i, :], Weights(likelihood[i, :]), 0.975)
        end
    
        dictionary = Dict([("means", means), ("cri", cri), ("storedI", storedI), ("likelihood", likelihood), ("rPosterior", rPosterior), ("runTime", runTime), ("totalIterations", totalIterations), ("meanTemp", meanTemp), ("criTemp", criTemp)])
    
    end

function inferUnderRepAndTempAggR(weeklyRepI, w, priorRShapeScale, rho, M, P, maxIter, maxEntireIterations)

#remove criCheck?
    totalWeeks = length(weeklyRepI)
    lengthSerial = length(w)

    #pre-allocation
    storedI = zeros(Int, P*totalWeeks, M)
    storedITimet = storedI
    sampleI = zeros(Int, P*totalWeeks, maxIter)
    likelihood = ones(totalWeeks, M)
    rPosterior = ones(totalWeeks, M)

    runTime = zeros(totalWeeks)
    totalIterations = zeros(totalWeeks)
    criTemp = fill(NaN, totalWeeks, M, 2)
    meanTemp = fill(NaN, totalWeeks, M)

    for t in 2:totalWeeks

        # re-set acceptance and iteration counts
        st_time = time_ns()
        acc = 0
        iter = 1
        k = 1

        # as Nic suggests, faster to do this sampling in one go
        if (t >= 3)

            sampleIdx = sample(1:M, Weights(likelihood[t-1, :]), maxIter, replace = true)
            sampleI = storedI[:, sampleIdx]

        elseif (t == 2)

            weeklyI1 = Int(weeklyRepI[1])
            maxVal = Int(round(100 * weeklyI1 / rho))
            if weeklyI1 == 0
                maxVal = Int(round(100/rho))
            end
            invBinPMF = likeliCalcInvBin(weeklyI1, rho, maxVal)

            trueWeeklyI1 = sample(0:maxVal, Weights(invBinPMF), maxIter, replace = true)
            sampleI[1:P, :] = generateMultinomialSamples(trueWeeklyI1, P)

        end

        #sampling R in one go is a good idea regardless of t
        sampleR = rand(Gamma(priorRShapeScale[1], priorRShapeScale[2]), maxIter)


        while (acc < M)

            # take samples of incidence and reproduction number
            simI = sampleI[:, iter]
            simR = sampleR[iter]
            for j in 1:P

                timeConsidered = min((t - 1) * P + j - 1, lengthSerial)

                infectiousPressure = sum(simI[((t - 1) * P + j - 1):-1:((t - 1) * P + j - timeConsidered)] .* w[1:timeConsidered])

                simI[(t-1)*P+j] = rand(Poisson(infectiousPressure*simR))

            end

            weeklySimI = sum(simI[((t-1)*P+1):(t*P)])

            likelihoodTmp = pdf.(Binomial.(weeklySimI, rho), weeklyRepI[t])

            if (likelihoodTmp > 0)

                acc += 1
                likelihood[t, acc] = likelihoodTmp
                rPosterior[t, acc] = simR
                storedITimet[:, acc] = simI

                # if (criCheck == true) & (acc>1) & (sum(likelihood[t, 1:acc])> 1)

                #     #criTemp is the credible interval calculated for each iteration
                #     criTemp[t, acc, 1] = quantile(rPosterior[t, 1:acc], Weights(likelihood[t, 1:acc]), 0.025)
                #     criTemp[t, acc, 2] = quantile(rPosterior[t, 1:acc], Weights(likelihood[t, 1:acc]), 0.975)
                #     meanTemp[t, acc] = sum(rPosterior[t, 1:acc] .* likelihood[t, 1:acc]) ./ sum(likelihood[t, 1:acc])

                # end

            end
            
            iter += 1

            ((sum(totalIterations[1:(t-1)])+ iter + (k - 1) * maxIter) > maxEntireIterations) && break

            if ((iter == maxIter) & (acc < M))

                println("Warning: maximum number of iterations reached at week ", t, " with ", acc, " samples")
            
                iter = 1 #? basically sampling from same initial samples. Is there a better way?
                k += 1

            end
        end
        storedI = storedITimet
        stop_time = time_ns()
        runTime[t] = (stop_time - st_time) / 1e9
        totalIterations[t] = iter + (k - 1) * maxIter

        (acc < M) && break

    end

    #calculate summary statistics
    means = sum(rPosterior .* likelihood, dims=2) ./ sum(likelihood, dims=2)
    means[1] = NaN

    means[means.==0] .= NaN

    cri = fill(NaN, totalWeeks, 2)
    for i in 2:totalWeeks
        cri[i, 1] = quantile(rPosterior[i, :], Weights(likelihood[i, :]), 0.025)
        cri[i, 2] = quantile(rPosterior[i, :], Weights(likelihood[i, :]), 0.975)
    end

    dictionary = Dict([("means", means), ("cri", cri), ("storedI", storedI), ("likelihood", likelihood), ("rPosterior", rPosterior), ("runTime", runTime), ("totalIterations", totalIterations), ("meanTemp", meanTemp), ("criTemp", criTemp)])

end

function inferTempAggOnlyR(weeklyRepI, w, priorRShapeScale, M, P, maxIter, maxEntireIterations)

    #remove criCheck?
        totalWeeks = length(weeklyRepI)
        lengthSerial = length(w)
    
        #pre-allocation
        storedI = zeros(Int, P*totalWeeks, M)
        storedITimet = storedI
        sampleI = zeros(Int, P*totalWeeks, maxIter)
        rPosterior = zeros(totalWeeks, M)
    
        runTime = zeros(totalWeeks)
        totalIterations = zeros(totalWeeks)
        meanTemp = fill(NaN, totalWeeks, M)
    
        for t in 2:totalWeeks
    
            # re-set acceptance and iteration counts
            st_time = time_ns()
            acc = 0
            iter = 1
            k = 1

            sampling = reSampling(M, maxIter, P, storedI, weeklyRepI[1], t, priorRShapeScale, sampleI)
            sampleI = sampling["sampleI"]
            sampleR = sampling["sampleR"]
    
            while (acc < M)
    
                # take samples of incidence and reproduction number
                simI = sampleI[:, iter]
                simR = sampleR[iter]
                for j in 1:P
    
                    timeConsidered = min((t - 1) * P + j - 1, lengthSerial)
    
                    infectiousPressure = sum(simI[((t - 1) * P + j - 1):-1:((t - 1) * P + j - timeConsidered)] .* w[1:timeConsidered])
    
                    simI[(t-1)*P+j] = rand(Poisson(infectiousPressure*simR))
    
                end
    
                weeklySimI = sum(simI[((t-1)*P+1):(t*P)])
    
                if (weeklySimI == weeklyRepI[t])
    
                    acc += 1
                    rPosterior[t, acc] = simR
                    storedITimet[:, acc] = simI

                end
                
                iter += 1
    
                # following line breaks out of while loop if we exceed the maximum number of iterations over the entire time period
                ((sum(totalIterations[1:(t-1)])+ iter + (k - 1) * maxIter) > maxEntireIterations) && break
                

                if ((iter == maxIter) & (acc < M))
    
                    println("Warning: maximum number of iterations reached at week ", t, " with ", acc, " samples")
                
                    iter = 1 #? basically sampling from same initial samples. Is there a better way?
                    k += 1

                    Resampling = reSampling(M, maxIter, P, storedI, weeklyRepI[1], t, priorRShapeScale, sampleI)
                    sampleI = Resampling["sampleI"]
                    sampleR = Resampling["sampleR"]
    
                end
            end
            storedI = storedITimet
            stop_time = time_ns()
            runTime[t] = (stop_time - st_time) / 1e9
            totalIterations[t] = iter + (k - 1) * maxIter

            #this line checks if we broke out of the while loop at this time step, and so we then break out of the for loop as well if so
            (acc < M) && break
    
        end
    
        #calculate summary statistics
        means = sum(rPosterior, dims=2)/M
        means[1] = NaN
    
        # if we broke out of the while loop, the mean will be exactly zero
        means[means.==0] .= NaN

        cri = fill(NaN, totalWeeks, 2)
        for i in 2:totalWeeks
            cri[i, 1] = quantile(rPosterior[i, :], 0.025)
            cri[i, 2] = quantile(rPosterior[i, :], 0.975)
        end
    
        dictionary = Dict([("means", means), ("cri", cri), ("storedI", storedI), ("rPosterior", rPosterior), ("runTime", runTime), ("totalIterations", totalIterations), ("meanTemp", meanTemp)])
    
    end

function inferUnderRepAndTempAggRcriCheck(weeklyRepI, w, priorRShapeScale, rho, M, P, maxIter, criCheck)

    #remove criCheck?
        totalWeeks = length(weeklyRepI)
        lengthSerial = length(w)
    
        #pre-allocation
        storedI = zeros(Int, P*totalWeeks, M)
        storedITimet = storedI
        sampleI = zeros(Int, P*totalWeeks, maxIter)
        likelihood = ones(totalWeeks, M)
        rPosterior = ones(totalWeeks, M)
    
        runTime = zeros(totalWeeks)
        totalIterations = zeros(totalWeeks)
        criTemp = fill(NaN, totalWeeks, M, 2)
        meanTemp = fill(NaN, totalWeeks, M)
    
        for t in 2:totalWeeks
    
            # re-set acceptance and iteration counts
            st_time = time_ns()
            acc = 0
            iter = 1
            k = 1
    
            # as Nic suggests, faster to do this sampling in one go
            if (t >= 3)
    
                sampleIdx = sample(1:M, Weights(likelihood[t-1, :]), maxIter, replace = true)
                sampleI = storedI[:, sampleIdx]     
    
            elseif (t == 2)
    
                weeklyI1 = Int(weeklyRepI[1])
                maxVal = Int(round(100 * weeklyI1 / probReported))
                invBinPMF = likeliCalcInvBin(weeklyI1, probReported, maxVal) #this is indexed so that the first element of the PMF corresponds to n=0
    
                trueWeeklyI1 = sample(0:maxVal, Weights(invBinPMF), maxIter, replace = true)
                sampleI[1:P, :] = generateMultinomialSamples(trueWeeklyI1, P)
    
            end
    
            #sampling R in one go is a good idea regardless of t
            sampleR = rand(Gamma(priorRShapeScale[1], priorRShapeScale[2]), maxIter)
    
    
            while (acc < M)
    
                # take samples of incidence and reproduction number
                simI = sampleI[:, iter]
                simR = sampleR[iter]
                for j in 1:P
    
                    timeConsidered = min((t - 1) * P + j - 1, lengthSerial)
    
                    infectiousPressure = sum(simI[((t - 1) * P + j - 1):-1:((t - 1) * P + j - timeConsidered)] .* w[1:timeConsidered])
    
                    simI[(t-1)*P+j] = rand(Poisson(infectiousPressure*simR))
    
                end
    
                weeklySimI = sum(simI[((t-1)*P+1):(t*P)])
    
                likelihoodTmp = pdf.(Binomial.(weeklySimI, rho), weeklyRepI[t])
    
                if (likelihoodTmp > 0)
    
                    acc += 1
                    likelihood[t, acc] = likelihoodTmp
                    rPosterior[t, acc] = simR
                    storedITimet[:, acc] = simI
    
                    if (criCheck == true) & (acc>1)
    
                        #criTemp is the credible interval calculated for each iteration
                        criTemp[t, acc, 1] = quantile(rPosterior[t, 1:acc], Weights(likelihood[t, 1:acc]), 0.025)
                        criTemp[t, acc, 2] = quantile(rPosterior[t, 1:acc], Weights(likelihood[t, 1:acc]), 0.975)
                        meanTemp[t, acc] = sum(rPosterior[t, 1:acc] .* likelihood[t, 1:acc]) ./ sum(likelihood[t, 1:acc])
    
                    end
    
                end
                
                iter += 1
    
                if ((iter == maxIter) & (acc < M))
    
                    println("Warning: maximum number of iterations reached at week ", t, " with ", acc, " samples")
                
                    iter = 1 #? basically sampling from same initial samples. Is there a better way?
                    k += 1
    
                end
            end
            storedI = storedITimet
            stop_time = time_ns()
            runTime[t] = (stop_time - st_time) / 1e9
            totalIterations[t] = iter + (k - 1) * maxIter
    
        end
    
        #calculate summary statistics
        means = sum(rPosterior .* likelihood, dims=2) ./ sum(likelihood, dims=2)
        means[1] = NaN
    
        cri = fill(NaN, totalWeeks, 2)
        for i in 2:totalWeeks
            cri[i, 1] = quantile(rPosterior[i, :], Weights(likelihood[i, :]), 0.025)
            cri[i, 2] = quantile(rPosterior[i, :], Weights(likelihood[i, :]), 0.975)
        end
    
        dictionary = Dict([("means", means), ("cri", cri), ("storedI", storedI), ("likelihood", likelihood), ("rPosterior", rPosterior), ("runTime", runTime), ("totalIterations", totalIterations), ("meanTemp", meanTemp), ("criTemp", criTemp)])
    
    end


function siCalc(siGamPar, P, numWeeksToIntegrate, divisionsPerP)
    tol = 1e-3
    
    numSteps = Int((numWeeksToIntegrate*P + 1)*divisionsPerP + 1)
    totalDomain = LinRange(0, numWeeksToIntegrate + (1 / P), numSteps)
    
    gamPdf(x) = pdf(Gamma(siGamPar[1], siGamPar[2]), x)
    
    totalProb, err = quadgk(gamPdf, 0, Inf)
    if abs(totalProb - 1) > tol
        error("Error: The value is not close enough to 1.")
    end
    
    wP = zeros(numWeeksToIntegrate * P)
    
    for i in 1:(numWeeksToIntegrate * P)
        tmpIdx = ((i - 1) * divisionsPerP + 1):((i + 1) * divisionsPerP + 1)
        tmpDomain = totalDomain[tmpIdx]
        wP[i] = trapz(tmpDomain, tentFunction(i, P, tmpDomain).*gamPdf(tmpDomain))
    end
    
    wP[1] += 1 - sum(wP)
    
 wP
end

function siCalcNew(siGamPar, P, numWeeksToIntegrate, divisionsPerP)
    
    # the difference in this function is that we calculate the 0 day contribution separately and then add it
    # to the 1 day contribution. We then normalize.
    tol = 1e-3
    
    numSteps = Int((numWeeksToIntegrate*P + 1)*divisionsPerP + 1)
    totalDomain = LinRange(0, numWeeksToIntegrate + (1 / P), numSteps)
    
    gamPdf(x) = pdf(Gamma(siGamPar[1], siGamPar[2]), x)
    
    totalProb, err = quadgk(gamPdf, 0, Inf)
    if abs(totalProb - 1) > tol
        error("Error: The value is not close enough to 1.")
    end
    
    wP = zeros(numWeeksToIntegrate * P)
    
    for i in 1:(numWeeksToIntegrate * P)
        tmpIdx = ((i - 1) * divisionsPerP + 1):((i + 1) * divisionsPerP + 1)
        tmpDomain = totalDomain[tmpIdx]

        wP[i] = trapz(tmpDomain, tentFunction(i, P, tmpDomain).*gamPdf(tmpDomain))
    end

    tmpIdx = (1 - divisionsPerP):(divisionsPerP + 1)
    tmpDomain = LinRange(-1/P, 1/P, (2*divisionsPerP + 1))
    wP[1] += trapz(tmpDomain, tentFunction(0, P, tmpDomain).*gamPdf(tmpDomain))

    wP = wP ./ sum(wP)
    
 wP
end

function siCalcCori(meanAndStd, P, numWeeksToIntegrate, divisionsPerP)
    
    # the difference in this function is that we calculate the 0 day contribution separately and then add it
    # to the 1 day contribution. We then normalize.
    tol = 1e-3
    
    numSteps = Int((numWeeksToIntegrate*P + 1)*divisionsPerP + 1)
    totalDomain = LinRange(0, numWeeksToIntegrate + (1 / P), numSteps)
    
    shape = ((meanAndStd[1]-1) / meanAndStd[2])^2
    scale = meanAndStd[2]^2 / (meanAndStd[1]-1)

    gamPdf(x) = pdf(Gamma(shape, scale), x)
    
    totalProb, err = quadgk(gamPdf, 0, Inf)
    if abs(totalProb - 1) > tol
        error("Error: The value is not close enough to 1.")
    end
    
    wP = zeros(numWeeksToIntegrate * P)
    
    for i in 1:(numWeeksToIntegrate * P)
        tmpIdx = ((i - 1) * divisionsPerP + 1):((i + 1) * divisionsPerP + 1)
        tmpDomain = totalDomain[tmpIdx]

        wP[i] = trapz(tmpDomain, tentFunction(i, P, tmpDomain).*gamPdf(tmpDomain))
    end

    tmpIdx = (1 - divisionsPerP):(divisionsPerP + 1)
    tmpDomain = LinRange(-1/P, 1/P, (2*divisionsPerP + 1))
    wP[1] += trapz(tmpDomain, tentFunction(0, P, tmpDomain).*gamPdf(tmpDomain))

    wP = wP ./ sum(wP)
    
 wP
end

function generateIncidence(day1I, trueWeeklyR, wDaily, PoissonOrRound, probReported, trueP)
    wDailyLength = length(wDaily)
    totalWeeks = length(trueWeeklyR)
    totalDays = totalWeeks * trueP
    dailyI = [day1I; zeros(totalDays-1)]


        for j in 2:trueP
            daysConsidered = min(wDailyLength, j-1)
            if PoissonOrRound == "P"
                dailyI[j] = rand(Poisson(trueWeeklyR[1] * sum(wDaily[daysConsidered:-1:1].*dailyI[(j-daysConsidered):(j-1)])))
            elseif PoissonOrRound == "R"
                dailyI[j] = round(trueWeeklyR[1] * dot(wDaily[daysConsidered:-1:1], dailyI[(j-daysConsidered):(j-1)]))
            end
        end


    for i in 2:totalWeeks
        for j in 1:trueP
            currentDay = (i-1) * trueP + j
            daysConsidered = min(wDailyLength, currentDay-1)
            if PoissonOrRound == "P"
                dailyI[(i-1)*trueP+j] = rand(Poisson(trueWeeklyR[i] * sum(wDaily[daysConsidered:-1:1].*dailyI[(currentDay - daysConsidered):(currentDay-1)])))
            elseif PoissonOrRound == "R"
                dailyI[(i-1)*trueP+j] = round(trueWeeklyR[i] * dot(wDaily[daysConsidered:-1:1], dailyI[(currentDay - daysConsidered):(currentDay-1)]))
            end
        end
    end

    weeklyI = reshape(dailyI, trueP, totalWeeks)
    weeklyI = sum(weeklyI, dims=1)[:]

    reportedWeeklyI = [rand(Binomial(Int(n), probReported)) for n in weeklyI]

     Dict("weeklyI" => weeklyI, "dailyI" => dailyI, "reportedWeeklyI" => reportedWeeklyI)
end

function generateIncidenceVaryRho(day1I, trueWeeklyR, wDaily, PoissonOrRound, probReported, trueP)
    wDailyLength = length(wDaily)
    totalWeeks = length(trueWeeklyR)
    totalDays = totalWeeks * trueP
    dailyI = [day1I; zeros(totalDays-1)]
    probsConsidered = length(probReported)

    reportedWeeklyI = zeros(Int64, probsConsidered, totalWeeks)


        for j in 2:trueP
            daysConsidered = min(wDailyLength, j-1)
            if PoissonOrRound == "P"
                dailyI[j] = rand(Poisson(trueWeeklyR[1] * sum(wDaily[daysConsidered:-1:1].*dailyI[(j-daysConsidered):(j-1)])))
            elseif PoissonOrRound == "R"
                dailyI[j] = round(trueWeeklyR[1] * dot(wDaily[daysConsidered:-1:1], dailyI[(j-daysConsidered):(j-1)]))
            end
        end


    for i in 2:totalWeeks
        for j in 1:trueP
            currentDay = (i-1) * trueP + j
            daysConsidered = min(wDailyLength, currentDay-1)
            if PoissonOrRound == "P"
                dailyI[(i-1)*trueP+j] = rand(Poisson(trueWeeklyR[i] * sum(wDaily[daysConsidered:-1:1].*dailyI[(currentDay - daysConsidered):(currentDay-1)])))
            elseif PoissonOrRound == "R"
                dailyI[(i-1)*trueP+j] = round(trueWeeklyR[i] * dot(wDaily[daysConsidered:-1:1], dailyI[(currentDay - daysConsidered):(currentDay-1)]))
            end
        end
    end

    weeklyI = reshape(dailyI, trueP, totalWeeks)
    weeklyI = sum(weeklyI, dims=1)[:]

    for i in 1:probsConsidered
        reportedWeeklyI[i, :] = [rand(Binomial(Int(n), probReported[i])) for n in weeklyI]
    end

     Dict("weeklyI" => weeklyI, "dailyI" => dailyI, "reportedWeeklyI" => reportedWeeklyI)

end

function generateStutteringIncidence(day1I, trueWeeklyRInitial, trueWeeklyRFinal, wDaily, PoissonOrRound, probReported, trueP, thresholdlIncidence, thresholdWeeks)
    #this function generates incidence data for a disease that has a stuttering pattern, and in particular does not pre-allocate the number weeks
    #where the the disease is growing.
    
    wDailyLength = length(wDaily)

    dailyI = [day1I]
    #next week simulation
    k=1

    push!(dailyI, rand(Poisson(trueWeeklyRInitial * sum(wDaily[1].*dailyI))))

    for j in 3:trueP
        daysConsidered = min(wDailyLength, j-1)
        if PoissonOrRound == "P"
            push!(dailyI, rand(Poisson(trueWeeklyRInitial * sum(wDaily[daysConsidered:-1:1].*dailyI[(j-daysConsidered):(j-1)]))))
        elseif PoissonOrRound == "R"
            push!(dailyI, round(trueWeeklyRInitial * dot(wDaily[daysConsidered:-1:1], dailyI[(j-daysConsidered):(j-1)])))
        end
    end


    while (sum(dailyI[end-trueP+1:end]) <= thresholdlIncidence) & (k<thresholdWeeks) 
        for j in 1:trueP
            currentDay = k * trueP + j
            daysConsidered = min(wDailyLength, currentDay-1)
            if PoissonOrRound == "P"
                push!(dailyI, rand(Poisson(trueWeeklyRInitial * sum(wDaily[daysConsidered:-1:1].*dailyI[(currentDay - daysConsidered):(currentDay-1)]))))
            elseif PoissonOrRound == "R"
                push!(dailyI, round(trueWeeklyRInitial * dot(wDaily[daysConsidered:-1:1], dailyI[(currentDay - daysConsidered):(currentDay-1)])))
            end
        end
        k+=1
    end

    for i = 1:length(trueWeeklyRFinal)
        for j in 1:trueP
            currentDay = (i+k-1) * trueP + j
            daysConsidered = min(wDailyLength, currentDay-1)
            if PoissonOrRound == "P"
                push!(dailyI, rand(Poisson(trueWeeklyRFinal[i] * sum(wDaily[daysConsidered:-1:1].*dailyI[(currentDay - daysConsidered):(currentDay-1)]))))
            elseif PoissonOrRound == "R"
                push!(dailyI, round(trueWeeklyRFinal[i] * dot(wDaily[daysConsidered:-1:1], dailyI[(currentDay - daysConsidered):(currentDay-1)])))
            end
        end
    end

    totalWeeks = length(dailyI) ÷ trueP

    weeklyI = reshape(dailyI, trueP, totalWeeks)
    weeklyI = sum(weeklyI, dims=1)[:]

    reportedWeeklyI = [rand(Binomial(Int(n), probReported)) for n in weeklyI]

     Dict("weeklyI" => weeklyI, "dailyI" => dailyI, "reportedWeeklyI" => reportedWeeklyI)
end

function tentFunction(k, P, u)
     1 .- P * abs.(u .- (k / P))
end

function likeliCalcInvBin(x, rho, maxVal)
    # We need to calculate the probability that n takes various values.
    # We do this from n = x to n = the MLE + numberOfStandDev * standard deviation (if n took the MLE) so that we get a reasonably large domain to look over
    
    nSupport = x:maxVal
    prob = zeros(maxVal+1) # we add 1 to include the 0 case
    
    for n in nSupport
        prob[n+1] = pdf(Binomial(n, rho), x)
    end
    
    # Need to get rid of probabilities so small they are 0, as once normalized will turn to NaNs
    if all(prob .== 0) || isnan(sum(prob))
        error("Inverse Binomial PMF cannot be calculated. Incidence could be too large?")
    end
    
    prob ./= sum(prob)
end

function generateMultinomialSamples(input_vector::Vector{Int}, P::Int)
    M = length(input_vector)
    output_vector = zeros(P, M)
    
    for i in 1:M
        probs = ones(Float64, P) / P
        sample = rand(Multinomial(input_vector[i], probs))
        output_vector[:, i] = sample
    end
    
    output_vector
end

function reSampling(M, maxIter, P, storedI, weeklyRepI1, t, priorRShapeScale, sampleI)

    if (t >= 3)
    
        sampleIdx = sample(1:M, maxIter, replace = true)
        sampleI = storedI[:, sampleIdx]

    elseif (t == 2)

        weeklyI1 = Int(weeklyRepI1)
        sampleI[1:P, :] = generateMultinomialSamples(fill(weeklyI1, maxIter), P)

    end

    #sampling R in one go is a good idea regardless of t
    sampleR = rand(Gamma(priorRShapeScale[1], priorRShapeScale[2]), maxIter)

    return Dict("sampleI" => sampleI, "sampleR" => sampleR)

end