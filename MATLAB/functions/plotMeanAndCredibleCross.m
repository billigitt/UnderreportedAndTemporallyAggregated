function p = plotMeanAndCredibleCross(mean, credible, time, color, label1, label2)

    timeFlip = [time; flipud(time)];

    credibleInterval = [credible(:, 1); flipud(credible(:,2))];
    
    hold on
    g = fill(timeFlip, credibleInterval, [1 1 1] , 'DisplayName', label2);
    set(g, 'facealpha', 0)
    set(g,'LineStyle', '-')
    set(g, 'EdgeColor', color)
    p = scatter(time, mean, 'color', color, 'Marker', 'x');
    
end