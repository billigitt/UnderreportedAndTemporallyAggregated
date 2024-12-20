clearvars
clc
close all

%load CSVs of true R numbers

%To do (12th Nov)
%Check that all the EE files are correct
%Replot in new way
%Continue fig1 thing for all EE.

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

addpath('../packages/tight_subplot(Nh, Nw, gap, marg_h, marg_w)')
addpath('functions')

colourMat = [0.9 0.6 0;... %orange 1
    0.35 0.7 0.9;... %sky blue 2
    0 0.6 0.5;... %blueish green 3
    0.9290 0.6940 0.1250;... %yellow 4
    0 0.44 0.7;... %blue 5
    0.8 0.4 0;... %red 6
    0.4940 0.1840 0.5560]; % purple 7

OG1Green = [0.4660 0.6740 0.1880];

%load serial interval for in-script Cori inference

wWeekly = readtable('../CSVs/SIWeekly.csv').wWeekly;

trueInc = readtable("../CSVs/largeScaleStudyIncidencesAndTrueRsNoLimitPrior1And3FirstDay1IncreasingRho.csv");
trueDec = readtable("../CSVs/largeScaleStudyIncidencesAndTrueRsNoLimitPrior1And3FirstDay1DecreasingRho.csv");

trueRhoInc = @(t) (1./(1 + exp(-(t-5.5)*log(9)/3.5)));
infRhoInc = [0.1 0.1 0.1 0.1 0.1 0.5 0.5 0.5 0.5 0.9 0.9 0.9 0.9 0.9];
trueRhoDec = @(t) 1-(1./(1 + exp(-(t-5.5)*log(9)/3.5)));
infRhoDec = [0.9 0.9 0.9 0.9 0.9 0.5 0.5 0.5 0.5 0.1 0.1 0.1 0.1 0.1];

t = 1/7:1/7:11;
% set index for increasing rho inference that we want to look at



%% Error bars plotting



%% Batch 2

% set index for increasing rho inference that we want to look at

idxInc = 14;

% set index for decreasing rho inference that we want to look at

idxDec = 16;

% load analysis files

fileNameOG1Inc = strcat('../CSVs/largeScaleStudyClusterNoLimitIncreasingRhoOG1/largeScaleStudyClusterNoLimitIncreasingRhoOG1_', num2str(idxInc), '.csv');
fileNameOG1Dec = strcat('../CSVs/largeScaleStudyClusterNoLimitDecreasingRhoOG1/largeScaleStudyClusterNoLimitDecreasingRhoOG1_', num2str(idxDec), '.csv');
fileNameOG2Inc = strcat('../CSVs/largeScaleStudyClusterNoLimitIncreasingRhoOG2/largeScaleStudyClusterNoLimitIncreasingRhoOG2_', num2str(idxInc), '.csv');
fileNameOG2Dec = strcat('../CSVs/largeScaleStudyClusterNoLimitDecreasingRhoOG2/largeScaleStudyClusterNoLimitDecreasingRhoOG2_', num2str(idxDec), '.csv');

OG1Inc = readtable(fileNameOG1Inc);
OG1Dec = readtable(fileNameOG1Dec);
OG2Inc = readtable(fileNameOG2Inc);
OG2Dec = readtable(fileNameOG2Dec);

trueRInc = trueInc.trueR((idxInc-1)*11+1:idxInc*11);
trueRDec = trueDec.trueR((idxDec-1)*11+1:idxDec*11);
trueItInc = trueInc.weeklyI((idxInc-1)*11+1:idxInc*11);
trueItDec = trueDec.weeklyI((idxDec-1)*11+1:idxDec*11);
% plot incidence, inference and true R for increasing rho

%Time used for plots of true rho


f = figure;
[ha, pos] = tight_subplot(2, 2, [.1 .18], 0.1, 0.1);
axes(ha(1))
xlabel('Time (\itt\rm weeks)')
yyaxis left
g(3) = bar(trueItInc, 'BarWidth', 1, 'FaceColor', [.5 .5 .5], 'LineStyle', 'none');
hold on
g(4) = bar(OG1Inc.reportedIncidence, 'BarWidth', 1, 'LineStyle', 'none');
xlim([0.5 11.5])
ylabel('Reported incidence')
ax = gca;
ax.YAxis(1).Color = 'k';
yyaxis right
g(1) = plot(0.5+t, trueRhoInc(t), 'k--'); %add on 0.5 because time goes from 0.5 to 1.5 for week 1, 1.5 to 2.5 for week 2, etc.
hold on
g(2) = plot([0.5:4.5, 4.5:7.5, 7.5:11.5], infRhoInc, 'r', 'LineStyle', '-');
ylab = ylabel('Reporting probability, \rho\it\fontsize{11}t');
ylab.Position(1) = 14;
set(get(gca,'YLabel'),'Rotation',270)
ax.YAxis(2).Color = 'r';
legend(g([4 3 1 2]), 'Reported incidence', 'Hidden incidence', ...
    'True \rho\it\fontsize{10}t', 'Model \rho\it\fontsize{10}t', 'Location', 'NorthWest')
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
box off
axes(ha(2))
eeStruct = struct('PriorPar', [1 3], 'W', wWeekly', 'I', OG1Inc.reportedIncidence', 'tau', 1);
eeStructOutput = R_Time_Series_EpiEstim(eeStruct);
h(1) = errorbar((2:11), OG1Inc.meanRt(2:end), OG1Inc.meanRt(2:end) - ...
    OG1Inc.lowerRt(2:end), OG1Inc.upperRt(2:end) - OG1Inc.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', OG1Green, 'MarkerSize', 15);
ylabel(["Time-dependent"+newline+"reproduction number,\it R\fontsize{12}t"])
hold on
h(2) = errorbar((2:11)+0.2, OG2Inc.meanRt(2:end), OG2Inc.meanRt(2:end) - ...
    OG2Inc.lowerRt(2:end), OG2Inc.upperRt(2:end) - OG2Inc.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', colourMat(7, :), 'MarkerSize', 15);

h(4) = errorbar((2:11)-0.2, eeStructOutput.Means, eeStructOutput.Means - ...
    eeStructOutput.CIs(2, :), eeStructOutput.CIs(2, :) - eeStructOutput.Means, '.', ...
    'LineWidth', 2, 'color',colourMat(2, :), 'MarkerSize', 15);
for i=1:10

h(3) = plot([.5+i 1.5+i], repelem(trueRInc(1+i), 2), 'k:');

end
h(1).CapSize = 7.5;
h(2).CapSize = 7.5;
h(4).CapSize = 7.5;
legend(h([4 1 2 3]), 'Cori method', 'OG1 method', 'OG2 method', 'True \itR\fontsize{12}t', 'Location', 'North')
xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
ylim([0 25])
xlim([0.5 11.5])
% plot incidence, inference and true R for decreasing rho
box off
axes(ha(3))
xlabel('Time (\itt\rm weeks)')
yyaxis left
g(3) = bar(trueItInc, 'BarWidth', 1, 'FaceColor', [.5 .5 .5], 'LineStyle', 'none');
hold on
g(4) = bar(OG1Dec.reportedIncidence, 'BarWidth', 1, 'LineStyle', 'none');
xlim([0.5 11.5])
ylabel('Reported incidence')
ax = gca;
ax.YAxis(1).Color = 'k';
yyaxis right
g(1) = plot(0.5+t, trueRhoDec(t), 'k--'); %add on 0.5 because time goes from 0.5 to 1.5 for week 1, 1.5 to 2.5 for week 2, etc.
hold on
g(2) = plot([0.5:4.5, 4.5:7.5, 7.5:11.5], infRhoDec, 'r', 'LineStyle','-');

ylab = ylabel('Reporting probability, \rho\it\fontsize{11}t');
ylab.Position(1) = 14;
set(get(gca,'YLabel'),'Rotation',270)
ax.YAxis(2).Color = 'r';
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
box off
axes(ha(4))
eeStruct = struct('PriorPar', [1 3], 'W', wWeekly', 'I', OG1Dec.reportedIncidence', 'tau', 1);
eeStructOutput = R_Time_Series_EpiEstim(eeStruct);
h(1) = errorbar((2:11), OG1Dec.meanRt(2:end), OG1Dec.meanRt(2:end) - ...
    OG1Dec.lowerRt(2:end), OG1Dec.upperRt(2:end) - OG1Dec.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', OG1Green, 'MarkerSize', 15);
ylabel(["Time-dependent"+newline+"reproduction number,\it R\fontsize{12}t"])
hold on
h(2) = errorbar((2:11)+0.2, OG2Dec.meanRt(2:end), OG2Dec.meanRt(2:end) - ...
    OG2Dec.lowerRt(2:end), OG2Dec.upperRt(2:end) - OG2Dec.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', colourMat(7, :), 'MarkerSize', 15);
h(4) = errorbar((2:11)-0.2, eeStructOutput.Means, eeStructOutput.Means - ...
    eeStructOutput.CIs(2, :), eeStructOutput.CIs(2, :) - eeStructOutput.Means, '.', ...
    'LineWidth', 2, 'color',colourMat(2, :), 'MarkerSize', 15);
for i=1:10

h(3) = plot([.5+i 1.5+i], repelem(trueRDec(1+i), 2), 'k:');

end
h(1).CapSize = 7.5;
h(2).CapSize = 7.5;
h(4).CapSize = 7.5;

xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
set(gcf,'Position',[0 0 1200 850])
xlim([0.5 11.5])
box off
set(gcf, 'color', 'none')


%% Supp fig

% set index for increasing rho inference that we want to look at

idxInc1 = 8;
idxInc2 = 16;

% set index for decreasing rho inference that we want to look at

% load analysis files

fileNameOG1Inc1 = strcat('../CSVs/largeScaleStudyClusterNoLimitIncreasingRhoOG1/largeScaleStudyClusterNoLimitIncreasingRhoOG1_', num2str(idxInc1), '.csv');
fileNameOG1Inc2 = strcat('../CSVs/largeScaleStudyClusterNoLimitIncreasingRhoOG1/largeScaleStudyClusterNoLimitIncreasingRhoOG1_', num2str(idxInc2), '.csv');
fileNameOG2Inc1 = strcat('../CSVs/largeScaleStudyClusterNoLimitIncreasingRhoOG2/largeScaleStudyClusterNoLimitIncreasingRhoOG2_', num2str(idxInc1), '.csv');
fileNameOG2Inc2 = strcat('../CSVs/largeScaleStudyClusterNoLimitIncreasingRhoOG2/largeScaleStudyClusterNoLimitIncreasingRhoOG2_', num2str(idxInc2), '.csv');

OG1Inc1 = readtable(fileNameOG1Inc1);
OG1Inc2 = readtable(fileNameOG1Inc2);
OG2Inc1 = readtable(fileNameOG2Inc1);
OG2Inc2 = readtable(fileNameOG2Inc2);

trueRInc1 = trueInc.trueR((idxInc1-1)*11+1:idxInc1*11);
trueRInc2 = trueInc.trueR((idxInc2-1)*11+1:idxInc2*11);
trueItInc1 = trueInc.weeklyI((idxInc1-1)*11+1:idxInc1*11);
trueItInc2 = trueInc.weeklyI((idxInc2-1)*11+1:idxInc2*11);

f = figure;
[ha, pos] = tight_subplot(4, 2, [0.05 .18], 0.075, 0.05);
axes(ha(1))
% xlabel('Time (\itt\rm weeks)')
yyaxis left
g(3) = bar(trueItInc1, 'BarWidth', 1, 'FaceColor', [.5 .5 .5], 'LineStyle', 'none');
hold on
g(4) = bar(OG1Inc1.reportedIncidence, 'BarWidth', 1, 'LineStyle', 'none');
xlim([0.5 11.5])
% ylab = ylabel('Reported incidence');
% ylab.Position(2) = -2500;
ax = gca;
ax.YAxis(1).Color = 'k';
yyaxis right
g(1) = plot(0.5+t, trueRhoInc(t), 'k--'); %add on 0.5 because time goes from 0.5 to 1.5 for week 1, 1.5 to 2.5 for week 2, etc.
hold on
g(2) = plot([0.5:4.5, 4.5:7.5, 7.5:11.5], infRhoInc, 'r', 'LineStyle', '-');
% ylab = ylabel('Reporting probability, \rho\it(t)');
% ylab.Position(1) = 13.5;
% ylab.Position(2) = 0;
% set(get(gca,'YLabel'),'Rotation',270)
% ax.YAxis(2).Color = 'r';
legend(g([4 3 1 2]), "\fontsize{11}Reported"+newline+"incidence", "\fontsize{11}Hidden"+newline+"incidence", ...
    '\fontsize{11}True \rho\it\fontsize{7}t', '\fontsize{11}Model \rho\it\fontsize{7}t', 'Location', 'NorthWest')
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
box off
axes(ha(2))
eeStruct = struct('PriorPar', [1 3], 'W', wWeekly', 'I', OG1Inc1.reportedIncidence', 'tau', 1);
eeStructOutput = R_Time_Series_EpiEstim(eeStruct);
h(1) = errorbar((2:11), OG1Inc1.meanRt(2:end), OG1Inc1.meanRt(2:end) - ...
    OG1Inc1.lowerRt(2:end), OG1Inc1.upperRt(2:end) - OG1Inc1.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', OG1Green, 'MarkerSize', 15);
% ylab = ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{12}t"]);
% ylab.Position(2) = -20;
hold on
h(2) = errorbar((2:11)+0.2, OG2Inc1.meanRt(2:end), OG2Inc1.meanRt(2:end) - ...
    OG2Inc1.lowerRt(2:end), OG2Inc1.upperRt(2:end) - OG2Inc1.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', colourMat(7, :), 'MarkerSize', 15);
h(4) = errorbar((2:11)-0.2, eeStructOutput.Means, eeStructOutput.Means - ...
    eeStructOutput.CIs(2, :), eeStructOutput.CIs(2, :) - eeStructOutput.Means, '.', ...
    'LineWidth', 2, 'color',colourMat(2, :), 'MarkerSize', 15);
for i=1:10

h(3) = plot([.5+i 1.5+i], repelem(trueRInc1(1+i), 2), 'k:');

end
h(1).CapSize = 7.5;
h(2).CapSize = 7.5;
h(4).CapSize = 7.5;
legend(h([4 1 2 3]), '\fontsize{11}Cori method',  '\fontsize{11}OG1 method', '\fontsize{11}OG2 method', '\fontsize{11}True \itR\fontsize{9}t', 'Position', [.8 .88 0 0])
% xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)

xlim([0.5 11.5])
% plot incidence, inference and true R for decreasing rho
box off
axes(ha(3))
% xlabel('Time (\itt\rm weeks)')
yyaxis left
g(3) = bar(trueItInc2, 'BarWidth', 1, 'FaceColor', [.5 .5 .5], 'LineStyle', 'none');
hold on
g(4) = bar(OG1Inc2.reportedIncidence, 'BarWidth', 1, 'LineStyle', 'none');
xlim([0.5 11.5])
% ylab = ylabel('Reported incidence');
% ylab.Position(2) = -50;
ax = gca;
ax.YAxis(1).Color = 'k';
yyaxis right
g(1) = plot(0.5+t, trueRhoInc(t), 'k--'); %add on 0.5 because time goes from 0.5 to 1.5 for week 1, 1.5 to 2.5 for week 2, etc.
hold on
g(2) = plot([0.5:4.5, 4.5:7.5, 7.5:11.5], infRhoInc, 'r', 'LineStyle','-');

ylab = ylabel('Reporting probability, \rho\it\fontsize{11}t');
ylab.Position(1) = 13.5;
ylab.Position(2) = -.28;
set(get(gca,'YLabel'),'Rotation',270)
ax.YAxis(2).Color = 'r';
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
box off
axes(ha(4))
eeStruct = struct('PriorPar', [1 3], 'W', wWeekly', 'I', OG1Inc2.reportedIncidence', 'tau', 1);
eeStructOutput = R_Time_Series_EpiEstim(eeStruct);
h(1) = errorbar((2:11), OG1Inc2.meanRt(2:end), OG1Inc2.meanRt(2:end) - ...
    OG1Inc2.lowerRt(2:end), OG1Inc2.upperRt(2:end) - OG1Inc2.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', OG1Green, 'MarkerSize', 15);
ylab = ylabel(["Time-dependent"+newline+"reproduction number,\it R\fontsize{12}t"]);
ylab.Position(2) = -1.5;
hold on
h(2) = errorbar((2:11)+0.2, OG2Inc2.meanRt(2:end), OG2Inc2.meanRt(2:end) - ...
    OG2Inc2.lowerRt(2:end), OG2Inc2.upperRt(2:end) - OG2Inc2.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', colourMat(7, :), 'MarkerSize', 15);

h(4) = errorbar((2:11)-0.2, eeStructOutput.Means, eeStructOutput.Means - ...
    eeStructOutput.CIs(2, :), eeStructOutput.CIs(2, :) - eeStructOutput.Means, '.', ...
    'LineWidth', 2, 'color',colourMat(2, :), 'MarkerSize', 15);
for i=1:10

h(3) = plot([.5+i 1.5+i], repelem(trueRInc2(1+i), 2), 'k:');

end
h(1).CapSize = 7.5;
h(2).CapSize = 7.5;
h(4).CapSize = 7.5;

xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)

xlim([0.5 11.5])
box off



% set index for decreasing rho inference that we want to look at

idxDec1 = 10;
idxDec2 = 18;

% load analysis files

fileNameOG1Dec1 = strcat('../CSVs/largeScaleStudyClusterNoLimitDecreasingRhoOG1/largeScaleStudyClusterNoLimitDecreasingRhoOG1_', num2str(idxDec1), '.csv');
fileNameOG1Dec2 = strcat('../CSVs/largeScaleStudyClusterNoLimitDecreasingRhoOG1/largeScaleStudyClusterNoLimitDecreasingRhoOG1_', num2str(idxDec2), '.csv');
fileNameOG2Dec1 = strcat('../CSVs/largeScaleStudyClusterNoLimitDecreasingRhoOG2/largeScaleStudyClusterNoLimitDecreasingRhoOG2_', num2str(idxDec1), '.csv');
fileNameOG2Dec2 = strcat('../CSVs/largeScaleStudyClusterNoLimitDecreasingRhoOG2/largeScaleStudyClusterNoLimitDecreasingRhoOG2_', num2str(idxDec2), '.csv');

OG1Dec1 = readtable(fileNameOG1Dec1);
OG1Dec2 = readtable(fileNameOG1Dec2);
OG2Dec1 = readtable(fileNameOG2Dec1);
OG2Dec2 = readtable(fileNameOG2Dec2);

trueRDec1 = trueDec.trueR((idxDec1-1)*11+1:idxDec1*11);
trueRDec2 = trueDec.trueR((idxDec2-1)*11+1:idxDec2*11);
trueItDec1 = trueDec.weeklyI((idxDec1-1)*11+1:idxDec1*11);
trueItDec2 = trueDec.weeklyI((idxDec2-1)*11+1:idxDec2*11);

axes(ha(5))
% xlabel('Time (\itt\rm weeks)')
yyaxis left
g(3) = bar(trueItDec1, 'BarWidth', 1, 'FaceColor', [.5 .5 .5], 'LineStyle', 'none');
hold on
g(4) = bar(OG1Dec1.reportedIncidence, 'BarWidth', 1, 'LineStyle', 'none');
xlim([0.5 11.5])
ylab = ylabel('Reported incidence');
ax = gca;
ax.YAxis(1).Color = 'k';
yyaxis right
g(1) = plot(0.5+t, trueRhoDec(t), 'k--'); %add on 0.5 because time goes from 0.5 to 1.5 for week 1, 1.5 to 2.5 for week 2, etc.
hold on
g(2) = plot([0.5:4.5, 4.5:7.5, 7.5:11.5], infRhoDec, 'r', 'LineStyle', '-');
% ylab = ylabel('Reporting probability, \rho\it(t)');
% ylab.Position(1) = 13.5;
% set(get(gca,'YLabel'),'Rotation',270)
% ax.YAxis(2).Color = 'r';

xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
box off
axes(ha(6))
eeStruct = struct('PriorPar', [1 3], 'W', wWeekly', 'I', OG1Dec1.reportedIncidence', 'tau', 1);
eeStructOutput = R_Time_Series_EpiEstim(eeStruct);
h(1) = errorbar((2:11), OG1Dec1.meanRt(2:end), OG1Dec1.meanRt(2:end) - ...
    OG1Dec1.lowerRt(2:end), OG1Dec1.upperRt(2:end) - OG1Dec1.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', OG1Green, 'MarkerSize', 15);
% ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{12}t"])
hold on
h(2) = errorbar((2:11)+0.2, OG2Dec1.meanRt(2:end), OG2Dec1.meanRt(2:end) - ...
    OG2Dec1.lowerRt(2:end), OG2Dec1.upperRt(2:end) - OG2Dec1.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', colourMat(7, :), 'MarkerSize', 15);
h(4) = errorbar((2:11)-0.2, eeStructOutput.Means, eeStructOutput.Means - ...
    eeStructOutput.CIs(2, :), eeStructOutput.CIs(2, :) - eeStructOutput.Means, '.', ...
    'LineWidth', 2, 'color',colourMat(2, :), 'MarkerSize', 15);
for i=1:10

h(3) = plot([.5+i 1.5+i], repelem(trueRDec1(1+i), 2), 'k:');

end
h(1).CapSize = 7.5;
h(2).CapSize = 7.5;
h(4).CapSize = 7.5;

xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)

xlim([0.5 11.5])
% plot incidence, inference and true R for decreasing rho
box off
axes(ha(7))
xlabel('Time (\itt\rm weeks)')
yyaxis left
g(3) = bar(trueItDec2, 'BarWidth', 1, 'FaceColor', [.5 .5 .5], 'LineStyle', 'none');
hold on
g(4) = bar(OG1Dec2.reportedIncidence, 'BarWidth', 1, 'LineStyle', 'none');
xlim([0.5 11.5])
% ylabel('Reported incidence')
ax = gca;
ax.YAxis(1).Color = 'k';
yyaxis right
g(1) = plot(0.5+t, trueRhoDec(t), 'k--'); %add on 0.5 because time goes from 0.5 to 1.5 for week 1, 1.5 to 2.5 for week 2, etc.
hold on
g(2) = plot([0.5:4.5, 4.5:7.5, 7.5:11.5], infRhoDec, 'r', 'LineStyle','-');

% ylab = ylabel('Reporting probability, \rho\it(t)');
% ylab.Position(1) = 13.5;
% set(get(gca,'YLabel'),'Rotation',270)
% ax.YAxis(2).Color = 'r';
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
box off
axes(ha(8))
eeStruct = struct('PriorPar', [1 3], 'W', wWeekly', 'I', OG1Dec2.reportedIncidence', 'tau', 1);
eeStructOutput = R_Time_Series_EpiEstim(eeStruct);
h(1) = errorbar((2:11), OG1Dec2.meanRt(2:end), OG1Dec2.meanRt(2:end) - ...
    OG1Dec2.lowerRt(2:end), OG1Dec2.upperRt(2:end) - OG1Dec2.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', OG1Green, 'MarkerSize', 15);
% ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{12}t"])
hold on
h(2) = errorbar((2:11)+0.2, OG2Dec2.meanRt(2:end), OG2Dec2.meanRt(2:end) - ...
    OG2Dec2.lowerRt(2:end), OG2Dec2.upperRt(2:end) - OG2Dec2.meanRt(2:end), '.', ...
    'LineWidth', 2, 'color', colourMat(7, :), 'MarkerSize', 15);

h(4) = errorbar((2:11)-0.2, eeStructOutput.Means, eeStructOutput.Means - ...
    eeStructOutput.CIs(2, :), eeStructOutput.CIs(2, :) - eeStructOutput.Means, '.', ...
    'LineWidth', 2, 'color',colourMat(2, :), 'MarkerSize', 15);
for i=1:10

h(3) = plot([.5+i 1.5+i], repelem(trueRDec2(1+i), 2), 'k:');

end
h(1).CapSize = 7.5;
h(2).CapSize = 7.5;
h(4).CapSize = 7.5;

xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
set(gcf,'Position',[0 0 1200 850])
xlim([0.5 11.5])
box off

set(gcf, 'color', 'none')