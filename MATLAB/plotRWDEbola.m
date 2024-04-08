load('../MATs/ebolaRealWorldInferenceEdittedM1e5.mat')

close all

figure
bar(realWorldInferenceEbolaEdittedM1e5.reportedWeeklyI)
xlabel('Time (weeks)')
ylabel('Reported Incidence')

% figure
% plotMeanAndCredible(realWorldInferenceEbola.meanRt, [realWorldInferenceEbola.lowerRt, realWorldInferenceEbola.upperRt])
% xlabel('Time (days)')
% ylabel('Rt')
figure
plotMeanAndCredible(realWorldInferenceEbolaEdittedM1e5.meanRt, [realWorldInferenceEbolaEdittedM1e5.lowerRt, realWorldInferenceEbolaEdittedM1e5.upperRt])
xlabel('Time (weeks)')
ylabel('Rt')

function p = plotMeanAndCredible(mean, credible)

    time = (1:length(mean))';
    timeCredible = time;
    timeCredible(1) = [];
    timeFlip = [timeCredible; flipud(timeCredible)];
    credible(1, :) = [];
    credibleInterval = [credible(:, 1); flipud(credible(:,2))];
    
    hold on
    p(1) = fill(timeFlip, credibleInterval, 'red' , 'LineWidth', 0.1, ...
        'edgecolor', [1 1 1]);
    set(p(1), 'facealpha', 0.5)
    p(2) = plot(time, mean, 'color', 'red');
    
end

function p = plotMeanAndCredibleWithDate(mean, credible, date)

    time = (1:length(mean))';
    timeCredible = time;
    timeCredible(1) = [];
    timeFlip = [timeCredible; flipud(timeCredible)];
    credible(1, :) = [];
    credibleInterval = [credible(:, 1); flipud(credible(:,2))];
    
    hold on
    p(1) = fill(timeFlip, credibleInterval, 'red' , 'LineWidth', 0.1, ...
        'edgecolor', [1 1 1]);
    set(p(1), 'facealpha', 0.5)
    p(2) = plot(time, mean);
    
end