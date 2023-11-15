function FIS = fm2fis(FM,k)
% FM2FIS convert the FM structure to the FIS structure of the Fuzzy Logic Toolbox
%    by The Mathworks. Creates a single-ouput FIS. To convert a multiple-output FM,
%    call FM2FIS for each output separately: FIS = FM2FIS(FM,OUT). Note that FIS
%    is always a static system - the dynamics must be provided externally.
%
% See also FIS2FM.

% (c) Robert Babuska 2001

if nargin < 2, k = 1; end;

a = antename(FM);
ni = length(a{k});
nr = size(FM.rls{k},1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% common params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FIS.name         = 'FIS';
FIS.type         = 'sugeno';
FIS.andMethod    = 'prod';
FIS.orMethod     = 'probor';
FIS.defuzzMethod = 'wtaver';
FIS.impMethod    = 'prod';
FIS.aggMethod    = 'sum';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : ni,
    FIS.input(i).name = a{k}{i};
    FIS.input(i).range = [FM.zmin{k}(i) FM.zmax{k}(i)];
    for j = 1 : size(FM.mfs{k}{i},1),
        sl = max(sqrt(1/14)*(FM.mfs{k}{i}(j,3)-FM.mfs{k}{i}(j,2)),1e-10);
        sr = max(sqrt(1/14)*(FM.mfs{k}{i}(j,5)-FM.mfs{k}{i}(j,4)),1e-10);
        pars = [sl FM.mfs{k}{i}(j,3) sr FM.mfs{k}{i}(j,4)];
        FIS.input(i).mf(j).name = ['mf' num2str(j)];
        FIS.input(i).mf(j).type = 'gauss2mf';
        FIS.input(i).mf(j).params = pars;
    end;
end;    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rules and consequent parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FIS.output.name = FM.OutputName{k};
FIS.output.range = [FM.zmin{k}(end) FM.zmax{k}(end)];
for j = 1 : nr,
    FIS.output.mf(j).name = ['mf' num2str(j)];
    FIS.output.mf(j).type = 'linear';
    FIS.output.mf(j).params = FM.th{1}(j,:);
    FIS.rule(j).antecedent = FM.rls{k}(j,:);
    FIS.rule(j).consequent = j;
    FIS.rule(j).weight = 1;
    FIS.rule(j).connection = 1;
end;
