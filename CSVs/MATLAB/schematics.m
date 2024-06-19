%% Schematics


clear all
close all

set(0,'DefaultFigureWindowStyle','normal')
set(0,'DefaultTextInterpreter', 'none')
set(0,'defaultAxesTickLabelInterpreter','none');
set(0, 'defaultLegendInterpreter','none')
set(0, 'defaultaxesfontsize', 22)
set(0, 'defaultlinelinewidth', 1.5)

set(0, 'DefaultAxesFontName', 'aakar');
set(0, 'DefaultTextFontName', 'aakar');
set(0, 'defaultUicontrolFontName', 'aakar');
set(0, 'defaultUitableFontName', 'aakar');
set(0, 'defaultUipanelFontName', 'aakar');

set(groot, 'defaultAxesTickLabelInterpreter','tex');
set(groot, 'defaultLegendInterpreter','tex');
set(0, 'DefaultTextInterpreter', 'tex')

% colour scheme: blue (row 1) is EpiEstim, red (row 2) is original method
% (temp agg), green (row 3) is new method (temp agg + under-rep)
% 
colourMat = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880];

clrGreen = [colourMat(3, :)*0.75; colourMat(3, :)*0.75; colourMat(3, :)*0.75; colourMat(3, :)*0.75; ...
    colourMat(3, :)*0.75; colourMat(3, :)*0.75; colourMat(3, :)*0.75; colourMat(3, :)*0.75; ...
    colourMat(3, :)*0.75; colourMat(3, :)*1.1; colourMat(3, :)*1.1; colourMat(3, :)*1.1];

incidenceWeekly = [20 30 25 10];

incidence1Week3 = [8 7 10 4 20 9 8 10 12]; % L = 0.172
incidence2Week3 = [12 3 8 11 10 15 7 12 9]; % L = 0.0990
incidence3Week3 = [5 9 14 8 18 3 12 6 8]; % L = 0.0196

incidence1Week4 = [8 7 10 4 20 9 8 10 12 8 4 1]; % L = 0.246
incidence2Week4 = [8 7 10 4 20 9 8 10 12 10 4 6]; % L = 0.00203
incidence3Week4 = [12 3 8 11 10 15 7 12 9 5 3 0]; % unaccepted

figure
subplot(1, 3, 1)

bar(incidence1Week3, 'FaceColor', colourMat(3, :)*0.75, 'BarWidth', 1)
ylabel('Incidence')
% xlabel(""+newline+"Time (\itt \rmweeks)")
xticks([2 5 8 11])
box off
ylim([0 20])
subplot(1, 3, 2)

bar(incidence2Week3, 'FaceColor', colourMat(3, :)*0.75, 'BarWidth', 1)
% ylabel('Incidence')
xlabel(""+newline+"\fontsize{24}Time (\itt \rmweeks)")
xticks([2 5 8 11])
box off
ylim([0 20])
subplot(1, 3, 3)

bar(incidence3Week3, 'FaceColor', colourMat(3, :)*0.75, 'BarWidth', 1)
xticks([2 5 8 11])
% xlabel(""+newline+"Time (\itt \rmweeks)")
% ylabel('Incidence')

set(gcf,'Position',[100 100 1200 275])
set(gcf, 'color', 'none') ;
box off
ylim([0 20])

figure
subplot(3, 1, 3)

b = bar(incidence1Week4, 'FaceColor', colourMat(3, :), 'BarWidth', 1, 'facecolor', 'flat');
ylabel('Incidence')
xlabel(""+newline+"Time (\itt \rmweeks)")
xticks([2 5 8 11])
box off
ylim([0 20])
subplot(3, 1, 2)
b.CData = clrGreen;

b = bar(incidence2Week4, 'FaceColor', colourMat(3, :), 'BarWidth', 1, 'facecolor', 'flat');
ylabel('Incidence')

xticks([2 5 8 11])
box off
ylim([0 20])
b.CData = clrGreen;
subplot(3, 1, 1)

b = bar(incidence3Week4, 'FaceColor', colourMat(3, :), 'BarWidth', 1, 'facecolor', 'flat');
xticks([2 5 8 11])

ylabel('Incidence')
box off
ylim([0 20])
set(gcf,'Position',[100 100 500 1250])
set(gcf, 'color', 'none') ;
box off
b.CData = clrGreen;
figure
b = bar(incidenceWeekly, 'BarWidth', 1, 'facecolor', 'flat');
xlabel('Time (\itt \rmweeks)')
ylabel('Incidence')
xlim([0.25 4.75])

set(gcf,'Position',[100 100 400 400])
set(gcf, 'color', 'none') ;
box off

clr = [colourMat(1, :)*0.75; colourMat(1, :)*0.75;...
    colourMat(1, :)*0.75; colourMat(1, :)*1.25];
b.CData = clr;

figure
x = 0:0.01:2;
y = gampdf(x, 1.4, 0.6);
plot(x, y, 'k')
box off
xlabel({'Time-dependent';'reproduction number (\itR\fontsize{17}t\fontsize{24}\rm)'})
ylabel("Probability density")
set(gcf,'Position',[100 100 430 400])
set(gcf, 'color', 'none')

figure
bar([0 0.38 0.24 0.16 0.1 0.06 0.03 0.02 0.01], 'BarWidth', 1, 'FaceColor', [.5 .5 .5])
box off
ylabel('Probability')
xlabel(""+newline+"Serial interval"+newline+"(\itt\rm weeks)")
xticks([2 5 8])
set(gcf,'Position',[100 100 390 400])
set(gcf, 'color', 'none') ;

figure
plotMeanAndCredible([1.5 1.1 0.9], [0.85 2.1; 0.6 1.6; 0.5 1.25], (2:4)', colourMat(3, :), '', '')
ylim([0 2.5])
xlim([0.5 5])
xticks(1:4)
ylabel("Time-dependent"+newline+"reproduction number (\itR\fontsize{18}t\fontsize{22})")
set(gcf, 'color', 'none') ;
xlabel("Time (\itt\rm weeks)")