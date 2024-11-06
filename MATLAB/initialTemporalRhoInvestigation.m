
%THIS FILE CAN BE DELETED.

close all
clear all

x = readtable('../CSVs/largeScaleStudyClusterNoLimitTemporalRhoOG2_All.csv');
trueR = x.trueR;
meanRtOG2 = x.meanRt;
size(meanRtOG2)

%remove nan values
meanRtOG2(1:11:end-10) = [];
trueR(1:11:end-10) = [];

%reshape into different epidemics, all of which have 10 inferences each
trueR = reshape(trueR, 10, []);
meanRtOG2 = reshape(meanRtOG2, 10, []);

absoluteRelativeErrorWeekly = abs(trueR-meanRtOG2)./trueR;
absoluteErrorWeekly = abs(trueR-meanRtOG2);
relativeErrorWeekly = (meanRtOG2 - trueR)./trueR;
relativeErrorWeekly = reshape(relativeErrorWeekly, 1, []);
relativeErrorTotal = sum(absoluteRelativeErrorWeekly);
[minTotalError, mostAccurateEpidemic] = min(relativeErrorTotal);

figure
subplot(1, 2, 1)
yyaxis left
ylabel('Incidence')
bar(x.reportedIncidence((mostAccurateEpidemic-1)*11+1:mostAccurateEpidemic*11), 'BarWidth', 1)
yyaxis right
ylabel('Reporting probability')
temporalRho = 1./(1+exp(-((1/7:1/7:11)-5.5)*log(9)/3.5));
h(1) = plot(0.5+(1/7:1/7:11), temporalRho, 'k--');
hold on
h(2) = plot((0:4)+0.5, [0.1 0.1 0.1 0.1 0.1], 'r', 'LineStyle', '-');
h(2) = plot((4:7)+0.5, [0.5 0.5 0.5 0.5], 'r', 'LineStyle', '-');
h(2) = plot((7:11)+0.5, [0.9 0.9 0.9 0.9 0.9], 'r', 'LineStyle', '-');

legend(h([1 2]), 'True reporting rate', 'Inferred reporting rate')

subplot(1, 2, 2)
h(1) = plot(x.trueR((mostAccurateEpidemic-1)*11+1:mostAccurateEpidemic*11), 'k');
hold on
h(2) = plot(x.meanRt((mostAccurateEpidemic-1)*11+1:mostAccurateEpidemic*11), 'r');

legend(h([1 2]), 'True Rt', 'OG2 mean Rt')

figure
histogram(relativeErrorWeekly)