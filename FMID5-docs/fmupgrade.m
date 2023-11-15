function FM = fmupgr(FM)
% FMUPGR upgrade the fuzzy model structure between versions.
%
%     FMNEW = FMUPGR(FMOLD)
%
%       FMOLD ... old fuzzy model structure
%       FMNEW ... new fuzzy model structure
%
%  See also FMCLUST, FMEST, FMSIM, FMDOF, FMSTRUCT.

% (c) Robert Babuska, Stanimir Mollov 1997-99

rmlist = {};
posinlist = 1;
if isfield(FM,'ny'), FM.Ny = FM.ny; rmlist{posinlist} ='ny';
   posinlist = posinlist + 1; end
if isfield(FM,'nu'), FM.Nu = FM.nu; rmlist{posinlist} ='nu'; 
	posinlist = posinlist + 1; end
if isfield(FM,'nd'), FM.Nd = FM.nd; rmlist{posinlist} ='nd';
	posinlist = posinlist + 1; end
if isfield(FM,'Alist'), FM.Nd = FM.nd; rmlist{posinlist} ='Alist';
	posinlist = posinlist + 1; end
if isfield(FM,'Clist'), FM.Nd = FM.nd; rmlist{posinlist} ='Clist';
	posinlist = posinlist + 1; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loop through the outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isfield(FM,'P')
   
   for k = 1 : FM.no,                 % for all outputs
      NI = size(FM.th{k},2)-1;
      M = FM.P{k}(1:NI,1:NI,:);
      NI1 = 1/NI;
      for j = 1 : size(FM.P{k},3),
         M(:,:,j) = det(FM.P{k}(1:NI,1:NI,j)).^NI1*inv(FM.P{k}(1:NI,1:NI,j));
      end;
      FM.M{k} = M;
   end; 
   rmlist{posinlist} ='P';
end   


%FM = rmfield(FM,{'ny','nu','nd','P','Alist','Clist'});
FM = rmfield(FM,rmlist);

FM = fmupdate(FM);