function DOF = dofprod(rls,mfs,x)
% DOFPROD calculates degrees of fulfillment of the rules
% using the product as the fuzzy logic AND operator.
%
% DOF = DOFPROD(RLS,MFS,X)
% Inputs:       RLS - rule matrix
%               MFS - membership function matrix
%               X   - input vector or matrix
%
% Output:       DOF - matrix of degrees of fulfillment
%
% See also TXT2RLS, RLS2TXT, MFSET, MFGET, INFER, DOFMIN, DOFTN.

% Copyright (c) Robert Babuska, 1993-2003

[nrls,ninps] = size(rls);

if nargin < 3,                  % membership degrees passed
    k  = size(mfs{1},1);
    unity = ones(k,nrls);
    DOF = unity;
    for i = 1 : ninps,
       any = (rls(:,i) == 0);
       rls(any,i) = 1;
       mu = mfs{i}(:,rls(:,i));
       mu(:,any) = 1; 
       DOF = DOF.*mu;
    end;    
else                            % membership functions passed
    k  = size(x,1);
    unity = ones(k,nrls);
    DOF = unity;
    if isnumeric(mfs), mfs = {mfs}; end;
    for i = 1 : ninps,
       if isempty(mfs{i}),
          mu = unity;
       else   
          any = (rls(:,i) == 0);
          rls(any,i) = 1;
          mu = mgrade(x(:,i),mfs{i}(rls(:,i),:));
          mu(:,any) = 1; 
       end;
       DOF = DOF.*mu;
    end;   
end;