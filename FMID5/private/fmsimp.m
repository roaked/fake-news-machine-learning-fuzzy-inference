function [rls_new,mfs_new]=fmsimp(FM,ind,sm,shoulder,use_t,k);
% FMSIMP simplifies a rule base described in FM
% by merging similar fuzzy sets.
%
% [RLS,MFS] = FMSIMP(FM,I,SM,S,T,K)
%
%   FM is a structure containing a fuzzy model (see FMSTRUCT) that can 
%   consist of several rule bases
%       I    ...  which of the rule bases in FM to merge (default 1)
%       SM   ...  threshold for merging similar fuzzy sets:
%                 0<SM<1 (default 0.8)
%       S    ...  preserve shoulders: 1 - yes
%                                     0 - no (default)
%       T    ...  use transitive closure: 1 - yes
%                                         0 - no (default)
%       K    ...  quantization of domain for similarity measure (default 100)
%
%       RLS  ...  simplified version of FM.rls{i}
%       MFS  ...  simplified version of FM.mfs{i}
%
%  See also FMRED, FMTUNE, FMEST, FMSTRUCT

% M. Setnes, Nov. 1998
% (c) Setnes 1998

%%%%%%%%%%%%%%%%
% INITIALIZING %
%%%%%%%%%%%%%%%%
if (nargin < 2), ind = 1; elseif isempty(ind), ind=1; end;
if (nargin < 3), sm = 0.8; elseif isempty(sm), sm = 0.8; end;
if (nargin < 4), shoulder = 0; elseif isempty(shoulder), shoulder = 0; end;
if (nargin < 5), use_t = 0; elseif isempty(use_t), use_t = 0; end;
if (nargin < 6), k=100; elseif isempty(k), k = 100; end;

if shoulder;
	disp('Preserving shoulders');
end;

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
if (use_t);
disp(['Rule base ' num2str(ind) ': Merging fuzzy sets using transitive similarity']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USING TRANSITIVE CLOSURE %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	for i = 1:m;
		mfs=mfs_new{i};			  	% the antecedent to consider
		if(size(mfs,1)>1),
			% Measure pair-wise similarity
			S = ss1((rl(i,1):(rl(i,2)-rl(i,1))/k:rl(i,2)),mfs);	% Uses 'ss1.m' for the similarity measures
			S_new=tclosure(S);		% Calculate Max-Min trans closure
			S=triu(S_new);			% Symmetric S, use only upper triang. part
			S=S>sm;					% Thresholding
			for j = 1:size(S,1);
				A=find(S(j,:))';		% The index in the MFS of the fuzzy sets to be merged
        		if A
					%%%%%%%%%
					% MERGE %
					%%%%%%%%%
					if shoulder; 	%See to that SHOULDERS are beeing kept:
					%If a left shoulder, all sets to be merged are made to have this shoulder
						if min(mfs(A,3)) <= rl(i,1); 	
							mfs(A,2) = (min(mfs(A,2))-1) * ones(size(A));
							mfs(A,3) = (mfs(A,2)+1);
						end;	
					%If a right shoulder, all sets to be merged are made to have this shoulder
						if max(mfs(A,4)) >= rl(i,2)	
							mfs(A,5) = (max(mfs(A,5))+1) * ones(size(A));
							mfs(A,4) = (mfs(A,5)-1);
						end;
					end; % end of "if shoulder"

					% Merge the sets
					p1=min(mfs(A,2));
					p2=(sum(mfs(A,3)))/length(A);
					p3=max( p2, (sum(mfs(A,4)))/length(A) );
					p4=max(mfs(A,5));
					mfs(A,:)=ones(length(A),1) * ([mfs(A(1),1) p1 p2 p3 p4]);

					%%%%%%%%%%%%%%
					% Update RLS %
					%%%%%%%%%%%%%%
					update=rls(:,i)*ones(1,length(A))-ones(n,1)*A';
					update=prod(update');
					rls(find(~update),i)=0*(rls(find(~update),i))+min(rls(find(~update),i));
    
				end; %end of "if A"
			end; % end of "for j"
		end; % end of "if size(mfs..."

		%%%%%%%%%%%%%%%%%%
		% Update mfs_new %
		%%%%%%%%%%%%%%%%%%
		mfs_new{i}=mfs;

	end;	% end of "for i = 1:m"

else
disp(['Rule base ' num2str(ind) ': Iterative merging of fuzzy sets']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USING ITERATIVE MERGING %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
	for i = 1:m,
        mfs=mfs_new{i};			  	% the antecedent to consider
		if(size(mfs,1)<=1),
			stop=1;
		else,
			stop=0;	% go on if more than one mfs
		end;
		
		while (stop~=1),
			% Measure pair-wise similarity
			S = ss1((rl(i,1):(rl(i,2)-rl(i,1))/k:rl(i,2)),mfs);	% Uses 'ss1.m' for the similarity measures
			S=triu(S,1);			% Symmetric S, use only upper triang. part
			S=S.*(S<1);				% Reset the similarity between sets that have been merged.
									% this is always '1' and thus will interfer
									% when trying to find the two most similar pairs.
			if max(max(S))>sm,		% Threshold
				[p,q]=find(S==max(max(S)));	% Finding the most similar pair of fuzzy sets
				A=sort([p;q]);		% This is done to get the right weight of the new mfs
				A=A(find([1;diff(A)]));

				%%%%%%%%%
				% MERGE %
				%%%%%%%%%
				if shoulder; 	%See to that SHOULDERS are beeing kept:
				%If a left shoulder, all sets to be merged are made to have this shoulder
					if min(mfs(A,3)) <= rl(i,1); 	
						mfs(A,2) = (min(mfs(A,2))-1) * ones(size(A));
						mfs(A,3) = (mfs(A,2)+1);
					end;	
				%If a right shoulder, all sets to be merged are made to have this shoulder
					if max(mfs(A,4)) >= rl(i,2)	
						mfs(A,5) = (max(mfs(A,5))+1) * ones(size(A));
						mfs(A,4) = (mfs(A,5)-1);
					end;
				end; % end of "if shoulder"
				
				% Merge the sets
				p1=min(mfs(A,2));
				p2=(sum(mfs(A,3)))/length(A);
				p3=max( p2, (sum(mfs(A,4)))/length(A) );
				p4=max(mfs(A,5));
				mfs(A,:)=ones(length(A),1) * ([mfs(A(1),1) p1 p2 p3 p4]);

				%%%%%%%%%%%%%%
				% Update RLS %
				%%%%%%%%%%%%%%
				update=rls(:,i)*ones(1,length(A))-ones(n,1)*A';
				update=prod(update');
				rls(find(~update),i)=0*(rls(find(~update),i))+min(rls(find(~update),i));


			else,
				stop=1;				% No more similar sets in this dimension
			end;
        end; % Ends if stop=1;
		
		%%%%%%%%%%%%%%%%%%
		% Update mfs_new %
		%%%%%%%%%%%%%%%%%%
		mfs_new{i}=mfs;
	    
	end;	% end of "for i = 1:m"

end; % End of use_t

%%%%%%%%%%%%
% UPDATING %
%%%%%%%%%%%%
% Remove unused MFS and update RLS
[n,m]=size(rls);

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

%% End of function FMSIMP %%

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

%%%%%%%%%%%%%%%%%%%%%%%
function RT=tclosure(R)
% RT=TCLOSURE(R)
% Calculates max-min transitive closure of the (nxn) relation R

% M.Setnes 15.05.97, Update:Aug 06, 1999

RT=max(R,sup_min(R,R));	%Calculate trans. closure
while any(any(RT~=R));
	R=RT;
	RT=max(R,sup_min(R,R));
end;

function C=sup_min(A,B)
% Sup-min composition
[bm,bn] = size(B);
[am,an] = size(A);
bn1 = ones(1,bn);
A=A';
for i=1:am
    C(i,:)=max(min(A(:,i)*bn1,B));
end
