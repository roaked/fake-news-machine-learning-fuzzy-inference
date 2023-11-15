function [FM,Part] = fmclust(Dat,FM,out)
% FMCLUST build a MIMO static or dynamic fuzzy model from data.
%     Uses product-space fuzzy clustering (Gustafson-Kessel).
%
%     [FM,Part] = FMCLUST(DAT,STR,OUT)
%
%     DAT is a structure with the following fields:
%       U,Y  ...  input and output data matrices, respectively
%                 use cell arrays to store independent batches
%       Ts   ...  sample time (optional, default 1)
%       FileName ...  file name (optional)
%
%     STR is a structure with the following fields:
%       c    ...  number of clusters (thus also rules) per output
%       m    ...  fuzziness exponent pre output (default 2)
%       tol  ...  termination tolerance (default 0.01)
%       seed ...  seed for initialization (default sum(100*clock))
%       ante ...  antecedents: 1 - product-space MFS (default)
%                              2 - projected MFS
%       cons ...  consequent estimation: 1 - global LS (default)
%                                        2 - local weighted LS
%                                        3 - total LS
%       Ny   ...  delays in y (default 0)
%       Nu   ...  delays in u (default 1)
%       Nd   ...  transport delays (default 0)
%
%     OUT is the number of the output to construct (default all)
%
%     FM is a structure containing the fuzzy model (see FMSTRUCT).
%     Part is a structure containing the fuzzy partition.
%
%  See also FMSIM, FMSTRUCT, GKFAST.

% (c) Robert Babuska, Stanimir Mollov 1997-1999

if isfield(Dat,'U'); U = Dat.U;
elseif isfield(Dat,'X')'; U = Dat.X;
elseif isfield(Dat,'x')'; U = Dat.x;
elseif isfield(Dat,'u')'; U = Dat.u; else U = []; end;
if isfield(Dat,'Y'); Y = Dat.Y;
elseif isfield(Dat,'y'); Y = Dat.y; else Y = []; end;
if ~iscell(U), U = {U}; end; if ~iscell(Y), Y = {Y}; end;

if isfield(Dat,'Ts'); Ts = Dat.Ts; else Ts = 1; end;
if isfield(Dat,'FileName'); FM.FileName = Dat.FileName; else FM.FileName = ''; end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get dimensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ninps = size(U{1},2); [Nd,NO] = size(Y{1});
FM.ni = Ninps; FM.no = NO; FM.Ts = Ts; FM.N = Nd;
FM.date  = fix(clock);

% update to ver.3.0 fuzzy model
FM = fmupdate(FM);

ny = FM.Ny;
nu = FM.Nu;

if Ninps == 0, nu = zeros(NO,1); nd = nu; end;

if isfield(FM,'c'); c = FM.c; else c = 1; end;
if isfield(FM,'m'); m = FM.m; else m = 2; end;
if isfield(FM,'ante'); ante = FM.ante; else ante = 1; end;
if isfield(FM,'cons'); cons = FM.cons; else cons = 1; end;
if ~isfield(FM,'tol'); FM.tol = 0.01; end;
if ~isfield(FM,'seed'); FM.seed = sum(100*clock); end;

initialPart = 0;
if size(c,1) > 1, initialPart = 1; end;
if initialPart == 1, FM.c = c; c = size(c,2); end; 

if length(c) == 1, c = c*ones(1,NO); end;
if length(m) == 1, m = m*ones(1,NO); end;
if length(ante) == 1, ante = ante*ones(1,NO); end;
if length(cons) == 1, cons = cons*ones(1,NO); end;

FM.m = m; FM.ante = ante; FM.cons = cons;
if isfield(Dat,'InputName'); FM.InputName = Dat.InputName;
elseif Ninps > 1, for j = 1 : Ninps, FM.InputName{j} = ['u_' num2str(j)]; end;
else FM.InputName{1} = 'u'; end;
if isfield(Dat,'OutputName'); FM.OutputName = Dat.OutputName;
elseif NO > 1, for j = 1 : NO, FM.OutputName{j} = ['y_' num2str(j)]; end;
else FM.OutputName{1} = 'y'; end;
   
if ~iscell(FM.OutputName), FM.OutputName = {FM.OutputName}; end;
if ~iscell(FM.InputName), FM.InputName = {FM.InputName}; end;

if nargin < 3, out = 1 : NO; end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clstep = 1;     % take each clstep-th data point for clustering
show = 0;       % show clustering progress
lstep = 1;      % take each clstep-th data point for least squares
%show = 1;       % show/don't show progress messages
MFTYPE = 2;     % type of membership functions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loop through the outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1 : NO,                 % for all outputs
   FM.rls{k} = [];
   FM.mfs{k} = {};
   FM.V{k} = [];
end;

for k = out,                 % for given outputs

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % make regression matrix and data matrix
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   dat = [];
   datcons = [];
   commondat = [];
   for b = 1 : length(U),
      if Ninps == 0,
         z = Y{b};
      else
         z = [Y{b} U{b}];
      end;

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % antecedent regressors
      % take the first cell row
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      [yr,ur,y1]=regres([Y{b}(:,k) z],ny{1}(k,:),nu{1}(k,:));

      dat = [dat;[ur y1]];          % data to cluster

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % consequent regressors
      % take the second cell row
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      [yr,ur,y1]=regres([Y{b}(:,k) z],ny{2}(k,:),nu{2}(k,:));

      datcons = [datcons;[ur y1]];  % data to build the consequents

      antesize = size(dat,1);
      conssize = size(datcons,1);

      if antesize < conssize,
         dd = datcons;
         clear datcons
         datcons = dd(end-antesize+1:end,:);
      end
      if conssize < antesize,
         dd = dat;
         clear dat
         dat = dd(end-conssize+1:end,:);
      end
      
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % common regressors
      % take the union of the two cell rows
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      unitedoutputs = [];
      unitedinputs = [];
      for united = 1:NO
         unitedoutputs{k,united} = union(ny{1}{k,united},ny{2}{k,united});
         %unitedoutputs = union(unitedoutputs,temp);
      end   
      for united = 1:Ninps,
         unitedinputs{k,united} = union(nu{1}{k,united},nu{2}{k,united});
         %unitedinputs = union(unitedinputs,temp);
      end   
      [yr,ur,y1]=regres([Y{b}(:,k) z],unitedoutputs(k,:),unitedinputs(k,:));
      commondat = [commondat;[ur y1]];
     
   end;
   
   % added in Feb 2012 to handle missing data
   ind = ~any(isnan(dat)')'; % find rows containing no NaN
   dat = dat(ind,:); % retain these rows
   ind = ~any(isnan(datcons)')'; % find rows containing no NaN
   datcons = datcons(ind,:); % retain these rows
   
   ND = size(dat,1); NI = size(dat,2)-1;
   dat = dat(1:clstep:ND,:);
   rls = (1:c(k))'*ones(1,NI);

   %hh = diag([1 2 3 4])*ones(4);
   %h1 = hh';
   %rls = [h1(:) hh(:)];
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % clustering
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if c(k) > 1,        % cluster data
      if (show ~= 0),
         fprintf(['Output ' num2str(k), ': clustering data in ' num2str(c(k)) ' clusters ...\n']);
         drawnow
      end;
      rand('seed',FM.seed);
      if initialPart == 0
        [mu,V,P,Phi,Lam] = gkfast(dat,c(k),m(k),FM.tol,0);
      else
        [mu,V,P,Phi,Lam] = gkfast(dat,FM.c,m(k),FM.tol,0);
      end;
      [dum,ind] = sort(V(:,1));
      mu = mu(:,ind); V = V(ind,:); P = P(:,:,ind);
      Phi = Phi(ind,:); Lam = Lam(ind,:);

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Construct M matrix
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      M = zeros(NI,NI,c(k));
      NI1 = 1/NI;
      for j = 1 : c(k),
         M(:,:,j) = det(P(1:NI,1:NI,j)).^NI1*inv(P(1:NI,1:NI,j));
      end;

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % make membership functions (and rules)
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      mfs = {};
      if ante(k) == 2,        % projected MFs
         if (show ~= 0),
            fprintf(1,['          extracting membership functions ...\n']);
            drawnow
         end;

         range   = [min(dat(:,1:NI))'  max(dat(:,1:NI))'];
         perc = 50;
         safety = perc*0.01*(range(:,2) - range(:,1));
         rlimits = [range(:,1)-safety range(:,2)+safety];

         mfstep = round(ND/100); if mfstep < 1, mfstep = 1; end;
         OPT = optimset('MaxFunEvals',1000,'Display','off');  
         %OPT = foptions; OPT(14) = 1000;
         for i = 1 : NI,
            [ds,fs]=smoothmf(dat(1:mfstep:ND,i),mu(1:mfstep:ND,:));
            mf = mffit(ds,fs,MFTYPE,OPT,[1 0 0]);
            lim = mf(:,3) == min(mf(:,3)); mf(lim,2:3) = ones(sum(lim),1)*[rlimits(i,1) rlimits(i,1)];
            if mf(lim,4) < rlimits(i,1), mf(lim,4) = rlimits(i,1); end;
            lim = mf(:,4) == max(mf(:,4)); mf(lim,4:5) = ones(sum(lim),1)*[rlimits(i,2) rlimits(i,2)];
            if mf(lim,3) > rlimits(i,2), mf(lim,3) = rlimits(i,2); end;
            mfs{i} = mf;
         end;
      end;
   else          % linear model
%      mfs = {};
      for i = 1 : NI, mfs{i} = [0 0 0 0 0]; end;
      V = mean(dat); P = cov(dat);
      M = det(P(1:NI,1:NI)).^(1/NI)*inv(P(1:NI,1:NI));
      mu = ones(ND,1);
      [ev,ed] = eig(P); Lam = diag(ed)';
      Phi = ev(:,Lam == min(Lam));
   end;

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Construct the FM and Part structures to be returned
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   FM.rls{k} = rls; FM.mfs{k} = mfs; FM.V{k} = V(:,1:end-1); FM.M{k} = M;
   FM.zmin{k} = min(commondat); FM.zmax{k} = max(commondat);

   Part.Mu{k} = mu;
   Part.Z{k} = dat;
   Part.Zc{k} = datcons;

   Part.V{k} = V; Part.F{k} = P;
   Part.Phi{k} = Phi; Part.Lam{k} = Lam;

end;

if (show ~= 0),
   fprintf(1,['Estimating consequent parameters ...\n']); drawnow
end;

%if any(FM.cons == 1),
%   FM = fmest(FM,Dat,out);
%else
FM = fmest(FM,Part,out);
%end;

lth = length(FM.th);
for i = lth+1 : NO, FM.th{i} = []; end

if (show ~= 0),
   fprintf(1,['Done.\n']);
   drawnow
end;
