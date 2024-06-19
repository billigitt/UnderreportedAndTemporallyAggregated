files = dir('../CSVs/largeScaleStudyOriginalMethodMaxInc200Day1-10PriorHalfAndFour/*.csv');
A = readtable(['../CSVs/largeScaleStudyOriginalMethodMaxInc200Day1-10PriorHalfAndFour/', files(1).name]);
%%
batchSize = 990;
A = A(1:batchSize, :);
numfiles = length(files);
%%
for k=2:100
filename = ['../CSVs/largeScaleStudyOriginalMethodMaxInc200Day1-10PriorHalfAndFour/', files(k).name];
T = readtable(filename);

matches = regexp(files(k).name, '(?<=_)\d+(?=\.)', 'match');
j = str2double(matches{1});

T = T(((j-1)*batchSize+1):j*batchSize, :);
A = vertcat(A, T);
end
writetable(A, 'largeScaleStudyOriginalMethodMaxInc200PriorHalfAndFourFirstDay10.csv');