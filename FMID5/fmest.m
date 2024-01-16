function [FM,dof] = fmest(FM,Dat,out)
% FMEST estimate consequent parameters for a MIMO TS fuzzy model.
%
%     FM = FMEST(FM,Dat,OUT) estimates consequent parameters
%     in fuzzy model FM, using data Dat. OUT (optional) may
%     be used to specify which output to estimate.
%
%     FM = FMEST(FM,Part,OUT) estimates consequent parameters in
%     fuzzy model FM, using fuzzy partition Part obtained from
%     FMCLUST. OUT (optional) may be used to specify which output
%     to estimate.
%

%  See also FMCLUST, FMSIM, FMSTRUCT.

% (c) Robert Babuska, Stanimir Mollov 1997-99, Koen Maertens 2002

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get dimensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update an old-type to ver 3.0 fuzzy model
FM = fmupdate(FM);

Ninps = FM.ni;
NO = FM.no;

if ~isfield(FM,'cons'),
   FM.cons = 1;                     % global optimization as default setting
end;

if ((~isfield(FM,'beta'))) %&...
%     ((FM.cons==4)|(FM.cons==5))),
    for i = 1 : NO,
        FM.beta{i} = ones(FM.c(i),1);       % use unity beta as standard 
    end;
end;


if ~iscell(FM.beta), FM.beta={FM.beta}; end;

if nargin < 3, out = 1 : NO; end;

if isfield(FM,'Ny'); ny = FM.Ny; else ny = zeros(NO,NO); end;
if isfield(FM,'Nu'); nu = FM.Nu; else nu = ones(NO,Ninps); end;
if isfield(FM,'Nd'); nd = FM.Nd; else nd = zeros(NO,Ninps); end;

for kk = 1 : NO,
   c(kk) = size(FM.rls{kk},1); % number of clusters for each output

   if (length(FM.beta{kk})<2),  %only one value defined
       FM.beta{kk}=FM.beta{kk}*ones(c(kk),1); 
   end;
   if (length(FM.beta)<NO),
      FM.beta{kk} = FM.beta{1};       % use first as example           
   end;
   if FM.cons==5,
        if ~isfield(FM,'deltath'), 
            FM.deltath{kk} = 1;       % use unity as standard 
        end;
        
        if ~iscell(FM.deltath), FM.deltath={FM.deltath}; end;
        
        if (length(FM.deltath{kk})<2),     % only one value defined
            if isfield(Dat,'Mu'), %eg from fmclust
              FM.deltath{kk}=FM.deltath{kk}*ones(FM.c,length(ny{2}{1})+length(nu{2}{1})+1);
              FM.deltath
            else
              FM.deltath{kk}=FM.deltath{kk}*ones(FM.c,Ninps+1);
            end;
        end;
        
        if (length(FM.deltath)<NO),
            FM.deltath{kk} = FM.deltath{1}; % use first as example      
        end;
   end;
end; % of cluster kk
   


if isfield(Dat,'Mu'), % eg from fmclust
   Z = Dat.Z;
   Zc = Dat.Zc;
   Mu = Dat.Mu; F = Dat.F; V = Dat.V;
   Phi = Dat.Phi; Lam = Dat.Lam;

else
   if isfield(Dat,'U'); U = Dat.U;
   elseif isfield(Dat,'X')'; U = Dat.X;
   elseif isfield(Dat,'x')'; U = Dat.x;
   elseif isfield(Dat,'u')'; U = Dat.u; else U = []; end;
   if isfield(Dat,'Y'); Y = Dat.Y;
   elseif isfield(Dat,'y'); Y = Dat.y; else Y = []; end;
   if ~iscell(U), U = {U}; end; if ~iscell(Y), Y = {Y}; end;
   
   for k = 1 : NO,                 % for all outputs
      dat = [];
      datcons = [];
      for b = 1 : length(U),
         if Ninps == 0,
            z = Y{b};
         else
            z = [Y{b} U{b}];
         end;
         [yr,ur,y1]=regres([Y{b}(:,k) z],ny{1}(k,:),nu{1}(k,:));
         dat = [dat;[ur y1]];          % data to make the clusters
         
         [yr,ur,y1]=regres([Y{b}(:,k) z],ny{2}(k,:),nu{2}(k,:));
         datcons = [datcons;[ur y1]];          % data to make the linear models
      end;
      Z{k} = dat;
      Zc{k} = datcons;
   end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loop through the outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for kk = out,

    % ante := antecedent regressor
   ante = Z{kk}(:,1:end-1);
   % cons := consequent regressor
   cons = Zc{kk}(:,1:end-1);
   x1 = ones(size(cons,1),1);
   dc = [cons x1];
   %%%%%%%%%%%%%%%%%%%%%%%%%%

   y = Zc{kk}(:,end); %size(Zc{kk},2));                   % output data vector

   if c(kk) > 1,
      if FM.ante(kk) == 1,      % product-space MFs
         mexp = (-1./(FM.m-1));
         d = zeros(length(x1),c(kk));
         NI = size(FM.rls{kk},2);
         for j = 1 : c(kk),                        % for all clusters
            xv = ante - x1*FM.V{kk}(j,:);
            d(:,j) = sum(xv*FM.M{kk}(:,:,j).*xv,2);
         end;
         d = (d+1e-100).^mexp(kk);      % clustering dist
         dof = (d ./ (sum(d,2)*ones(1,c(kk))));
         % dofe = 1./(1+d);             % similarity
      elseif FM.ante(kk) == 2,  % projected MFs
         dof = dofprod(FM.rls{kk},FM.mfs{kk},ante);
      end;
      if FM.ante(kk) == 1 & FM.cons(kk) ~= 1,
         dof = Mu{kk};
      end;
      if FM.cons(kk) <  1,
         dof = 1.0*(dof >= FM.cons(kk));    % alpha cut
         [p,t,t,t,s] = suglms(dc,y,dof,[],1);
      elseif FM.cons(kk) == 1,   [p,t,t,t,s] = suglms(dc,y,dof,[],0);   % Global LS
      elseif FM.cons(kk) == 2,   [p,t,t,t,s] = suglms(dc,y,dof,[],1);   % Locally WLS
      elseif FM.cons(kk) == 3,   [p,s] = cov2sug(V{kk},Phi{kk},Lam{kk},Z{kk});
      elseif FM.cons(kk) == 4,   
          [p,t,t,t,s,t,t,sens] = suglms(dc,y,dof,[],2,FM.beta{kk}); % Trade-off local vs global alg. 1  
          FM.sens{kk}=sens;       
          FM.sensl{kk}=-sens.*(1./FM.beta{kk}*(ones(1,length(p(1,:)))));
      elseif FM.cons(kk) == 5,
          [p,t,t,t,s,t,t,lambda] = suglms(dc,y,dof,[],3,FM.beta{kk},FM.deltath{kk}); % Trade-off local vs global alg. 2 
          FM.lambda{kk}=lambda;
      end;
   else                                 % linear model
    if FM.cons(kk) == 3,                                      % total LS (for linear model only, not for TS)
        dc0 = mean(dc(:,1:end-1));
        y0 = mean(y);
        [p,s] = tls(dtrend(dc(:,1:end-1)),dtrend(y));
        p = [p' y0-p'*dc0'];
    else
        [p,t,t,t,s] = suglms(dc,y);
    end;
   end;
   FM.th{kk} = p; FM.s{kk} = s;
end;
