load('../MATs/realWorldInferenceEbolaAllRhoTest.mat')

close all

meanAndCredibleAllRhoMatrix = zeros(max(testRho1.week), 3, 6); % 3D matrix with 1st dim being time, 2nd dim being means, lower percentiles and upper percentiles, and 3rd dim being rho.

meanAndCredibleAllRhoMatrix(:, 1, 1) = testRho1.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 2) = testRho2.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 3) = testRho3.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 4) = testRho4.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 5) = testRho5.meanRt;
meanAndCredibleAllRhoMatrix(:, 1, 6) = testRho6.meanRt;

meanAndCredibleAllRhoMatrix(:, 2, 1) = testRho1.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 2) = testRho2.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 3) = testRho3.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 4) = testRho4.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 5) = testRho5.lowerRt;
meanAndCredibleAllRhoMatrix(:, 2, 6) = testRho6.lowerRt;

meanAndCredibleAllRhoMatrix(:, 3, 1) = testRho1.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 2) = testRho2.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 3) = testRho3.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 4) = testRho4.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 5) = testRho5.upperRt;
meanAndCredibleAllRhoMatrix(:, 3, 6) = testRho6.upperRt;

figure
bar(testRho1.reportedWeeklyI)
xlabel('Time (weeks)')
ylabel('Reported Incidence')

% figure
% plotMeanAndCredible(test.meanRt, [test.lowerRt, test.upperRt])
% xlabel('Time (days)')
% ylabel('Rt')
figure
plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 1), [meanAndCredibleAllRhoMatrix(2:end, 2, 1), meanAndCredibleAllRhoMatrix(2:end, 3, 1)], (2:53)', 'blue', 'a', 'b')
hold on
% plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 2), [meanAndCredibleAllRhoMatrix(2:end, 2, 2), meanAndCredibleAllRhoMatrix(2:end, 3, 2)], (2:53)', 'green', 'a2', 'b2')
% plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 3), [meanAndCredibleAllRhoMatrix(2:end, 2, 3), meanAndCredibleAllRhoMatrix(2:end, 3, 3)], (2:53)', 'black', 'a3', 'b3')
% plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 4), [meanAndCredibleAllRhoMatrix(2:end, 2, 4), meanAndCredibleAllRhoMatrix(2:end, 3, 4)], (2:53)', 'yellow', 'a4', 'b4')
% plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 5), [meanAndCredibleAllRhoMatrix(2:end, 2, 5), meanAndCredibleAllRhoMatrix(2:end, 3, 5)], (2:53)', 'red', 'a5', 'b5')
plotMeanAndCredible(meanAndCredibleAllRhoMatrix(2:end, 1, 6), [meanAndCredibleAllRhoMatrix(2:end, 2, 6), meanAndCredibleAllRhoMatrix(2:end, 3, 6)], (2:53)', 'magenta', 'a6', 'b6')
xlabel('Time (weeks)')
ylabel('Rt')