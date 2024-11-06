function [Rmat, dailyICell] = OG1_RInference(I, w, priorShapeScale, P, M)

%pre-allocate 'daily' incidence (may not be daily but we call it that for
%ease)
Tweekly = length(I);

T = Tweekly*P;

dailyI = zeros(T, M);

shape = priorShapeScale(1);
scale = priorShapeScale(2);

I_1 = I(1);

Rmat = zeros(Tweekly, M);

vecOne2M = (1:M)';

% uniform daily incidence week 1. M samples.

dailyI(1:P, :) = mnrnd(I_1,ones(1, P)/P, M)';

dailyICell = cell(Tweekly, 1);

%begin routine

for t = 2:Tweekly

    disp(t)

    wTmp = w(1:((t-1)*P));
    idxAccept = [];
    newDailyIncidence = [];
    numAcc = 0;
    newR = [];

    while numAcc < M

        dailyITmp = dailyI(1:(t-1)*P, :);

        %Sample Rt from prior
        RTmpMat = gamrnd(shape, scale, [1 M]);

        %Repeated renewal equation
        dailyITmp(((t-1)*P + 1), :) = renewalEqnInference(dailyI(1:((t-1)*P), :), ...
            wTmp, RTmpMat);

        for tt = 2:P

            dailyITmp(((t-1)*P + tt), :) = renewalEqnInference([dailyI(1:((t-1)*P), :); ...
                dailyITmp(((t-1)*P):((t-1)*P + tt-1), :)], wTmp, RTmpMat);

        end

        %acceptance check and update

        idxAcceptNew = (sum(dailyITmp(((t-1)*P + 1): (t*P), :)) == I(t));

        idxAccept = [idxAccept; vecOne2M(idxAcceptNew)];

        newDailyIncidence = [newDailyIncidence dailyITmp(1:(t*P), idxAcceptNew)];

        newR = [newR RTmpMat(idxAcceptNew)];

        numAcc = length(idxAccept);

    end

    %in case of over-flow, use '1:M' instead of ':'
    newR = newR(1:M);


    %update dailyIs with accepted values
    dailyI(1:(t*P), :) = newDailyIncidence(1:(t*P), 1:M);

    dailyICell{t} = dailyI(1:(t*P), :);

    Rmat(t, :) = newR';

end



end