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

addpath('ownEpiEstim')

load('../MATs/robustnessCheckFromLargeScaleStudy.mat')
load('../MATs/largeScaleStudy.mat')
load('../MATs/SIWeekly.mat')

trueR = largeScaleStudy.trueR(24:33);

% own Inference

inputStruct = struct('PriorPar', [1 3], 'W', [0; SIWeekly.wWeekly]', 'I', largeScaleStudy.reportedWeeklyI(23:33)', 'tau', 1);

outputStruct = R_Time_Series_EpiEstim(inputStruct);

% Display plots

% Plot 1: Standard Plot

figure
subplot(2, 1, 1)
bar(largeScaleStudy.reportedWeeklyI(23:33))
ylabel('Reported Incidence')
xlabel('Time (weeks)')
subplot(2,1,2)
plotMeanAndCredible(robustnessCheckFromLargeScaleStudyM1e5.meanRt(2:11), ...
    [robustnessCheckFromLargeScaleStudyM1e5.lowerRt(2:11),...
    robustnessCheckFromLargeScaleStudyM1e5.upperRt(2:11)], (2:11)', 'red', 'Epi-Estim Perfect Information Mean', 'Epi-Estim Perfect Information 95% Cri')
hold on
plotMeanAndCredible(outputStruct.Means', outputStruct.CIs', (2:11)', 'blue', 'mean', 'ci')
plot(2:11, trueR, 'k--')
legend('Simulation Approach 95% Cri', 'Simulation Approach Mean', 'Naive Epi-Estim Cri', 'Naive Epi-Estim', 'True $R_t$')
ylabel('$R_t$', 'interpreter', 'latex')
xlabel('Time (weeks)')

%

T = max(robustnessCheckFromLargeScaleStudyM1e3.week);

Table = vertcat(robustnessCheckFromLargeScaleStudyM1e3, ...
    robustnessCheckFromLargeScaleStudyM1e4, ...
    robustnessCheckFromLargeScaleStudyM1e5);

Table.M = [1e3*ones(30*T, 1); 1e4*ones(30*T, 1); 1e5*ones(30*T, 1)];


figure
subplot(2,2,1)
boxchart(Table.week, Table.meanRt, 'GroupByColor', Table.M)
hold on
plot(Table.week(2:T), trueR, 'DisplayName', 'True $R_t$')
scatter(Table.week(2:T), outputStruct.Means, 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
legend('$M=1,000$', '$M=10,000$', '$M=100,000$', 'True $R_t$', 'EpiEstim')
xlabel('Time (weeks)')
ylabel('mean $R_t$', 'interpreter', 'latex')

subplot(2,2,2)
boxchart(Table.week, Table.lowerRt, 'GroupByColor', Table.M)
hold on
plot(Table.week(2:T), trueR, 'DisplayName', 'True $R_t$')
scatter(Table.week(2:T), outputStruct.CIs(2, :), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
legend('$M=1,000$', '$M=10,000$', '$M=100,000$', 'True $R_t$', 'EpiEstim')
xlabel('Time (weeks)')
ylabel('2.5 $R_t$ percentile', 'interpreter', 'latex')

subplot(2,2,3)
boxchart(Table.week, Table.upperRt, 'GroupByColor', Table.M)
hold on
plot(Table.week(2:T), trueR, 'DisplayName', 'True $R_t$')
scatter(Table.week(2:T), outputStruct.CIs(1, :), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
legend('$M=1,000$', '$M=10,000$', '$M=100,000$', 'True $R_t$', 'EpiEstim')
xlabel('Time (weeks)')
ylabel('97.5 $R_t$ percentile', 'interpreter', 'latex')


