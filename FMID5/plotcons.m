function plotcons(FM,opt,fig,options)
% PLOTCONS    Plot consequent parameters.
%    PLOTCONS(FM,OPT,FIG,OPTIONS) plots the consequent parameters
%    FM.th versus the cluster centers FM.V. The OPT parameter can
%    be used to specify the PLOT options (optional). The FIG
%    parameter (optional) specifies the figure where to begin 
%    with the plots. The default is 1. Set the (i,j)-th element of
%    the OPTIONS matrix to zero to disable the plot of the j-th
%    parameter vs. the i-th antecedent variable.

% Copyright (c) Robert Babuska, Stanimir Mollov 1999.

if nargin < 2, opt = []; end;
if nargin < 3, fig = 1; elseif isempty(fig), fig = 1; end;
if exist('options') == 1, if ~iscell(options), options = {options}; end; end;
   
sp = [1 1; 2 1; 3 1; 2 2; 3 2; 4 2; 3 3; 4 3; 5 3; (6:50)' ones(45,1)];

FontSize = 6;
V = FM.V; Th = FM.th; S = FM.s;
avars = antename(FM);
vars = consname(FM);
outputoffset = 0;
NO = FM.no;
for i = 1 : NO
   vars{i}{end+1} = 'offset';
end;

for i = 1 : NO,
   nant = size(V{i},2);
   npar = size(Th{i},2);
%   if nargin < 4, options{i} = diag(ones(nant,1)); end;
	if nargin < 4, options{i} = ones(nant,npar-1); end;
   
   if size(options{i},2) == (npar-1), options{i} = [options{i} zeros(nant,1)]; end;
   % check for coincidence between antecedent and consequent variables;
   for antepos = 1:nant,
      flag = 0;
      conspos = 1;
      %for conspos = 1:npar-1,
      while ~flag & conspos < npar   
         if ~isempty(findstr(avars{i}{antepos},vars{i}{conspos}))   
            flag = 1;
         end   
      conspos = conspos + 1;   
      end   
      % insert empty positions in options{i},Th{i} S{i} and vars{i}
      if ~flag
         tempoptions = options{i}(:,antepos:end);
         options{i}(:,antepos) = zeros(size(Th,1),1);
         options{i} = [options{i}(:,1:antepos) tempoptions];
         
         tempth = Th{i}(:,antepos:end);
         Th{i}(:,antepos) = zeros(size(Th,1),1);
         Th{i} = [Th{i}(:,1:antepos) tempth];
         
         temps = S{i}(:,antepos:end);
         S{i}(:,antepos) = zeros(size(S,1),1);
         S{i} = [S{i}(:,1:antepos) temps];
         
         for namepos = 1:npar-antepos+1,
            tempvars{namepos} = vars{i}{antepos-1+namepos};
         end   
         vars{i}{antepos} = '';
         for namepos = 1:npar-antepos+1
            vars{i}{antepos + namepos} = tempvars{namepos};
         end   
      end  
      % get new dimensions
      nant = size(V{i},2);
      npar = size(Th{i},2);
   end
   
   %end modifications
   
   for k = 1 : npar;
      if sum(options{i}(:,k)) > 0,
         figure(fig+k-1+outputoffset); clf; set(gcf,'numbertitle','off','name',vars{i}{k});
      end;   
      jj = 0;
      antepos = 1;
      for j = 1 : nant;
         if options{i}(j,k),
            jj = jj + 1;
            [v,ind] = sort(V{i}(:,j));
            th = Th{i}(ind,k);
            %s = FM.s{i}(ind,k);
            s = S{i}(ind,k);
            npar = sum(options{i}(:,k));
            subplot(sp(npar,1),sp(npar,2),jj);
            if ~isempty(opt), 
               errorbar(v,th,s,opt);
            else
               errorbar(v,th,s,'-'); hold on;
               plot([V{i}(:,j) V{i}(:,j)]',[Th{i}(:,k) Th{i}(:,k)]','.','MarkerSize',15); hold off;
            end;
            
            % get the correct zmin&zmax positions
            antediffers = getregresdiff(FM,'ante',i);
            while ~antediffers(1,antepos)
               antepos = antepos + 1;
            end   
            set(gca,'XLim',[FM.zmin{i}(antepos) FM.zmax{i}(antepos)]);
            antepos = antepos + 1;

            set(gca,'FontSize',FontSize)
            if strcmp(vars{i}{k},'offset'),
               ylabel([vars{i}{k}],'FontSize',9);
            else
               ylabel(['param at ' vars{i}{k}],'FontSize',9);
            end;   
            xlabel(avars{i}{j},'FontSize',9);
         end;
      end;
      drawnow;
   end;
   outputoffset = i*npar;
end;
