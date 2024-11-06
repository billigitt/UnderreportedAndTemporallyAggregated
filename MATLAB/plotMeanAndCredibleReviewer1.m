function p = plotMeanAndCredibleReviewer1(mean, credible, time, color, label1, label2)

    timeFlip = [time; flipud(time)];

    credibleInterval = [credible(:, 1); flipud(credible(:,2))];
    
    hold on
    g = fill(timeFlip, credibleInterval, color , 'DisplayName', label2);
    set(g, 'facealpha', 0.75)
    set(g,'LineStyle', '--')
    set(g, 'EdgeColor', color)
    p = plot(time, mean, 'color', color, 'DisplayName', label1);
    
end