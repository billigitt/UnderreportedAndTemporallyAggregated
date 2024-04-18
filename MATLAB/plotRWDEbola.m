load('../MATs/realWorldInferenceEbolaAllRho.mat')

% close all

meanAndCredibleAllRhoMatrix = zeros(max(realWorldInferenceEbolaRho1.week), 3, 7); % 3D matrix with 1st dim being time, 2nd dim being means, lower percentiles and upper percentiles, and 3rd dim being rho.

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
subplot(1, 2, 1)

bar(realWorldInferenceEbolaRho1.trueWeeklyI)
xlabel('Time (weeks)')
ylabel('Assumed true incidence')

% figure
% plotMeanAndCredible(realWorldInferenceEbola.meanRt, [realWorldInferenceEbola.lowerRt, realWorldInferenceEbola.upperRt])
% xlabel('Time (days)')
% ylabel('Rt')
subplot(1, 2, 2)
p(1) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 1), [meanAndCredibleAllRhoMatrix(2:end, 2, 1), meanAndCredibleAllRhoMatrix(2:end, 3, 1)], (2:75)', 'red', 'a', 'b');
hold on
p(2) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 2), [meanAndCredibleAllRhoMatrix(2:end, 2, 2), meanAndCredibleAllRhoMatrix(2:end, 3, 2)], (2:75)', [0.8500 0.3250 0.0980], 'a2', 'b2');
p(3) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 3), [meanAndCredibleAllRhoMatrix(2:end, 2, 3), meanAndCredibleAllRhoMatrix(2:end, 3, 3)], (2:75)', 'yellow', 'a3', 'b3');
p(4) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 4), [meanAndCredibleAllRhoMatrix(2:end, 2, 4), meanAndCredibleAllRhoMatrix(2:end, 3, 4)], (2:75)', 'green', 'a4', 'b4');
p(5) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 5), [meanAndCredibleAllRhoMatrix(2:end, 2, 5), meanAndCredibleAllRhoMatrix(2:end, 3, 5)], (2:75)', 'blue', 'a5', 'b5');
p(6) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 6), [meanAndCredibleAllRhoMatrix(2:end, 2, 6), meanAndCredibleAllRhoMatrix(2:end, 3, 6)], (2:75)', [0.4940 0.1840 0.5560], 'a6', 'b6');
p(7) = plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 6), [meanAndCredibleAllRhoMatrix(2:end, 2, 6), meanAndCredibleAllRhoMatrix(2:end, 3, 6)], (2:75)', [1 0 1], 'a6', 'b6');
xlabel('Time (weeks)')
ylabel('$R_t$', 'interpreter', 'latex')
legend(p([1 2 3 4 5 6 7]), '$\rho = 0.3$', '$\rho = 0.4$', '$\rho = 0.5$', '$\rho = 0.6$', '$\rho = 0.7$', '$\rho = 0.8$', '$\rho = 0.9$')

figure
p(1) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 1), [meanAndCredibleAllRhoMatrix(2:end, 2, 1), meanAndCredibleAllRhoMatrix(2:end, 3, 1)], (2:75)', 'red', 'a');
hold on
p(2) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 2), [meanAndCredibleAllRhoMatrix(2:end, 2, 2), meanAndCredibleAllRhoMatrix(2:end, 3, 2)], (2:75)', [0.8500 0.3250 0.0980], 'a2');
p(3) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 3), [meanAndCredibleAllRhoMatrix(2:end, 2, 3), meanAndCredibleAllRhoMatrix(2:end, 3, 3)], (2:75)', 'yellow', 'a3');
p(4) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 4), [meanAndCredibleAllRhoMatrix(2:end, 2, 4), meanAndCredibleAllRhoMatrix(2:end, 3, 4)], (2:75)', 'green', 'a4');
p(5) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 5), [meanAndCredibleAllRhoMatrix(2:end, 2, 5), meanAndCredibleAllRhoMatrix(2:end, 3, 5)], (2:75)', 'blue', 'a5');
p(6) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 6), [meanAndCredibleAllRhoMatrix(2:end, 2, 6), meanAndCredibleAllRhoMatrix(2:end, 3, 6)], (2:75)', [0.4940 0.1840 0.5560], 'a6');
p(7) = plotMeanAndCredibleNoFill(meanAndCredibleAllRhoMatrix(2:end, 1, 6), [meanAndCredibleAllRhoMatrix(2:end, 2, 6), meanAndCredibleAllRhoMatrix(2:end, 3, 6)], (2:75)', [1 0 1], '');
xlabel('Time (weeks)')
ylabel('$R_t$', 'interpreter', 'latex')
legend(p([1 2 3 4 5 6 7]), '$\rho = 0.3$', '$\rho = 0.4$', '$\rho = 0.5$', '$\rho = 0.6$', '$\rho = 0.7$', '$\rho = 0.8$', '$\rho = 0.9$')