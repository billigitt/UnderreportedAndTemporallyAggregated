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
 
load('../MATs/compareWithNic.mat')

numInf = 6;

T = max(compareWithNic.week);
timeConsidered = 10;

indices = reshape(((0:numInf-1)*T)+ (T-timeConsidered+1:T)', [], 1);

figure
p(1) = plotMeanAndCredibleNoFill(compareWithNic.meanRt(2:11), [compareWithNic.lowerRt(2:11), compareWithNic.upperRt(2:11)], (2:11)', 'red', '$\rho = 0.33$');
hold on
p(2) = plotMeanAndCredibleNoFill(compareWithNic.meanRt(2+1*11:11*2), [compareWithNic.lowerRt(2+1*11:11*2), compareWithNic.upperRt(2+1*11:11*2)], (2:11)', [1 .5 0], '$\rho = 0.43$');
p(3) = plotMeanAndCredibleNoFill(compareWithNic.meanRt(2+2*11:11*3), [compareWithNic.lowerRt(2+2*11:11*3), compareWithNic.upperRt(2+2*11:11*3)], (2:11)', 'yellow', '$\rho = 0.53$');
p(4) = plotMeanAndCredibleNoFill(compareWithNic.meanRt(2+3*11:11*4), [compareWithNic.lowerRt(2+3*11:11*4), compareWithNic.upperRt(2+3*11:11*4)], (2:11)', 'green', '$\rho = 0.63$');
p(5) = plotMeanAndCredibleNoFill(compareWithNic.meanRt(2+4*11:11*5), [compareWithNic.lowerRt(2+4*11:11*5), compareWithNic.upperRt(2+4*11:11*5)], (2:11)', 'cyan', '$\rho = 0.73$');
p(6) = plotMeanAndCredibleNoFill(compareWithNic.meanRt(2+5*11:11*6), [compareWithNic.lowerRt(2+5*11:11*6), compareWithNic.upperRt(2+5*11:11*6)], (2:11)', 'blue', '$\rho = 0.83$');
legend(p([1:6]), '$\rho=0.33$', '$\rho=0.43$', '$\rho=0.53$', '$\rho=0.63$', '$\rho=0.73$', '$\rho=0.83$')
xlabel('Time (weeks)')
ylabel('$R_t$', 'interpreter', 'latex')

criWidth = [(compareWithNic.upperRt(2:11) - compareWithNic.lowerRt(2:11))'; ...
    (compareWithNic.upperRt(2+11:11*2) - compareWithNic.lowerRt(2+1*11:11*2))';...
    (compareWithNic.upperRt(2+2*11:11*3) - compareWithNic.lowerRt(2+2*11:11*3))';...
    (compareWithNic.upperRt(2+3*11:11*4) - compareWithNic.lowerRt(2+3*11:11*4))';...
    (compareWithNic.upperRt(2+4*11:11*5) - compareWithNic.lowerRt(2+4*11:11*5))';...
    (compareWithNic.upperRt(2+5*11:11*6) - compareWithNic.lowerRt(2+5*11:11*6))'];

figure; bar(criWidth'); legend('$\rho = 0.33$', '$\rho = 0.43$', ...
    '$\rho = 0.53$', '$\rho = 0.63$', '$\rho = 0.73$', '$\rho = 0.83$')
xlabel('Time (weeks)')
ylabel('Width of cri')