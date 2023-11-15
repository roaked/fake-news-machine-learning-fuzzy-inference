%% Dados
clear all
clc
load('metaInputs.mat');
load('metaTargets.mat');


% %Choosing only 4 parameters of the news (the ones that seem more important)
% metaInputs2 = metaInputs([1 2 3 19],:);
% testingdata = metaInputs(1:4:end,:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%% features %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1  number of tokens good
%2  number of words without punctuation good
%3  number of types good
%4  number of links inside the news 
%5  number of words in upper case
%6  number of verbs  discard
%7  number of subjuntive and imperative verbs 
%8  number of nouns   discard
%9  number of adjectives   discard
%10 number of adverbs   discard
%11 number of modal verbs (mainly auxiliary verbs)
%12 number of singular first and second personal pronouns
%13 number of plural first personal pronouns
%14 number of pronouns   discard
%15 pausality   discard
%16 number of characters
%17 average sentence length
%18 average word length
%19 percentage of news with speeling errors good
%20 emotiveness
%21 diversity

%%%%%%%%%%%%%%%%%%%%%%%%%%%% features %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


metaInputs2 = metaInputs([1 2 3 6 8 9 10 14],:);

figure (1), hold all
subplot(2,1,1)
boxplot(metaInputs','Symbol','');
ylim([0 10250])
xlabel('Features #');
title('All Features')


subplot(2,1,2)
boxplot(metaInputs2','Symbol','','labels',{'1','2','3','6',...
    '8','9','10','14',});
h=findobj(gca,'tag','Outliers','MarkerSize',12);
set(h,'Marker','o');
ylim([0 2400])
xlabel('Features #');
title('Only Specific Features')

%% Fake or Not Fake

%features 11 12 15 20 - linguistic

metaInputs3 = metaInputs([11 12 15 20],:)';
metaInputsTrue = metaInputs3(1:3602,:);
metaInputsFake = metaInputs3(3603:7204,:);
%fake news after #3602

figure (2), hold all
subplot(2,1,1)
boxplot(metaInputsTrue,'Symbol','','labels',{'11 - # of Modal Verbs'...
    '12 - # of Personal Pronouns','15 - Pausality','20 - Emotiveness'});
ylim([0 60])
xlabel('Features #');
title('True News - Linguistic Features');

metaInputs3 = metaInputs([11 12 15 20],:);
subplot(2,1,2)
boxplot(metaInputsFake,'Symbol','','labels',{'11 - # of Modal Verbs'...
    '12 - # of Personal Pronouns','15 - Pausality','20 - Emotiveness'});
ylim([0 60])
xlabel('Features #');
title('Fake News - Linguistic Features');



