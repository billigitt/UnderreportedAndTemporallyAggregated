files = dir('../CSVs/nSimsMaxEntIt1e7M1e4_New/*.csv');
A = readtable(['../CSVs/nSimsMaxEntIt1e7M1e4_New/', files(1).name]);
%%
batchSize = 990;
A = A(1:batchSize, :);
numfiles = length(files);
%%
for k=2:100
filename = ['../CSVs/nSimsMaxEntIt1e7M1e4_New/', files(k).name];
T = readtable(filename);

matches = regexp(files(k).name, '(?<=_)\d+(?=\.)', 'match');
j = str2double(matches{1});

T = T(((j-1)*batchSize+1):j*batchSize, :);
A = vertcat(A, T);
end
writetable(A, '../CSVs/nSimsMaxEntIt1e7M1e4_New.csv');