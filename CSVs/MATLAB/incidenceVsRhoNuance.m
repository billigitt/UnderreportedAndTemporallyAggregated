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
 
load('../MATs/incidenceVsRhoNuance.mat')

disp('Hello')

lowerRt = incidenceVsRhoNuance.lowerRt(incidenceVsRhoNuance.week==2);
upperRt = incidenceVsRhoNuance.upperRt(incidenceVsRhoNuance.week==2);

criWidth = upperRt - lowerRt;

criWidthMatrix = reshape(criWidth, 19, 100);