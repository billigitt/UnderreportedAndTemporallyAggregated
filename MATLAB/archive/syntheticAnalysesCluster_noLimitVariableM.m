clear all
close all

set(0,'DefaultFigureWindowStyle','normal')
set(0,'DefaultTextInterpreter', 'none')
set(0,'defaultAxesTickLabelInterpreter','none')
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

load('../MATs/noLimitOriginalMethodVariableMPrior1And3.mat')
load('../MATs/noLimitNewMethodTmpPrior1And3.mat')
load('../MATs/largeScaleAnalysisOurEE_BigEpiLowRhos.mat')
load('../MATs/SIWeekly.mat')

% colour scheme: blue (row 1) is EpiEstim, red (row 2) is original method
% (temp agg), green (row 3) is new method (temp agg + under-rep)
% 

colourMat = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.5*0.4660 0.5*0.6740 0.5*0.1880];

criWidthThreshold = (icdf('Gamma', 0.975, 1, 5) - icdf('Gamma', 0.025, 1, 5))*0.75;

idx1s = 1:11:(11*9*999+11*8+1);
idxAll = 1:(11*9*1000);
idxNot1s = idxAll;
idxNot1s(idx1s) = [];

totalItOG = noLimitOriginalMethodVariableMPrior1And3.totalIterations;
totalItNew = noLimitNewMethodTmpPrior1And3.totalIterations;
runTimeOG = noLimitOriginalMethodVariableMPrior1And3.runTime;
runTimeNew = noLimitNewMethodTmpPrior1And3.runTime;
reportedWeeklyI = noLimitOriginalMethodVariableMPrior1And3.reportedWeeklyI;
totalItOG(idx1s) = [];
totalItNew(idx1s) = [];
runTimeOG(idx1s) = [];
runTimeNew(idx1s) = [];
reportedWeeklyI(idx1s) = [];
efficiencyOG = 1e3./totalItOG;
efficiencyNew = 1e5./totalItNew;
estRNew = noLimitNewMethodTmpPrior1And3.meanRt;
estROG = noLimitOriginalMethodVariableMPrior1And3.meanRt;
estROG(idx1s) = [];
estRNew(idx1s) = [];

idxDNFNew = isnan(estRNew);
idxDNFOG = isnan(estROG);

totalItNew(idxDNFNew) = 1e6+1;
totalItOG(idxDNFOG) = 1e6+1;

entireItNew = sum(reshape(totalItNew, 10, 9000));
entireItOG = sum(reshape(totalItOG, 10, 9000));

% idxEntireItNewLarge = (entireItNew > 1e6);
% idxEntireItOGLarge = (entireItOG > 1e6);
% entireItNew(idxEntireItNewLarge) = 1e6+1;
% entireItOG(idxEntireItOGLarge) = 1e6+1;

figure
histogram(entireItOG./entireItNew)
xlabel('Ratio of total iterations over time-series (original/new)')
ylabel('Frequency')

figure
h(1) = histogram(entireItOG, 'Normalization', 'probability', 'BinWidth', 5e4);
hold on
h(2) = histogram(entireItNew, 'Normalization', 'probability', 'BinWidth', 5e4);
legend(h([1 2]), "Simulation based"+newline+"(no under-reporting)", "Simulation based"+newline+"(under-reporting)")


xlabel('Entire number of simulations')
ylabel('Percentage of epidemics (%)')
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100)


figure
h(1) = histogram(100*efficiencyOG, 'Normalization', 'probability', 'BinWidth', 2.5);
hold on
h(2) = histogram(100*efficiencyNew, 'Normalization', 'probability', 'BinWidth', 2.5);
legend(h([1 2]), "Simulation based"+newline+"(no under-reporting)", "Simulation based"+newline+"(under-reporting)")


xlabel('Percentage of simulations accepted (%)')
ylabel('Percentage of inferences (%)')
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100)

figure
h(1) = histogram(totalItOG, 'Normalization', 'probability', 'BinWidth', 1e4);
hold on
h(2) = histogram(totalItNew, 'Normalization', 'probability', 'BinWidth', 1e4);
legend(h([1 2]), "Simulation based"+newline+"(no under-reporting)", "Simulation based"+newline+"(under-reporting)")

xlim([0 5e5])

xlabel('Number of iterations per inference')
ylabel('Percentage of inferences (%)')
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100)

figure
h(1) = plot(entireItOG);
hold on
h(2) = plot(entireItNew);
legend(h([1 2]), "Simulation based"+newline+"(no under-reporting)", "Simulation based"+newline+"(under-reporting)")

ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100)

figure
h(1) = scatter(reportedWeeklyI, totalItOG);
hold on
h(2) = scatter(reportedWeeklyI, totalItNew);

legend(h([1 2]), "Simulation based"+newline+"(no under-reporting)", "Simulation based"+newline+"(under-reporting)")

set(gca, 'YScale', 'log')

xlabel('Reported incidence')
ylabel('Number of iterations')

trueR = noLimitOriginalMethodVariableMPrior1And3.trueR;
trueR(idx1s) = [];

reportedWeeklyI = noLimitOriginalMethodVariableMPrior1And3.reportedWeeklyI;
reportedWeeklyI(idx1s) = [];

%estREE = 


%upperREE = 
upperRNew = noLimitNewMethodTmpPrior1And3.upperRt;
upperROG = noLimitOriginalMethodVariableMPrior1And3.upperRt;
upperROG(idx1s) = [];
upperRNew(idx1s) = [];

%lowerREE = 
lowerRNew = noLimitNewMethodTmpPrior1And3.lowerRt;
lowerROG = noLimitOriginalMethodVariableMPrior1And3.lowerRt;
lowerROG(idx1s) = [];
lowerRNew(idx1s) = [];

criWidthOG = upperROG - lowerROG;
criWidthNew = upperRNew - lowerRNew;

idxIncludeOG = (criWidthOG<=criWidthThreshold);
idxIncludeNew = (criWidthNew<=criWidthThreshold);

idxExcludeOG = [];
idxExcludeNew = [];

%error calculations

errorOG = (estROG - trueR)./trueR;
errorNew = (estRNew - trueR)./trueR;
errorOG(idxExcludeOG) = [];
errorNew(idxExcludeNew) = [];

absErrorOG = abs(errorOG);
absErrorNew = abs(errorNew);

coverageOG = (lowerROG <= trueR) & (upperROG >= trueR);
coverageNew = (lowerRNew <= trueR) & (upperRNew >= trueR);

coverageByRhoOG = zeros(1,9);

rho = repmat(repelem((0.1:0.1:0.9)', 10), 1000, 1);
rhoVec = 0.1:0.1:0.9;

for i = 1:9
   
    logTmp = (rho == rhoVec(i));
    
    idxTmpOG = (logTmp) & (idxIncludeOG);
    idxTmpNew = (logTmp) & (idxIncludeNew);
    
    coverageByRhoOG(i) = sum(coverageOG(idxTmpOG))/length(coverageOG(idxTmpOG));
    coverageByRhoNew(i) = sum(coverageNew(idxTmpNew))/length(coverageNew(idxTmpNew));
    
end

coverageNewAndIncluded = coverageNew(idxIncludeNew);
coverageOGAndIncluded = coverageOG(idxIncludeOG);

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

subplot(1, 3, 1)
b = boxchart(rho(idxIncludeNew), 100*absErrorNew(idxIncludeNew), 'BoxWidth', 0.005, 'MarkerStyle', 'none');
b.BoxFaceColor = colourMat(3, :);
ylim([0 130])
xlim([0 0.1])
ylabel('Relative error (%)')
xlabel('Reporting rate, \rho')

subplot(1, 3, 2)
b = boxchart(rho(idxIncludeNew), upperRNew(idxIncludeNew) - lowerRNew(idxIncludeNew), 'BoxWidth', 0.005, 'MarkerStyle', 'none');
b.BoxFaceColor = colourMat(3, :);
xlim([0 0.1])
ylabel('95% CrI width')
xlabel('Reporting rate, \rho')
 
subplot(1, 3, 3)
yline(95, 'k--', 'LineWidth', 1.5)
hold on
og = plot(0.01:0.01:0.09, 100*coverageByRhoOG, 'color', colourMat(1,:));
ur = plot(0.01:0.01:0.09, 100*coverageByRhoNew, 'color', colourMat(3, :));

ylim([60 100])
xlim([0 0.1])
xlabel('Reporting rate, \rho')
ylabel('CrI coverage (%)')
legend([og ur], "Simulation based"+newline+"(no under-reporting)",...
    "Simulation based"+newline+"(under-reporting)")

%% Example Inference

% figure
% tile = tiledlayout(1, 2);
% nexttile
% bar(largeScaleStudyNewBigEpiLowRhosPrior1And2FirstDay100.reportedWeeklyI(1:11), 'BarWidth', 1)
% ylabel('Reported incidence')
% xlabel('Time (\itt \rmweeks)')
% xlim([0.25 11.75])
% xticks(1:11)
% box off
% nexttile
% x = plotMeanAndCredible(largeScaleStudyNewBigEpiLowRhosPrior1And2FirstDay100.meanRt(2+99*2:11+99*2), ...
%     [largeScaleStudyNewBigEpiLowRhosPrior1And2FirstDay100.lowerRt(2+99*2:11+99*2),...
%     largeScaleStudyNewBigEpiLowRhosPrior1And2FirstDay100.upperRt(2+99*2:11+99*2)], (2:11)', colourMat(3, :), 'Epi-Estim Perfect Information Mean', 'Epi-Estim Perfect Information 95% Cri');
% hold on
% y = plotMeanAndCredible(means(2+99*2:11+99*2), cis(2+99*2:11+99*2, :), (2:11)', colourMat(1, :), 'mean', 'ci');
% z = plot(2:11, largeScaleStudyNewBigEpiLowRhosPrior1And2FirstDay100.trueR(2+99*2:11+99*2), 'k--');
% legend([x, y, z], '\fontsize{15}\itM\rm\fontsize{9} \fontsize{15}=\fontsize{1} \fontsize{15}100,000', 'Cori', 'True \itR\fontsize{12}t')
% ylabel({'\fontsize{18}';'\fontsize{18}Time-dependent';'\fontsize{18}reproduction number (\itR\fontsize{14}t\fontsize{18}\rm)'})
% xlabel('Time (\itt \rmweeks)')
% xlim([1.5 11.5])
% xticks(2:11)
% tile.Padding  = 'compact';
% tile.TileSpacing = 'compact';

%
% 
% T = max(robustnessCheckFromLargeScaleStudyM1e3.week);
% 
% Table = vertcat(robustnessCheckFromLargeScaleStudyM1e3, ...
%     robustnessCheckFromLargeScaleStudyM1e4, ...
%     robustnessCheckFromLargeScaleStudyM1e5);
% 
% Table.M = [1e3*ones(30*T, 1); 1e4*ones(30*T, 1); 1e5*ones(30*T, 1)];
% 
% idxIncluded = reshape((4:11)' + (0:11:89*11), 1, []);
% 
% figure
% subplot(1,3,1)
% boxchart(Table.week(idxIncluded), Table.meanRt(idxIncluded), 'GroupByColor', Table.M(idxIncluded))
% hold on
% plot(Table.week(4:T), trueR(3:end), 'DisplayName', 'True \itR\fontsize{12}t', 'color', 'black', 'LineStyle', '--')
% %scatter(Table.week(4:T), outputStruct.Means(3:10), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
% legend('\itM\rm\fontsize{9} \fontsize{15}=\fontsize{1} \fontsize{15}1,000', '\itM\rm\fontsize{9} \fontsize{15}=\fontsize{1} \fontsize{15}10,000', '\itM\rm\fontsize{9} \fontsize{15}=\fontsize{1} \fontsize{15}100,000', 'True \itR\fontsize{12}t', 'EpiEstim')
% xlabel('Time (\itt \rmweeks)')
% ylabel('Mean \itR\fontsize{14}t')
% xlim([3.5 11.5])
% ylim([0 11])
% 
% subplot(1, 3,2)
% boxchart(Table.week(idxIncluded), Table.lowerRt(idxIncluded), 'GroupByColor', Table.M(idxIncluded))
% hold on
% plot(Table.week(4:T), trueR(3:end), 'DisplayName', 'True $R_t$', 'color', 'black', 'LineStyle', '--')
% %scatter(Table.week(2:T), outputStruct.CIs(2, :), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
% xlabel('Time (\itt \rmweeks)')
% ylabel('2.5^{th} \itR\fontsize{14}t \fontsize{18}\rmpercentile')
% xlim([3.25 11.75])
% ylim([0 11])
% 
% subplot(1, 3,3)
% boxchart(Table.week(idxIncluded), Table.upperRt(idxIncluded), 'GroupByColor', Table.M(idxIncluded))
% hold on
% plot(Table.week(4:T), trueR(3:end), 'DisplayName', 'True $R_t$', 'color', 'black', 'LineStyle', '--')
% %scatter(Table.week(2:T), outputStruct.CIs(1, :), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
% xlabel('Time (\itt \rmweeks)')
% ylabel('97.5^{th} \itR\fontsize{14}t \fontsize{18}\rmpercentile')
% xlim([3.5 11.5])
% ylim([0 11])