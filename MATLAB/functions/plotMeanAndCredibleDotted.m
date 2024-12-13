function p = plotMeanAndCredibleDotted(mean, credible, time, color, label1, label2)

    timeFlip = [time; flipud(time)];

    credibleInterval = [credible(:, 1); flipud(credible(:,2))];
    
    hold on
    g = fill(timeFlip, credibleInterval, color , 'LineWidth', 0.1, ...
        'edgecolor', [1 1 1], 'DisplayName', label2);
    set(g, 'facealpha', 0.25)
    p = plot(time, mean, 'color', color, 'DisplayName', label1, 'LineStyle', '--');
    
end
