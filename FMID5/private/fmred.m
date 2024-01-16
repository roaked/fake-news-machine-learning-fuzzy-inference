function [rls_new,mfs_new,th,rem]=fmred(FM,ind,sm,k);
% FMRED reduce a rule base described in FM by merging equal rules
% and removing redundent premise dimensions
%
% [RLS,MFS,TH,REM] = FMRED(FM,I,SM,K)
%
%   FM is a structure containing a fuzzy model (see FMSTRUCT) that can 
%   consist of several rule bases
%       I    ...  which of the rule bases in FM to consider (default 1)
%       SM   ...  threshold for removing redundant premises	(average similarity)
%                 0<SM<1 (default 0.8)
%       K    ...  quantization of domain for similarity measure (default 100)
%
%       RLS  ...  simplified version of FM.rls{i}
%       MFS  ...  simplified version of FM.mfs{i}
%       TH   ...  new consequent parameters
%       REM  ...  premise dimensions (input) removed
%
%  See also FMSIMP, FMTUNE, FMEST, FMSTRUCT

% M. Setnes, feb 1999 
% (c) Setnes 1998

%%%%%%%%%%%%%%%%
% INITIALIZING %
%%%%%%%%%%%%%%%%
if (nargin < 2), ind = 1; elseif isempty(ind), ind=1; end;
if (nargin < 3), sm = 0.8; elseif isempty(sm), sm = 0.8; end;
if (nargin < 4), k=100; elseif isempty(k), k = 100; end;


rls=FM.rls{ind};
th=FM.th{ind};
mfs=FM.mfs{ind};
% getting the rlimits (of inputs only)
rl=[[FM.zmin{ind}(1:size(rls,2))]',[FM.zmax{ind}(1:size(rls,2))]'];
rem=[];

%%%%%%%%%%%%%%%%%%%%%
% Merge equal rules %
%%%%%%%%%%%%%%%%%%%%%
stop=0;
j=0;
while(~stop),
	j=j+1;
	merge=find(sum(abs(ones(size(rls,1),1)*rls(j,:)-rls)')==0)';
	if(length(merge)>1),
		th(min(merge),:)=mean(th(merge,:));%consequent of remaining rule is mean of all those merged
		disp(['Rule base ' num2str(ind) ', merging rules ' num2str(merge')]);
		merge(1)=[];
		th(merge,:)=[];
		rls(merge,:)=[];
	end;
	if(j>=size(rls,1)),
		stop=1;
	end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Look for similar premise dimensions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rls_new=rls;
%% Check that mfs are defined for this rule base%%
if(isempty(mfs)),
	mfs_new=mfs;
	disp(['No membership functions are defined in rule base ' num2str(ind)]);
	return;
end;

% Detect candidates by checking rlimits:
ni=size(rls,2); %number of inputs
% Minimum:
mini=rl(:,1)*ones(1,ni)-[rl(:,1)*ones(1,ni)]';
mini=(tril(mini*0+1))+triu(mini,1);
[mini,minj]=find(abs(mini)<1e-10);

% Maximum:
maxi=rl(:,2)*ones(1,ni)-[rl(:,2)*ones(1,ni)]';
maxi=(tril(maxi*0+1))+triu(maxi,1);
[maxi,maxj]=find(abs(maxi)<1e-10);

select=[];
for i=1:length(mini),
   if~isempty(maxi),
   	merge=ones(size(maxi,1),1)*[mini(i),minj(i)]-[maxi,maxj];
		merge=sum(abs(merge'));
      select=[select; min(find(merge==0))];
   end;
end;

% Candidate similar premise pairs:
candi=maxi(select);
candj=maxj(select);

% Check similarity:
while(~isempty(candi)),
	ii=candi(1);jj=candj(1);
	seli=rls(:,ii);
	selj=rls(:,jj);
	% check for 0's in rls, if non matched zeros -> abort
    if(isempty(find((seli==0)~=(selj==0))) & (sum(seli)~=0)),
		% remove matched 0'
		seli=seli(find(seli));
		selj=selj(find(selj));
		
		domain=rl(ii,1):(rl(ii,2)-rl(ii,1))/k:rl(ii,2);
		S=ss1(domain,[mfs{ii}(seli,:);mfs{jj}(selj,:)]);
		% extract interesting part
		S=S(1:length(seli),length(seli)+1:size(S,2));
		% check similarity
		if(trace(S)>=sm*size(S,2));
			% Remove redundant premise
			rls_new(:,jj)=0*rls_new(:,jj);
			rem=[rem;jj];
		end;
	end;
	candi(1)=[];
	candj(1)=[];
end;

%% Create new MFS matrix %%
mfs_new=mfs;
% Remove unused MFS and update RLS
for i = 1:size(rls_new,2);
   a=rls_new(:,i);
   a=a(a>0);				% The mfs pointers in the rules that use the input i
   if(isempty(a));
      mfs_new{i}=[];
   else,
      a=sort(a);
      a=a(find([1;diff(a)])); % a is the pointer to the used mfs
   	mfs_new{i}=mfs_new{i}(a,:);		% ceep only the used mfs
      for j = 1:size(a,1),	% update the RLS matrix
         rls_new(find(rls_new(:,i)==a(j)),i)=0*rls_new(find(rls_new(:,i)==a(j)),i)+j;
      end;
   end;
end;


if(~isempty(rem)),
   disp(['Rule base ' num2str(ind) ', removed premise(s) ' num2str(rem')]);
end;

%% End of function FMRED %%

%%%%%%%%%%%%%%%%%%%%%
function s=ss1(x,mfs)
% S=SS1(X,MFS) similarity measure based on set theoretic operations.
% Magne Setnes, 28. September 1995
% Updated november 1998 to comply with FMID toolbox
m=size(mfs,1);
Z=mgrade(x,mfs)';
j=1;			%for rubustness, if mfs is 1 mf only
p=1;
for i=1:m-1;
	for j=i+1:m;
		s(i,j) = sum((min(Z(i,:),Z(j,:))).^p) / sum((max(Z(i,:),Z(j,:))).^p);
		s(j,i) = s(i,j);
	end;
	s(i,i)=1;	% The diagonal is 1
end;
s(j,j)=1;		% The diagonal is 1
