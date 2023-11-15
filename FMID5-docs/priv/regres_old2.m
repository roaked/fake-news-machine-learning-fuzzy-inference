%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Yr,Ur,Y] = regres(z,na,nb,nd)
% REGRES according to the specified discrete-model orders, creates a
% regression matrix and an output vector.
%
% [R,Y] = REGRES(Z,NA,NB,NK)
% Inputs:       Z - the output-input data, the same convention as in 
%		    the ID toolbox, i.e. z = [y u]
%               NA - transfer function denominator order
%               NB - numerator order(s)
%               ND - transport delay(s) 
%	
% Outputs:      R - regression matrix, i.e. [y(k-1),y(k-2),...,u1(k-1-d1),u1(k-2-d1),...,u2(k-1-d2),...]
%		Y - model output, i.e. y(k)
% or 
%
% [YR,UR,Y] = REGRES(Z,NA,NB,NK)
%
% Outputs:      YR - output regressors, i.e. [y(k-1),y(k-2),...]
%		UR - input regressors, i.e. [u1(k-1-d1),u1(k-2-d1),...,u2(k-1-d2),...]
%		Y - model output, i.e. y(k)
%
% This function is not included the printed documentation.

% (c) Robert Babuska, May 1994

[m,n] = size(z);
if nargin < 3, nb = zeros(m,n-1); end;
if nargin < 4, nd = zeros(m,n-1); end;
ns = [0 cumsum(nb)];

y = z(:,1); u = z(:,2:n);

for i = na : -1 : 0,
  yr(:,i+1) = y(1+na-i:m-i);
end;

for j = 1 : n-1  
  for i = nb(j)-1 : -1 : 0,
    ur(:,ns(j)+i+1) = u(max(nd)-nd(j)+max(nb)-i:m-i-nd(j),j);
  end;
end;

my = size(yr,1); mu = size(ur,1); m = min(my,mu);

if nargout < 3,
  if na == 0 & nb == 0, Yr = ur; Ur = [];
  elseif nb == 0, Yr = yr(:,2:na+1); Ur = yr(:,1);
  else Yr = [yr(my-m+1:my,2:na+1),ur(mu-m+1:mu,:)]; Ur = yr(my-m+1:my,1);
  end
else
  if na == 0 & nb == 0, Yr = [];
  elseif nb == 0, Y = yr(:,1); Yr = yr(:,2:na+1);
  else  Y = yr(my-m+1:my,1); 
     Yr = yr(my-m+1:my,2:na+1); 
     %Ur = ur(mu-m+1:mu,:); %Robert
     Ur = ur(mu-m+1:mu,:); %Stanimir
  end
end;


