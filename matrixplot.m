%% Dados
clear all
clc
close all
load('metaInputs.mat');

%Choosing only 4 parameters of the news (the ones that seem more important)
metaInputs2 = metaInputs([1 2 3 19],:);

metaInputsTrue = metaInputs2(:,[1:3602]);
metaInputsFalse = metaInputs2(:,[3603:end]);

figure (1)
subplot(1,2,1)
plotmatrix(metaInputsTrue') 
title('True news')

hold on
subplot(1,2,2)
plotmatrix(metaInputsFalse')
title('Fake news')