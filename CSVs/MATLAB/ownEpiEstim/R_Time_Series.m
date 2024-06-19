function [CIs, Means, Shape, Scale, Par_Matrix] = R_Time_Series(Par, W, I, tau, Adaptive_Prior)

%Generates the entire sequence of CIs and mean R estimates for a serial
%interval matrix (each row is a different time) and the entire data stream
%of incident cases, I. This means that the output can be immeadiatley
%plotted.

%Diagram of I time-series:

% 1-2--...---------------------------------------t (Indices)
% 1-2--...--(tau)---------------(t-tau+1)--------t (Time)

%---start-----------------------start (Starts are at 2 and (t-tau+1) so 
%there are t-tau values in the I time-series)


%This (as shown in the diagram) implies that the length of the sequence of
%CIs and Means is (t-tau), Epi-Estim doesnt use the first one for some
%reason.

%Errors

if size(W, 1) ~= length(I)
    
    error(['Zak identified an error. You need the W matrix to have', ...
    'the same number of rows as I (even though they may not all be used)'])
    
end

t = length(I);

Original_Par = Par;

Means = zeros(t - tau, 1);
CIs = zeros(t - tau, 2);
Shape = zeros(t - tau, 1);
Scale = zeros(t - tau, 1);

Par_Matrix = zeros(t-tau, 2);

if isequal(Adaptive_Prior, 'on') 

    for i = 1 : t - tau
        
        [Means(i), CIs(i, 1), CIs(i, 2), Shape(i), Scale(i)] = R_Infer(I(1 : tau + i), W, Par, tau, i);
        
        Par_Matrix(i, :) = [Shape(i)^2*Scale(i)^2/(Original_Par(1)*Original_Par(2)^2) Original_Par(1)*Original_Par(2)^2/(Shape(i)*Scale(i))];
        
        Par = [Shape(i) Scale(i)];
        
    end

elseif isequal(Adaptive_Prior, 'off')
    
    for i = 1 : t - tau
        
        [Means(i), CIs(i, 1), CIs(i, 2), Shape(i), Scale(i)] = R_Infer(I(1 : tau + i), W, Par, tau, i);
        
    end
    
end

end

