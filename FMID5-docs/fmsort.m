function [FM,Part] = fmsort(FM,Part,ind)
% FMSORT Sort rules in a fuzzy model.
%
%     [FMs,Parts] = FMSORT(FM,ind)
%     [FMs,Parts] = FMSORT(FM,Part,ind)
%
%     FM         fuzzy model
%     Part       partition structure
%     ind        index vector for sorting
%                (cell array of vectors for MIMO models)
%
%  See also FMCLUST, FMSIM, FMSTRUCT, FMEST, FMODEL.

% (c) Robert Babuska, 1997-99

if nargin < 3, ind = Part; end;
if ~iscell(ind), ind = {ind}; end;
   
names = fieldnames(FM);
for i = 1 : length(names),
   field = getfield(FM,names{i});
   if iscell(field) & (length(field) == FM.no),
      for j = 1 : FM.no,
         if ~isempty(field{j}),
            if all(names{i}=='M'),
               field{j} = field{j}(:,:,ind{j});
            else              
               if size(field{j},1) == length(ind{j}),
                  field{j} = field{j}(ind{j},:);
               end;   
            end;   
         end;   
      end;   
      FM = setfield(FM,names{i},field);
   end;   
end;

if nargin > 2, 
   for j = 1 : FM.no,
      Part.Mu{j} = Part.Mu{j}(:,ind{j});
      Part.V{j}  = Part.V{j}(ind{j},:);
      Part.F{j}  = Part.F{j}(:,:,ind{j});
   end;
end;
