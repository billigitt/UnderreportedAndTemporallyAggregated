%find indices
clearvars
clc
close all

load('../../MATs/constantRhoOG1Analysis.mat')

idxRemove = 1:11:99000;
incidenceMaster(idxRemove) = [];
OG1lowerRMaster(idxRemove) = [];
OG1upperRMaster(idxRemove) = [];
OG1meanRMaster(idxRemove) = [];

files = dir('*.csv');

pattern = 'largeScaleStudyOriginalMethodClusterM1e3Revisions_(\d+)\.csv'; % Regular expression to match the file name and capture NUM
numbers = []; % Initialize an array to store the numbers

for i = 1:length(files)
    fileName = files(i).name; % Get the file name
    tokens = regexp(fileName, pattern, 'tokens'); % Extract the number part using regex
    if ~isempty(tokens)
        numbers(end+1) = str2double(tokens{1}{1}); % Convert the captured token to a number
    end
end

%for loop of these indices

numNumbers = length(numbers);

meandifferences = zeros(100*9*10*10, 1);
updifferences = zeros(100*9*10*10, 1);
downdifferences = zeros(100*9*10*10, 1);

idxMiniRemove = 1:11:990;


for i = numbers

    filename = strcat('largeScaleStudyOriginalMethodClusterM1e3Revisions_', num2str(i));
    table = readtable(filename);
    meanTmp = table.meanRt;
    lowerTmp = table.lowerRt;
    upperTmp = table.upperRt;
    incTmp = table.reportedIncidence;
    meanTmp(idxMiniRemove) = [];
    lowerTmp(idxMiniRemove) = [];
    upperTmp(idxMiniRemove) = [];
    incTmp(idxMiniRemove) = [];

    meandifferences(((i-1)*900+1):(i*900)) = OG1meanRMaster(((i-1)*900+1):(i*900)) - meanTmp;
    incdifferences(((i-1)*900+1):(i*900)) = incidenceMaster(((i-1)*900+1):(i*900)) - incTmp;
end

%for i, find the corresponding indices

%compute vector of differences in inference

