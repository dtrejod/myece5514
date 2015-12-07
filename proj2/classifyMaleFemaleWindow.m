% Digital Signal Processing (Fall 2015)
% Project 2: Predict whether a male/female is speaking in the mp3 file
% Classificaiton by window function
% By: Tyler Olivieri; Devin Trejo; Robert Irwin

% Returns 0 for male, 1 for female
function [win_identity, coff] = classifyMaleFemaleWindow(F0_mean,...
    F0_var, Fx_mean, Fxvar)
% Read in training results
%
maleF0 = dlmread(fullfile(pwd, 'train', 'out', 'male_F0data.txt'));
femaleF0 = dlmread(fullfile(pwd, 'train', 'out','female_F0data.txt'));
maleFx = dlmread(fullfile(pwd, 'train', 'out','male_Fxdata.txt'));
femaleFx = dlmread(fullfile(pwd, 'train', 'out','female_Fxdata.txt'));

% Expect values for fundemental freqeuncy
%
maleF0Mean = mean(maleF0); % Expect mean for male frequency
maleF0Var = var(maleF0);
femaleF0Mean = mean(femaleF0); % Expected mean for female frequency
femaleF0Var = var(femaleF0);

% Expect values for harmonic freqeuncies
%
maleFxMean = mean(maleFx); % Expect mean for male frequency
maleFxVar = var(maleFx);
femaleFxMean = mean(femaleFx); % Expected mean for female frequency
femaleFxVar = var(femaleFx);

% Generate classifier
%
% MALE = [mean(maleF0Mean) mean(maleF0Var)]
% FEMALE = [mean(femaleF0Mean) mean(femaleF0Var)]
MALE = [.9903 1.2762e3];
FEMALE = [17.6844 2.6318e3];

%generate a line for classification
%change in x
dx1 = FEMALE(1)-MALE(1);
dx2 = FEMALE(2)-MALE(2);

mid1 = (FEMALE(1)+MALE(1))/2;
mid2 = (FEMALE(2)+MALE(2))/2;

%we want the range to be 100 [-50 50]
m1 = 100/dx1;
m2 = 100/dx2;

VAR = abs(Fxvar - F0_var);
MEAN = Fx_mean - F0_mean;

% Begin making decision
%
if MEAN >= mid1
    if MEAN <= FEMALE(1)
        ymean = m1*(MEAN-mid1);
    else
        ymean = 50;
    end
else
    if MEAN >= MALE(1)
        ymean = m1*(MEAN-mid1);
    else
        ymean = -50;
    end
end

if VAR >= mid2
    if VAR <= FEMALE(2)
        yvar = m2*(VAR-mid2);
    else
        yvar = 50;
    end
else
    if VAR >= MALE(2)
        yvar = m2*(VAR-mid2);
    else
        yvar = -50;
    end
end

% Make Decision
%
coff = ymean+yvar;
if(coff > 0)
    win_identity = 1;
else
    win_identity = 0;
end
