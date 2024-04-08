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

error = abs(largeScaleStudyFinal.trueR - largeScaleStudyFinal.meanRt)./largeScaleStudyFinal.trueR;
mean(error)

figure
histogram(100*error, 'Normalization', 'probability')
xticks(0:25:150)
xticklabels({'0', '25', '50', '75', '100'})
yticks(0:0.05:0.25)
yticklabels({'0', '5', '10', '15', '20', '25'})
xlim([-5 125])
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
