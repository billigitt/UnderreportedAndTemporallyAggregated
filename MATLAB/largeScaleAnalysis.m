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

set(groot, 'defaultAxesTickLabelInterpreter','tex');
set(groot, 'defaultLegendInterpreter','tex');
set(0, 'DefaultTextInterpreter', 'tex')

load('../MATs/largeScaleStudyCluster.mat')
load('../MATs/largeScaleAnalysisOurEE.mat')
load('../MATs/SIWeekly.mat')

% colour scheme: blue (row 1) is EpiEstim, red (row 2) is original method
% (temp agg), green (row 3) is new method (temp agg + under-rep)
% 
colourMat = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.5*0.4660 0.5*0.6740 0.5*0.1880];

%%

cri95WidthThreshold = (icdf('Gamma', 0.975, 1, 3) - icdf('Gamma', 0.025, 1, 3))*0.5;

meansEE = means;
cisEE = cis;
w = SIWeekly.wWeekly;

largeScaleStudyRaw = largeScaleStudyCluster;

idxOfNaNs = 1:11:(11*9*999+11*8+1);
idxOfFirsts = 1:10:(10*9*999+10*8+1);

largeScaleStudyFinal = largeScaleStudyRaw;
largeScaleStudyFinal(idxOfNaNs, :) = [];

reportedWeeklyIPast = largeScaleStudyRaw.reportedWeeklyI;
reportedWeeklyIPast = reshape(reportedWeeklyIPast, [11, 9000]);
reportedWeeklyIPast(end, :) = [];

% We want to remove the t=1 contributions, where we are unable to infer Rt.
% idxOfNans corresponds to these values.

largeScaleCrIWidth = largeScaleStudyFinal.upperRt - largeScaleStudyFinal.lowerRt;
idxUninformative = largeScaleCrIWidth > cri95WidthThreshold;
idxInformative = largeScaleCrIWidth < cri95WidthThreshold;
largeScaleCrIWidth(idxUninformative) = nan;

largeScaleCrIWidthEE = cis(:, 1) - cis(:, 2);
idxUninformativeEE = largeScaleCrIWidthEE > cri95WidthThreshold;
idxInformativeEE = largeScaleCrIWidthEE < cri95WidthThreshold;
largeScaleCrIWidthEE(idxUninformativeEE) = nan;

logicalTotalCoverage = ((largeScaleStudyFinal.trueR >= largeScaleStudyFinal.lowerRt) & (largeScaleStudyFinal.trueR <= largeScaleStudyFinal.upperRt));

overallTotalCoverage = sum(logicalTotalCoverage(idxInformative))/length(logicalTotalCoverage(idxInformative));

logicalTotalCoverage(idxUninformative) = false;
logicalCoverageBySim = reshape(logicalTotalCoverage, [10, 9000]);
consideredInferencesBySim = reshape(idxInformative, [10, 9000]);

coverageBySim = sum(logicalCoverageBySim, 1)./sum(consideredInferencesBySim, 1);

absoluteRelativeError = abs(largeScaleStudyFinal.trueR - largeScaleStudyFinal.meanRt)./largeScaleStudyFinal.trueR;

mean(absoluteRelativeError)

absoluteRelativeErrorNaiveEE = abs(largeScaleStudyFinal.trueR - meansEE)./largeScaleStudyFinal.trueR;
mean(absoluteRelativeErrorNaiveEE)

logicalCoverageNaiveEE = (cisEE(:, 2) <= largeScaleStudyFinal.trueR) & (cisEE(:, 1) >= largeScaleStudyFinal.trueR);
overallNaiveEECoverage = sum(logicalCoverageNaiveEE)/length(logicalCoverageNaiveEE);

logicalCoverageNaiveEE(idxUninformativeEE) = false;
logicalCoverageNaiveEEBySim = reshape(logicalCoverageNaiveEE, [10, 9000]);
consideredInferencesBySimEE = reshape(idxInformativeEE, [10, 9000]);
coverageBySimNaiveEE = sum(logicalCoverageNaiveEEBySim, 1)./sum(consideredInferencesBySimEE, 1);

idxRho1 = reshape((0:90:(90000-90))+(1:10)', [], 1);
idxRho2 = reshape((10:90:(90000-80))+(1:10)', [], 1);
idxRho3 = reshape((20:90:(90000-70))+(1:10)', [], 1);
idxRho4 = reshape((30:90:(90000-60))+(1:10)', [], 1);
idxRho5 = reshape((40:90:(90000-50))+(1:10)', [], 1);
idxRho6 = reshape((50:90:(90000-40))+(1:10)', [], 1);
idxRho7 = reshape((60:90:(90000-30))+(1:10)', [], 1);
idxRho8 = reshape((70:90:(90000-20))+(1:10)', [], 1);
idxRho9 = reshape((80:90:(90000-10))+(1:10)', [], 1);
 
logicalRho1 = false*ones(1, 9e4);
logicalRho1(idxRho1) = true;
logicalRho1(idxUninformative) = false;
logicalRho1 = logical(logicalRho1);

logicalRho2 = false*ones(1, 9e4);
logicalRho2(idxRho2) = true;
logicalRho2(idxUninformative) = false;
logicalRho2 = logical(logicalRho2);

logicalRho3 = false*ones(1, 9e4);
logicalRho3(idxRho3) = true;
logicalRho3(idxUninformative) = false;
logicalRho3 = logical(logicalRho3);

logicalRho4 = false*ones(1, 9e4);
logicalRho4(idxRho4) = true;
logicalRho4(idxUninformative) = false;
logicalRho4 = logical(logicalRho4);

logicalRho5 = false*ones(1, 9e4);
logicalRho5(idxRho5) = true;
logicalRho5(idxUninformative) = false;
logicalRho5 = logical(logicalRho5);

logicalRho6 = false*ones(1, 9e4);
logicalRho6(idxRho6) = true;
logicalRho6(idxUninformative) = false;
logicalRho6 = logical(logicalRho6);

logicalRho7 = false*ones(1, 9e4);
logicalRho7(idxRho7) = true;
logicalRho7(idxUninformative) = false;
logicalRho7 = logical(logicalRho7);

logicalRho8 = false*ones(1, 9e4);
logicalRho8(idxRho8) = true;
logicalRho8(idxUninformative) = false;
logicalRho8 = logical(logicalRho8);

logicalRho9 = false*ones(1, 9e4);
logicalRho9(idxRho9) = true;
logicalRho9(idxUninformative) = false;
logicalRho9 = logical(logicalRho9);

logicalRhoEE1 = false*ones(1, 9e4);
logicalRhoEE1(idxRho1) = true;
logicalRhoEE1(idxUninformativeEE) = false;
logicalRhoEE1 = logical(logicalRhoEE1);

logicalRhoEE2 = false*ones(1, 9e4);
logicalRhoEE2(idxRho2) = true;
logicalRhoEE2(idxUninformativeEE) = false;
logicalRhoEE2 = logical(logicalRhoEE2);

logicalRhoEE3 = false*ones(1, 9e4);
logicalRhoEE3(idxRho3) = true;
logicalRhoEE3(idxUninformativeEE) = false;
logicalRhoEE3 = logical(logicalRhoEE3);

logicalRhoEE4 = false*ones(1, 9e4);
logicalRhoEE4(idxRho4) = true;
logicalRhoEE4(idxUninformativeEE) = false;
logicalRhoEE4 = logical(logicalRhoEE4);

logicalRhoEE5 = false*ones(1, 9e4);
logicalRhoEE5(idxRho5) = true;
logicalRhoEE5(idxUninformativeEE) = false;
logicalRhoEE5 = logical(logicalRhoEE5);

logicalRhoEE6 = false*ones(1, 9e4);
logicalRhoEE6(idxRho6) = true;
logicalRhoEE6(idxUninformativeEE) = false;
logicalRhoEE6 = logical(logicalRhoEE6);

logicalRhoEE7 = false*ones(1, 9e4);
logicalRhoEE7(idxRho7) = true;
logicalRhoEE7(idxUninformativeEE) = false;
logicalRhoEE7 = logical(logicalRhoEE7);

logicalRhoEE8 = false*ones(1, 9e4);
logicalRhoEE8(idxRho8) = true;
logicalRhoEE8(idxUninformativeEE) = false;
logicalRhoEE8 = logical(logicalRhoEE8);

logicalRhoEE9 = false*ones(1, 9e4);
logicalRhoEE9(idxRho9) = true;
logicalRhoEE9(idxUninformativeEE) = false;
logicalRhoEE9 = logical(logicalRhoEE9);


coverageByRho = [sum(logicalTotalCoverage(logicalRho1))/length(logicalTotalCoverage(logicalRho1)),...
    sum(logicalTotalCoverage(logicalRho2))/length(logicalTotalCoverage(logicalRho2)),...
    sum(logicalTotalCoverage(logicalRho3))/length(logicalTotalCoverage(logicalRho3)),...
    sum(logicalTotalCoverage(logicalRho4))/length(logicalTotalCoverage(logicalRho4)),...
    sum(logicalTotalCoverage(logicalRho5))/length(logicalTotalCoverage(logicalRho5)),...
    sum(logicalTotalCoverage(logicalRho6))/length(logicalTotalCoverage(logicalRho6)),...
    sum(logicalTotalCoverage(logicalRho7))/length(logicalTotalCoverage(logicalRho7)),...
    sum(logicalTotalCoverage(logicalRho8))/length(logicalTotalCoverage(logicalRho8)),...
    sum(logicalTotalCoverage(logicalRho9))/length(logicalTotalCoverage(logicalRho9))];

coverageEEByRho = [sum(logicalCoverageNaiveEE(logicalRhoEE1))/length(logicalCoverageNaiveEE(logicalRhoEE1)),...
    sum(logicalCoverageNaiveEE(logicalRhoEE2))/length(logicalCoverageNaiveEE(logicalRhoEE2)),...
    sum(logicalCoverageNaiveEE(logicalRhoEE3))/length(logicalCoverageNaiveEE(logicalRhoEE3)),...
    sum(logicalCoverageNaiveEE(logicalRhoEE4))/length(logicalCoverageNaiveEE(logicalRhoEE4)),...
    sum(logicalCoverageNaiveEE(logicalRhoEE5))/length(logicalCoverageNaiveEE(logicalRhoEE5)),...
    sum(logicalCoverageNaiveEE(logicalRhoEE6))/length(logicalCoverageNaiveEE(logicalRhoEE6)),...
    sum(logicalCoverageNaiveEE(logicalRhoEE7))/length(logicalCoverageNaiveEE(logicalRhoEE7)),...
    sum(logicalCoverageNaiveEE(logicalRhoEE8))/length(logicalCoverageNaiveEE(logicalRhoEE8)),...
    sum(logicalCoverageNaiveEE(logicalRhoEE9))/length(logicalCoverageNaiveEE(logicalRhoEE9))];

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

rhoToRepeat = [0.1*ones(10, 1); 0.2*ones(10, 1); 0.3*ones(10, 1); 0.4*ones(10, 1); 0.5*ones(10, 1); 0.6*ones(10, 1); 0.7*ones(10, 1); 0.8*ones(10, 1); 0.9*ones(10, 1)];
largeScaleStudyFinal.rho = repmat(rhoToRepeat, 1000, 1);



% figure
% histogram(100*signedRelativeError, 'Normalization', 'probability')
% xticks(0:25:150)
% xticklabels({'0', '25', '50', '75', '100'})
% yticks(0:0.05:0.25)
% yticklabels({'0', '5', '10', '15', '20', '25'})
% xlim([-125 125])
% xlabel('Relative error (%)')
% ylabel('Percentage of inferences (%)')



%%


figure

subplot(1, 3, 1)
b = boxchart(largeScaleStudyFinal.rho(idxInformative), 100*abs(largeScaleStudyFinal.meanRt(idxInformative)-largeScaleStudyFinal.trueR(idxInformative))./largeScaleStudyFinal.trueR(idxInformative), 'BoxWidth', 0.05, 'MarkerStyle', 'none');
b.BoxFaceColor = colourMat(3, :);
xlim([0 1])
ylim([0 80])
xticks(0.1:0.1:0.9)
xlim([0.05 0.95])
ylabel('Relative error (%)')
xlabel('Reporting rate, \rho')


subplot(1, 3, 2)
b = boxchart(largeScaleStudyFinal.rho(idxInformative), (largeScaleStudyFinal.upperRt(idxInformative)-largeScaleStudyFinal.lowerRt(idxInformative)), 'BoxWidth', 0.05, 'MarkerStyle', 'none');
b.BoxFaceColor = colourMat(3, :);
xlim([0 1])
ylim([0 6])
xticks(0.1:0.1:0.9)
xlim([0.05 0.95])
ylabel('95% CrI width')
xlabel('Reporting rate, \rho')

subplot(1, 3, 3)
yline(95, 'k--', 'LineWidth', 1.5)
hold on
pp = plot(0.1:0.1:0.9, 100*coverageByRho, 'color', colourMat(3,:));
gg = plot(0.1:0.1:0.9, 100*coverageEEByRho, 'color', colourMat(1, :));
% yline(100*overallTotalCoverage, )
% yline(100*overallNaiveEECoverage)

ylim([60 100])
xlabel('Reporting rate, \rho')
ylabel('CrI coverage (%)')
legend([pp gg], "Simulation based"+newline+"(under-reporting)", "Cori (no"+newline+"under-reporting)")
xticks(0.1:0.1:0.9)
xlim([0.05 0.95])
box off
% set(gcf, 'color', 'none') ;
% figure
% 
% scatter(largeScaleStudyFinal.reportedWeeklyI, absoluteRelativeErrorNaiveEE)
% hold on
% scatter(largeScaleStudyFinal.reportedWeeklyI, absoluteRelativeError)
% plot(differentReportsVector, meansByReportingEE)
% plot(differentReportsVector, meansByReportingSims)
% set(gca,'yscale','log')

% figure
% 
% scatter(infectiousPotential, absoluteRelativeErrorNaiveEE)
% set(gca,'yscale','log')
% figure
% scatter(infectiousPotential, absoluteRelativeError)
% set(gca,'yscale','log')

figure
subplot(1, 2, 1)
histogram(100*absoluteRelativeError(idxInformative), 'Normalization', 'probability', 'FaceColor', colourMat(3, :))
hold on
histogram(100*absoluteRelativeErrorNaiveEE(idxInformativeEE), 'Normalization', 'probability', 'FaceColor', colourMat(1, :))
xticks(0:25:150)
xticklabels({'0', '25', '50', '75', '100'})
yticks(0:0.05:0.25)
yticklabels({'0', '5', '10', '15', '20', '25'})
xlim([0 100])
xlabel('Relative error (%)')
ylabel('Percentage of inferences (%)')
xline(mean(absoluteRelativeErrorNaiveEE(idxInformativeEE))*100, '--', 'color', colourMat(1, :), 'LineWidth', 2)
xline(mean(absoluteRelativeError(idxInformative))*100, '--', 'color', colourMat(3, :), 'LineWidth', 2)
box off
subplot(1, 2, 2)

histogram(coverageBySim, 'Normalization', 'probability', 'FaceColor', colourMat(3, :), 'BinEdges', -0.05:0.1:1.05)
hold on
histogram(coverageBySimNaiveEE, 'Normalization', 'probability', 'FaceColor', colourMat(1, :), 'BinEdges', -0.05:0.1:1.05)
yticks(0:0.1:0.6)
yticklabels({'0', '10', '20', '30', '40', '50', '60'})
xline(mean(coverageBySim), '--','color', colourMat(3, :), 'LineWidth', 2)
xline(mean(coverageBySimNaiveEE), '--', 'color', colourMat(1, :), 'LineWidth', 2)
xlim([0 1.05])
xticks(0:0.1:1)
xticklabels({'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'})
ylabel('Percentage of simulations (%)')
xlabel('CrI coverage (%)')

legend("Simulation based"+newline+"(under-reporting)", "Cori (no"+newline+"under-reporting)")
box off
% set(gcf, 'color', 'none') ;

% Fig to show that coverage  does not change with rho

disp("Percentage of times that EE had smaller error than Simulation: "+num2str(100*sum(absoluteRelativeErrorNaiveEE<=absoluteRelativeError)/length(absoluteRelativeError)))