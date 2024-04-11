load('../MATs/realWorldInferenceEbolaAllRho.mat')

% close all

meanAndCredibleAllRhoMatrix = zeros(max(realWorldInferenceEbolaRho1.week), 3, 6); % 3D matrix with 1st dim being time, 2nd dim being means, lower percentiles and upper percentiles, and 3rd dim being rho.

meanAndCredibleAllRhoMatrix(:, 1, 1) = realWorldInferenceEbolaRho1.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 2) = realWorldInferenceEbolaRho2.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 3) = realWorldInferenceEbolaRho3.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 4) = realWorldInferenceEbolaRho4.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 5) = realWorldInferenceEbolaRho5.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 6) = realWorldInferenceEbolaRho6.meanRt;

meanAndCredibleAllRhoMatrix(:, 2, 1) = realWorldInferenceEbolaRho1.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 2) = realWorldInferenceEbolaRho2.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 3) = realWorldInferenceEbolaRho3.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 4) = realWorldInferenceEbolaRho4.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 5) = realWorldInferenceEbolaRho5.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 6) = realWorldInferenceEbolaRho6.lowerRt;

meanAndCredibleAllRhoMatrix(:, 3, 1) = realWorldInferenceEbolaRho1.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 2) = realWorldInferenceEbolaRho2.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 3) = realWorldInferenceEbolaRho3.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 4) = realWorldInferenceEbolaRho4.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 5) = realWorldInferenceEbolaRho5.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 6) = realWorldInferenceEbolaRho6.upperRt;

figure
bar(realWorldInferenceEbolaRho1.reportedWeeklyI)
xlabel('Time (weeks)')
ylabel('Reported Incidence')

% figure
% plotMeanAndCredible(realWorldInferenceEbola.meanRt, [realWorldInferenceEbola.lowerRt, realWorldInferenceEbola.upperRt])
% xlabel('Time (days)')
% ylabel('Rt')
figure
p(1) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 1), [meanAndCredibleAllRhoMatrix(2:end, 2, 1), meanAndCredibleAllRhoMatrix(2:end, 3, 1)], (2:53)', 'cyan', 'a', 'b');
hold on
% plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 2), [meanAndCredibleAllRhoMatrix(2:end, 2, 2), meanAndCredibleAllRhoMatrix(2:end, 3, 2)], (2:53)', 'green', 'a2', 'b2')
% plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 3), [meanAndCredibleAllRhoMatrix(2:end, 2, 3), meanAndCredibleAllRhoMatrix(2:end, 3, 3)], (2:53)', 'black', 'a3', 'b3')
% plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 4), [meanAndCredibleAllRhoMatrix(2:end, 2, 4), meanAndCredibleAllRhoMatrix(2:end, 3, 4)], (2:53)', 'yellow', 'a4', 'b4')
% plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 5), [meanAndCredibleAllRhoMatrix(2:end, 2, 5), meanAndCredibleAllRhoMatrix(2:end, 3, 5)], (2:53)', 'red', 'a5', 'b5')
p(2) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 6), [meanAndCredibleAllRhoMatrix(2:end, 2, 6), meanAndCredibleAllRhoMatrix(2:end, 3, 6)], (2:53)', 'magenta', 'a6', 'b6');
xlabel('Time (weeks)')
ylabel('$R_t$', 'interpreter', 'latex')
legend(p([1 2]), '$\rho = 0.33$', '$\rho = 0.83$')