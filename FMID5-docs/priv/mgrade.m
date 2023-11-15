function y=mgrade(x,mfs)
% MGRADE(X,MFS) returns the membership grade of the elements of X
% in fuzzy sets with membership functions defined in MFS.
% MFS can be either a matrix containing membership function parameters
% or a cell array of such matrices. In the latter case, membership
% degrees in the product space of the individual elements of MFS
% are returned in an N-D array.
%
% The size of the MFS matrix is M x 5, where M is the number of membership 
% functions. The first column determines the membership function type:
%
%       0 ... one everywhere,        1 ... Trapezoidal
%       2 ... Exponential,           3 ... Sigmoidal
%
% The remaining four columns [p1 p2 p3 p4]define the parameters 
% as follows:
%
%       Ax = 0                  for x <= p1 or  x >= p4
%            1                  for x >= p2 and x <= p3
%            in (0,1)           for x >  p1 and x <  p2 or
%                                   x >  p3 and x <  p4
%
% The shape of the membership function curve between p1 and p2
% and between p3 and p4 is determined by the membership function type,
% i.e., linear (1), exponential (2) or sigmoidal (3). For the equations
% see the User's Guide.

% Copyright (c) Robert Babuska, 1992-98

if ~iscell(mfs),		% standard situation
   [k,l]=size(mfs);
    x = x(:)';
   lx = length(x);
   mx = ones(1,lx);
   if ~all(mfs(:,2)<=mfs(:,3) & mfs(:,3)<=mfs(:,4) & mfs(:,4)<=mfs(:,5)),
      error('Illegal membership function parameters');
   end;
   xx = ones(k,1)*x;
   y = 1.0*(xx >= mfs(:,3)*mx & xx <= mfs(:,4)*mx);
   for j = 1 : k
      if mfs(j,1) == 0,                    % ANY
         y(j,:) = mx;
      elseif mfs(j,1) == 1,                % trapezoidal
         if mfs(j,3) > mfs(j,2),  y(j,:) = y(j,:) + ...
               (x > mfs(j,2) & x < mfs(j,3)).*(x - mfs(j,2))/(mfs(j,3) - mfs(j,2));
         end;
         if mfs(j,5) > mfs(j,4),  y(j,:) = y(j,:) + ...
               (x > mfs(j,4) & x < mfs(j,5)).*(mfs(j,5) - x)/(mfs(j,5) - mfs(j,4));
         end;
      elseif mfs(j,1) == 2,                % exponential
         wl = mfs(j,3) - mfs(j,2);
         wr = mfs(j,5) - mfs(j,4);
         if wl > 0
            y(j,:)=y(j,:)+(x<mfs(j,3)).*exp(-7*(x-mfs(j,3)).^2/wl^2);
         end;
         if wr > 0
            y(j,:)=y(j,:)+(x>mfs(j,4)).*exp(-7*(x-mfs(j,4)).^2/wr^2);
         end;
      elseif mfs(j,1)==3,                  % sigmoidal
         wl = (mfs(j,3) - mfs(j,2))/2;
         wr = (mfs(j,5) - mfs(j,4))/2;
         if wl > 0
            y(j,:)=y(j,:)+0.5*((x>mfs(j,2)) & (x<=mfs(j,2)+wl)).*...
               (((x-mfs(j,2))/wl).^2)+...
               ((x>mfs(j,2)+wl) & (x<mfs(j,3))).*...
               (1-0.5*(((mfs(j,3)-x)/wl).^2));
         end;
         if  wr > 0
            y(j,:)=y(j,:)+((x>mfs(j,4)) & (x<=mfs(j,4)+wr)).*...
               (1-0.5*(((mfs(j,4)-x)/wr).^2))+...
               0.5*((x>mfs(j,4)+wr) & (x<mfs(j,5))).*...
               (((mfs(j,5)-x)/wr).^2);
         end;
      end;
   end;
	y = y';   
else			% cell array supplied
   for k = 1 : size(x,1),
      a = mgrade(x(k,1),mfs{1});
      sb = length(a);
      for i = 2 : length(mfs),
         b = mgrade(x(k,i),mfs{i});
         sb(i) = length(b);
         a = a(:);
         %	   a = min(a*ones(1,sb(i)),ones(size(a))*b(:)');
         a = a*b(:)';
      end;   
      %   y = zeros(sb);       % ND array
      %   y(:) = a(:);
      y(k,:) = a(:)';
	end;   
end;   