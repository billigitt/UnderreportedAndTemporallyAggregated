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

load('../MATs/largeScaleStudy.mat')
load('../MATs/epiEstimImperfectInfoLargeScaleStudy.mat')

largeScaleStudyRaw = vertcat(largeScaleStudy, largeScaleStudy2, largeScaleStudy4, largeScaleStudy5);

% We want to remove the t=1 contributions, where we are unable to infer Rt.
% idxOfNans corresponds to these values.
idxOfNaNs = 1:11:(11*6*999+11*5+1);

largeScaleStudyFinal = largeScaleStudyRaw;
largeScaleStudyFinal(idxOfNaNs, :) = [];

logicalTotalCoverage = ((largeScaleStudyFinal.trueR >= largeScaleStudyFinal.lowerRt) & (largeScaleStudyFinal.trueR <= largeScaleStudyFinal.upperRt));

sum(logicalTotalCoverage)/length(logicalTotalCoverage)

logicalCoverageBySim = reshape(logicalTotalCoverage, [10, 6000]);

coverageBySim = sum(logicalCoverageBySim, 1);

absoluteRelativeError = abs(largeScaleStudyFinal.trueR - largeScaleStudyFinal.meanRt)./largeScaleStudyFinal.trueR;
mean(absoluteRelativeError)


trueRWithoutFirstPoint = largeScaleStudyFinal.trueR;
trueRWithoutFirstPoint(1:10:60000-9) = [];
absoluteRelativeErrorNaiveEE = abs(trueRWithoutFirstPoint - epiEstimImperfectInfoLargeScaleStudy.meanRt)./trueRWithoutFirstPoint;
mean(absoluteRelativeErrorNaiveEE)

signedRelativeError = (largeScaleStudyFinal.meanRt - largeScaleStudyFinal.trueR)./largeScaleStudyFinal.trueR;

figure
histogram(100*absoluteRelativeError, 'Normalization', 'probability')
hold on
histogram(100*absoluteRelativeErrorNaiveEE, 'Normalization', 'probability')
xticks(0:25:150)
xticklabels({'0', '25', '50', '75', '100'})
yticks(0:0.05:0.25)
yticklabels({'0', '5', '10', '15', '20', '25'})
xlim([-5 125])
xlabel('Relative error (%)')
ylabel('Percentage of inferences (%)')

legend('Simulation Approach', 'Naive Epi-Estim', 'location', 'best')

figure
histogram(100*signedRelativeError, 'Normalization', 'probability')
xticks(0:25:150)
xticklabels({'0', '25', '50', '75', '100'})
yticks(0:0.05:0.25)
yticklabels({'0', '5', '10', '15', '20', '25'})
xlim([-125 125])
xlabel('Relative error (%)')
ylabel('Percentage of inferences (%)')

figure
histogram(coverageBySim, 'Normalization', 'probability')
yticks(0.1:0.1:0.6)
yticklabels({'10', '20', '30', '40', '50', '60'})
xticks(6:10)
xticklabels({'60', '70', '80', '90', '100'})
xlabel('Relative error (%)')
ylabel('Credible interval coverage (%)')

%%

rhoToRepeat = [0.33*ones(10, 1); 0.43*ones(10, 1); 0.53*ones(10, 1); 0.63*ones(10, 1); 0.73*ones(10, 1); 0.83*ones(10, 1)];
largeScaleStudyFinal.rho = repmat(rhoToRepeat, 1000, 1);
figure
boxchart(largeScaleStudyFinal.rho, 100*abs(largeScaleStudyFinal.meanRt-largeScaleStudyFinal.trueR)./largeScaleStudyFinal.trueR, 'BoxWidth', 0.05, 'MarkerStyle', 'none')

xlim([0.26 0.9])
ylim([0 100])
xticks(0.33:0.1:0.83)

ylabel('Error (%)')
xlabel('$\rho$', 'interpreter', 'latex')


idxRho1 = reshape((0:60:(60000-60))+(1:10)', [], 1);
idxRho2 = reshape((10:60:(60000-50))+(1:10)', [], 1);
idxRho3 = reshape((20:60:(60000-40))+(1:10)', [], 1);
idxRho4 = reshape((30:60:(60000-30))+(1:10)', [], 1);
idxRho5 = reshape((40:60:(60000-20))+(1:10)', [], 1);
idxRho6 = reshape((50:60:(60000-10))+(1:10)', [], 1);

figure
scatter(largeScaleStudyFinal.reportedWeeklyI(idxRho1), 1./(absoluteRelativeError(idxRho1)).^0.3)
