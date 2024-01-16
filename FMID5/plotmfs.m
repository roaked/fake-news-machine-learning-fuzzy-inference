function plotmfs(mfs,opt,dom)
% PLOTMFS    Plot membership functions.
%    PLOTMFS(MFS,OPT,FIG) plots membership functions. MFS can be a numerical
%    array, a cell array or a fuzzy model structure FM. The OPT parameter
%    can be used to specify the PLOT options (optional). The FIG parameter 
%    (optional) specifies the figure where to begin  with the plots. 
%    The default is 1. 

% Copyright (c) Robert Babuska, 1998.

FontSize = 6;
if nargin < 2, opt = ''; elseif isempty(opt), opt = ''; end;
if nargin < 3, dom = []; fig = 1; 
elseif length(dom) == 1, fig = dom; dom = []; 
else fig = 1; end;


if isnumeric(mfs) & ~isempty(mfs),
   if isempty(dom), 
     dom = [min(mfs(:,2)) max(mfs(:,5))];
     dom = (dom(1) : (dom(2)-dom(1))/500 : dom(2))';
   end;  
   plot(dom,mgrade(dom,mfs),opt);
   set(gca,'YLim',[0 1]);
elseif isstruct(mfs),
   FM = mfs;
	vars = antename(FM);
   for i = 1 : FM.no,
      figure(fig+i-1); clf; set(gcf,'numbertitle','off','name',['Membership functions (' FM.OutputName{i} ')']);
      if mfs.ante(i) == 2,
         [c,nvar] = size(FM.rls{i});% size(FM.mfs{i});
         antepos = 1;
         antediffers = getregresdiff(FM,'ante',i);
         for k = 1 : nvar;
            switch nvar,
               case 1, subplot(1,1,1);
               case {2,3}, subplot(nvar,1,k);
               otherwise, subplot(ceil(nvar/2),2,k);
            end;      
            
            while ~antediffers(1,antepos) & antepos < length(antediffers) 
               antepos = antepos + 1;
            end   
   
            dom = [FM.zmin{i}(antepos) FM.zmax{i}(antepos)];
            dom = (dom(1) : (dom(2)-dom(1))/500 : dom(2))';
            antepos = antepos + 1;
            
            plotmfs(FM.mfs{i}{k},opt,dom);
            set(gca,'FontSize',FontSize)
            xlabel(vars{i}{k},'FontSize',9);
            ylabel('\mu','FontSize',9);
            set(gca,'xlim',[FM.zmin{i}(antepos-1) FM.zmax{i}(antepos-1)]);
         end;   
      else
         [c,nvar] = size(FM.V{i});
         if c > 1,
            for k = 1 : nvar;            
               dom = [FM.zmin{i}(k) FM.zmax{i}(k)];
               dom = (dom(1) : (dom(2)-dom(1))/500 : dom(2))';
               for j = 1 : c,
                  xx = ones(501,1)*FM.V{i}(j,:);
                  xx(:,k) = dom;
                  ff = fgrade(FM,xx,i);
                  f(:,j) = ff(:,j);
               end;
               switch nvar,
               case 1, subplot(1,1,1);
               case {2,3}, subplot(nvar,1,k);
               otherwise, subplot(ceil(nvar/2),2,k);
               end;      
               plot(dom,f,opt);
               set(gca,'YLim',[0 1]);
               set(gca,'FontSize',FontSize)
               xlabel(vars{i}{k},'FontSize',9);
               ylabel('\mu','FontSize',9);
            end;
         else
            text(.5,.5,'no membership functions available ...','horizontalalignment','center');
         end;
      end;   
   end;   
elseif iscell(mfs),
   n = length(mfs);
   for i = 1 : n,
      switch n,
         case 1, subplot(1,1,1);
         case {2,3}, subplot(n,1,i);
         otherwise, subplot(ceil(n/2),2,i);
      end;      
      plotmfs(mfs{i},opt);
   end;
end;

