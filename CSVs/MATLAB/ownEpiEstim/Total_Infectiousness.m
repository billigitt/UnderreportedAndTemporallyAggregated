function Gamma = Total_Infectiousness(I_data, Generation)

%Error

if size(I_data, 1) + size(Generation, 1) ~= 2
   
    error('Zak identified an error. The data and GI need to be in rows.')
    
end

%Function takes incidence data relevant to the Generation Interval, and
%computes the 'Total Infectiousness', Capital Gamma in the literature.

    length_I = length(I_data);
    
    length_G = length(Generation);

    %Get Generation Interval and the Incidence to be the same length so we can dot
    %product
    
    if length_I < length_G
       
         Transmitting_Cases = [zeros(1,length_G - length_I), I_data];
%         
%         Transmitting_Cases = I_data;
% 
%         Generation(length_I+1:end) = [];
%         
%         Generation = Generation/(sum(Generation));
        
    else
        
        Transmitting_Cases = I_data(end-length_G+1:end);
        
    end

    Gamma = dot(Transmitting_Cases, fliplr(Generation)); %We now have to flip the Serial

end