function FM = FMupdate(FM)
% FMupdate update a fuzzy model.
% In the current version, different dynamic structures can 
% be used in the antecent and consequent. Lagged 
% for example y(k+1) = f(y(k),y(k-3),...,u(k-1),u(k-4),...).
%
% [FMnew] = FMupdate(FMold)
%
%       FMold ... fuzzy model structure of version 2.1
%
%       FMnew ... fuzzy model structure of version 3.0
%
%  See also FMCLUST, FMSIM, FMSTRUCT, GKFAST, VAF.

% (c) Robert Babuska, 1997-1999

if isfield(FM,'Ny') & isfield(FM,'Nu') & ...
      iscell(FM.Ny) & iscell(FM.Nu) & ...
   	iscell(FM.Ny{1}) & iscell(FM.Nu{1}) & ...
      size(FM.Ny,1) == 2 & size(FM.Nu,1) == 2 & ... 
      iscell(FM.Ny{2}) & iscell(FM.Nu{2}), 
      return;		%ver.3.0 structure
else  %old ver structure
      
%   fprintf('Update an old-type fuzzy model to ver. 3.0\n');
      
   if ~isfield(FM,'Ny')
      FM.Ny = zeros(FM.no,FM.no); 
   end   
   if ~isfield(FM,'Nu')
      FM.Nu = ones(FM.no,FM.ni);
   end   
   if ~isfield(FM,'Nd')
      FM.Nd = zeros(FM.no,FM.ni);
   end   
   
   
   
	verstr = 3;
   if ~iscell(FM.Ny) 
%      for s = 1:size(FM.Ny,1),
%         for ss = 1:size(FM.Ny,2),
%            FM.Ny = {[1:FM.Ny(s,ss)]}; 
%         end; 
%      end   
		FM.Ny = {FM.Ny};
		verstr = 2;
   end   
   if size(FM.Ny,1) == 1 & (verstr == 2 | iscell(FM.Ny{1})),
      FM.Ny{2,1} = FM.Ny{1,1}; 
	end;
   if ~iscell(FM.Ny{1})
      ny = FM.Ny;
      FM = rmfield(FM,'Ny');
      if verstr == 2 % old structure
         for postn = 1:2
            for ss = 1:size(ny{postn},1)
               for s = 1:size(ny{postn},2) 
                  FM.Ny{postn,1}{ss,s} = [1:1:ny{postn}(ss,s)];
               end
            end
         end
%      elseif iscell(ny)
%         for postn = 1:2
%            for ss = 1:size(ny,1)
%%%               for s = 1:size(ny,2) 
%			         FM.Ny{postn,1}{ss,s} = {ny{ss,s}};
%               end
%            end
%         end
      else   
         for postn = 1:2
            for ss = 1:size(ny,1)
               for s = 1:size(ny,2) 
			         FM.Ny{postn,1}{ss,s} = ny{ss,s};
               end
            end
         end
      end	
   end
   clear ny
   if ~iscell(FM.Nu) 
      %      for s = 1:size(FM.Nu,1),
      %         for ss = 1:size(FM.Nu,2),
      %            FM.Nu = {[1:FM.Nu(s,ss)]}; 
      %         end; 
      %     end   
      %      if ~iscell(FM.Nu) 
      FM.Nu = {FM.Nu}; 
      %		 end; 
      verstr = 2;
   end; 
   
   if size(FM.Nu,1) == 1 & ( verstr == 2 | iscell(FM.Nu{1}) ), FM.Nu{2,1} = FM.Nu{1}; end;
   
   if ~iscell(FM.Nd) FM.Nd = {FM.Nd}; end; 
   
   if size(FM.Nd,1) == 1 FM.Nd{2,1} = FM.Nd{1}; end;
   
   if ~iscell(FM.Nu{1})
      nu = FM.Nu;
      nd = FM.Nd;
      FM = rmfield(FM,'Nu');
      FM = rmfield(FM,'Nd');
      if verstr == 2 % old structure
         for postn = 1:2 
            for ss = 1:size(nu{postn},1)
               for s = 1:size(nu{postn},2) 
                  FM.Nu{postn,1}{ss,s} = [nd{postn}(ss,s):1:nu{postn}(ss,s)+nd{postn}(ss,s)-1];
               end
            end
         end
%      elseif iscell(nu)
%         for postn = 1:2
%            for ss = 1:size(nu,1)
%               for s = 1:size(nu,2) 
%                  temp = nu{ss,s}
%			         FM.Nu{postn,1}{ss,s} = temp;
%               end
%            end
%         end
      else
         for postn = 1:2
            for ss = 1:size(nu,1)
               for s = 1:size(nu,2) 
                  FM.Nu{postn,1}{ss,s} = nu{ss,s};
               end
            end
         end
      end	
      
   end
   clear nu nd
end