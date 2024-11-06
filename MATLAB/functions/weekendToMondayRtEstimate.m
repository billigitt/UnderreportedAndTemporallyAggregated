function [shapeR, scaleR] = weekendToMondayRtEstimate(I, wDaily, tau, priorShapeScale, firstWeekDay)
%Here, we factor in the weekend effect, by effectively distorting the w
%input to account for the fact that cases were most likely not infected by
%wekeend infectors. By 'weekendToMonday', we assume that the weekend effect is
%all encompassing, i.e. no cases are recorded on the weekends, and
%therefore all the probability is attributed to the following Monday.


a = priorShapeScale(1);
b = priorShapeScale(2);

T = length(I);

shapeR = zeros(1, T);
shapeR(1:tau) = nan;
scaleR = shapeR;
rateR = ones(1, T)/b;
rateR(1:tau) = nan;

T = length(I);

for t = (tau+2):T %tau could be 0 which would mean starting at t=2 (which is what is done usually)

    shapeR(t) = a + sum(I(t-tau:t)); %only dependent on incidence so editting SI changes nothing

    for tt = (t-tau):t

        %changes serial when considering infectors on day tt
        wTmp = serialChanger(wDaily, firstWeekDay, tt);
        wTmp = wTmp(1:tt-1);

        rateR(t) = rateR(t) + forceOfInfection(I, wTmp, 1, tt);

    end


end

scaleR = 1./rateR;

end