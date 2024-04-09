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

load('../MATs/ebolaStutteringSimulationAndInferenceSeed6.mat')

numInf = 30;

T = max(weightedM1e3StutterEbolaSimSeed6.week);
timeConsidered = 10;

indices = reshape(((0:numInf-1)*T)+ (T-timeConsidered+1:T)', [], 1);

seed1Table = vertcat(weightedM1e3StutterEbolaSimSeed6(indices, :), weightedM1e4StutterEbolaSimSeed6(indices, :), weightedM1e5StutterEbolaSimSeed6(indices, :));
seed1Table.M = [1e3*ones(30*timeConsidered, 1); 1e4*ones(30*timeConsidered, 1); 1e5*ones(30*timeConsidered, 1)];

meansEpiEstim = [NaN; NaN; epiEstimTau7PerfectInfoStutterEbolaSimSeed6.meanRt];
lowerEpiEstim = [NaN; NaN; epiEstimTau7PerfectInfoStutterEbolaSimSeed6.quantile0025];
upperEpiEstim = [NaN; NaN; epiEstimTau7PerfectInfoStutterEbolaSimSeed6.quantile0975];

meansNaiveEpiEstim = [NaN; NaN; epiEstimImperfectInfoStutterEbolaSimSeed6.meanRt];
lowerNaiveEpiEstim = [NaN; NaN; epiEstimImperfectInfoStutterEbolaSimSeed6.quantile0025];
upperNaiveEpiEstim = [NaN; NaN; epiEstimImperfectInfoStutterEbolaSimSeed6.quantile0975];

figure;bar([weightedM1e3StutterEbolaSimSeed6.reportedWeeklyI(1:T), weightedM1e3StutterEbolaSimSeed6.weeklyI(1:T) - weightedM1e3StutterEbolaSimSeed6.reportedWeeklyI(1:T)], 'stacked')
% Set legend labels
legend({'Reported Weekly Infections', 'Unreported Weekly Infections'}, 'Location', 'best')
ylabel('Incidence')
xlabel('Time (weeks)')

figure;bar(41:50, [weightedM1e3StutterEbolaSimSeed6.reportedWeeklyI(T-timeConsidered+1:T), weightedM1e3StutterEbolaSimSeed6.weeklyI(T-timeConsidered+1:T) - weightedM1e3StutterEbolaSimSeed6.reportedWeeklyI(T-timeConsidered+1:T)], 'stacked')
% Set legend labels
legend({'Reported Weekly Infections', 'Unreported Weekly Infections'}, 'Location', 'best')
ylabel('Incidence')
xlabel('Time (weeks)')

figure
boxchart(seed1Table.week, seed1Table.meanRt, 'GroupByColor', seed1Table.M)
hold on
plot(seed1Table.week(1:timeConsidered), [1.5*ones(5, 1); 0.75*ones(5, 1)], 'DisplayName', 'True $R_t$')
scatter(seed1Table.week(1:timeConsidered), meansEpiEstim(T-timeConsidered+1:T), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
scatter(seed1Table.week(1:timeConsidered), meansNaiveEpiEstim(T-timeConsidered+1:T), 40, 'MarkerEdgeColor',[0.4660 0.6740 0.1880], 'MarkerFaceColor',[0.4660 0.6740 0.1880], 'LineWidth',1.5, 'DisplayName', 'EpiEstim Non-PI')
legend('$M=1,000$', '$M=10,000$', '$M=100,000$', 'True $R_t$', 'EpiEstim Perfect Info', 'EpiEstim Imperfect Info')
xlabel('Time (weeks)')
ylabel('mean $R_t$', 'interpreter', 'latex')

figure
boxchart(seed1Table.week, seed1Table.upperRt, 'GroupByColor', seed1Table.M)
hold on
plot(seed1Table.week(1:timeConsidered), [1.5*ones(5, 1); 0.75*ones(5, 1)], 'DisplayName', 'True $R_t$')
scatter(seed1Table.week(1:timeConsidered), upperEpiEstim(T-timeConsidered+1:T), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
scatter(seed1Table.week(1:timeConsidered), upperNaiveEpiEstim(T-timeConsidered+1:T), 40, 'MarkerEdgeColor',[0.4660 0.6740 0.1880], 'MarkerFaceColor',[0.4660 0.6740 0.1880], 'LineWidth',1.5, 'DisplayName', 'EpiEstim Non-PI')
legend('$M=1,000$', '$M=10,000$', '$M=100,000$', 'True $R_t$', 'EpiEstim Perfect Info', 'EpiEstim Imperfect Info')
xlabel('Time (weeks)')
ylabel('$97.5$ $R_t$ credible percentile', 'interpreter', 'latex')

figure
boxchart(seed1Table.week, seed1Table.lowerRt, 'GroupByColor', seed1Table.M)
hold on
plot(seed1Table.week(1:timeConsidered), [1.5*ones(5, 1); 0.75*ones(5, 1)], 'DisplayName', 'True $R_t$')
scatter(seed1Table.week(1:timeConsidered), lowerEpiEstim(T-timeConsidered+1:T), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
scatter(seed1Table.week(1:timeConsidered), lowerNaiveEpiEstim(T-timeConsidered+1:T), 40, 'MarkerEdgeColor',[0.4660 0.6740 0.1880], 'MarkerFaceColor',[0.4660 0.6740 0.1880], 'LineWidth',1.5, 'DisplayName', 'EpiEstim Non-PI')
legend('$M=1,000$', '$M=10,000$', '$M=100,000$', 'True $R_t$', 'EpiEstim Perfect Info', 'EpiEstim Imperfect Info')
xlabel('Time (weeks)')
ylabel('$2.5$ $R_t$ credible percentile', 'interpreter', 'latex')


figure
plotMeanAndCredible(meansEpiEstim(T-timeConsidered+1:T), [lowerEpiEstim(T-timeConsidered+1:T), upperEpiEstim(T-timeConsidered+1:T)], (T-timeConsidered+1:T)', 'red', 'Epi-Estim Perfect Information Mean', 'Epi-Estim Perfect Information 95% Cri')
hold on
plotMeanAndCredible(weightedM1e3StutterEbolaSimSeed6.meanRt(T-timeConsidered+1:T), [weightedM1e3StutterEbolaSimSeed6.lowerRt(T-timeConsidered+1:T), weightedM1e3StutterEbolaSimSeed6.upperRt(T-timeConsidered+1:T)], (T-timeConsidered+1:T)', 'blue', 'Simulation Mean', 'Simulation 95% Cri')
plot(T-timeConsidered+1:T, [1.5*ones(5, 1); 0.75*ones(5, 1)], 'k', 'DisplayName', 'True Rt')
xlabel('Time (weeks)')
ylabel('$R_t$', 'interpreter', 'latex')
legend

figure
plotMeanAndCredible(weightedM1e3StutterEbolaSimSeed6.meanRt(T-timeConsidered+1:T), [weightedM1e3StutterEbolaSimSeed6.lowerRt(T-timeConsidered+1:T), weightedM1e3StutterEbolaSimSeed6.upperRt(T-timeConsidered+1:T)], (T-timeConsidered+1:T)', 'blue', 'Simulation Mean', 'Simulation 95% Cri')
hold on
plotMeanAndCredible(meansNaiveEpiEstim(T-timeConsidered+1:T), [lowerNaiveEpiEstim(T-timeConsidered+1:T), upperNaiveEpiEstim(T-timeConsidered+1:T)], (T-timeConsidered+1:T)', 'green', 'Epi-Estim Imperfect Information Mean', 'Epi-Estim Imperfect Information 95% Cri')
plot(T-timeConsidered+1:T, [1.5*ones(5, 1); 0.75*ones(5, 1)], 'k', 'DisplayName', 'True Rt')
xlabel('Time (weeks)')
ylabel('$R_t$', 'interpreter', 'latex')
legend