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
load('../MATs/largeScaleAnalysisOurEE.mat')
load('../MATs/SIWeekly.mat')

%%

meansEE = means;
cisEE = cis;
w = SIWeekly.wWeekly;

largeScaleStudyRaw = vertcat(largeScaleStudy, largeScaleStudy2, largeScaleStudy4, largeScaleStudy5);

idxOfNaNs = 1:11:(11*6*999+11*5+1);
idxOfFirsts = 1:10:(10*6*999+10*5+1);

largeScaleStudyFinal = largeScaleStudyRaw;
largeScaleStudyFinal(idxOfNaNs, :) = [];

reportedWeeklyIPast = largeScaleStudyRaw.reportedWeeklyI;
reportedWeeklyIPast = reshape(reportedWeeklyIPast, [11, 6000]);
reportedWeeklyIPast(end, :) = [];

infectiousPotential = zeros(10, 6000);

for i = 1:10

    infectiousPotential(i, :) = flipud(w(1:i))'*reportedWeeklyIPast(1:i, :);
    
end

reshapedTrueR = reshape(largeScaleStudyFinal.trueR, [10, 6000]);
infectiousPotential = infectiousPotential.*reshapedTrueR;
infectiousPotential = reshape(infectiousPotential, [60000, 1]);

% We want to remove the t=1 contributions, where we are unable to infer Rt.
% idxOfNans corresponds to these values.


logicalTotalCoverage = ((largeScaleStudyFinal.trueR >= largeScaleStudyFinal.lowerRt) & (largeScaleStudyFinal.trueR <= largeScaleStudyFinal.upperRt));

overallTotalCoverage = sum(logicalTotalCoverage)/length(logicalTotalCoverage);

logicalCoverageBySim = reshape(logicalTotalCoverage, [10, 6000]);

coverageBySim = sum(logicalCoverageBySim, 1);

absoluteRelativeError = abs(largeScaleStudyFinal.trueR - largeScaleStudyFinal.meanRt)./largeScaleStudyFinal.trueR;
mean(absoluteRelativeError)

absoluteRelativeErrorNaiveEE = abs(largeScaleStudyFinal.trueR - meansEE)./largeScaleStudyFinal.trueR;
mean(absoluteRelativeErrorNaiveEE)

logicalCoverageNaiveEE = (cisEE(:, 2) <= largeScaleStudyFinal.trueR) & (cisEE(:, 1) >= largeScaleStudyFinal.trueR);
overallNaiveEECoverage = sum(logicalCoverageNaiveEE)/length(logicalCoverageNaiveEE);
logicalCoverageNaiveEEBySim = reshape(logicalCoverageNaiveEE, [10, 6000]);
coverageBySimNaiveEE = sum(logicalCoverageNaiveEEBySim, 1);


signedRelativeError = (largeScaleStudyFinal.meanRt - largeScaleStudyFinal.trueR)./largeScaleStudyFinal.trueR;
signedRelativeError(idxOfFirsts) = [];

idxRho1 = reshape((0:60:(60000-60))+(1:10)', [], 1);
idxRho2 = reshape((10:60:(60000-50))+(1:10)', [], 1);
idxRho3 = reshape((20:60:(60000-40))+(1:10)', [], 1);
idxRho4 = reshape((30:60:(60000-30))+(1:10)', [], 1);
idxRho5 = reshape((40:60:(60000-20))+(1:10)', [], 1);
idxRho6 = reshape((50:60:(60000-10))+(1:10)', [], 1);

idxRhoEE1 = reshape((0:54:(54000-54))+(1:9)', [], 1);
idxRhoEE2 = reshape((9:54:(54000-45))+(1:9)', [], 1);
idxRhoEE3 = reshape((18:54:(54000-36))+(1:9)', [], 1);
idxRhoEE4 = reshape((27:54:(54000-27))+(1:9)', [], 1);
idxRhoEE5 = reshape((36:54:(54000-18))+(1:9)', [], 1);
idxRhoEE6 = reshape((45:54:(54000-9))+(1:9)', [], 1);


coverageByRho = [sum(logicalTotalCoverage(idxRho1))/length(logicalTotalCoverage(idxRho1)),...
    sum(logicalTotalCoverage(idxRho2))/length(logicalTotalCoverage(idxRho2)),...
    sum(logicalTotalCoverage(idxRho3))/length(logicalTotalCoverage(idxRho3)),...
    sum(logicalTotalCoverage(idxRho4))/length(logicalTotalCoverage(idxRho4)),...
    sum(logicalTotalCoverage(idxRho5))/length(logicalTotalCoverage(idxRho5)),...
    sum(logicalTotalCoverage(idxRho6))/length(logicalTotalCoverage(idxRho6))];

coverageEEByRho = [sum(logicalCoverageNaiveEE(idxRho1))/length(logicalCoverageNaiveEE(idxRho1)),...
    sum(logicalCoverageNaiveEE(idxRho2))/length(logicalCoverageNaiveEE(idxRho2)),...
    sum(logicalCoverageNaiveEE(idxRho3))/length(logicalCoverageNaiveEE(idxRho3)),...
    sum(logicalCoverageNaiveEE(idxRho4))/length(logicalCoverageNaiveEE(idxRho4)),...
    sum(logicalCoverageNaiveEE(idxRho5))/length(logicalCoverageNaiveEE(idxRho5)),...
    sum(logicalCoverageNaiveEE(idxRho6))/length(logicalCoverageNaiveEE(idxRho6))];

logical_vector = false(1, max(largeScaleStudyFinal.reportedWeeklyI));
logical_vector(largeScaleStudyFinal.reportedWeeklyI) = true;

differentReports = sum(logical_vector);

differentReportsVector = 1:max(largeScaleStudyFinal.reportedWeeklyI);
differentReportsVector = differentReportsVector(logical_vector);

meansByReportingSims = zeros(length(differentReportsVector), 1);
meansByReportingEE = zeros(length(differentReportsVector), 1);

k = 1;
for i = differentReportsVector
    logicalTmp = (largeScaleStudyFinal.reportedWeeklyI == i);
    
    meansByReportingSims(k) = mean(absoluteRelativeError(logicalTmp));
    meansByReportingEE(k) = mean(absoluteRelativeErrorNaiveEE(logicalTmp));
    k = k + 1;
end

rhoToRepeat = [0.33*ones(10, 1); 0.43*ones(10, 1); 0.53*ones(10, 1); 0.63*ones(10, 1); 0.73*ones(10, 1); 0.83*ones(10, 1)];
largeScaleStudyFinal.rho = repmat(rhoToRepeat, 1000, 1);



figure
histogram(100*signedRelativeError, 'Normalization', 'probability')
xticks(0:25:150)
xticklabels({'0', '25', '50', '75', '100'})
yticks(0:0.05:0.25)
yticklabels({'0', '5', '10', '15', '20', '25'})
xlim([-125 125])
xlabel('Relative error (%)')
ylabel('Percentage of inferences (%)')



%%


figure

subplot(2, 1, 1)
boxchart(largeScaleStudyFinal.rho, 100*abs(largeScaleStudyFinal.meanRt-largeScaleStudyFinal.trueR)./largeScaleStudyFinal.trueR, 'BoxWidth', 0.05, 'MarkerStyle', 'none')

xlim([0.26 0.9])
ylim([0 100])
xticks(0.33:0.1:0.83)

ylabel('Error (%)')
xlabel('$\rho$', 'interpreter', 'latex')


subplot(2, 1, 2)
boxchart(largeScaleStudyFinal.rho, (largeScaleStudyFinal.upperRt-largeScaleStudyFinal.lowerRt), 'BoxWidth', 0.05, 'MarkerStyle', 'none')

xlim([0.26 0.9])
ylim([0 10])
xticks(0.33:0.1:0.83)

ylabel('Credibleinterval width')
xlabel('$\rho$', 'interpreter', 'latex')

figure

scatter(largeScaleStudyFinal.reportedWeeklyI, absoluteRelativeErrorNaiveEE)
hold on
scatter(largeScaleStudyFinal.reportedWeeklyI, absoluteRelativeError)
plot(differentReportsVector, meansByReportingEE)
plot(differentReportsVector, meansByReportingSims)
set(gca,'yscale','log')

figure

scatter(infectiousPotential, absoluteRelativeErrorNaiveEE)
set(gca,'yscale','log')
figure
scatter(infectiousPotential, absoluteRelativeError)
set(gca,'yscale','log')

figure
subplot(2, 2, 1)
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
xline(mean(absoluteRelativeErrorNaiveEE)*100, 'red')
xline(mean(absoluteRelativeError)*100, 'blue')

legend('Simulation Approach', 'Naive Epi-Estim', 'location', 'best')

subplot(2, 2, 2)

histogram(coverageBySim, 'Normalization', 'probability')
hold on
histogram(coverageBySimNaiveEE, 'Normalization', 'probability')
yticks(0.1:0.1:0.6)
yticklabels({'10', '20', '30', '40', '50', '60'})
xticks(6:10)
xticklabels({'60', '70', '80', '90', '100'})
ylabel('Relative frequency (%)')
xlabel('Credible interval coverage (%)')

legend('Simulation Approach', 'Naive Epi-Estim')

% Fig to show that coverage  does not change with rho

subplot(2,2,3)

plot(0.33:0.1:0.83, coverageByRho)
hold on
yline(overallTotalCoverage)
plot(0.33:0.1:0.83, coverageEEByRho)
yline(overallNaiveEECoverage)
xlabel('Reporting rate, $\rho$', 'interpreter', 'latex')
ylabel('Coverage (%)')