%% Dados
clear all
clc
load('metaInputs.mat');
load('metaTargets.mat')

%% Data with all news parameters
%25% of data for testing

testingData = metaInputs(:,1:4:end);
testingClass = metaTargets(:,1:4:end);

%75% of data for training
trainingData = metaInputs;
trainingClass = metaTargets;

for i = size(metaInputs,2):-1:1
    if ismember(i,[1:4:size(metaInputs,2)]) == 1
        trainingData(:,i) = [] ;
        trainingClass(:,i) = [];
    end
end


%% Data with only the 4 linguistic parameters
metaInputsLing = metaInputs([11 12 15 20],:);

%25% of data for testing

testingDataLing = metaInputsLing(:,1:4:end);
testingClassLing = metaTargets(:,1:4:end);

%75% of data for training
trainingDataLing = metaInputsLing;
trainingClassLing = metaTargets;

for i = size(metaInputsLing,2):-1:1
    if ismember(i,[1:4:size(metaInputsLing,2)]) == 1
        trainingDataLing(:,i)=[] ;
        trainingClassLing(:,i) = [];
    end
end

