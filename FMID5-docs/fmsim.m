function [Ym,q,DOF,Yl,Ylm] = fmsim(Ue,Ye,FM,Ymin,Ymax,show,H)
% FMSIM simulate a MIMO fuzzy model.
%
% [Ym,q,DOF,Yl,Ylm] = FMSIM(U,Y,FM,Ymin,Ymax,show,H)
%
%       U,Y  ... input and output data matrices, respectively
%                (output data is needed for initialization
%                and for comparison)
%       FM   ... structure containing fuzzy model parameters
%       Ymin ... lower bound constraint on Y (optional)
%       Ymax ... upper bound constraint on Y (optional)
%       show ... set to 1 for on-line graphics, 2 for final plot only,
%		 and 0 for no graphics (optional, default 1)
%       H    ... prediction horizon (optional, by default simulation)
%
%       Ym  ... simulated output of the model
%       q   ... performance index of the model computed as VAF
%               (variance accounted for)
%       DOF ... degrees of fulfillment of the rules (all outputs
%               appended)
%       Yl .... output of the individual rule's consequents
%       Ylm ... output of the individual rule's consequents
%               (data with DOF < 0.5 are masked by NaN)
%
%  See also FMCLUST, FMSTRUCT, GKFAST, VAF.

% (c) Robert Babuska, Stanimir Mollov 1997-1999

%# scalar i j kk k nset

if ~iscell(Ue), Ue = {Ue}; end; if ~iscell(Ye), Ye = {Ye}; end;

%Update an old-type model 
FM = fmupdate(FM);

for nset = 1 : length(Ue),
   
   U = Ue{nset};
   Y = Ye{nset};
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract data from the FM structure (much faster!)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ninps = size(U,2);
NO = FM.no;

ny = FM.Ny;
nu = FM.Nu;

atype = FM.ante;
rls = FM.rls; 
mfs = FM.mfs;
p = FM.th;

for k = 1 : NO,
%  # fastindex
  c(k) = size(p{k},1);
%  # fastindex
  V1{k} = ones(c(k),1);
end;

if any(atype == 1), 
   V = FM.V;
   M = FM.M; 
   m = FM.m; 
end;

%NI = sum(ny,2) + sum(nu,2); % Robert

NI = max(size([ny{1}{:}],2),size([ny{2}{:}],2)) + max(size([nu{1}{:}],2),size([nu{2}{:}],2)); %Stanimir

if isempty(Y), Y = zeros(size(U,1),NO); end;
if nargin < 4, Ymin = -inf*ones(1,NO); elseif isempty(Ymin), Ymin = -inf*ones(1,NO); end;
if nargin < 5, Ymax =  inf*ones(1,NO); elseif isempty(Ymax), Ymax =  inf*ones(1,NO); end;
if nargin < 6, show = 1; elseif isempty(show), show =  1; end;
if nargin < 7, H = 0; elseif isempty(H), H =  0; end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intialize graphics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if show == 1,
   clf;
  if ~((max(size([ny{1}{:}],2))|max(size([ny{2}{:}],2))) == 0 | NI == 1 | H ~= 0), 
     Ts = FM.Ts;
    for i = 1:NO,
      subplot(NO,1,i); 
      plot(Ts*(1:length(Y(:,i))),Y(:,i));
      set(gca,'xlim',Ts*[1 size(Y,1)]);
      xlabel('Time [s]'); ylabel(FM.OutputName{i}); drawnow; hold on; 
    end;
  end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% static model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if max(max(ny)) == 0,	%Robert

if (max(size([ny{1}{:}],2))+max(size([ny{2}{:}],2))) == 0,		%Stanimir
   for kk = 1 : NO,
      
      %antecedent regressor
%      # fastindex
      [trash,ante,trash]=regres([ones(size(U,1),1) U],ny{1}(k,:),nu{1}(k,:)); 
      x1 = ones(size(ante,1),1);
      %consequent regressor
%      # fastindex
      [trash,consq,trash]=regres([ones(size(U,1),1) U],ny{2}(k,:),nu{2}(k,:)); 
      x2 = ones(size(consq,1),1);
      if isempty(x2), x2 = x1;, end
      cons = [consq x2]; 
      
      if ~isempty(FM.th{kk}),
%	      # fastindex
         if c(kk) > 1,
            if atype(kk) == 1,		% product-space MFs
%               # fastindex
               for j = 1 : c(kk),                        % for all clusters
%                  # fastindex
                  xv = ante - x1*V{kk}(j,:);
%                  # fastindex
                  d(:,j) = sum(xv*M{kk}(:,:,j).*xv,2);
               end;
%               # fastindex
               d = (d+1e-100).^(-1/(m(kk)-1));		% clustering dist
%               # fastindex
               DOF{kk} = (d ./ (sum(d,2)*ones(1,c(kk))));
            elseif atype(kk) == 2,	% projected MFs
%               # fastindex
               DOF{kk} = dofprod(FM.rls{kk},FM.mfs{kk},ante);
            end;
%            # fastindex
            [Ym(:,kk),Yl{kk},Ylm{kk}] = sugval(FM.th{kk},cons,DOF{kk});
         else
%            # fastindex
            Ym(:,kk) = cons*FM.th{kk}';
%            # fastindex
            DOF{kk} = ones(size(Ym(:,kk)));
%            # fastindex
            Yl{kk} = Ym(:,kk);
%            # fastindex
            Ylm{kk} = Yl{kk};
         end;
      else
%         # fastindex
         Ym(:,kk) = Y(end-size(ante,1)+1:end,kk);
%         # fastindex
         DOF{kk} = NaN*Ym(:,kk);
%         # fastindex
         Yl{kk} = DOF{kk};
%         # fastindex
         Ylm{kk} = Yl{kk};         
      end;
%      # fastindex
      Y = Y(end-size(ante,1)+1:end,:);
   end;
elseif H > 0,	% dynamic model, H-step-ahead simulation

N = size(Y,1);
Ym = Y;

for kk = 1 : NO,                 % for all outputs
   if Ninps == 0, z = Y; else z = [Y U]; end;
   
   %antecedent regressor%
%   # fastindex
   [yr,ante,y1]=regres([Y(:,kk) z],ny{1}(kk,:),nu{1}(kk,:)); 
   x1 = ones(size(ante,1),1);
   
   %consequent regressor
%   # fastindex
   [yr,consq,y1]=regres([Y(:,kk) z],ny{2}(kk,:),nu{2}(kk,:)); 
   x2 = ones(size(consq,1),1);
   cons = [consq x2];
   
   if ~isempty(FM.th{kk}),
%      # fastindex
      if c(kk) > 1,
%         # fastindex
         if atype(kk) == 1,		% product-space MFs
            d = [];
%            # fastindex
            for j = 1 : c(kk),                        % for all clusters
%               # fastindex
               xv = ante - x1*V{kk}(j,:);
%               # fastindex
               d(:,j) = sum(xv*M{kk}(:,:,j).*xv,2);
            end;
%            # fastindex
            d = (d+1e-100).^(-1/(m(kk)-1));		% clustering dist
%            # fastindex
            dofe = (d ./ (sum(d,2)*ones(1,c(kk))));
            %  dofe = 1./(1+d);				% similarity
         elseif atype(kk) == 2,	% projected MFs
%            # fastindex
            dofe = dofprod(rls{kk},mfs{kk},ante);
         end;
         s1 = size(ante,1);
%         # fastindex
         [Ym(N-s1+1:N,kk),Yl{kk}(N-s1+1:N,:),Ylm{kk}(N-s1+1:N,:)] = sugval(p{kk},cons,dofe);
%         # fastindex
         DOF{kk} = dofe;
      else
         s1 = size(ante,1);
%         # fastindex
         Ym(N-s1+1:N,kk) = cons*p{kk}';
%         # fastindex
         DOF{kk} = 1;
      end;
   else
%      # fastindex
      Ym(:,kk) = Y(:,kk);
%      # fastindex
      DOF{kk} = NaN*Ym(:,kk);
%      # fastindex
      Yl{kk} = DOF{kk};
%      # fastindex
      Ylm{kk} = Yl{kk};         
   end;
end;

else	% dynamic model, simulation from input
   if Ninps > 0,
           
      k0 = fmorder(ny,nu); 
      
      if size(U,1) < k0, error(['Supply at least ' int2str(k0) ' data samples.']); end;
   else
      k0 = max(max(max([ny{1}{:}]),max([ny{2}{:}]))+1,2); 
   end;
   if Ninps > 0, kmax = size(U,1); else kmax = size(Y,1); end;
   
   Ym = Y; 
   for k = k0 : kmax,                           % discrete time
       for kk = 1 : NO,                          % for all ouputs
           if ~isempty(FM.th{kk}),
               ante = [];
               cons = [];
               for j = 1 : NO,
                   for s = 1:size(ny{1}{kk,j},2)
                       pos = ny{1}{kk,j}(s);
                       if isempty(pos), pos = 0; end
                       ante = [ante Ym(k-pos,j)']; 
                   end
                   for s = 1:size(ny{2}{kk,j},2)
                       pos = ny{2}{kk,j}(s);	       
                       if isempty(pos), pos = 0; end
                       cons = [cons Ym(k-pos,j)']; 
                   end
               end;
               for j = 1 : Ninps,
                   for s = 1:size(nu{1}{kk,j},2)
                       ante = [ante U(k-nu{1}{kk,j}(s),j)']; 
                   end
                   for s = 1:size(nu{2}{kk,j},2)
                       cons = [cons U(k-nu{2}{kk,j}(s),j)']; 
                   end
               end;
               cons = [cons 1];
%              # fastindex
               if c(kk) > 1,
%              # fastindex
                   if atype(kk) == 1,		% product-space MFs
                       %        ante = max(min(ante,FM.zmax{kk}(1:NI)),FM.zmin{kk}(1:NI));
%                      # fastindex
                       xv = V1{kk}*ante - V{kk};
                       d = [];
%                      # fastindex
                       for j = 1 : c(kk),
%                          # fastindex
                           d(j) = xv(j,:)*M{kk}(:,:,j)*xv(j,:)';
                       end;
%                      # fastindex
                       d = (d+1e-100).^(-1/(m(kk)-1));		% clustering distance
%                      # fastindex
                       dofe = (d ./ (sum(d,2)*ones(1,c(kk))));
                       %    dofe = 1./(1+d);				% similarity
%                      # fastindex
                   elseif atype(kk) == 2,	% projected MFs
%                      # fastindex
                       dofe = dofprod(rls{kk},mfs{kk},ante);
                   end;
%                  # fastindex
                   yl = cons*p{kk}';	         % local models
                   ylm = yl;
%                  # fastindex
                   ylm(find(dofe < max(dofe))) = NaN;		% mask with NaN's for plots
                   ds = sum(dofe);
                   if ds >0,
%                      # fastindex
                       Ym(k,kk) = yl*(dofe/ds)';
                   else   
%                      # fastindex
                       Ym(k,kk) = Ym(k-1,kk);
                   end;   
%                  # fastindex
                   Yl{kk}(k,:) = yl;
%                  # fastindex
                   Ylm{kk}(k,:) = ylm;
%                  # fastindex
                   DOF{kk}(k-1,:) = dofe;
               else
%                  # fastindex
                   Ym(k,kk) = cons*p{kk}';
%                  # fastindex
                   DOF{kk}(k-1,:) = 1;
%                  # fastindex
                   Yl{kk}(k,:) = Ym(k,kk);
%                  # fastindex
                   Ylm{kk}(k,:) = Ym(k,kk);
               end;
%              # fastindex
               if Ym(k,kk) < Ymin(kk), 
%              # fastindex
                   Ym(k,kk) = Ymin(kk); 
               end;
%              # fastindex
               if Ym(k,kk) > Ymax(kk), 
%                  # fastindex
                   Ym(k,kk) = Ymax(kk); 
               end;
           else
%              # fastindex
               DOF{kk}(k-1,:) = NaN;
%              # fastindex
               Yl{kk}(k,:) = NaN;
%              # fastindex
               Ylm{kk}(k,:) = NaN;
           end;  
           
           if show == 1,
               subplot(NO,1,kk);
%              # fastindex
               plot(Ts*[k-1 k],[Ym(k-1,kk) Ym(k,kk)],'m-','EraseMode','none'); drawnow;
           end;
       end;
   end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% final plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%show = 0;
if show,
   clf; hold off;
   for i = 1:NO,
      subplot(NO,1,i); 
      if  (max(size([ny{1}{:}],2))& max(size([ny{2}{:}],2))) == 0 &...
            (max(size([nu{1}{:}],2))&max(size([nu{2}{:}],2))) == 1 & NI == 1, % static SISO model
%         # fastindex
         plot(U,Y(:,i),'b-',U,Ym(:,i),'m-.');
         xlabel('Input'); ylabel(FM.OutputName{i}); drawnow;
      else	% dynamic model
         Ts = FM.Ts;
%         # fastindex
         plot(Ts*(1:length(Y(:,i))),Y(:,i),'b-',Ts*(1:length(Ym(:,i))),Ym(:,i),'m-.');
         xlabel('Time [s]'); ylabel(FM.OutputName{i}); drawnow;
      end;
   end;
end;

if size(Y,1)==size(Ym,1) & size(Ym,1)>1, q = vaf(Y,Ym); end;

end;