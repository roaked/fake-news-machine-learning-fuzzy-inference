function [FM1]=fmtune(FM,sm,su,sp,shoulder,use_t)
% FMTUNE simplify and reduce the fuzzy MODEL described in FM
% by merging similar fuzzy sets and removing fuzzy sets 
% similar to the universal set.
%
% [FM1] = FMTUNE(FM,SM,SU,SP,S,T)
%
%   FM is a structure containing the fuzzy model (see FMSTRUCT)
%   Optional input parameters:
%       SM   ...  threshold for merging similar fuzzy sets:
%                 0<SM<1 (default 2/3)
%       SU   ...  threshold for removing fuzzy sets similar to universal set:
%                 0<SU<1 (default 0.8)	
%       SP   .... threshold for merging similar fuzzy sets:
%                 0<SP<1 (default 0.8)
%       S    ...  preserve shoulders: 1 - yes
%                                     0 - no (default)
%       T    ...  use transitive closure: 1 - yes
%                                         0 - no (default)
%
%   FM1 is a structure containing the new fuzzy model
%   (if training data is available, it is adviced to tune
%    the models consequent parameters using FMEST)
%
%  See also FMSTRUCT, FMEST, FMSIMP, FMRED

% M. Setnes, Nov. 1998, aug 1999
% (c) Setnes 1998
% this funtion calls fmsimp, fmred, fmrem

%%%%%%%%%%%%%%%%%%%%%%
%%%% INITIALIZING %%%%
%%%%%%%%%%%%%%%%%%%%%%
k=100;				% Quantization to be used for domains
if (nargin < 2), sm = 2/3; elseif isempty(sm), sm = 2/3; end;
if (nargin < 3), su = 0.8; elseif isempty(su), su = 0.8; end;
if (nargin < 4), sp = 0.8; elseif isempty(sp), sp = 0.8; end;
if (nargin < 5), shoulder = 0; elseif isempty(shoulder), shoulder = 0; end;
if (nargin < 6), use_t = 0; elseif isempty(use_t), use_t = 0; end;

FM1=FM;
total_removed=0;		% counter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% RULE BASE REDUCTION %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
new_rule=0;	% counter
for i=1:size(FM1.rls,2),
   old=max(FM1.rls{i});
	[rls,mfs,th,rem]=fmred(FM1,i,.8,k);
	%disp(['Rule base ' num2str(i), ', removed premise(s)' num2str(rem)]);
	FM1.rls{i}=rls;
   FM1.mfs{i}=mfs;
	FM1.th{i}=th;
   new_rule=new_rule+size(FM1.rls{i},1);
   total_removed=total_removed+sum(old-max(FM1.rls{i}));
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% MERGE SIMILAR MEMBERSHIP FUNCTIONS%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FM can contain several rule bases
old_rule=0;old_mfs=0;	% counters
for i=1:size(FM1.rls,2),
	old_rule=old_rule+size(FM.rls{i},1);
	old_mfs=old_mfs+sum(max(FM.rls{i}));
	old=max(FM1.rls{i});
   [rls,mfs]=fmsimp(FM1,i,sm,shoulder,use_t,k);	% This function does the merging
   FM1.rls{i}=rls;
   FM1.mfs{i}=mfs;
   removed=sum(old-max(FM1.rls{i}));
   disp(['Rule base ' num2str(i), ', removed ' num2str(removed) ' membership functions by merging']);
   total_removed=total_removed+removed;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% TEST SIMILARITY WITH UNIVERSAL SET %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(FM1.rls,2),
   old=max(FM1.rls{i});
   [rls,mfs]=fmrem(FM1,i,su,k);
   FM1.rls{i}=rls;
   FM1.mfs{i}=mfs;
   removed=sum(old-max(FM1.rls{i}));
   disp(['Rule base ' num2str(i), ', removed ' num2str(removed) ' membership functions sim. to univ.']);
   total_removed=total_removed+removed;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% RULE BASE REDUCTION %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
new_rule=0;	% counter
for i=1:size(FM1.rls,2),
   old=max(FM1.rls{i});
	[rls,mfs,th,rem]=fmred(FM1,i,sp,k);
	%disp(['Rule base ' num2str(i), ', removed premise(s)' num2str(rem)]);
	FM1.rls{i}=rls;
   FM1.mfs{i}=mfs;
	FM1.th{i}=th;
   new_rule=new_rule+size(FM1.rls{i},1);
   total_removed=total_removed+sum(old-max(FM1.rls{i}));
end;

disp('************');
disp('Tuning is finished!');
disp(['New model has ' num2str(total_removed) ' membership functions less']);
disp(['New model has ' num2str(old_rule-new_rule) ' rules less']);