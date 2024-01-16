function plotout(FM,opt,fig)
% PLOTOUT    Plot outputs as functions of individual inputs.
%    PLOTOUT(FM,OPT,FIG) FM is the fuzzy model. The OPT parameter
%    can be used to specify the PLOT options (linetype, color).
%    The FIG parameter (optional) specifies the figure where to 
%    begin  with the plots. The default is 1. 

% Copyright (c) Robert Babuska, Stanimir Mollov 1999.

if nargin < 2, opt = []; end;
if nargin < 3, fig = 1; elseif isempty(fig), fig = 1; end;

FontSize = 4;
LabSize = 6;
FontSize = 6;
LabSize = 8;
avars = antename(FM);
cvars = consname(FM);

for i = 1 : FM.no,
   c = size(FM.mfs{i},1);
   %c = FM.c;
	nvar = size(FM.zmin{i},2)-1;
   
   vars{i} = getvarunion(FM,i); %union(avars{i},cvars{i});
   figure(i+fig-1); set(gcf,'numbertitle','off','name',['Output ' num2str(i)]);
   if FM.ante(i) == 2,
 		antediffers = getregresdiff(FM,'ante',i);
		consdiffers = getregresdiff(FM,'cons',i);
      antepos = 0;
		conspos = 0;
      for k = 1 : nvar,
         dom = [FM.zmin{i}(k) FM.zmax{i}(k)];
         dom = (dom(1) : (dom(2)-dom(1))/500 : dom(2))';
         if antediffers(1,k)
            antepos = antepos + 1;
         end			
         if consdiffers(1,k)
            conspos = conspos + 1;
         end
         for j = 1 : c,
            xx = ones(501,1)*FM.V{i}(j,:);
            if antediffers(1,k)
               xx(:,antepos) = dom;	            
            end
         end;
         dof = dofprod(FM.rls{i},FM.mfs{i},xx);

         for j = 1 : size(FM.V{i},1),
            cons = ones(501,size(FM.th{i},2));
            aindx = 1;
            cindx = 1;
            for indx = 1: length(antediffers),
               if consdiffers(indx)
                  if antediffers(indx)
                     cons(:,cindx) = cons(:,cindx)*FM.V{i}(j,aindx); 
                     aindx = aindx + 1;
                  else
                     cons(:,cindx) = cons(:,cindx)*mean([FM.zmin{i}(indx) FM.zmax{i}(indx)]); 
                  end   
                  cindx = cindx + 1;
               else   
                  if antediffers(indx)
                     aindx = aindx + 1;
						end
               end
            end   
            if consdiffers(1,k)
               cons(:,conspos) = dom;
            end
            [Ym(:,j),Yl,Ylm] = sugval(FM.th{i},cons,dof);
         end;
         switch nvar,
         case 1, subplot(1,1,1);
         case {2,3}, subplot(nvar,1,k);
         otherwise, subplot(ceil(nvar/2),2,k);
         end;      
         if ~isempty(opt),
            plot(dom,Ym,opt);
         else   
            plot(dom,Ym);
         end;
         set(gca,'FontSize',FontSize)
         xlabel(vars{i}{k},'FontSize',LabSize);
         ylabel(FM.OutputName{i},'FontSize',LabSize);
         set(gca,'xlim',[FM.zmin{i}(k) FM.zmax{i}(k)]);
      end;   
   else
		antediffers = getregresdiff(FM,'ante',i);
		consdiffers = getregresdiff(FM,'cons',i);
      antepos = 0;
      conspos = 0;
      for k = 1 : nvar;            
         if antediffers(1,k)
            antepos = antepos + 1;
         end			
         if consdiffers(1,k)
            conspos = conspos + 1;
         end			
         dom = [FM.zmin{i}(k) FM.zmax{i}(k)];
         dom = (dom(1) : (dom(2)-dom(1))/500 : dom(2))';
         
         for j = 1 : size(FM.V{i},1),
            xx = ones(501,1)*FM.V{i}(j,:);
            if antediffers(1,k)
               xx(:,antepos) = dom;	            
            end
            dof = fgrade(FM,xx,i);
            
            cons = ones(501,size(FM.th{i},2));
            aindx = 1;
            cindx = 1;
            for indx = 1: length(antediffers),
               if consdiffers(indx)
                  if antediffers(indx)
                     cons(:,cindx) = cons(:,cindx)*FM.V{i}(j,aindx); 
                     aindx = aindx + 1;
                  else
                     cons(:,cindx) = cons(:,cindx)*mean([FM.zmin{i}(indx) FM.zmax{i}(indx)]); 
                  end   
                  cindx = cindx + 1;
					else                  
                  if antediffers(indx)
                     aindx = aindx + 1;
						end
               end
            end   
            if consdiffers(1,k)
               cons(:,conspos) = dom;
            end
            
            [Ym(:,j),Yl,Ylm] = sugval(FM.th{i},cons,dof);
            
            Ymm(:,j) = Ym(:,j);
            Ym(find(max(dof,[],2) < 0.8),j) = NaN;		% mask with NaN's for plots
            
         end;
         switch nvar,
         case 1, subplot(1,1,1);
         case {2,3}, subplot(nvar,1,k);
         otherwise, subplot(ceil(nvar/2),2,k);
         end;      
         if ~isempty(opt),
            plot(dom,Ym,opt);
         else   
            plot(dom,Ymm,':k'); hold on
            plot(dom,Ym,'linewidth',1.4); hold off
         end;
         set(gca,'FontSize',FontSize)
         xlabel(vars{i}{k},'FontSize',LabSize);
         ylabel(FM.OutputName{i},'FontSize',LabSize);
      end;
   end;   
end;

