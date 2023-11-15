function FM = fmodel(rls,mfs,th,zmin,zmax,Ny,Nu,Nd)
% FMODEL construct the structure for a static or dynamic fuzzy model.
%
%     F = FMODEL(RLS,MFS,TH,ZMIN,ZMAX)
%
%     FM is a structure containing the fuzzy model (see FMSTRUCT).
%
%     rls        rules
%     mfs        membership functions
%     th         consequent parameters
%     zmin       minima of the antecedent and consequent domains (optional)
%     zmax       maxima of the antecedent and consequent domains (optional)
%     ny         number of output lags (optional)
%     nu         number of input lags (optional)
%     nd         number of pure delays (optional)
%
%  See also FMCLUST, FMSIM, FMSTRUCT, FMEST.

% (c) Robert Babuska, 1997-98
% Magne Setnes 28.02.1999

if ~iscell(rls), rls = {rls}; end; 
NO = length(rls);
NI = size(rls{1},2);
if ~iscell(mfs), mfs = {mfs}; end;
if nargin < 3, th = cell(1,NO); end;
if ~iscell(th),  th = {th};   end;
if nargin < 4, zmin = cell(1,NO); elseif(size(zmin,1)>1), zmin=zmin';end;%magne
if nargin < 5, zmax = cell(1,NO); elseif(size(zmax,1)>1), zmax=zmax';end;%magne
if ~iscell(zmin), zmin = {zmin}; end;
if ~iscell(zmax), zmax = {zmax}; end;
if nargin < 6, Ny = zeros(NO,NO); end;
if nargin < 7, Nu = ones(NO,NI); end;
if nargin < 8, Nd = zeros(NO,NI); end;


% robert:
%FM.rls = rls;
%FM.mfs=mfs;

%magne:
FM.mfs=[];
FM.rls=[];
FM.rls{1}=rls{1}*0;
for i=1:size(rls{1},2),
   ind=sort(rls{1}(:,i));
   ind=ind(find([(ind(1)~=0);diff(ind)])); %also takes care of zeroes in rls
   FM.mfs{1}{i} = mfs{1}(ind,:);
   for j=1:length(ind),
      jj=find(rls{1}(:,i)==ind(j));
      FM.rls{1}(jj,i)=ones(length(jj),1)*j;
   end;
end;

FM.th  = th;
FM.zmin = zmin;
FM.zmax = zmax;
FM.ante = 2*ones(1,NO);

FM.no = NO;
FM.ni= size(Nu,2);
FM.date  = fix(clock); 
FM.Ny = Ny; 
FM.Nu = Nu; 
FM.Nd = Nd; 
if FM.ni == 1,
    FM.InputName = 'u';
else    
    for j = 1 : FM.ni, FM.InputName{j} = ['u_' num2str(j)]; end; 
end;    
if FM.no == 1,
    FM.OutputName = 'y'; 
else
    for j = 1 : NO, FM.OutputName{j} = ['y_' num2str(j)]; end;
end;    
