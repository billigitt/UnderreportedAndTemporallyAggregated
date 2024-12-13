files = dir('../CSVs/largeScaleStudyClusterNoLimitTemporalRhoOG1/*.csv');
A = readtable(['../CSVs/largeScaleStudyClusterNoLimitTemporalRhoOG1/', files(1).name]);
B = readtable('../CSVs/largeScaleStudyIncidencesAndTrueRsNoLimitPrior1And3FirstDay1TemporalRho.csv');

%%
batchSize = 110;
A = A(1:batchSize, :);
A.trueR(1:batchSize) = B.trueR(1:batchSize);
%to remove
A.reportedWeeklyICheck = B.reportedWeeklyI(1:batchSize);
numfiles = length(files);
%%
for k=2:100
filename = ['../CSVs/largeScaleStudyClusterNoLimitTemporalRhoOG1/', files(k).name];
T = readtable(filename);

matches = regexp(files(k).name, '(?<=_)\d+(?=\.)', 'match');
j = str2double(matches{1});

T.trueR = B.trueR(((j-1)*batchSize+1):j*batchSize);
T.reportedWeeklyICheck = B.reportedWeeklyI(((j-1)*batchSize+1):j*batchSize);


A = vertcat(A, T);
end
writetable(A, '../CSVs/largeScaleStudyClusterNoLimitTemporalRhoOG1_All.csv');

