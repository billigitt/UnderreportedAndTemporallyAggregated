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

addpath('ownEpiEstim')

load('../MATs/robustnessCheckFromLargeScaleStudy.mat')
load('../MATs/largeScaleStudy.mat')
load('../MATs/SIWeekly.mat')

% colour scheme: blue (row 1) is EpiEstim, red (row 2) is original method
% (temp agg), green (row 3) is new method (temp agg + under-rep)
% 
colourMat = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880]; 

trueR = largeScaleStudy.trueR(24:33);

% own Inference

inputStruct = struct('PriorPar', [1 3], 'W', [0; SIWeekly.wWeekly]', 'I', largeScaleStudy.reportedWeeklyI(23:33)', 'tau', 1);

outputStruct = R_Time_Series_EpiEstim(inputStruct);

% Display plots

% Plot 1: Standard Plot

figure
subplot(1, 2, 1)
bar(largeScaleStudy.reportedWeeklyI(23:33))
ylabel('Reported Incidence')
xlabel('Time (\itt \rmweeks)')
xlim([0.5 11.5])
box off
subplot(1,2,2)
x = plotMeanAndCredible(robustnessCheckFromLargeScaleStudyM1e5.meanRt(4:11), ...
    [robustnessCheckFromLargeScaleStudyM1e5.lowerRt(4:11),...
    robustnessCheckFromLargeScaleStudyM1e5.upperRt(4:11)], (4:11)', colourMat(3, :), 'Epi-Estim Perfect Information Mean', 'Epi-Estim Perfect Information 95% Cri');
hold on
y = plotMeanAndCredible(outputStruct.Means(3:end)', outputStruct.CIs(:, 3:end)', (4:11)', colourMat(1, :), 'mean', 'ci');
z = plot(4:11, trueR(3:end), 'k--');
legend([x, y, z], '\itM\rm = 100,000', 'Cori', 'True \itR\fontsize{14}t')
ylabel({'Time-dependent';'reproduction number (\itR\fontsize{14}t\fontsize{18}\rm)'})
xlabel('Time (\itt \rmweeks)')
xlim([3.5 11.5])

%

T = max(robustnessCheckFromLargeScaleStudyM1e3.week);

Table = vertcat(robustnessCheckFromLargeScaleStudyM1e3, ...
    robustnessCheckFromLargeScaleStudyM1e4, ...
    robustnessCheckFromLargeScaleStudyM1e5);

Table.M = [1e3*ones(30*T, 1); 1e4*ones(30*T, 1); 1e5*ones(30*T, 1)];

idxIncluded = reshape((4:11)' + (0:11:89*11), 1, []);

figure
subplot(1,3,1)
boxchart(Table.week(idxIncluded), Table.meanRt(idxIncluded), 'GroupByColor', Table.M(idxIncluded))
hold on
plot(Table.week(4:T), trueR(3:end), 'DisplayName', 'True \itR\fontsize{14}t', 'color', 'black', 'LineStyle', '--')
%scatter(Table.week(4:T), outputStruct.Means(3:10), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
legend('\itM\rm = 1,000', '\itM\rm = 10,000', '\itM\rm = 100,000', 'True \itR\fontsize{14}t', 'EpiEstim')
xlabel('Time (\itt \rmweeks)')
ylabel('Mean \itR\fontsize{14}t')
xlim([3.5 11.5])
ylim([0 11])

subplot(1, 3,2)
boxchart(Table.week(idxIncluded), Table.lowerRt(idxIncluded), 'GroupByColor', Table.M(idxIncluded))
hold on
plot(Table.week(4:T), trueR(3:end), 'DisplayName', 'True $R_t$', 'color', 'black', 'LineStyle', '--')
%scatter(Table.week(2:T), outputStruct.CIs(2, :), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
xlabel('Time (\itt \rmweeks)')
ylabel('2.5^{th} \itR\fontsize{14}t \fontsize{18}\rmpercentile')
xlim([3.5 11.5])
ylim([0 11])

subplot(1, 3,3)
boxchart(Table.week(idxIncluded), Table.upperRt(idxIncluded), 'GroupByColor', Table.M(idxIncluded))
hold on
plot(Table.week(4:T), trueR(3:end), 'DisplayName', 'True $R_t$', 'color', 'black', 'LineStyle', '--')
%scatter(Table.week(2:T), outputStruct.CIs(1, :), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
xlabel('Time (\itt \rmweeks)')
ylabel('97.5^{th} \itR\fontsize{14}t \fontsize{18}\rmpercentile')
xlim([3.5 11.5])
ylim([0 11])


