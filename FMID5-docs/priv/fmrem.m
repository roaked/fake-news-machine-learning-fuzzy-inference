function [rls_new,mfs_new]=fmrem(FM,ind,su,k);
% FMREM simplifies a rule base described in FM
% by removing fuzzy sets smimilar to the universal set (sim>SU).
%
% [RLS, MFS] = FMREM(FM,I,SU,K)
%
%   FM is a structure containing a fuzzy model (see FMSTRUCT) that can 
%   consist of several rule bases
%       I    ...  which of the rule bases in FM to consider (default 1)
%       SU   ...  threshold for removing fuzzy sets similar to univ. set:
%                 0<SU<1 (default 0.8)
%       K    ...  quantization of domain for similarity measure (default 100)
%
%       RLS  ...  simplified version of FM.rls{i}
%       MFS  ...  simplified version of FM.mfs{i}
%
%  See also FMRED, FMTUNE, FMEST, FMSTRUCT

% M. Setnes, Nov. 1998
% (c) Setnes 1998

if (nargin < 2), ind = 1; elseif isempty(ind), ind=1; end;
if (nargin < 3), su = 0.8; elseif isempty(su), su = 0.8; end;
if (nargin < 4), k=100; elseif isempty(k), k = 100; end;

rls=FM.rls{ind};
mfs=FM.mfs{ind};

%% Check that mfs are defined %%
if(isempty(mfs)),
	rls_new=rls;mfs_new=mfs;
   disp(['No membership functions are defined in rule base ' num2str(ind)]);
   return;
end;

% getting the rlimits
rl=[FM.zmin{ind}',FM.zmax{ind}'];

% number of rules (n), number of inputs (m)
[n,m]=size(rls);

% Remove unused MFS and update RLS
for i = 1:m;
	a=rls(:,i);
   a=a(a>0);				% The mfs pointers in the rules that use the input i
   if(isempty(a));
      mfs{i}=[];
   else,
      a=sort(a);
      a=a(find([1;diff(a)])); % a is the pointer to the used mfs
      mfs{i}=mfs{i}(a,:);		% ceep only the used mfs
      for j = 1:size(a,1),	% update the RLS matrix
         rls(find(rls(:,i)==a(j)),i)=0*rls(find(rls(:,i)==a(j)),i)+j;
      end;
   end;
end;

mfs_new=mfs;

%%% Detecting mfs similar to univ. set %%%
for i = 1:m;
	mfs=mfs_new{i};			  	% the antecedent to consider
	if(size(mfs,1)>0),
      S = [mgrade((rl(i,1):(rl(i,2)-rl(i,1))/k:rl(i,2)),mfs)];
      if(size(S,1)~=(k+1)),	% Detecting old/new mgrade
         S=S';
      end;
      S = sum(S)/(k+1);		% The similarity of the fuzzy sets for input i to the univ. set
		S = find(S>su);			% Find those who have a sim. to univ.set bigger than the threshold
		for jj=1:length(S),
			rls(find(rls(:,i)==S(jj)),i)=0*find(rls(:,i)==S(jj));% Remove these fuzzy sets from the premise of the rules
		end;
	end;
end;	% end of "for i = 1:m"


% Remove unused MFS and update RLS
for i = 1:m;
   a=rls(:,i);
   a=a(a>0);				% The mfs pointers in the rules that use the input i
   if(isempty(a));
      mfs_new{i}=[];
   else,
      a=sort(a);
      a=a(find([1;diff(a)])); % a is the pointer to the used mfs
   	mfs_new{i}=mfs_new{i}(a,:);		% ceep only the used mfs
      for j = 1:size(a,1),	% update the RLS matrix
         rls(find(rls(:,i)==a(j)),i)=0*rls(find(rls(:,i)==a(j)),i)+j;
      end;
   end;
end;

rls_new=rls;

%% END of file %%