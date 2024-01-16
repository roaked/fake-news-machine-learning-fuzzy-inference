%% Preprocessing data


%N = number of news
N = 1:3602;

%remove news that for some reason don't exist
N(697) = [];
N(1467) = [];

for i = N
    %metaInputs will be the input for the models
    %iTwomportfile12 opens the txt files and saves them as mat variables
%     metaInputsTrue(:,i) = importfile(sprintf('%d-meta.txt',i));
        metaInputsFake(:,i) = importfile(sprintf('%d-meta.txt',i));

    
    %metaTargets will be the targets of the neural network
%     metaTargetsTrue(:,i) = [1; 0];
        metaTargetsFake(:,i) = [0; 1];

end

metaInputs = [metaInputsTrue metaInputsFake];
metaTargets = [metaTargetsTrue metaTargetsFake];






%metaInputs data:
% number of tokens good
%  number of words without punctuation good
%  number of types good
%  number of links inside the news 
%  number of words in upper case
%  number of verbs  discard
%  number of subjuntive and imperative verbs 
%  number of nouns   discard
%  number of adjectives   discard
%  number of adverbs   discard
%  number of modal verbs (mainly auxiliary verbs)
%  number of singular first and second personal pronouns
%  number of plural first personal pronouns
%  number of pronouns   discard
%  pausality   discard
%  number of characters
%  average sentence length
%  average word length
%  percentage of news with speeling errors good
%  emotiveness
%  diversity
