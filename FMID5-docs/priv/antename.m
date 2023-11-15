function ante = antename(FM)
% ANTENAME    extract names of antecedent variables from FM.
%     ANTE = ANTENAME(FM) is a cell array of cell arrays
%     containing the names of all antecedent variables
%     in the fuzzy model FM.
%
%  See also FM2TEX, PLOTMFS, FMSTRUCT

% (c) Robert Babuska, Stanimir Mollov 1997-99

ny = FM.Ny;
nu = FM.Nu;
%nd = FM.Nd;
NI = FM.ni;
NO = FM.no;
vars{1} = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define strings for input and output names
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(FM.InputName);
   inpvar = FM.InputName;
else
   for j = 1 : NI, inpvar{j} = ['u_' num2str(j)]; end;
end;
if ~isempty(FM.OutputName);
   outvar = FM.OutputName;
else
   for j = 1 : NO, outvar{j} = ['y_' num2str(j)]; end;
end;

%%%%%%%%%% loop for all outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1 : NO,
   ii = 1;
   for j = 1 : NO,
      if iscell(ny),
         for i = 1 : size(ny{1}{k,j},2),
            %for i = 1 : ny(k,j),
            vars{ii} = [outvar{j} '(k-' num2str(ny{1}{k,j}(1,i)) ')'];
            %         if i == 1, vars{ii} = [outvar{j} '(k)'];
            %         else vars{ii} = [outvar{j} '(k-' num2str(i-1) ')']; end;
            ii = ii + 1;
         end;
      else %1st order AR model
         if ny
         for i = 1 : size(ny,2),
            vars{ii} = [outvar{i}];
            ii = ii + 1;
         end
         end
      end
   end;

   for j = 1 : NI,
      %      for i = nd(k,j) : nu(k,j)+nd(k,j)-1,
      if iscell(nu),
         for i = 1 : size(nu{1}{k,j},2),

            %      if all(ny(k,:) == 0),
            %         vars{ii} = inpvar{j};
            %      else
            %         if i == 0, vars{ii} = [inpvar{j} '(k+1)'];
            %         elseif i == 1, vars{ii} = [inpvar{j} '(k)'];
            if ~nu{1}{k,j}(1,i)
               %vars{ii} = [inpvar{j} '(k)'];
               vars{ii} = inpvar{j};
            else
               vars{ii} = [inpvar{j} '(k-' num2str(nu{1}{k,j}(1,i)) ')'];
            end
            %               else vars{ii} = [inpvar{j} '(k-' num2str(i-1) ')']; end;
            %end;
            ii = ii + 1;
         end;
      else %static model
         if nu
         for i = 1 : size(nu,2),
               vars{ii} = [inpvar{i}];
            ii = ii + 1;
         end
         end
      end
   end;
   ante{k} = vars;
end;
