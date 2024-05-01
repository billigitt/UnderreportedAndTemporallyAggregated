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

load('../MATs/realWorldNovelInferenceEbolaSingleRho04.mat')
load('../MATs/realWorldNovelInferenceEbolaSingleNaiveRho04.mat')

% colour scheme: blue (row 1) is EpiEstim, red (row 2) is original method
% (temp agg), green (row 3) is new method (temp agg + under-rep)
% 
colourMat = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.5*0.4660 0.5*0.6740 0.5*0.1880];

T = 102;

% VarName8 gives the reported incidence, VarName9 gives the hidden
% incidence

numWeeks = T;

%%
figure
subplot(1, 2, 1)
bar(1:102, realWorldNovelInferenceEbolaSingleRho04.reportedWeeklyI, 'BarWidth', 1)
xlabel('Time (\itt\rm weeks)')
ylabel('Reported Incidence')
box off

subplot(1, 2, 2)
p1 = plotMeanAndCredible(realWorldNovelInferenceEbolaSingleNaiveRho04.meanRt(2:end), [realWorldNovelInferenceEbolaSingleNaiveRho04.lowerRt(2:end) realWorldNovelInferenceEbolaSingleNaiveRho04.upperRt(2:end)], (2:T)', colourMat(2, :), '', '');
hold on
p2 = plotMeanAndCredible(realWorldNovelInferenceEbolaSingleRho04.meanRt(2:end), [realWorldNovelInferenceEbolaSingleRho04.lowerRt(2:end) realWorldNovelInferenceEbolaSingleRho04.upperRt(2:end)], (2:102)', colourMat(3,:), '', '');
xlabel('Time (\itt\rm weeks)')
ylabel({'Time-dependent';'reproduction number (\itR\fontsize{14}t\fontsize{18}\rm)'})
legend([p1, p2], 'Naive Ogi-Gittins et al.', '\itM\rm = 100,000')
xlim([0 25])
% set(gcf, 'color', 'none') ;