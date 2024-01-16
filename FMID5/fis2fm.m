function FM = fis2fm(FIS,FM,k)
% FM2FIS convert the FM structure to the FIS structure of the Fuzzy Logic Toolbox
%    by The Mathworks. Creates a single-ouput FIS. To convert a multiple-output FM,
%    call FM2FIS for each output separately: FIS = FM2FIS(FM,OUT). Note that FIS
%    is always a static system - the dynamics must be provided externally.
%
% See also FIS2FM.

% (c) Robert Babuska 2001

if nargin < 3, k = 1; end;

ni = length(FIS.input);
nr = length(FIS.rule);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% membership functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : ni,
    FM.zmin{k}(i) = FIS.input(i).range(1);
    FM.zmax{k}(i) = FIS.input(i).range(2);
    for j = 1 : length(FIS.input(i).mf),
        p2 = FIS.input(i).mf(j).params(2);
        p3 = FIS.input(i).mf(j).params(4);
        if p2 > p3, p2 = mean([p2 p3]); p3 = p2; end;
        p1 = p2 - abs(FIS.input(i).mf(j).params(1))/sqrt(1/14);
        p4 = p3 + abs(FIS.input(i).mf(j).params(3))/sqrt(1/14);        
        FM.mfs{k}{i}(j,:) = [2 p1 p2 p3 p4];
    end;
end;    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rules and consequent parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FM.zmin{k}(end+1) = FIS.output.range(1);
FM.zmax{k}(end+1) = FIS.output.range(2);
for j = 1 : nr,
    FM.rls{k}(j,:) = FIS.rule(j).antecedent;
    FM.th{k}(j,:) = FIS.output.mf(j).params;
end;

FM.no = max(FM.no,k);