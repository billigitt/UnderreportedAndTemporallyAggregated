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

load('../MATs/largeScaleStudyOriginalMethodMaxInc200PriorHalfAndFourFirstDay10.mat')
load('../MATs/largeScaleStudyNewMaxInc200PriorHalfAndFourFirstDay10.mat')
load('../MATs/largeScaleAnalysisOurEE.mat')
load('../MATs/SIWeekly.mat')

% colour scheme: blue (row 1) is EpiEstim, red (row 2) is original method
% (temp agg), green (row 3) is new method (temp agg + under-rep)
% 

colourMat = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.5*0.4660 0.5*0.6740 0.5*0.1880];

criWidthThreshold = (icdf('Gamma', 0.975, 1, 2) - icdf('Gamma', 0.025, 1, 2))*0.75;

idx1s = 1:11:(11*9*999+11*8+1);

trueR = largeScaleStudyNewMaxInc200PriorHalfAndFourFirstDay10.trueR;
trueR(idx1s) = [];

reportedWeeklyI = largeScaleStudyNewMaxInc200PriorHalfAndFourFirstDay10.reportedWeeklyI;
reportedWeeklyI(idx1s) = [];

%estREE = 
estRNew = largeScaleStudyNewMaxInc200PriorHalfAndFourFirstDay10.meanRt;
estROG = largeScaleStudyOriginalMethodMaxInc200PriorHalfAndFourFirstDay1.meanRt;
estROG(idx1s) = [];
estRNew(idx1s) = [];

%upperREE = 
upperRNew = largeScaleStudyNewMaxInc200PriorHalfAndFourFirstDay10.upperRt;
upperROG = largeScaleStudyOriginalMethodMaxInc200PriorHalfAndFourFirstDay1.upperRt;
upperROG(idx1s) = [];
upperRNew(idx1s) = [];
%lowerREE = 
lowerRNew = largeScaleStudyNewMaxInc200PriorHalfAndFourFirstDay10.lowerRt;
lowerROG = largeScaleStudyOriginalMethodMaxInc200PriorHalfAndFourFirstDay1.lowerRt;
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

sum(coverageNewAndIncluded)/length(coverageNewAndIncluded)
sum(coverageOGAndIncluded)/length(coverageOGAndIncluded)

xx = repmat((2:11)', 9000, 1);

idxIncorrectCoverageNew = (idxIncludeNew) & (coverageNew == 0) & (xx > 2);
idxIncorrectCoverageOG = (idxIncludeOG) & (coverageOG == 0) & (xx > 2);

idxCorrectCoverageNew = (idxIncludeNew) & (coverageNew == 1) & (xx > 2);
idxCorrectNewIncorrectOG = (idxCorrectCoverageNew) & (idxIncorrectCoverageOG)...
    & (xx > 2);

idxCorrectNewIncorrectOGBehind = idxCorrectNewIncorrectOG;
idxCorrectNewIncorrectOGBehind(1) = [];
idxCorrectNewIncorrectOGBehind = [idxCorrectNewIncorrectOGBehind; false];

trueRWrongOG = trueR(idxCorrectNewIncorrectOG);
upperRWrongOG = upperROG(idxCorrectNewIncorrectOG);
lowerRWrongOG = lowerROG(idxCorrectNewIncorrectOG);

idxUnderEstimate = (trueR(idxCorrectNewIncorrectOG)> upperROG(idxCorrectNewIncorrectOG));
idxOverEstimate = (trueR(idxCorrectNewIncorrectOG)< lowerROG(idxCorrectNewIncorrectOG));

errorUnder = trueRWrongOG(idxUnderEstimate) - upperRWrongOG(idxUnderEstimate);

errorOver =  lowerRWrongOG(idxOverEstimate) - trueRWrongOG(idxOverEstimate);

% h(1) = histogram(trueR(idxCorrectNewIncorrectOG));
% hold on
% h(2) = histogram(trueR(idxCorrectNewIncorrectOGBehind));
% legend(h([1 2]), 't', 't-1')
% xlabel('Rt')
% ylabel('Frequency')


%% Plotting


figure
 
subplot(1, 3, 1)
b = boxchart(rho(idxIncludeNew), 100*absErrorNew(idxIncludeNew), 'BoxWidth', 0.05, 'MarkerStyle', 'none');
b.BoxFaceColor = colourMat(3, :);
ylim([0 130])
ylabel('Relative error (%)')
xlabel('Reporting rate, \rho')

subplot(1, 3, 2)
b = boxchart(rho(idxIncludeNew), upperRNew(idxIncludeNew) - lowerRNew(idxIncludeNew), 'BoxWidth', 0.05, 'MarkerStyle', 'none');
b.BoxFaceColor = colourMat(3, :);

ylabel('95% CrI width')
xlabel('Reporting rate, \rho')
 
subplot(1, 3, 3)
yline(95, 'k--', 'LineWidth', 1.5)
hold on
og = plot(0.1:0.1:0.9, 100*coverageByRhoOG, 'color', colourMat(1,:));
ur = plot(0.1:0.1:0.9, 100*coverageByRhoNew, 'color', colourMat(3, :));

ylim([60 100])
xlabel('Reporting rate, \rho')
ylabel('CrI coverage (%)')
legend([og ur], "Simulation based"+newline+"(no under-reporting)",...
    "Simulation based"+newline+"(under-reporting)")

%% Example Inference

figure
tile = tiledlayout(1, 2);
nexttile
bar(largeScaleStudy.reportedWeeklyI(23:33), 'BarWidth', 1)
ylabel('Reported incidence')
xlabel('Time (\itt \rmweeks)')
xlim([0.25 11.75])
xticks(1:11)
box off
nexttile
x = plotMeanAndCredible(robustnessCheckFromLargeScaleStudyM1e5.meanRt(4:11), ...
    [robustnessCheckFromLargeScaleStudyM1e5.lowerRt(4:11),...
    robustnessCheckFromLargeScaleStudyM1e5.upperRt(4:11)], (4:11)', colourMat(3, :), 'Epi-Estim Perfect Information Mean', 'Epi-Estim Perfect Information 95% Cri');
hold on
y = plotMeanAndCredible(outputStruct.Means(3:end)', outputStruct.CIs(:, 3:end)', (4:11)', colourMat(1, :), 'mean', 'ci');
z = plot(4:11, trueR(3:end), 'k--');
legend([x, y, z], '\fontsize{15}\itM\rm\fontsize{9} \fontsize{15}=\fontsize{1} \fontsize{15}100,000', 'Cori', 'True \itR\fontsize{12}t')
ylabel({'\fontsize{18}';'\fontsize{18}Time-dependent';'\fontsize{18}reproduction number (\itR\fontsize{14}t\fontsize{18}\rm)'})
xlabel('Time (\itt \rmweeks)')
xlim([3.5 11.5])
xticks(4:11)
tile.Padding  = 'compact';
tile.TileSpacing = 'compact';

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
plot(Table.week(4:T), trueR(3:end), 'DisplayName', 'True \itR\fontsize{12}t', 'color', 'black', 'LineStyle', '--')
%scatter(Table.week(4:T), outputStruct.Means(3:10), 40, 'MarkerEdgeColor',[0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410], 'LineWidth',1.5, 'DisplayName', 'EpiEstim PI')
legend('\itM\rm\fontsize{9} \fontsize{15}=\fontsize{1} \fontsize{15}1,000', '\itM\rm\fontsize{9} \fontsize{15}=\fontsize{1} \fontsize{15}10,000', '\itM\rm\fontsize{9} \fontsize{15}=\fontsize{1} \fontsize{15}100,000', 'True \itR\fontsize{12}t', 'EpiEstim')
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
xlim([3.25 11.75])
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