function FM = anfisfm(Dat,FM,k,epochs)
% ANFISFM apply ANFIS backprop training to FM. Requires Fuzzy Logic Toolbox
%     for MATLAB by The Mathworks. 
%    
%     FM = ANFISFM(Dat,FM,k,E)
%
%     DAT ... the same data structure as the one used by FMCLUST.
%     FM  ... an existing fuzzy model.
%     k   ... output number (ANFIS only works for single-output systems)
%     E   ... number of training epochs
%
%    You may want to modify this function to get access to other ANFIS training parameters
%    than the number of epochs. It is also also possible to use FM2FIS call ANFIS
%    directly and then convert FIS back by using FIS2FM.
%
% See also ANFIS, FMCLUST, FM2FIS, FIS2FM.

% (c) Robert Babuska 2001

if nargin < 3, k = 1; end;
if nargin < 4, epochs = 10; end;

FM2 = FM; FM2.c = 1;
[trash,Part] = fmclust(Dat,FM2);
Z = Part.Z{k};

FIS = anfis(Z,fm2fis(FM,k),epochs,[],[],0);
FM = fis2fm(FIS,FM,k);
