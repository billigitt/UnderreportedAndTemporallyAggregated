
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

load('../MATs/realWorldInferenceEbolaAllRho.mat')
load('../MATs/realWorldNovelInferenceEbolaSingleRho04.mat')

realWorldInferenceEbolaRho1.date = datetime(realWorldInferenceEbolaRho1.date,'InputFormat','dd-MM-yy ');

meanAndCredibleAllRhoMatrix = zeros(max(realWorldInferenceEbolaRho1.week), 3, 9); % 3D matrix with 1st dim being time, 2nd dim being means, lower percentiles and upper percentiles, and 3rd dim being rho.

meanAndCredibleAllRhoMatrix(:, 1, 1) = realWorldInferenceEbolaRho1.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 2) = realWorldInferenceEbolaRho2.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 3) = realWorldInferenceEbolaRho3.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 4) = realWorldInferenceEbolaRho4.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 5) = realWorldInferenceEbolaRho5.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 6) = realWorldInferenceEbolaRho6.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 7) = realWorldInferenceEbolaRho7.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 8) = realWorldInferenceEbolaRho8.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 9) = realWorldInferenceEbolaRho9.meanRt;

meanAndCredibleAllRhoMatrix(:, 2, 1) = realWorldInferenceEbolaRho1.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 2) = realWorldInferenceEbolaRho2.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 3) = realWorldInferenceEbolaRho3.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 4) = realWorldInferenceEbolaRho4.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 5) = realWorldInferenceEbolaRho5.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 6) = realWorldInferenceEbolaRho6.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 7) = realWorldInferenceEbolaRho7.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 8) = realWorldInferenceEbolaRho8.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 9) = realWorldInferenceEbolaRho9.lowerRt;

meanAndCredibleAllRhoMatrix(:, 3, 1) = realWorldInferenceEbolaRho1.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 2) = realWorldInferenceEbolaRho2.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 3) = realWorldInferenceEbolaRho3.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 4) = realWorldInferenceEbolaRho4.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 5) = realWorldInferenceEbolaRho5.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 6) = realWorldInferenceEbolaRho6.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 7) = realWorldInferenceEbolaRho7.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 8) = realWorldInferenceEbolaRho8.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 9) = realWorldInferenceEbolaRho9.upperRt;

figure
subplot(2, 2, 1)

bh = bar(realWorldInferenceEbolaRho1.date, [realWorldNovelInferenceEbolaSingleRho04.reportedWeeklyI, realWorldInferenceEbolaRho1.trueWeeklyI - realWorldNovelInferenceEbolaSingleRho04.reportedWeeklyI], 'stacked', 'BarWidth', 1, 'EdgeColor', 'none');
xlabel('Date (mm/yy)')
ylabel('Incidence')
set(bh, 'FaceColor', 'Flat')
bh(2).CData = [0.5 0.5 0.5];

legend('Actual reported', 'Simulated hidden')
box off
ylim([0 500])
xtickangle(60);
xlim([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(end)])
xticks([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(34), realWorldInferenceEbolaRho1.date(68), realWorldInferenceEbolaRho1.date(end)])
xticklabels(datestr([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(34), realWorldInferenceEbolaRho1.date(68), realWorldInferenceEbolaRho1.date(end)], 'mm/yy'))
subplot(2, 2, 2)
bh = bar(realWorldInferenceEbolaRho1.date, [realWorldInferenceEbolaRho1.reportedWeeklyI, realWorldInferenceEbolaRho1.trueWeeklyI - realWorldInferenceEbolaRho1.reportedWeeklyI], 'stacked', 'BarWidth', 1, 'EdgeColor', 'none');
xlabel('Date (mm/yy)')
ylabel('Incidence')
set(bh, 'FaceColor', 'Flat')
bh(1).CData = [0.9290 0.6940 0.1250];
bh(2).CData = [0.5 0.5 0.5];
bh(2).FaceAlpha = 0.5;

datetick('x', 'mm/yy');
xtickangle(60);

legend('Simulated reported (\rho = 0.1)', 'Simulated hidden')
box off
ylim([0 500])
xtickangle(60);
xlim([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(end)])
xticks([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(34), realWorldInferenceEbolaRho1.date(68), realWorldInferenceEbolaRho1.date(end)])
xticklabels(datestr([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(34), realWorldInferenceEbolaRho1.date(68), realWorldInferenceEbolaRho1.date(end)], 'mm/yy'))
subplot(2, 2, 3)


bh = bar(realWorldInferenceEbolaRho1.date, [realWorldInferenceEbolaRho9.reportedWeeklyI, realWorldInferenceEbolaRho9.trueWeeklyI - realWorldInferenceEbolaRho9.reportedWeeklyI], 'stacked', 'BarWidth', 1, 'EdgeColor', 'none');
xlabel('Date (mm/yy)')
ylabel('Incidence')
set(bh, 'FaceColor', 'Flat')
bh(1).CData = [0.4940 0.1840 0.5560];
bh(2).CData = [0.5 0.5 0.5];
bh(2).FaceAlpha = 0.5;
legend('Simulated reported (\rho = 0.9)', 'Simulated hidden')
box off
% figure
% plotMeanAndCredible(realWorldInferenceEbola.meanRt, [realWorldInferenceEbola.lowerRt, realWorldInferenceEbola.upperRt])
% xlabel('Time (days)')
% ylabel('Rt')
ylim([0 500])
xtickangle(60);
xlim([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(end)])
xticks([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(34), realWorldInferenceEbolaRho1.date(68), realWorldInferenceEbolaRho1.date(end)])
xticklabels(datestr([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(34), realWorldInferenceEbolaRho1.date(68), realWorldInferenceEbolaRho1.date(end)], 'mm/yy'))
subplot(2, 2, 4)
p(1) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 1), [meanAndCredibleAllRhoMatrix(2:end, 2, 1), meanAndCredibleAllRhoMatrix(2:end, 3, 1)], realWorldInferenceEbolaRho1.date(2:end), [0.9290 0.6940 0.1250], 'a', 'b');
hold on
p(3) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 9), [meanAndCredibleAllRhoMatrix(2:end, 2, 9), meanAndCredibleAllRhoMatrix(2:end, 3, 9)], realWorldInferenceEbolaRho1.date(2:end), [0.4940 0.1840 0.5560], 'a3', 'b3');
xlabel('Date (mm/yy)')
ylabel({'Time-dependent';'reproduction number (\itR\fontsize{14}t\fontsize{18}\rm)'})
legend(p([1 3]), '\rho = 0.1', '\rho = 0.9')
%xlim([0 102.5])
%datetick('x', 'mm/yy');
xtickangle(60);
xlim([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(end)])
xticks([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(34), realWorldInferenceEbolaRho1.date(68), realWorldInferenceEbolaRho1.date(end)])
xticklabels(datestr([realWorldInferenceEbolaRho1.date(1), realWorldInferenceEbolaRho1.date(34), realWorldInferenceEbolaRho1.date(68), realWorldInferenceEbolaRho1.date(end)], 'mm/yy'))
% datetick('x', 'mm/yy');

box off

% figure
% p(1) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 1), [meanAndCredibleAllRhoMatrix(2:end, 2, 1), meanAndCredibleAllRhoMatrix(2:end, 3, 1)], (2:75)', 'red', 'a');
% hold on
% p(2) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 2), [meanAndCredibleAllRhoMatrix(2:end, 2, 2), meanAndCredibleAllRhoMatrix(2:end, 3, 2)], (2:75)', [0.8500 0.3250 0.0980], 'a2');
% p(3) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 3), [meanAndCredibleAllRhoMatrix(2:end, 2, 3), meanAndCredibleAllRhoMatrix(2:end, 3, 3)], (2:75)', 'yellow', 'a3');
% p(4) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 4), [meanAndCredibleAllRhoMatrix(2:end, 2, 4), meanAndCredibleAllRhoMatrix(2:end, 3, 4)], (2:75)', 'green', 'a4');
% p(5) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 5), [meanAndCredibleAllRhoMatrix(2:end, 2, 5), meanAndCredibleAllRhoMatrix(2:end, 3, 5)], (2:75)', 'blue', 'a5');
% p(6) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 6), [meanAndCredibleAllRhoMatrix(2:end, 2, 6), meanAndCredibleAllRhoMatrix(2:end, 3, 6)], (2:75)', [0.4940 0.1840 0.5560], 'a6');
% p(7) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 6), [meanAndCredibleAllRhoMatrix(2:end, 2, 6), meanAndCredibleAllRhoMatrix(2:end, 3, 6)], (2:75)', [1 0 1], '');
% xlabel('Time (weeks)')
% ylabel('$R_t$', 'interpreter', 'latex')
% legend(p([1 2 3 4 5 6 7]), '$\rho = 0.3$', '$\rho = 0.4$', '$\rho = 0.5$', '$\rho = 0.6$', '$\rho = 0.7$', '$\rho = 0.8$', '$\rho = 0.9$')