function p = plotMeanAndCredible(mean, credible, time, color, label1, label2)

    timeFlip = [time; flipud(time)];

    credibleInterval = [credible(:, 1); flipud(credible(:,2))];
    
    hold on
    p(1) = fill(timeFlip, credibleInterval, color , 'LineWidth', 0.1, ...
        'edgecolor', [1 1 1], 'DisplayName', label2);
    set(p(1), 'facealpha', 0.5)
    p(2) = plot(time, mean, 'color', color, 'DisplayName', label1);
    
end
