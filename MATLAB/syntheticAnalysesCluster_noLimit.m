clear all
close all

set(0,'DefaultFigureWindowStyle', 'normal')
set(0,'DefaultTextInterpreter', 'none')
set(0,'defaultAxesTickLabelInterpreter','none')
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

load('../MATs/noLimitOriginalMethodVariableMPrior1And3.mat')
load('../MATs/noLimitNewMethodPrior1And3.mat')
load('../MATs/largeScaleAnalysisOurEE.mat')
load('../MATs/SIWeekly.mat')
load('../MATs/nSimsMaxEntIt1e7M1e4_NewAndOriginal.mat')
load('../MATs/robustnessCheckFromLargeScaleStudy.mat')

% colour scheme: blue (row 1) is EpiEstim, red (row 2) is original method
% (temp agg), green (row 3) is new method (temp agg + under-rep)
% 
%%
colourMat = [0.9 0.6 0;... %orange 1
    0.35 0.7 0.9;... %sky blue 2
    0 0.6 0.5;... %blueish green 3
    0.9290 0.6940 0.1250;... %yellow 4
    0 0.44 0.7;... %blue 5
    0.8 0.4 0;... %red 6
    0.4940 0.1840 0.5560]; % purple 7

criWidthThreshold = (icdf('Gamma', 0.975, 1, 3) - icdf('Gamma', 0.025, 1, 3))/3;

idx1s = 1:11:(11*9*999+11*8+1);
idxAll = 1:(11*9*1000);
idxNot1s = idxAll;
idxNot1s(idx1s) = [];



totalItOG = noLimitOriginalMethodVariableMPrior1And3.totalIterations;
totalItNew = noLimitNewMethodPrior1And3.totalIterations;
runTimeOG = noLimitOriginalMethodVariableMPrior1And3.runTime;
runTimeNew = noLimitNewMethodPrior1And3.runTime;
reportedWeeklyI = noLimitOriginalMethodVariableMPrior1And3.reportedWeeklyI;
totalItOG(idx1s) = [];
totalItNew(idx1s) = [];
runTimeOG(idx1s) = [];
runTimeNew(idx1s) = [];
reportedWeeklyI(idx1s) = [];
efficiencyOG = 1e3./totalItOG;
efficiencyNew = 1e5./totalItNew;
estRNew = noLimitNewMethodPrior1And3.meanRt;
estROG = noLimitOriginalMethodVariableMPrior1And3.meanRt;
estROG(idx1s) = [];
estRNew(idx1s) = [];

nSimsM1e4New = nSimsMaxEntIt1e7M1e4New.totalIterations;
nSimsM1e4NewMeans = nSimsMaxEntIt1e7M1e4New.meanRt;
nSimsM1e4NewUpper = nSimsMaxEntIt1e7M1e4New.upperRt;
nSimsM1e4NewLower = nSimsMaxEntIt1e7M1e4New.lowerRt;
nSimsM1e4New(idx1s) = [];
nSimsM1e4NewMeans(idx1s) = [];
nSimsM1e4New(isnan(nSimsM1e4NewMeans)) = 1e7;

nSimsM1e4OG = nSimsMaxEntIt1e7M1e4Original.totalIterations;
nSimsM1e4OGMeans = nSimsMaxEntIt1e7M1e4Original.meanRt;
nSimsM1e4OG(idx1s) = [];
nSimsM1e4OGMeans(idx1s) = [];
nSimsM1e4OG(isnan(nSimsM1e4OGMeans)) = 1e7;

entireItM1e4New = sum(reshape(nSimsM1e4New, 10, 9000));
entireItM1e4OG = sum(reshape(nSimsM1e4OG, 10, 9000));

entireItM1e4New(entireItM1e4New > 1e7) = 1e7+1;
entireItM1e4OG(entireItM1e4OG > 1e7) = 1e7+1;

entireItNew = sum(reshape(totalItNew, 10, 9000));
entireItOG = sum(reshape(totalItOG, 10, 9000));

% figure
% histogram(entireItOG./entireItNew)
% xlabel('#Original simulations/#New simulations')
% ylabel('Frequency')
% xlim([0 5])
% ylim([0 1700])

trueR = noLimitOriginalMethodVariableMPrior1And3.trueR;
trueR(idx1s) = [];

reportedWeeklyI = noLimitOriginalMethodVariableMPrior1And3.reportedWeeklyI;
reportedWeeklyI(idx1s) = [];

estREE = means;


upperREE = cis(:, 1);
upperRNew = noLimitNewMethodPrior1And3.upperRt;
upperROG = noLimitOriginalMethodVariableMPrior1And3.upperRt;
upperROG(idx1s) = [];
upperRNew(idx1s) = [];

lowerREE = cis(:, 2);
lowerRNew = noLimitNewMethodPrior1And3.lowerRt;
lowerROG = noLimitOriginalMethodVariableMPrior1And3.lowerRt;
lowerROG(idx1s) = [];
lowerRNew(idx1s) = [];

criWidthOG = upperROG - lowerROG;
criWidthNew = upperRNew - lowerRNew;
criWidthEE = upperREE - lowerREE;

idxIncludeOG = (criWidthOG <= criWidthThreshold);
idxIncludeNew = (criWidthNew <= criWidthThreshold);
idxIncludeEE = (criWidthEE <= criWidthThreshold);

idxExcludeOG = [];
idxExcludeNew = [];

%error calculations

errorOG = (estROG - trueR)./trueR;
errorNew = (estRNew - trueR)./trueR;
errorEE = (estREE - trueR)./trueR;
errorOG(idxExcludeOG) = [];
errorNew(idxExcludeNew) = [];
% errorEE(idxExcludeEE) = [];

absErrorOG = abs(errorOG);
absErrorNew = abs(errorNew);
absErrorEE = abs(errorEE);

coverageOG = (lowerROG <= trueR) & (upperROG >= trueR);
coverageNew = (lowerRNew <= trueR) & (upperRNew >= trueR);
coverageEE = (lowerREE <= trueR) & (upperREE >= trueR);

coverageNewEpi = coverageNew;
coverageNewEpi(~idxIncludeNew) = -1;
coverageEEEpi = coverageEE;
coverageEEEpi(~idxIncludeEE) = -1;
coverageOGEpi = coverageOG;
coverageOGEpi(~idxIncludeOG) = -1;

numIgnoredNew = 10-sum(reshape(coverageNewEpi, 10, 9000) == -1);
numIgnoredEE = 10-sum(reshape(coverageEEEpi, 10, 9000) == -1);
numIgnoredOG = 10-sum(reshape(coverageOGEpi, 10, 9000) == -1);

coverageNewEpi(coverageNewEpi==-1) = 0;
coverageEEEpi(coverageEEEpi==-1) = 0;
coverageOGEpi(coverageOGEpi==-1) = 0;

coverageNewByEpi = sum(reshape(coverageNewEpi, 10, 9000))./numIgnoredNew;
coverageEEByEpi = sum(reshape(coverageEEEpi, 10, 9000))./numIgnoredEE;
coverageOGByEpi = sum(reshape(coverageOGEpi, 10, 9000))./numIgnoredOG;

coverageByRhoOG = zeros(1,9);
coverageByRhoNew = zeros(1,9);
coverageByRhoEE = zeros(1,9);

rho = repmat(repelem((0.1:0.1:0.9)', 10), 1000, 1);
rhoVec = 0.1:0.1:0.9;

for i = 1:9
    
    logTmp = (rho == rhoVec(i));
    
    idxTmpOG = (logTmp) & (idxIncludeOG);
    idxTmpNew = (logTmp) & (idxIncludeNew);
    idxTmpEE = (logTmp) & (idxIncludeEE);
    
    coverageByRhoOG(i) = sum(coverageOG(idxTmpOG))/length(coverageOG(idxTmpOG));
    coverageByRhoNew(i) = sum(coverageNew(idxTmpNew))/length(coverageNew(idxTmpNew));
    coverageByRhoEE(i) = sum(coverageEE(idxTmpEE))/length(coverageEE(idxTmpEE));
    
end

coverageNewAndIncluded = coverageNew(idxIncludeNew);
coverageOGAndIncluded = coverageOG(idxIncludeOG);
coverageEEAndIncluded = coverageEE(idxIncludeEE);

sum(coverageEEAndIncluded)/length(coverageEEAndIncluded)
sum(coverageOGAndIncluded)/length(coverageOGAndIncluded)
sum(coverageNewAndIncluded)/length(coverageNewAndIncluded)

xx = repmat((2:11)', 9000, 1);

idxIncorrectCoverageNew = (idxIncludeNew) & (coverageNew == 0) & (xx > 2);
idxIncorrectCoverageOG = (idxIncludeOG) & (coverageOG == 0) & (xx > 2);

idxCorrectCoverageNew = (idxIncludeNew) & (coverageNew == 1) & (xx > 2);
idxCorrectNewIncorrectOG = (idxCorrectCoverageNew) & (idxIncorrectCoverageOG)...
    & (xx > 2);

idxCorrectNewIncorrectOGRaw = false*ones(99000, 1);
idxCorrectNewIncorrectOGRaw(idxNot1s) = idxCorrectNewIncorrectOG;
idxCorrectNewIncorrectOGRaw = logical(idxCorrectNewIncorrectOGRaw);


idxCorrectNewIncorrectOGBehind = idxCorrectNewIncorrectOG;
idxCorrectNewIncorrectOGBehind(1) = [];
idxCorrectNewIncorrectOGBehind = [idxCorrectNewIncorrectOGBehind; false];



% h(1) = histogram(trueR(idxCorrectNewIncorrectOG));
% hold on
% h(2) = histogram(trueR(idxCorrectNewIncorrectOGBehind));
% legend(h([1 2]), 't', 't-1')
% xlabel('Rt')
% ylabel('Frequency')


%% Plotting

figure

tile = tiledlayout(1, 2);
nexttile
b = boxchart(rho(idxIncludeNew), 100*absErrorNew(idxIncludeNew), 'BoxWidth', 0.05, 'MarkerStyle', 'none');
b.BoxFaceColor = colourMat(7, :);
ylim([0 80])
xlim([0 1])
ylabel('Relative error (%)')
xlabel('Reporting probability, \rho')
xticks(0:0.2:1)


nexttile
b = boxchart(rho(idxIncludeNew), upperRNew(idxIncludeNew) - lowerRNew(idxIncludeNew), 'BoxWidth', 0.05, 'MarkerStyle', 'none');
b.BoxFaceColor = colourMat(7, :);
xlim([0 1])
ylabel('95% CrI width')
xlabel('Reporting probability, \rho')
xticks(0:0.2:1)
 
% nexttile
% yline(95, 'k--', 'LineWidth', 1.5)
% hold on
% ee = plot(0.1:0.1:0.9, 100*coverageByRhoEE, 'color', colourMat(2,:));
% og = plot(0.1:0.1:0.9, 100*coverageByRhoOG, 'color', colourMat(1,:));
% ur = plot(0.1:0.1:0.9, 100*coverageByRhoNew, 'color', colourMat(7, :));
% 
% ylim([30 100])
% xlim([0 1])
% xticks(0:0.2:1)
% xlabel('Reporting rate, \rho')
% ylabel('CrI coverage (%)')
% legend([ee og ur], "\fontsize{16}Cori (no"+newline+"\fontsize{16}under-reporting)",...
%     "\fontsize{16}Simulation based"+newline+"\fontsize{16}(no under-reporting)",...
%     "\fontsize{16}Simulation based"+newline+"\fontsize{16}(under-reporting)",...
%     'Location', 'SouthWest')
% box off
set(gcf,'Position',[100 100 1150 500])
% set(gcf, 'color', 'none') ;

tile.Padding  = 'compact';
tile.TileSpacing = 'compact';

%%
figure
subplot(1, 2, 1);
% nexttile
h(1) = histogram(entireItM1e4OG, 'Normalization', 'probability', 'FaceColor', colourMat(1,:), 'BinWidth', 1e6, 'LineStyle', 'none');
hold on
h(2) = histogram(entireItM1e4New, 'Normalization', 'probability', 'FaceColor', colourMat(7, :), 'BinWidth', 1e6, 'LineStyle', 'none');
xlabel('Number of simulated weeks')
ylabel(""+newline+"Percentage of"+newline+"model fits (%)")
yticks(0:0.2:1)
xticks([0:5e6:1e7, 1.05e7])
yticklabels({'0', '20', '40', '60', '80', '100'})
xticklabels({'0', '5\times10^6', '', '\geq10^7'})
ylim([0 1])
legend(h([1 2]), "\fontsize{17}OG1 method", "\fontsize{17}OG2 method", 'Location', 'North')
xtickangle(0)
box off
subplot(1, 2, 2)
h(1) = histogram(100*coverageOGByEpi, 'Normalization', 'probability', 'FaceColor', colourMat(1,:), 'BinEdges', -0:100/11:100, 'LineStyle', 'none');
hold on
h(2) = histogram(100*coverageNewByEpi, 'Normalization', 'probability', 'FaceColor', colourMat(7,:), 'BinEdges', -0:100/11:100, 'LineStyle', 'none');

xline(100*mean(coverageNewByEpi), '--','color', colourMat(7, :), 'LineWidth', 2)
xline(100*mean(coverageOGByEpi), '--', 'color', colourMat(1, :), 'LineWidth', 2)
xlabel('CrI coverage (%)')
ylabel("\color{white}."+newline+"\color[rgb]{0.15, 0.15, 0.15}Percentage of"+newline+"model fits (%)")
yticks(0:0.2:1)
yticklabels({'0', '20', '40', '60', '80', '100'})
xticks(0:10:100)
xticklabels({'0', '', '20', '', '40', '', '60', '', '80', '', '100'})
xtickangle(0)
xlim([0 100])
legend(h([1 2]), "\fontsize{17}OG1 method", "\fontsize{17}OG2 method", 'Location', 'NorthWest')

box off
% tile.Padding  = 'compact';
% tile.TileSpacing = 'compact';
set(gcf,'Position',[100 100 1150 500])
% set(gcf, 'color', 'none') ;

figure
yline(95, 'k--', 'LineWidth', 1.5)
hold on
ee = plot(0.1:0.1:0.9, 100*coverageByRhoEE, 'color', colourMat(2,:), 'Marker', 'x');
og = plot(0.1:0.1:0.9, 100*coverageByRhoOG, 'color', colourMat(1,:), 'Marker', 'x');
ur = plot(0.1:0.1:0.9, 100*coverageByRhoNew, 'color', colourMat(7, :), 'Marker', 'x');

ylim([30 100])
xlim([0 1])
xticks(0:0.1:1)
xticklabels({'0', '', '0.2', '', '0.4', '', '0.6', '', '0.8', '', '1'})
xlabel('Reporting rate, \rho')
ylabel('CrI coverage (%)')
legend([ee og ur], "\fontsize{16}Cori (no"+newline+"\fontsize{16}under-reporting)",...
    "\fontsize{16}Simulation based"+newline+"\fontsize{16}(no under-reporting)",...
    "\fontsize{16}Simulation based"+newline+"\fontsize{16}(under-reporting)",...
    'Location', 'SouthWest')

box off
set(gcf,'Position',[100 100 750 500])
% set(gcf, 'color', 'none') ;


% figure
% 
% histogram(absErrorNew(idxIncludeNew), 'BinWidth', 0.02);
% hold on
% histogram(absErrorOG(idxIncludeOG), 'BinWidth', 0.02);
% xlim([0 2])

%% Example Inference


figure
tile = tiledlayout(2, 2);
nexttile
bar(1:11, noLimitNewMethodPrior1And3.reportedWeeklyI(1+11*(9*13+4):11+11*(9*13+4)), 'BarWidth', 1, 'LineStyle','none')
ylabel('\fontsize{22}Reported incidence')
xlabel('\fontsize{22}Time (\itt\fontsize{16} \fontsize{22}\rmweeks)')
xlim([0.5 11.5])
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
ylim([0 1600])
yticks(0:400:1600)
xtickangle(0)
box off
nexttile
x = plotMeanAndCredible(noLimitNewMethodPrior1And3.meanRt(2+11*(9*13+4):11+11*(9*13+4)), ...
    [noLimitNewMethodPrior1And3.lowerRt(2+11*(9*13+4):11+11*(9*13+4)),...
    noLimitNewMethodPrior1And3.upperRt(2+11*(9*13+4):11+11*(9*13+4))], (2:11)', colourMat(7, :), 'Epi-Estim Perfect Information Mean', 'Epi-Estim Perfect Information 95% Cri');
hold on
y = plotMeanAndCredible(means(1+10*(9*13+4):10+10*(9*13+4)), cis(1+10*(9*13+4):10+10*(9*13+4), :), (2:11)', colourMat(2, :), 'mean', 'ci');
z = plot(2:11, noLimitNewMethodPrior1And3.trueR(2+11*(9*13+4):11+11*(9*13+4)), 'k--');
legend([z, y, x], '\fontsize{16}True \itR\fontsize{12}t', "\fontsize{16}Cori method", "\fontsize{16}OG2 method")
ylabel({'\fontsize{22}';'\fontsize{22}Time-dependent';'\fontsize{22}reproduction number (\itR\fontsize{16}t\fontsize{22}\rm)'})
xlabel('\fontsize{22}Time (\itt\fontsize{16} \fontsize{22}\rmweeks)')
xlim([0.5 11.5])
ylim([0 16])
yticks(0:4:16)
yticklabels({'0', '4', '8', '12', '16'})
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
xtickangle(0)
nexttile
h(1) = histogram(100*errorNew(idxIncludeNew), 'Normalization', 'probability', 'FaceColor', colourMat(7, :), 'LineStyle','none');
hold on
h(2) = histogram(100*errorEE(idxIncludeEE), 'Normalization', 'probability', 'FaceColor', colourMat(2, :), 'LineStyle','none');
% xticks(0:25:100)
% % xticklabels({'0', '25', '50', '75', '100'})
yticks(0:0.05:0.25)
yticklabels({'0', '5', '10', '15', '20', '25'})
xlabel('\fontsize{22}Relative error (%)')
ylabel('\fontsize{22}Percentage of inferences (%)')
% xline(mean(errorEE(idxIncludeEE))*100, '--', 'color', colourMat(1, :), 'LineWidth', 2)
% xline(mean(errorNew(idxIncludeNew))*100, '--', 'color', colourMat(7, :), 'LineWidth', 2)
xlim([-100 100])
xtickangle(0)
legend(h([2 1]), "\fontsize{16}Cori method", "\fontsize{16}OG2 method", 'Location', 'NorthWest')
box off


nexttile
h(1) = histogram(100*coverageNewByEpi, 'Normalization', 'probability', 'FaceColor', colourMat(7, :), 'BinEdges', 0:100/11:100, 'LineStyle','none');
hold on
h(2) = histogram(100*coverageEEByEpi, 'Normalization', 'probability', 'FaceColor', colourMat(2, :), 'BinEdges', 0:100/11:100, 'LineStyle','none');
% yticks(0:0.1:0.6)
% yticklabels({'0', '10', '20', '30', '40', '50', '60'})
xline(100*mean(coverageNewByEpi), '--','color', colourMat(7, :), 'LineWidth', 2)
xline(100*mean(coverageEEByEpi), '--', 'color', colourMat(2, :), 'LineWidth', 2)
yticks(0:0.2:1)
yticklabels({'0', '20', '40', '60', '80', '100'})
xlim([0 100])
xticks(0:10:100)
xticklabels({'0', '', '20', '', '40', '', '60', '', '80', '', '100'})
ylabel("\fontsize{22}Percentage of"+newline+"model fits (%)")
xlabel('\fontsize{22}CrI coverage (%)')
xtickangle(0)
legend(h([2 1]), "\fontsize{16}Cori method", "\fontsize{16}OG2 method", 'Location', 'NorthWest')
box off


set(gcf,'Position',[100 100 1150 1150])
% set(gcf, 'color', 'none') ;

tile.Padding  = 'compact';
tile.TileSpacing = 'compact';


% figure
% subplot(1, 2, 1)
% histogram(100*absErrorNew(idxIncludeNew), 'Normalization', 'probability', 'FaceColor', colourMat(7, :))
% hold on
% histogram(100*absErrorEE(idxIncludeEE), 'Normalization', 'probability', 'FaceColor', colourMat(1, :))
% xticks(0:25:100)
% xticklabels({'0', '25', '50', '75', '100'})
% yticks(0:0.1:0.4)
% yticklabels({'0', '10', '20', '30', '40'})
% xlim([0 100])
% xlabel('\fontsize{22}Relative error (%)')
% ylabel('\fontsize{22}Percentage of inferences (%)')
% xline(mean(absErrorEE(idxIncludeEE))*100, '--', 'color', colourMat(1, :), 'LineWidth', 2)
% xline(mean(absErrorNew(idxIncludeNew))*100, '--', 'color', colourMat(7, :), 'LineWidth', 2)
% box off
% subplot(1, 2, 2)
% histogram(coverageNewByEpi, 'Normalization', 'probability', 'FaceColor', colourMat(7, :), 'BinEdges', -0.05:0.1:1.05)
% hold on
% histogram(coverageEEByEpi, 'Normalization', 'probability', 'FaceColor', colourMat(1, :), 'BinEdges', -0.05:0.1:1.05)
% % yticks(0:0.1:0.6)
% % yticklabels({'0', '10', '20', '30', '40', '50', '60'})
% xline(mean(coverageNew(idxIncludeNew)), '--','color', colourMat(7, :), 'LineWidth', 2)
% xline(mean(coverageEE(idxIncludeEE)), '--', 'color', colourMat(1, :), 'LineWidth', 2)
% yticks(0:0.2:0.8)
% yticklabels({'0', '20', '40', '60', '80'})
% xlim([0 1.05])
% xticks(0:0.2:1)
% xticklabels({'0', '20', '40', '60', '80', '100'})
% ylabel("\fontsize{22}Percentage of"+newline+"simulated epidemics (%)")
% xlabel('\fontsize{22}CrI coverage (%)')
% 
% legend("\fontsize{18}Simulation based"+newline+"\fontsize{18}(under-reporting)", "\fontsize{18}Cori (no"+newline+"\fontsize{18}under-reporting)", 'Location', 'NorthWest')
% box off
% set(gcf,'Position',[100 100 1150 500])
% set(gcf, 'color', 'none') ;



T = max(robustnessCheckFromLargeScaleStudyM1e3.week);

Table = vertcat(robustnessCheckFromLargeScaleStudyM1e3, ...
    robustnessCheckFromLargeScaleStudyM1e4, ...
    robustnessCheckFromLargeScaleStudyM1e5);

Table.M = [1e3*ones(30*T, 1); 1e4*ones(30*T, 1); 1e5*ones(30*T, 1)];

idxIncluded = reshape((2:11)' + (0:11:89*11), 1, []);

% figure
% subplot(1,3,1)
% boxchart(Table.week(idxIncluded), Table.meanRt(idxIncluded), 'GroupByColor', Table.M(idxIncluded), 'MarkerStyle', "none")
% hold on
% plot(Table.week(2:T), noLimitNewMethodPrior1And3.trueR(2+11*(9*13+4):11+11*(9*13+4)), 'DisplayName', 'True \itR\fontsize{12}t', 'color', 'black', 'LineStyle', '--')
% %scatter(Table.week(4:T), outputStruct.Means(3:10), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
% xlabel('Time (\itt \rmweeks)')
% ylabel('Mean \itR\fontsize{16}t')
% xlim([0.5 11.5])
% ylim([0 11])
% 
% subplot(1, 3,2)
% boxchart(Table.week(idxIncluded), Table.lowerRt(idxIncluded), 'GroupByColor', Table.M(idxIncluded), 'MarkerStyle', "none")
% hold on
% plot(Table.week(2:T), noLimitNewMethodPrior1And3.trueR(2+11*(9*13+4):11+11*(9*13+4)), 'DisplayName', 'True $R_t$', 'color', 'black', 'LineStyle', '--')
% %scatter(Table.week(2:T), outputStruct.CIs(2, :), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
% xlabel('Time (\itt \rmweeks)')
% ylabel('2.5^{th} \itR\fontsize{16}t \fontsize{22}\rmpercentile')
% xlim([0.5 11.75])
% ylim([0 11])
% legend('\fontsize{18}\itM\rm\fontsize{9} \fontsize{18}=\fontsize{1} \fontsize{18}1,000', '\fontsize{18}\itM\rm\fontsize{9} \fontsize{18}=\fontsize{1} \fontsize{18}10,000', '\fontsize{18}\itM\rm\fontsize{9} \fontsize{18}=\fontsize{1} \fontsize{18}100,000', 'True \itR\fontsize{14}t', 'EpiEstim')
% 
% 
% subplot(1, 3,3)
% boxchart(Table.week(idxIncluded), Table.upperRt(idxIncluded), 'GroupByColor', Table.M(idxIncluded), 'MarkerStyle', "none")
% hold on
% plot(Table.week(2:T), noLimitNewMethodPrior1And3.trueR(2+11*(9*13+4):11+11*(9*13+4)), 'DisplayName', 'True $R_t$', 'color', 'black', 'LineStyle', '--')
% %scatter(Table.week(2:T), outputStruct.CIs(1, :), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
% xlabel('Time (\itt \rmweeks)')
% ylabel('97.5^{th} \itR\fontsize{16}t \fontsize{22}\rmpercentile')
% xlim([0.5 11.5])
% ylim([0 11])
% 
% box off
% set(gcf,'Position',[100 100 1150 500])
% set(gcf, 'color', 'none') ;

perturbation = [-1/3 0 1/3];

colours = [colourMat(5, :); colourMat(7, :); colourMat(3, :)];

figure
tile = tiledlayout(1, 3);
nexttile
plot(Table.week(2:T), noLimitNewMethodPrior1And3.trueR(2+11*(9*13+4):11+11*(9*13+4)),...
    'DisplayName', 'True \itR\fontsize{12}t', 'color', 'black', 'LineStyle', '--', 'Marker', 'x')
hold on

for ii = 1:3
    
    for jj = 2:11
        
        idxTmp = 330*(ii-1) + (jj:11:(11*29+jj));
        
        lowerTmp = prctile(Table.meanRt(idxTmp), 2.5);
        upperTmp = prctile(Table.meanRt(idxTmp), 97.5);
        
        xPt = jj + perturbation(ii);
        
        h(ii) = plot([xPt xPt], [lowerTmp upperTmp], 'color', colours(ii, :), 'LineWidth', 3);
        
    end
    
end
xlim([0.5 11.5])
xticks(2:11)
xticklabels({ '2', '', '4', '', '6', '', '8', '', '10', ''})
yticks(0:2.5:12.5)
ylim([0 12.5])
xlabel('Time (\itt \rmweeks)')
ylabel('\fontsize{22}Mean \itR\fontsize{16}t \fontsize{22}\rmestimate')
xtickangle(0)
box off
legend(h([1 2 3]), '\fontsize{18}\itM\rm\fontsize{9} \fontsize{18}=\fontsize{1} \fontsize{18}1,000', '\fontsize{18}\itM\rm\fontsize{9} \fontsize{18}=\fontsize{1} \fontsize{18}10,000', '\fontsize{18}\itM\rm\fontsize{9} \fontsize{18}=\fontsize{1} \fontsize{18}100,000')

nexttile
plot(Table.week(2:T), noLimitNewMethodPrior1And3.trueR(2+11*(9*13+4):11+11*(9*13+4)),...
    'DisplayName', 'True \itR\fontsize{12}t', 'color', 'black', 'LineStyle', '--', 'Marker', 'x')
hold on

for ii = 1:3
    
    for jj = 2:11
        
        idxTmp = 330*(ii-1) + (jj:11:(11*29+jj));
        
        lowerTmp = prctile(Table.lowerRt(idxTmp), 2.5);
        upperTmp = prctile(Table.lowerRt(idxTmp), 97.5);
        
        xPt = jj + perturbation(ii);
        
        h(ii) = plot([xPt xPt], [lowerTmp upperTmp], 'color', colours(ii, :), 'LineWidth', 3);
        
    end
    
end
xlim([0.5 11.5])
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
yticks(0:2.5:12.5)
ylim([0 12.5])
xlabel('Time (\itt \rmweeks)')
ylabel('2.5^{th} percentile \itR\fontsize{16}t \fontsize{22}\rmestimate')
box off
xtickangle(0)
nexttile
plot(Table.week(2:T), noLimitNewMethodPrior1And3.trueR(2+11*(9*13+4):11+11*(9*13+4)),...
    'DisplayName', 'True \itR\fontsize{12}t', 'color', 'black', 'LineStyle', '--', 'Marker', 'x')
hold on

for ii = 1:3
    
    for jj = 2:11
        
        idxTmp = 330*(ii-1) + (jj:11:(11*29+jj));
        
        lowerTmp = prctile(Table.upperRt(idxTmp), 2.5);
        upperTmp = prctile(Table.upperRt(idxTmp), 97.5);
        
        xPt = jj + perturbation(ii);
        
        plot([xPt xPt], [lowerTmp upperTmp], 'color', colours(ii, :), 'LineWidth', 3)
        
    end
    
end
xlim([0.5 11.5])
xticks(1:11)
xticklabels({'', '2', '', '4', '', '6', '', '8', '', '10', ''})
yticks(0:2.5:12.5)
ylim([0 12.5])
xlabel('Time (\itt \rmweeks)')
ylabel(""+newline+"97.5^{th} percentile \itR\fontsize{16}t \fontsize{22}\rmestimate")
xtickangle(0)
set(gcf,'Position',[100 100 1150 500])
% set(gcf, 'color', 'none')

box off

tile.Padding  = 'compact';
tile.TileSpacing = 'compact';