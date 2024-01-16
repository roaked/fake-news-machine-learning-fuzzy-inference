function plotpart(Part,opt)
% PLOTPART    Plot projected fuzzy partition.
%    PLOTPART(Part,OPT) plots the fuzzy partition matrix Part.Mu
%    projected onto the columns of data matrix Part.Z. OPT are
%    options for the plot command (linetype, color, etc.).

% Copyright (c) Robert Babuska, 1998.

Z = Part.Z; Mu = Part.Mu;

NO = length(Z);
for i = 1 : NO,
   figure(i); clf;
   nvar = size(Z{i}(:,1:end-1),2);
   for k = 1 : nvar;
      [z,ind] = sort(Z{i}(:,k));
      mu = Mu{i}(ind,:);
      [z,mus]=smoothmf(z,mu);
      switch nvar,
      case 1, subplot(1,1,1);
      case {2,3}, subplot(nvar,1,k);
      otherwise, subplot(ceil(nvar/2),2,k);
      end;      
      if nargin > 2, 
         plot(z,mu,opt); hold on; plot(z,mus,'LineWidth',2); hold off;
      else
         plot(z,mu,'.'); hold on; plot(z,mus,'LineWidth',2); hold off;
      end;
   end;
end;
