%In this script, we run OG1 on the large simulated epidemic data-set.

clearvars
close all
clc

addpath('functions')
addpath('../packages/MatlabToolbox-master') % for weighted quantile calculation

pwd()

load('../MATs/noLimitNewMethodPrior1And3.mat')

incidenceAll = noLimitNewMethodPrior1And3.reportedWeeklyI;

numOutbreaks = 10;
numRhos = 9;

idx = str2num(getenv('SLURM_ARRAY_TASK_ID'));


w = (readtable("../CSVs/siDaily.csv").wTrue)';
priorShapeScale = [1 3];
P = 7;
M = 1e5;
numRhos = 9;

R3DMat = zeros(11, M, numOutbreaks*numRhos);
likeliMat = zeros(11, M, numOutbreaks*numRhos);

OG1CI95R = nan(2, 11, numOutbreaks*numRhos);
OG1meanR = nan(11, numOutbreaks*numRhos);

for outbreak = 1:(numOutbreaks*numRhos)

    
    [R3DMat(:, :, outbreak), ~, likeliMat(:, :, outbreak)] = OG1_RInference_Trick(incidenceAll((((idx-1)*11*10*numRhos) + (outbreak-1)*11+1):(((idx-1)*11*10*numRhos) + (outbreak*11))), w, priorShapeScale, P, M);

    for t = 2:11

        OG1CI95R(:, t, outbreak) = iosr.statistics.quantile(R3DMat(t, :, outbreak), [0.025 0.975], [], [], likeliMat(t, :, outbreak));
        OG1meanR(t, outbreak) = sum(R3DMat(t, :, outbreak).*likeliMat(t, :, outbreak))/sum(likeliMat(t, :, outbreak));

    end

end

OG1meanR = reshape(OG1meanR, [], 1);
OG1lowerR = reshape(squeeze(OG1CI95R(1, :, :)), [], 1);
OG1upperR = reshape(squeeze(OG1CI95R(2, :, :)), [], 1);

idxs = (((idx-1)*11*10*numRhos) + 1):(((idx-1)*11*10*numRhos) + (numRhos*numOutbreaks*11));

incidenceConsidered = incidenceAll(idxs);

%load mat file
load('../MATs/constantRhoOG1Analysis.mat')

OG1meanRMaster(idxs) = OG1meanR;
OG1lowerRMaster(idxs) = OG1lowerR;
OG1upperRMaster(idxs) = OG1upperR;
incidenceMaster(idxs) = incidenceConsidered;

save("../MATs/temporalRhoOG1Analysis.mat", "OG1meanRMaster", "OG1lowerRMaster", ...
    "OG1upperRMaster", "incidenceMaster")
