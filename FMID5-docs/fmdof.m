function [DOF,X] = fmdof(U,Y,FM)
% FMDOF compute the degree of fulfillment in a MIMO fuzzy model.
%
%     [DOF,X] = FMDOF(U,Y,FM) computes the DOF for the data in 
%     U and Y (no simulation performed).
%
%         U,Y ... input and output data matrices, respectively
%         FM  ... structure containing fuzzy model parameters
%         DOF ... degrees of fulfillment of the rules
%         X   ... regressors
%
%  See also FMSIM, FMCLUST, FMSTRUCT, GKFAST.

% (c) Robert Babuska, Stanimir Mollov 1997-1999

NO = FM.no;

for k = 1 : NO,
  c(k) = size(FM.th{k},1);
end;

mexp = (-1./(FM.m-1));

for kk = 1 : NO,
   if FM.ni == 0, z = Y; else z = [Y U]; end;
%   [yr,ante,y1]=regres([Y(:,kk) z],0,[FM.Ny(kk,:) FM.Nu(kk,:)],[ones(1,NO).*(FM.Ny(kk,:)>0) FM.Nd(kk,:)]);
   [yr,ante,y1]=regres([Y(:,kk) z],FM.Ny{1}(kk,:),FM.Nu{1}(kk,:));
   x1 = ones(size(ante,1),1);
   if c(kk) > 1,
      if FM.ante(kk) == 1,		% product-space MFs
         d = zeros(length(x1),c(kk));
         NI = size(FM.rls{kk},2);
         for j = 1 : c(kk),                        % for all clusters
            xv = ante - x1*FM.V{kk}(j,:);
            d(:,j) = sum(xv*FM.M{kk}(:,:,j).*xv,2);
         end;
         d = (d+1e-100).^mexp(kk);		% clustering dist
         DOF{kk} = (d ./ (sum(d,2)*ones(1,c(kk))));
         % dofe = 1./(1+d);				% similarity
      elseif FM.ante(kk) == 2,	% projected MFs
         DOF{kk} = dofprod(FM.rls{kk},FM.mfs{kk},ante);
      end;
   else
      DOF{kk} = x1;
   end;
   X{kk} = ante;   
end;
