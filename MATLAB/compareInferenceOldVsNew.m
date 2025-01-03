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

time = realWorldNovelInferenceEbolaSingleRho04.date(2:end);
timeFlip = [time; flipud(time)];
credibleNaive = [realWorldNovelInferenceEbolaSingleNaiveRho04.lowerRt(2:end) realWorldNovelInferenceEbolaSingleNaiveRho04.upperRt(2:end)];
credibleOG2 = [realWorldNovelInferenceEbolaSingleRho04.lowerRt(2:end) realWorldNovelInferenceEbolaSingleRho04.upperRt(2:end)];

credibleIntervalNaive = [credibleNaive(:, 1); flipud(credibleNaive(:,2))];
credibleIntervalOG2 = [credibleOG2(:, 1); flipud(credibleOG2(:,2))];

figure
tile = tiledlayout(2, 1);
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
hold on
g1 = fill(timeFlip, credibleIntervalNaive, colourMat(1, :));
g2 = fill(timeFlip, credibleIntervalOG2, colourMat(7, :));
set(g1, 'facealpha', 0.5)
set(g1,'LineStyle', 'none')
set(g1, 'EdgeColor', colourMat(1, :))
set(g2, 'facealpha', 0.5)
set(g2,'LineStyle', 'none')
set(g2, 'EdgeColor', colourMat(7, :))

% p1 = scatter(time, realWorldNovelInferenceEbolaSingleNaiveRho04.meanRt(2:end), 20, colourMat(1, :), 'filled');
p2 = plot(time, realWorldNovelInferenceEbolaSingleRho04.meanRt(2:end), 'color', colourMat(7, :));
p1 = plot(time, realWorldNovelInferenceEbolaSingleNaiveRho04.meanRt(2:end), 'color', colourMat(1, :));
% p2 = scatter(time, realWorldNovelInferenceEbolaSingleRho04.meanRt(2:end), 20, colourMat(7, :));
xlabel('Date (mm/yy)')
ylabel({'Time-dependent';'reproduction number (\itR\fontsize{14}t\fontsize{18}\rm)'})
legend([p1, p2], "OG1 method (with"+newline+"naive under-reporting)", "OG2 method", 'Location', 'North', 'FontSize', 12)
xtickangle(60)
xlim([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)])
xticks([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(21), realWorldNovelInferenceEbolaSingleNaiveRho04.date(41), realWorldNovelInferenceEbolaSingleNaiveRho04.date(62), realWorldNovelInferenceEbolaSingleNaiveRho04.date(82), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)])
xticklabels(datestr([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(21), realWorldNovelInferenceEbolaSingleNaiveRho04.date(41), realWorldNovelInferenceEbolaSingleNaiveRho04.date(62), realWorldNovelInferenceEbolaSingleNaiveRho04.date(82), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)], 'mm/yy'))

% ylim([-.2 2.5])

tile.Padding  = 'compact';
tile.TileSpacing = 'compact';

set(gcf,'Position',[100 100 750 750])
set(gcf, 'color', 'none') ;

%%

figure
% tile = tiledlayout(1, 2);
% nexttile
% bar((realWorldNovelInferenceEbolaSingleNaiveRho04.date)', realWorldNovelInferenceEbolaSingleRho04.reportedWeeklyI, 'BarWidth', 1, 'EdgeColor', 'none')
% xlabel('Date (mm/yy)')
% ylabel('Reported incidence')
% 
% xlim([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)])
% xticks([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(21), realWorldNovelInferenceEbolaSingleNaiveRho04.date(41), realWorldNovelInferenceEbolaSingleNaiveRho04.date(62), realWorldNovelInferenceEbolaSingleNaiveRho04.date(82), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)])
% xticklabels(datestr([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(21), realWorldNovelInferenceEbolaSingleNaiveRho04.date(41), realWorldNovelInferenceEbolaSingleNaiveRho04.date(62), realWorldNovelInferenceEbolaSingleNaiveRho04.date(82), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)], 'mm/yy'))
% xtickangle(60);
% box off
% 
% nexttile
hold on
g1 = fill(timeFlip, credibleIntervalNaive, colourMat(1, :));
g2 = fill(timeFlip, credibleIntervalOG2, colourMat(7, :));
set(g1, 'facealpha', 0.5)
set(g1,'LineStyle', 'none')
set(g1, 'EdgeColor', colourMat(1, :))
set(g2, 'facealpha', 0.5)
set(g2,'LineStyle', 'none')
set(g2, 'EdgeColor', colourMat(7, :))
p1 = plot(time, realWorldNovelInferenceEbolaSingleNaiveRho04.meanRt(2:end), 'color', colourMat(1, :), 'Marker', '.', 'MarkerSize', 20);
% p1 = scatter(time, realWorldNovelInferenceEbolaSingleNaiveRho04.meanRt(2:end), 20, colourMat(1, :), 'filled');
p2 = plot(time, realWorldNovelInferenceEbolaSingleRho04.meanRt(2:end), 'color', colourMat(7, :));
% p2 = scatter(time, realWorldNovelInferenceEbolaSingleRho04.meanRt(2:end), 20, colourMat(7, :));
xlabel('Date (mm/yy)')
ylabel({'Time-dependent';'reproduction number (\itR\fontsize{14}t\fontsize{18}\rm)'})
legend([p1, p2], "OG1 method (with"+newline+"naive under-reporting)", "OG2 method", 'Location', 'North', 'FontSize', 12)
xtickangle(60)
xlim([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)])
xticks([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(21), realWorldNovelInferenceEbolaSingleNaiveRho04.date(41), realWorldNovelInferenceEbolaSingleNaiveRho04.date(62), realWorldNovelInferenceEbolaSingleNaiveRho04.date(82), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)])
xticklabels(datestr([realWorldNovelInferenceEbolaSingleNaiveRho04.date(1), realWorldNovelInferenceEbolaSingleNaiveRho04.date(21), realWorldNovelInferenceEbolaSingleNaiveRho04.date(41), realWorldNovelInferenceEbolaSingleNaiveRho04.date(62), realWorldNovelInferenceEbolaSingleNaiveRho04.date(82), realWorldNovelInferenceEbolaSingleNaiveRho04.date(end)], 'mm/yy'))


tile.Padding  = 'compact';
tile.TileSpacing = 'compact';

set(gcf,'Position',[100 100 750 500])
set(gcf, 'color', 'none') ;