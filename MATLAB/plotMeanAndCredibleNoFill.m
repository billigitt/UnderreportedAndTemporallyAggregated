function p = plotMeanAndCredibleNoFill(mean, credible, time, color, label1)

    timeFlip = [time; flipud(time)];

    credibleInterval = [credible(:, 1); flipud(credible(:,2))];
    
    hold on

    p = plot(time, mean, 'color', color, 'DisplayName', label1);
    plot(time, credible(:, 1), 'color', color);
    plot(time, credible(:, 2), 'color', color);
    
end
