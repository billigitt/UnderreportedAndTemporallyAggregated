clearvars
clc
close all

%load CSVs of true R numbers

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

colourMat = [0.9 0.6 0;... %orange 1
    0.35 0.7 0.9;... %sky blue 2
    0 0.6 0.5;... %blueish green 3
    0.9290 0.6940 0.1250;... %yellow 4
    0 0.44 0.7;... %blue 5
    0.8 0.4 0;... %red 6
    0.4940 0.1840 0.5560]; % purple 7

OG1Green = [0.4660 0.6740 0.1880];

trueInc = readtable("../CSVs/largeScaleStudyIncidencesAndTrueRsNoLimitPrior1And3FirstDay1IncreasingRho.csv");
trueDec = readtable("../CSVs/largeScaleStudyIncidencesAndTrueRsNoLimitPrior1And3FirstDay1DecreasingRho.csv");

trueRhoInc = @(t) (1./(1 + exp(-(t-5.5)*log(9)/3.5)));
infRhoInc = [0.1 0.1 0.1 0.1 0.5 0.5 0.5 0.9 0.9 0.9 0.9];
trueRhoDec = @(t) 1-(1./(1 + exp(-(t-5.5)*log(9)/3.5)));
infRhoDec = [0.9 0.9 0.9 0.9 0.5 0.5 0.5 0.1 0.1 0.1 0.1];

t = 1/7:1/7:11;
% set index for increasing rho inference that we want to look at

idxInc = 8;

% set index for decreasing rho inference that we want to look at

idxDec = 10;

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


figure
subplot(1, 41, 1:16)
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
g(2) = plot(1:11, infRhoInc, 'r', 'LineStyle', '-');
ylab = ylabel('Reporting probability, \rho\it(t)');
ylab.Position(1) = 14;
set(get(gca,'YLabel'),'Rotation',270)
legend(g([1 2 3 4]), 'True \rho\it(t)', 'Assumed \rho\it(t)', ...
    'Hidden incidence', 'Reported incidence', 'Location', 'NorthWest')
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
subplot(1, 41, 26:41)
h(1) = plot(OG1Inc.meanRt, 'color', OG1Green);
ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{12}t"])
hold on
h(2) = plot(OG2Inc.meanRt, 'color', colourMat(7, :));
h(3) = plot(1:11, trueRInc, 'k--');
fill([(2:11)'; (11:-1:2)'], [OG1Inc.lowerRt(2:end); flipud(OG1Inc.upperRt(2:end))], OG1Green, 'FaceAlpha', 0.5, 'LineStyle','none')
fill([(2:11)'; (11:-1:2)'], [OG2Inc.lowerRt(2:end); flipud(OG2Inc.upperRt(2:end))], colourMat(7, :), 'FaceAlpha', 0.5, 'LineStyle','none')
legend(h([1 2 3]), 'OG1 method', 'OG2 method', 'True \itR\fontsize{12}t')
xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
set(gcf,'Position',[100 100 1250 600])
% plot incidence, inference and true R for decreasing rho

% figure
% sgtitle(strcat('Simulation ', num2str(idxDec)))
% subplot(1, 41, 1:16)
% xlabel('Time (\itt\rm weeks)')
% yyaxis left
% g(3) = bar(trueItInc, 'BarWidth', 1, 'FaceColor', [.5 .5 .5], 'LineStyle', 'none');
% hold on
% g(4) = bar(OG1Dec.reportedIncidence, 'BarWidth', 1, 'LineStyle', 'none');
% xlim([0.5 11.5])
% ylabel('Reported incidence')
% ax = gca;
% ax.YAxis(1).Color = 'k';
% yyaxis right
% g(1) = plot(0.5+t, trueRhoDec(t), 'k--'); %add on 0.5 because time goes from 0.5 to 1.5 for week 1, 1.5 to 2.5 for week 2, etc.
% hold on
% g(2) = plot(1:11, infRhoDec, 'r', 'LineStyle','-');
% legend(g([1 2 3 4]), 'True \rho\it(t)', 'Assumed \rho\it(t)', 'Hidden incidence', 'Reported incidence')
% ylabel('Reporting probability, \rho\it(t)')
% xtickangle(0)
% subplot(1, 41, 26:41)
% h(1) = plot(OG1Dec.meanRt, 'color', OG1Green);
% ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{7}t"])
% hold on
% h(2) = plot(OG2Dec.meanRt, 'color', colourMat(7, :));
% h(3) = plot(1:11, trueRDec, 'k--');
% fill([(2:11)'; (11:-1:2)'], [OG1Dec.lowerRt(2:end); flipud(OG1Dec.upperRt(2:end))], OG1Green, 'FaceAlpha', 0.5, 'LineStyle','none')
% fill([(2:11)'; (11:-1:2)'], [OG2Dec.lowerRt(2:end); flipud(OG2Dec.upperRt(2:end))], colourMat(7, :), 'FaceAlpha', 0.5, 'LineStyle','none')
% legend(h([1 2 3]), 'OG1 method', 'OG2 method', 'True \itR\fontsize{7}t')
% xlabel('Time (\itt\rm weeks)')

%% Batch 2

% set index for increasing rho inference that we want to look at

idxInc = 14;

% set index for decreasing rho inference that we want to look at

idxDec = 13;

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


figure
subplot(1, 41, 1:16)
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
g(2) = plot(1:11, infRhoInc, 'r', 'LineStyle', '-');
ylabel('Reporting probability, \rho\it(t)')
set(get(gca,'YLabel'),'Rotation',270)
legend(g([1 2 3 4]), 'True \rho\it(t)', 'Assumed \rho\it(t)', 'Hidden incidence', 'Reported incidence', 'Location', 'NorthWest')
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
subplot(1, 41, 26:41)
h(1) = plot(OG1Inc.meanRt, 'color', OG1Green);
ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{7}t"])
hold on
h(2) = plot(OG2Inc.meanRt, 'color', colourMat(7, :));
h(3) = plot(1:11, trueRInc, 'k--');
fill([(2:11)'; (11:-1:2)'], [OG1Inc.lowerRt(2:end); flipud(OG1Inc.upperRt(2:end))], OG1Green, 'FaceAlpha', 0.5, 'LineStyle','none')
fill([(2:11)'; (11:-1:2)'], [OG2Inc.lowerRt(2:end); flipud(OG2Inc.upperRt(2:end))], colourMat(7, :), 'FaceAlpha', 0.5, 'LineStyle','none')
legend(h([1 2 3]), 'OG1 method', 'OG2 method', 'True \itR\fontsize{7}t')
xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
set(gcf,'Position',[100 100 1250 600])
% plot incidence, inference and true R for decreasing rho

figure
subplot(1, 41, 1:16)
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
g(2) = plot(1:11, infRhoDec, 'r', 'LineStyle','-');
legend(g([1 2 3 4]), 'True \rho\it(t)', 'Assumed \rho\it(t)', 'Hidden incidence', 'Reported incidence', 'Location', 'NorthWest')
ylabel('Reporting probability, \rho\it(t)')
set(get(gca,'YLabel'),'Rotation',270)
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
subplot(1, 41, 26:41)
h(1) = plot(OG1Dec.meanRt, 'color', OG1Green);
ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{7}t"])
hold on
h(2) = plot(OG2Dec.meanRt, 'color', colourMat(7, :));
h(3) = plot(1:11, trueRDec, 'k--');
fill([(2:11)'; (11:-1:2)'], [OG1Dec.lowerRt(2:end); flipud(OG1Dec.upperRt(2:end))], OG1Green, 'FaceAlpha', 0.5, 'LineStyle','none')
fill([(2:11)'; (11:-1:2)'], [OG2Dec.lowerRt(2:end); flipud(OG2Dec.upperRt(2:end))], colourMat(7, :), 'FaceAlpha', 0.5, 'LineStyle','none')
legend(h([1 2 3]), 'OG1 method', 'OG2 method', 'True \itR\fontsize{7}t')
xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
set(gcf,'Position',[100 100 1250 600])

%% Batch 3

% set index for increasing rho inference that we want to look at

idxInc = 16;

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


figure
subplot(1, 41, 1:16)
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
g(2) = plot(1:11, infRhoInc, 'r', 'LineStyle', '-');
ylabel('Reporting probability, \rho\it(t)')
set(get(gca,'YLabel'),'Rotation',270)
legend(g([1 2 3 4]), 'True \rho\it(t)', 'Assumed \rho\it(t)', 'Hidden incidence', 'Reported incidence', 'Location', 'NorthWest')
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
subplot(1, 41, 26:41)
h(1) = plot(OG1Inc.meanRt, 'color', OG1Green);
ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{7}t"])
hold on
h(2) = plot(OG2Inc.meanRt, 'color', colourMat(7, :));
h(3) = plot(1:11, trueRInc, 'k--');
fill([(2:11)'; (11:-1:2)'], [OG1Inc.lowerRt(2:end); flipud(OG1Inc.upperRt(2:end))], OG1Green, 'FaceAlpha', 0.5, 'LineStyle','none')
fill([(2:11)'; (11:-1:2)'], [OG2Inc.lowerRt(2:end); flipud(OG2Inc.upperRt(2:end))], colourMat(7, :), 'FaceAlpha', 0.5, 'LineStyle','none')
legend(h([1 2 3]), 'OG1 method', 'OG2 method', 'True \itR\fontsize{7}t')
xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
set(gcf,'Position',[100 100 1250 600])
% plot incidence, inference and true R for decreasing rho

figure
subplot(1, 41, 1:16)
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
g(2) = plot(1:11, infRhoDec, 'r', 'LineStyle','-');
legend(g([1 2 3 4]), 'True \rho\it(t)', 'Assumed \rho\it(t)', 'Hidden incidence', 'Reported incidence', 'Location', 'NorthWest')
ylabel('Reporting probability, \rho\it(t)')
set(get(gca,'YLabel'),'Rotation',270)
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
subplot(1, 41, 26:41)
h(1) = plot(OG1Dec.meanRt, 'color', OG1Green);
ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{7}t"])
hold on
h(2) = plot(OG2Dec.meanRt, 'color', colourMat(7, :));
h(3) = plot(1:11, trueRDec, 'k--');
fill([(2:11)'; (11:-1:2)'], [OG1Dec.lowerRt(2:end); flipud(OG1Dec.upperRt(2:end))], OG1Green, 'FaceAlpha', 0.5, 'LineStyle','none')
fill([(2:11)'; (11:-1:2)'], [OG2Dec.lowerRt(2:end); flipud(OG2Dec.upperRt(2:end))], colourMat(7, :), 'FaceAlpha', 0.5, 'LineStyle','none')
legend(h([1 2 3]), 'OG1 method', 'OG2 method', 'True \itR\fontsize{7}t')
xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
set(gcf,'Position',[100 100 1250 600])

%% Batch 4

% set index for increasing rho inference that we want to look at

idxInc = 19;

% set index for decreasing rho inference that we want to look at

idxDec = 18;

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


figure
subplot(1, 41, 1:16)
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
g(2) = plot(1:11, infRhoInc, 'r', 'LineStyle', '-');
ylabel('Reporting probability, \rho\it(t)')
set(get(gca,'YLabel'),'Rotation',270)
legend(g([1 2 3 4]), 'True \rho\it(t)', 'Assumed \rho\it(t)', 'Hidden incidence', 'Reported incidence', 'Location', 'NorthWest')
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
subplot(1, 41, 26:41)
h(1) = plot(OG1Inc.meanRt, 'color', OG1Green);
ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{7}t"])
hold on
h(2) = plot(OG2Inc.meanRt, 'color', colourMat(7, :));
h(3) = plot(1:11, trueRInc, 'k--');
fill([(2:11)'; (11:-1:2)'], [OG1Inc.lowerRt(2:end); flipud(OG1Inc.upperRt(2:end))], OG1Green, 'FaceAlpha', 0.5, 'LineStyle','none')
fill([(2:11)'; (11:-1:2)'], [OG2Inc.lowerRt(2:end); flipud(OG2Inc.upperRt(2:end))], colourMat(7, :), 'FaceAlpha', 0.5, 'LineStyle','none')
legend(h([1 2 3]), 'OG1 method', 'OG2 method', 'True \itR\fontsize{7}t')
xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
set(gcf,'Position',[100 100 1250 600])
% plot incidence, inference and true R for decreasing rho

figure
subplot(1, 41, 1:16)
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
g(2) = plot(1:11, infRhoDec, 'r', 'LineStyle','-');
legend(g([1 2 3 4]), 'True \rho\it(t)', 'Assumed \rho\it(t)', 'Hidden incidence', 'Reported incidence', 'Location', 'NorthWest')
ylabel('Reporting probability, \rho\it(t)')
set(get(gca,'YLabel'),'Rotation',270)
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
subplot(1, 41, 26:41)
h(1) = plot(OG1Dec.meanRt, 'color', OG1Green);
ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{7}t"])
hold on
h(2) = plot(OG2Dec.meanRt, 'color', colourMat(7, :));
h(3) = plot(1:11, trueRDec, 'k--');
fill([(2:11)'; (11:-1:2)'], [OG1Dec.lowerRt(2:end); flipud(OG1Dec.upperRt(2:end))], OG1Green, 'FaceAlpha', 0.5, 'LineStyle','none')
fill([(2:11)'; (11:-1:2)'], [OG2Dec.lowerRt(2:end); flipud(OG2Dec.upperRt(2:end))], colourMat(7, :), 'FaceAlpha', 0.5, 'LineStyle','none')
legend(h([1 2 3]), 'OG1 method', 'OG2 method', 'True \itR\fontsize{7}t')
xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
set(gcf,'Position',[100 100 1250 600])

%% Batch 5 (just another increase)

% set index for increasing rho inference that we want to look at

idxInc = 20;


% load analysis files

fileNameOG1Inc = strcat('../CSVs/largeScaleStudyClusterNoLimitIncreasingRhoOG1/largeScaleStudyClusterNoLimitIncreasingRhoOG1_', num2str(idxInc), '.csv');
fileNameOG2Inc = strcat('../CSVs/largeScaleStudyClusterNoLimitIncreasingRhoOG2/largeScaleStudyClusterNoLimitIncreasingRhoOG2_', num2str(idxInc), '.csv');

OG1Inc = readtable(fileNameOG1Inc);
OG2Inc = readtable(fileNameOG2Inc);

trueRInc = trueInc.trueR((idxInc-1)*11+1:idxInc*11);
trueItInc = trueInc.weeklyI((idxInc-1)*11+1:idxInc*11);
% plot incidence, inference and true R for increasing rho

%Time used for plots of true rho


figure
subplot(1, 41, 1:16)
xlabel('Time (\itt\rm weeks)')
yyaxis left
g(3) = bar(trueItInc, 'BarWidth', 1, 'FaceColor', [0.5 0.5 0.5], 'LineStyle', 'none');
hold on
g(4) = bar(OG1Inc.reportedIncidence, 'BarWidth', 1, 'LineStyle', 'none');
xlim([0.5 11.5])
ylabel('Reported incidence')
ax = gca;
ax.YAxis(1).Color = 'k';
yyaxis right
g(1) = plot(0.5+t, trueRhoInc(t), 'k--'); %add on 0.5 because time goes from 0.5 to 1.5 for week 1, 1.5 to 2.5 for week 2, etc.
hold on
g(2) = plot(1:11, infRhoInc, 'r', 'LineStyle', '-');
ylabel('Reporting probability, \rho\it(t)')
legend(g([1 2 3 4]), 'True \rho\it(t)', 'Assumed \rho\it(t)', 'Hidden incidence', 'Reported incidence', 'Location', 'NorthWest')
xtickangle(0)
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
subplot(1, 41, 26:41)
h(1) = plot(OG1Inc.meanRt, 'color', OG1Green);
ylabel(["Time dependent"+newline+"reproduction number,\it R\fontsize{7}t"])
hold on
h(2) = plot(OG2Inc.meanRt, 'color', colourMat(7, :));
h(3) = plot(1:11, trueRInc, 'k--');
fill([(2:11)'; (11:-1:2)'], [OG1Inc.lowerRt(2:end); flipud(OG1Inc.upperRt(2:end))], OG1Green, 'FaceAlpha', 0.5, 'LineStyle','none')
fill([(2:11)'; (11:-1:2)'], [OG2Inc.lowerRt(2:end); flipud(OG2Inc.upperRt(2:end))], colourMat(7, :), 'FaceAlpha', 0.5, 'LineStyle','none')
legend(h([1 2 3]), 'OG1 method', 'OG2 method', 'True \itR\fontsize{7}t')
xlabel('Time (\itt\rm weeks)')
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
set(gcf,'Position',[100 100 1250 600])
% plot incidence, inference and true R for decreasing rho

