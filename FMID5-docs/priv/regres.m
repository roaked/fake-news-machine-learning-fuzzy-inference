%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Yr,Ur,Y] = regres(z,ny,nu)
% REGRES according to the specified discrete-model orders, creates a
% regression matrix and an output vector.
%
% [R,Y] = REGRES(Z,NY,NU)
% Inputs:       Z - the output-input data, the same convention as in 
%		    the ID toolbox, i.e. z = [y u]
%					 NY - transfer function denominator structure
%					 NU - transfer function nominator structure
%	
% Outputs:      R - regression matrix, i.e. [y(k-1),y(k-2),...,u1(k-1-d1),u1(k-2-d1),...,u2(k-1-d2),...]
%		Y - model output, i.e. y(k)
% or 
%
% [YR,UR,Y] = REGRES(Z,NY,NU)
%
% Outputs:      YR - output regressors, i.e. [y(k-1),y(k-2),...]
%		UR - input regressors, i.e. [u1(k-1-d1),u1(k-2-d1),...,u2(k-1-d2),...]
%		Y - model output, i.e. y(k)
%
% This function is not included the printed documentation.

% (c) Robert Babuska, Stanimir Mollov 1994-1999

[m,n] = size(z);
maxorder = 0;
for i = 1:size(ny,2),
   maxorder = max([maxorder max([ny{1,i}])]); 
%   maxordery = max([max([ny{1,:}])]); 
%   maxorderu = max([max([nu{1,:}])]); 
end
for i = 1:size(nu,2),
   maxorder = max([maxorder max([nu{1,i}])]); 
%   maxordery = max([max([ny{1,:}])]); 
%   maxorderu = max([max([nu{1,:}])]); 
end

y = z(:,1); u = z(:,2:n);
na = 0;
for i = na : -1 : 0,
  yr(:,i+1) = y(1+maxorder-i:m-i);
end;
ur = [];

% loop through the outputs
colpos = 1;
mstatic = 1;
for j = 1:size(ny,2),
  if ~isempty(ny{1,j})
     for i = 1:size(ny{1,j},2), 
     	temp = ny{1,j}(i);
        ur(:,colpos) = u(maxorder - temp+1:m - temp,j);
        colpos = colpos + 1;
     end;
     mstatic = 0;
  end
  
end;

%if mstatic, j = size(u,2)-1;end
if mstatic, j = size(u,2)-size(nu,2);end
% loop through the inputs
for jj = 1 : size(nu,2),  
   if ~isempty(nu{1,jj})
      for i = 1:size(nu{1,jj},2),
        temp = nu{1,jj}(i);
         ur(:,colpos) = u(maxorder - temp+1:m-temp,j+jj);
         colpos = colpos + 1;
      end;
   end
end;

my = size(yr,1); mu = size(ur,1); m = min(my,mu);

if nargout < 3,
   if isempty([ny]) & isempty([nu]) , Yr = ur; Ur = []; 
   elseif isempty([nu]), Yr = yr(:,2:na+1); Ur = yr(:,1); 
  else Yr = [yr(:,2:na+1),ur]; Ur = yr(:,1); 
  end
else
   if isempty([ny]) & isempty([nu]), Yr = []; %
  elseif isempty([nu]), Y = yr(:,1); Yr = yr(:,2:na+1); 
  else  
     Y = yr(:,1); 
     Yr = yr(:,2:na+1); 
     Ur = ur; 
  end
end;


