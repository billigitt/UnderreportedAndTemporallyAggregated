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
colourMat = [0.9 0.6 0;... %orange 1
    0.35 0.7 0.9;... %sky blue 2
    0 0.6 0.5;... %blueish green 3
    0.9290 0.6940 0.1250;... %yellow 4
    0 0.44 0.7;... %blue 5
    0.8 0.4 0;... %red 6
    0.4940 0.1840 0.5560]; % purple 7

T = 103;

% VarName8 gives the reported incidence, VarName9 gives the hidden
% incidence

numWeeks = T;

cri95WidthThreshold = (icdf('Gamma', 0.975, 1, 3) - icdf('Gamma', 0.025, 1, 3))*0.5;

%%
figure
tile = tiledlayout(1, 2);
nexttile
bar((realWorldNovelInferenceEbolaSingleNaiveRho04.date)', realWorldNovelInferenceEbolaSingleRho04.reportedWeeklyI, 'BarWidth', 1, 'EdgeColor', 'none')
xlabel('Date (mm/yy)')
ylabel('Reported incidence')

xlim([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)])
xticks([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(21), realWorldNovelInferenceEbolaSingleNaiveRho04.date(41), realWorldNovelInferenceEbolaSingleNaiveRho04.date(62), realWorldNovelInferenceEbolaSingleNaiveRho04.date(82), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)])
xticklabels(datestr([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(21), realWorldNovelInferenceEbolaSingleNaiveRho04.date(41), realWorldNovelInferenceEbolaSingleNaiveRho04.date(62), realWorldNovelInferenceEbolaSingleNaiveRho04.date(82), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)], 'mm/yy'))
xtickangle(60);
box off

nexttile
p2 = plotMeanAndCredible(realWorldNovelInferenceEbolaSingleRho04.meanRt(2:end), [realWorldNovelInferenceEbolaSingleRho04.lowerRt(2:end) realWorldNovelInferenceEbolaSingleRho04.upperRt(2:end)], realWorldNovelInferenceEbolaSingleRho04.date(2:end), colourMat(7,:), '', '');
hold on
p1 = plotMeanAndCredible(realWorldNovelInferenceEbolaSingleNaiveRho04.meanRt(2:end), [realWorldNovelInferenceEbolaSingleNaiveRho04.lowerRt(2:end) realWorldNovelInferenceEbolaSingleNaiveRho04.upperRt(2:end)], realWorldNovelInferenceEbolaSingleRho04.date(2:end), colourMat(1, :), '', '');
xlabel('Date (mm/yy)')
ylabel({'Time-dependent';'reproduction number (\itR\fontsize{14}t\fontsize{18}\rm)'})
legend([p1, p2], "OG1 method (with"+newline+"naive under-reporting)", "OG2 method", 'Location', 'North')
xtickangle(60)
xlim([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)])
xticks([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(21), realWorldNovelInferenceEbolaSingleNaiveRho04.date(41), realWorldNovelInferenceEbolaSingleNaiveRho04.date(62), realWorldNovelInferenceEbolaSingleNaiveRho04.date(82), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)])
xticklabels(datestr([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(21), realWorldNovelInferenceEbolaSingleNaiveRho04.date(41), realWorldNovelInferenceEbolaSingleNaiveRho04.date(62), realWorldNovelInferenceEbolaSingleNaiveRho04.date(82), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)], 'mm/yy'))

% 
tile.Padding  = 'compact';
tile.TileSpacing = 'compact';

set(gcf,'Position',[100 100 1150 500])
set(gcf, 'color', 'none')