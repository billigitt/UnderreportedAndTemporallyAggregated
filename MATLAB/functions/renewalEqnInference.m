function I = renewalEqnInference(matrixI, w, R)

%used in renewal equation process in OG1 method. Identical to
%renewalEquation.m, other than enable R as a vector input, to vectorise
%computation.

T = size(matrixI, 1);
lengthSI = length(w);

if (lengthSI < T)

    w = [w zeros(1, T - lengthSI)];

else

    w = w(1:T);

end

gammaVec = fliplr(w)*matrixI;
infPot = gammaVec.*R;

I = poissrnd(infPot);

end