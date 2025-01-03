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

load('../MATs/largeScaleStudyOriginalClusterMaxInc200Prior1And2FirstDay1.mat')
load('../MATs/largeScaleStudyNewClusterMaxInc200Prior1And2FirstDay1.mat')
load('../MATs/largeScaleAnalysisOurEE.mat')
load('../MATs/SIWeekly.mat')

% colour scheme: blue (row 1) is EpiEstim, red (row 2) is original method
% (temp agg), green (row 3) is new method (temp agg + under-rep)
% 

colourMat = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.5*0.4660 0.5*0.6740 0.5*0.1880];

criWidthThreshold = (icdf('Gamma', 0.975, 1, 2) - icdf('Gamma', 0.025, 1, 2))*0.25;

idx1s = 1:11:(11*9*999+11*8+1);

trueR = largeScaleStudyNewClusterMaxInc200Prior12FirstDay1.trueR;
trueR(idx1s) = [];

reportedWeeklyI = largeScaleStudyNewClusterMaxInc200Prior12FirstDay1.reportedWeeklyI;
reportedWeeklyI(idx1s) = [];

%estREE = 
estRNew = largeScaleStudyNewClusterMaxInc200Prior12FirstDay1.meanRt;
estROG = largeScaleStudyOriginalClusterMaxInc200Prior12FirstDay1.meanRt;
estROG(idx1s) = [];
estRNew(idx1s) = [];

%upperREE = 
upperRNew = largeScaleStudyNewClusterMaxInc200Prior12FirstDay1.upperRt;
upperROG = largeScaleStudyOriginalClusterMaxInc200Prior12FirstDay1.upperRt;
upperROG(idx1s) = [];
upperRNew(idx1s) = [];

%lowerREE = 
lowerRNew = largeScaleStudyNewClusterMaxInc200Prior12FirstDay1.lowerRt;
lowerROG = largeScaleStudyOriginalClusterMaxInc200Prior12FirstDay1.lowerRt;
lowerROG(idx1s) = [];
lowerRNew(idx1s) = [];

criWidthOG = upperROG - lowerROG;
criWidthNew = upperRNew - lowerRNew;

idxIncludeOG = (criWidthOG<=criWidthThreshold);
idxIncludeNew = (criWidthNew<=criWidthThreshold);

idxExcludeOG = [];
idxExcludeNew = [];

%error calculations

errorOG = (estROG - trueR);
errorNew = (estRNew - trueR);
errorOG(idxExcludeOG) = [];
errorNew(idxExcludeNew) = [];

coverageOG = (lowerROG <= trueR) & (upperROG >= trueR);
coverageNew = (lowerRNew <= trueR) & (upperRNew >= trueR);

coverageNewAndIncluded = coverageNew(idxIncludeNew);
coverageOGAndIncluded = coverageOG(idxIncludeOG);

sum(coverageNewAndIncluded)/length(coverageNewAndIncluded)
sum(coverageOGAndIncluded)/length(coverageOGAndIncluded)

idxIncorrectCoverageNew = (idxIncludeNew) & (coverageNew == 0);
idxIncorrectCoverageOG = (idxIncludeOG) & (coverageOG == 0);

figure
histogram(reportedWeeklyI(idxIncorrectCoverageNew))
hold on
histogram(reportedWeeklyI(idxIncorrectCoverageOG))

figure
histogram(trueR(idxIncorrectCoverageNew))
hold on
histogram(trueR(idxIncorrectCoverageOG))
histogram(trueR)

%% Plotting


% figure
% 
% subplot(1, 3, 1)
% b = boxchart(largeScaleStudyFinal.rho(idxInformative), 100*abs(largeScaleStudyFinal.meanRt(idxInformative)-largeScaleStudyIncidencesAndTrueRs.trueR(idxInformative))./largeScaleStudyIncidencesAndTrueRs.trueR(idxInformative), 'BoxWidth', 0.05, 'MarkerStyle', 'none');
% b.BoxFaceColor = colourMat(3, :);
% xlim([0 1])
% ylim([0 80])
% xticks(0.1:0.1:0.9)
% xlim([0.05 0.95])
% ylabel('Relative error (%)')
% xlabel('Reporting rate, \rho')
% 
% 
% subplot(1, 3, 2)
% b = boxchart(largeScaleStudyFinal.rho(idxInformative), (largeScaleStudyFinal.upperRt(idxInformative)-largeScaleStudyFinal.lowerRt(idxInformative)), 'BoxWidth', 0.05, 'MarkerStyle', 'none');
% b.BoxFaceColor = colourMat(3, :);
% xlim([0 1])
% ylim([0 6])
% xticks(0.1:0.1:0.9)
% xlim([0.05 0.95])
% ylabel('95% CrI width')
% xlabel('Reporting rate, \rho')
% 
% subplot(1, 3, 3)
% yline(95, 'k--', 'LineWidth', 1.5)
% hold on
% pp = plot(0.1:0.1:0.9, 100*coverageByRho, 'color', colourMat(3,:));
% gg = plot(0.1:0.1:0.9, 100*coverageEEByRho, 'color', colourMat(1, :));
% % yline(100*overallTotalCoverage, )
% % yline(100*overallNaiveEECoverage)
% 
% ylim([60 100])
% xlabel('Reporting rate, \rho')
% ylabel('CrI coverage (%)')
% legend([pp gg], "Simulation based"+newline+"(under-reporting)", "Cori (no"+newline+"under-reporting)")
% xticks(0.1:0.1:0.9)
% xlim([0.05 0.95])
% box off
% % set(gcf, 'color', 'none') ;
% % figure
% % 
% % scatter(largeScaleStudyFinal.reportedWeeklyI, absoluteRelativeErrorNaiveEE)
% % hold on
% % scatter(largeScaleStudyFinal.reportedWeeklyI, absoluteRelativeError)
% % plot(differentReportsVector, meansByReportingEE)
% % plot(differentReportsVector, meansByReportingSims)
% % set(gca,'yscale','log')
% 
% % figure
% % 
% % scatter(infectiousPotential, absoluteRelativeErrorNaiveEE)
% % set(gca,'yscale','log')
% % figure
% % scatter(infectiousPotential, absoluteRelativeError)
% % set(gca,'yscale','log')

figure
histogram(100*errorOG, 'Normalization', 'probability', 'FaceColor', colourMat(3, :), 'FaceAlpha', 0.4)
hold on
histogram(100*errorNew, 'Normalization', 'probability', 'FaceColor', colourMat(1, :), 'FaceAlpha', 0.4)
%xticks(0:25:150)
% xticklabels({'0', '25', '50', '75', '100'})
%yticks(0:0.05:0.25)
% yticklabels({'0', '5', '10', '15', '20', '25'})
% xlim([0 100])
xlabel('Relative error (%)')
ylabel('Percentage of inferences (%)')
% xline(mean(absoluteRelativeErrorNaiveEE(idxInformativeEE))*100, '--', 'color', colourMat(1, :), 'LineWidth', 2)
% xline(mean(absoluteRelativeError(idxInformative))*100, '--', 'color', colourMat(3, :), 'LineWidth', 2)

% 
% histogram(coverageBySim, 'Normalization', 'probability', 'FaceColor', colourMat(3, :), 'BinEdges', -0.05:0.1:1.05)
% hold on
% histogram(coverageBySimNaiveEE, 'Normalization', 'probability', 'FaceColor', colourMat(1, :), 'BinEdges', -0.05:0.1:1.05)
% yticks(0:0.1:0.6)
% yticklabels({'0', '10', '20', '30', '40', '50', '60'})
% xline(mean(coverageBySim), '--','color', colourMat(3, :), 'LineWidth', 2)
% xline(mean(coverageBySimNaiveEE), '--', 'color', colourMat(1, :), 'LineWidth', 2)
% xlim([0 1.05])
% xticks(0:0.1:1)
% xticklabels({'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'})
% ylabel('Percentage of simulations (%)')
% xlabel('CrI coverage (%)')
% 
% legend("Simulation based"+newline+"(under-reporting)", "Cori (no"+newline+"under-reporting)")
% box off
% % set(gcf, 'color', 'none') ;

% Fig to show that coverage  does not change with rho