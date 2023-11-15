%Statistics
avgNumbToken = sum(metaInputs(1,:))/7204;
avgNumbTokenTrue = sum(metaInputs(1,[1:3602]))/3602;
avgNumbTokenFalse = sum(metaInputs(1,[3603:end]))/3602;

%Dá igual às stats que estão no paper
