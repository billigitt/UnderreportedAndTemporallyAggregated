clear all
close all

load('ebolaLongStutteringSimulationAndInferenceSeed2.mat')

numInf = 30;

T = max(weightedM1e3LongStutterEbolaSimSeed2.week);
timeConsidered = 10;

indices = reshape(((0:numInf-1)*T)+ (T-timeConsidered+1:T)', [], 1);

seed1Table = vertcat(weightedM1e3LongStutterEbolaSimSeed2(indices, :), weightedM1e4LongStutterEbolaSimSeed2(indices, :), weightedM1e5LongStutterEbolaSimSeed2(indices, :));
seed1Table.M = [1e3*ones(30*timeConsidered, 1); 1e4*ones(30*timeConsidered, 1); 1e5*ones(30*timeConsidered, 1)];

meansEpiEstim = [NaN; NaN; epiEstimTau7PerfectInfoLongStutterEbolaSimSeed2.meanRt];
lowerEpiEstim = [NaN; NaN; epiEstimTau7PerfectInfoLongStutterEbolaSimSeed2.quantile0025];
upperEpiEstim = [NaN; NaN; epiEstimTau7PerfectInfoLongStutterEbolaSimSeed2.quantile0975];

figure
boxchart(seed1Table.week, seed1Table.meanRt, 'GroupByColor', seed1Table.M)
hold on
plot(seed1Table.week(1:timeConsidered), [1.5*ones(5, 1); 0.75*ones(5, 1)], 'DisplayName', 'True Rt')
scatter(seed1Table.week(1:timeConsidered), meansEpiEstim(T-timeConsidered+1:T), 40, 'MarkerEdgeColor',[0.4660 0.6740 0.1880], 'MarkerFaceColor',[0.4660 0.6740 0.1880], 'LineWidth',1.5, 'DisplayName', 'EpiEstim')
legend
xlabel('Time (weeks)')
ylabel('mean Rt')

figure
plotMeanAndCredible(meansEpiEstim(T-timeConsidered+1:T), [lowerEpiEstim(T-timeConsidered+1:T), upperEpiEstim(T-timeConsidered+1:T)], (T-timeConsidered+1:T)', 'red', 'Epi-Estim Perfect Information Mean', 'Epi-Estim Perfect Information 95% Cri')
hold on
plotMeanAndCredible(weightedM1e3LongStutterEbolaSimSeed2.meanRt(T-timeConsidered+1:T), [weightedM1e3LongStutterEbolaSimSeed2.lowerRt(T-timeConsidered+1:T), weightedM1e3LongStutterEbolaSimSeed2.upperRt(T-timeConsidered+1:T)], (T-timeConsidered+1:T)', 'blue', 'Simulation Mean', 'Simulation 95% Cri')
plot(T-timeConsidered+1:T, [1.5*ones(5, 1); 0.75*ones(5, 1)], 'k', 'DisplayName', 'True Rt')

legend