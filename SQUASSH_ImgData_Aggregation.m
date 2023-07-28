%% Batch script for SQUASSH Data Aggregation

% Get the directory to squassh data & find Image Data folder
basepath = uigetdir('select squassh output folder');

% Create results folder & path
respath = [basepath, filesep, 'aggregate data'];
if ~exist(respath, 'dir')
    mkdir(respath);
end
aggDataPath = [respath, filesep, 'Aggregate SQUASSH Data.xls'];

% Get image data csv files
imgDir = dir(basepath);
onlynamefiles = {imgDir.name};
CSVNames = contains(onlynamefiles, '.csv');
csvFiles = imgDir(CSVNames);

% Set import and table parameters
DELIMITER = ';';
HEADERLINES = 2;
varNames = {'Frames', 'Channel', '# Objects', 'Mean Size', 'Mean Surface', 'Mean Length'};
numRows = length(csvFiles);


for i = 1:numRows
    csvData = importdata([basepath, filesep, csvFiles(i).name], DELIMITER, HEADERLINES);
    ID = 1:numRows;
    newID = num2cell(ID);
    for a = 1:numRows
        newID(1,a) = csvData.textdata(3,1);
    end
    csvTable = table(csvData.data);
    aggTable = splitvars(csvTable, 'Var1');
    labAggTable = addvars(aggTable, ID', 'NewVariableNames', {'Image ID'});
end

writetable(labAggTable, aggDataPath);