% Digital Signal Processing (Fall 2015)
% Project 2: Predict whether a male/female is speaking in the mp3 file
% By: Tyler Olivieri; Devin Trejo; Robert Irwin

%% Training
clear;clc; close all;

% Training data from:
% http://www.repository.voxforge1.org/downloads/
% Save to train folder (seperated by dirs male/female)

% Run training female files
%
trainDir = fullfile(pwd, 'train', 'female');
trainFiles = dir(fullfile(trainDir, '*.mp3'));
trainFiles = [trainFiles; dir(fullfile(trainDir, '*.wav'))];
femaleF0 = [];
femaleFx = [];
for file = trainFiles'
    [F0_i, Fx_i] = trainGenderIdent(fullfile(trainDir, file.name));
    femaleF0 = [femaleF0 F0_i];
    femaleFx = [femaleFx Fx_i];
    clear F0_i Fx_i;
end

% Save training output
%
dlmwrite(fullfile(pwd, 'train', 'out','female_F0data.txt'),femaleF0);
dlmwrite(fullfile(pwd, 'train', 'out','female_Fxdata.txt'),femaleFx);
fprintf('Female: \n\tF0 mu=%0.2f, std=%0.2f\n\tFx mu=%0.2f, std=%0.2f\n',...
    mean(femaleF0), std(femaleF0), mean(femaleFx),std(femaleFx));
clear trainFiles;

% Repeat for females
%
trainDir = fullfile(pwd,'train', 'male');
trainFiles = dir(fullfile(trainDir, '*.mp3'));
trainFiles = [trainFiles; dir(fullfile(trainDir, '*.wav'))];
maleF0 = [];
maleFx = [];
for file = trainFiles'
    [F0_i, Fx_i] = trainGenderIdent(fullfile(trainDir, file.name));
    maleF0 = [maleF0 F0_i];
    maleFx = [maleFx Fx_i];
    clear F0_i Fx_i;
end
fprintf('Male: \n\tF0 mu=%0.2f, std=%0.2f\n\tFx mu=%0.2f, std=%0.2f\n',...
    mean(maleF0), std(maleF0), mean(maleFx),std(maleFx));

% Save training output
%
dlmwrite(fullfile(pwd, 'train', 'out','male_F0data.txt'),maleF0);
dlmwrite(fullfile(pwd, 'train', 'out','male_Fxdata.txt'),maleFx);


%% Classfication
clear; clc; close all;

% Run Indentification
%
classDir = fullfile(pwd, 'data', 'female');
classFiles = dir(fullfile(classDir, '*.mp3'));
classFiles = [classFiles; dir(fullfile(classDir, '*.wav'))];

for file = classFiles'
    classifyMaleFemale(fullfile(classDir, file.name));
end


%% Unit testing
clear; clc; close all;
% Run unit testing
%
