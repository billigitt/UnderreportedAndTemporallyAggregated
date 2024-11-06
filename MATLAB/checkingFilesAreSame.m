clearvars

% this file was used for new OG1 analysis:

load('../MATs/noLimitNewMethodPrior1And3.mat')
trueRNew = noLimitNewMethodPrior1And3.trueR;

% this file was used for the old Cori + OG2 analyses

load('../MATs/noLimitOriginalMethodVariableMPrior1And3.mat')
trueROld = noLimitOriginalMethodVariableMPrior1And3.trueR;

%Now we check that when we choose the best Rt that fits

error = 0;

for i = 1:99000

    RTmp = trueRNew(i);

    [errorTmp, idxTmp] = min(abs(trueROld - RTmp));

    disp(idxTmp)

    trueROld(idxTmp) = [];

    error = error + errorTmp;

end
