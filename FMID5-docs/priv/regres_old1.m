%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Yr,Ur,Y] = regres(z,structure)
% REGRES according to the specified discrete-model orders, creates a
% regression matrix and an output vector.
%
% [R,Y] = REGRES(Z,STRUCTURE)
% Inputs:       Z - the output-input data, the same convention as in 
%		    the ID toolbox, i.e. z = [y u]
%					 STRUCTURE:
%					 STRUCTURE.NY - transfer function denominator structure
%					 STRUCTURE.NU - transfer function nominator structure
%	
% Outputs:      R - regression matrix, i.e. [y(k-1),y(k-2),...,u1(k-1-d1),u1(k-2-d1),...,u2(k-1-d2),...]
%		Y - model output, i.e. y(k)
% or 
%
% [YR,UR,Y] = REGRES(Z,STRUCTURE)
%
% Outputs:      YR - output regressors, i.e. [y(k-1),y(k-2),...]
%		UR - input regressors, i.e. [u1(k-1-d1),u1(k-2-d1),...,u2(k-1-d2),...]
%		Y - model output, i.e. y(k)
%
% This function is not included the printed documentation.

% (c) Robert Babuska, 1994-1999

[m,n] = size(z);
%if nargin < 3, nb = zeros(m,n-1); end; %Robert
%if nargin < 4, nd = zeros(m,n-1); end; %Robert	

ny = structure.ny; %Stanimir
nu = structure.nu; %Stanimir

maxorder = max([max([nu{1,:}]),max([ny{1,:}])]); %Stanimir

%ns = [0 cumsum(nb)];

y = z(:,1); u = z(:,2:n);
na = 0;
for i = na : -1 : 0,
  yr(:,i+1) = y(1+maxorder-i:m-i);
end;

% change 'ur' to contain all the shifted
% vectors with respect to the structure of ny and nu
% now 'nd' is embedded in 'nu'

% loop through the outputs
colpos = 1;
for j = 1:size(ny,2),
  %inner loop -- extracts the delayed lines from a signal
  if ~isempty(ny{1,j})
     for i = 1:size(ny{1,j},2), 
        %  for i = nb(j)-1 : -1 : 0,
        ur(:,colpos) = u(maxorder - ny{1,j}(i)+1:m - ny{1,j}(i),j);
        colpos = colpos + 1;
     end;
  end
end;

if isempty(j), j = 0;end

% loop through the inputs
for jj = 1 : size(nu,2),  
   %inner loop -- extracts the delayed lines from a signal
   if ~isempty(nu{1,jj})
      for i = 1:size(nu{1,jj},2), 
         %  for i = nb(j)-1 : -1 : 0,
         ur(:,colpos) = u(maxorder - nu{1,jj}(i)+1:m-nu{1,jj}(i),j+jj);
         colpos = colpos + 1;
      end;
   end
end;

my = size(yr,1); mu = size(ur,1); m = min(my,mu);

if nargout < 3,
%  if na == 0 & nb == 0, Yr = ur; Ur = []; %Robert
  if isempty([ny]) & isempty([nu]) , Yr = ur; Ur = []; %Stanimir
%  elseif nb == 0, Yr = yr(:,2:na+1); Ur = yr(:,1); %Robert
  elseif isempty([nu]), Yr = yr(:,2:na+1); Ur = yr(:,1); %Stanimir
%  else Yr = [yr(my-m+1:my,2:na+1),ur(mu-m+1:mu,:)]; Ur = yr(my-m+1:my,1); %Robert
  else Yr = [yr(:,2:na+1),ur]; Ur = yr(:,1); %Stanimir
  end
else
%   if na == 0 & nb == 0, Yr = []; %Robert
   if isempty([ny]) & isempty([nu]), Yr = []; %Stanimir
%  elseif nb == 0, Y = yr(:,1); Yr = yr(:,2:na+1); %Robert
  elseif isempty([nu]), Y = yr(:,1); Yr = yr(:,2:na+1); %Stanimir
  else  %Y = yr(my-m+1:my,1);  %Robert
     Y = yr(:,1); %Stanimir
%     Yr = yr(my-m+1:my,2:na+1); %Robert
     Yr = yr(:,2:na+1); %Stanimir
     %Ur = ur(mu-m+1:mu,:); %Robert
     Ur = ur; %Stanimir
  end
end;


