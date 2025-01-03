function [Rmat, dailyICell, likelihood] = OG1_RInference_Trick(I, w, priorShapeScale, P, M, sampleFactor)

%function that uses a likelihood trick to improve on OG1 method. We also
%'oversample' by scaling the samples up by a factor of 'sampleFactor' to
%speed up computation time.

%pre-allocate 'daily' incidence (may not be daily but we call it that for
%ease)

%To do (14th Nov): write out to do list from meeting. Fix this function!

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

likelihood = ones(Tweekly, M);

%begin routine

% f = waitbar(0,'1','Name','Calculating risks...',...
%     'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
% 
% setappdata(f,'canceling',0);

for t = 2:Tweekly

%     if getappdata(f,'canceling')
% 
%         break
% 
%     end
% 
%     waitbar((t-1)/(Tweekly-1),f,sprintf("t = "+t+" (of "+1+" to "+Tweekly+")"))

    wTmp = w;
    newDailyIncidence = [];
    numAcc = 0;
    newR = [];
    likelihoodTmp = [];

    while numAcc < M

        disp(numAcc)

        %sample from reconstructed incidence proportional to likelihood
        idxSample = randsample(1:M, M*sampleFactor, true, likelihood(t-1, :));


        dailyITmp = [dailyI(1:(t-1)*P, idxSample); zeros(P, M*sampleFactor)];

        %Sample Rt from prior
        RTmpMat = gamrnd(shape, scale, [1 M*sampleFactor]);

        %Repeated renewal equation
        dailyITmp(((t-1)*P + 1), :) = renewalEqnInference(dailyITmp(1:((t-1)*P), :), ...
            wTmp, RTmpMat);

        for tt = 2:(P-1)

            
            dailyITmp(((t-1)*P + tt), :) = renewalEqnInference(dailyITmp(1:((t-1)*P + tt-1), :),...
                wTmp, RTmpMat);

        end

        %exclude simulations that already exceed data
        idxAccept = (sum(dailyITmp(((t-1)*P + 1):((t-1)*P + P-1), :)) <= I(t));
        numAcc = numAcc + sum(idxAccept);
        dailyITmp = dailyITmp(:, idxAccept);
        RTmpMat = RTmpMat(idxAccept);

        %calculate necessary number of cases on final 'day' to match
        finalDay = I(t) - sum(dailyITmp(((t-1)*P + 1):((t-1)*P + tt-1), :));
        dailyITmp(end, :) = finalDay;

        %calculate likelihood of the final 'day' matching the weekly data (via Poisson process)
        gammaTmp = fliplr(wTmp(1:((t-1)*P+P-1)))*dailyITmp(1:((t-1)*P + P-1), :);
        gammaTmp = RTmpMat.*gammaTmp; % 1 by M vector

        %append time t quantities
        likelihoodTmp = [likelihoodTmp poisspdf(finalDay, gammaTmp)];
        newR = [newR RTmpMat];
        newDailyIncidence = [newDailyIncidence dailyITmp];

    end

    %in case of over-flow, use '1:M' instead of ':'
    newR = newR(1:M);
    likelihood(t, :) = likelihoodTmp(1:M);

    %update dailyIs with accepted values
    dailyI(1:(t*P), :) = newDailyIncidence(1:(t*P), 1:M);

    dailyICell{t} = dailyI(1:(t*P), :);

    Rmat(t, :) = newR';

end

% delete(f)

end