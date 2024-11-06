function [shapeR, scaleR, ci95] = slidingREstimate(I, w, tau, priorShapeScale)

%Standard Cori approach

    a = priorShapeScale(1);
    b = priorShapeScale(2);

    T = length(I);

    shapeR = zeros(1, T);
    shapeR(1:tau) = nan;
    rateR = ones(1, T)/b;
    rateR(1:tau) = nan;

    ci95 = ones(2, T)*nan;

    T = length(I);

    for t = tau+1:T

        shapeR(t) = a + sum(I(t-tau:t));
        
        for tt = t-tau:t

            rateR(t) = rateR(t) + forceOfInfection(I, w, 1, tt);

        end


    end

    scaleR = 1./rateR;

    for t = tau:T

        ci95(:, t) = gaminv([0.025; 0.975], shapeR(t), scaleR(t));

    end

end
