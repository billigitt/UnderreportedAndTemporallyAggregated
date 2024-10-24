clear all
close all

set(0,'DefaultFigureWindowStyle','normal')
set(0,'DefaultTextInterpreter', 'none')
set(0,'defaultAxesTickLabelInterpreter','none');
set(0, 'defaultLegendInterpreter','none')
set(0, 'defaultaxesfontsize', 18)
set(0, 'defaultlinelinewidth', 1.5)

set(0, 'DefaultAxesFontName', 'aakar');
set(0, 'DefaultTextFontName', 'aakar');
set(0, 'defaultUicontrolFontName', 'aakar');
set(0, 'defaultUitableFontName', 'aakar');
set(0, 'defaultUipanelFontName', 'aakar');

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

load('../MATs/noLimitNewMethodPrior1And3.mat')
% load('../MATs/epiEstimImperfectInfoLargeScaleStudy.mat')
load('../MATs/SIWeekly.mat')

addpath('ownEpiEstim')

largeScaleStudyRaw = noLimitNewMethodPrior1And3;

T = 11;

nInferences = length(largeScaleStudyRaw.reportedWeeklyI)/T;

means = zeros(nInferences*(T-1), 1);
cis = zeros(nInferences*(T-1), 2);

for i = 1:nInferences
    
    inputStruct = struct('PriorPar', [1 3], 'W', [0; SIWeekly.wWeekly]', 'I', largeScaleStudyRaw.reportedWeeklyI((T*(i-1)+1):i*T)', 'tau', 1);
    outputStruct = R_Time_Series_EpiEstim(inputStruct);
    means(((i-1)*(T-1)+1):(i*(T-1))) = outputStruct.Means;
    cis(((i-1)*(T-1)+1):(i*(T-1)), :) = outputStruct.CIs';
    
end

save('largeScaleAnalysisOurEE.mat', 'means', 'cis')
