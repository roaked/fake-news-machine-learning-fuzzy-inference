function fm2tex(FM,filename)
% FMGET write the information contained in FM into a LaTEX file
%
%  fm2tex(FM,filename)
%
%       FM  ... structure containing fuzzy model parameters
%       filename ... name of the LaTEX file to be created
%
%  See also FMGET, FMSTRUCT

% (c) Robert Babuska, Stanimir Mollov 1997-1999

printstd = 0;		% print standard deviations of FM.th

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% update old version model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FM = fmupdate(FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract some parameters from FM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NO    = FM.no;
dat   = FM.date;
ny    = FM.Ny;
nu    = FM.Nu;
c     = FM.c;

%only cons structureis included !!!
%NI = sum([ny'; zeros(1,NO)]) + sum([nu'; zeros(1,NO)]);
NI = zeros(1,size(ny{2},1));
for j = 1:size(ny{2},1)
   for k = 1:size(ny{2},2)
         NI(1,j) = NI(1,j) + size(ny{2}{j,k},2);   
   end
end
for j = 1:size(nu{2},1)
   for k = 1:size(nu{2},2)
         NI(1,j) = NI(1,j) + size(nu{2}{j,k},2);   
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% names of variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
avars =	 antename(FM);
cvars = consname(FM);

if ~isempty(FM.OutputName);
   outvar = FM.OutputName;
else
   if NO == 1,
      outvar{1} = 'y';
   else
      for j = 1 : NO, outvar{j} = ['y_' num2str(j)]; end;
   end;
end;



fid = fopen(filename,'w');
if fid == -1, error(['Error opening file ' filename]); end;

dat = [num2str(dat(3)) '-' num2str(dat(2)) '-' num2str(dat(1))];

%%%%%%%%%% generate LaTEX header %%%%%%%%%%%%%%%%%%%%

trow = ['\documentclass{article}'];
fprintf(fid,'%s\n\n',deblank(trow));
trow = ['\textheight 250mm'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\textwidth 170mm'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\hoffset -40mm'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\voffset -25mm'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\parindent 0mm'];
fprintf(fid,'%s\n\n',deblank(trow));

trow = ['\def\If{\mbox{\bf~If~}}                   % "If" in the rules'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\def\Then{\mbox{\bf~then~}}               % "then" in the rules'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\def\Is{\mbox{~is~}}                      % "is" in the rules'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\def\And{\mbox{\bf~and~}}                 % "and" in the rules'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\def\Or{\mbox{\bf~or~}}                   % "or" in the rules'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\def\Not{\mbox{\bf~not~}}                 % "not" in the rules'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\newcommand{\lab}[1]{\mbox{\sc #1}}       % linguistic label'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['\newcommand{\var}[1]{\mbox{\em #1}}       % linguistic variable'];
fprintf(fid,'%s\n\n',deblank(trow));
trow = ['\begin{document}'];
fprintf(fid,'%s\n\n',deblank(trow));

%%%%%%%%%% generate some description text %%%%%%%%%%%%%%%%%%%%

trow = ['This model was generated on ' dat ' from ' num2str(FM.N) ' data samples.'];
fprintf(fid,'%s\n',deblank(trow));
if FM.ni == 1, instr = ' input'; else instr = ' inputs'; end;
if NO == 1, outstr = ' output'; else outstr = ' outputs'; end;
trow = ['It has ' int2str(FM.ni) instr ' and ' int2str(NO) outstr '. ' ...
        'The sampling period is ' num2str(FM.Ts) '~s.'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['The termination tolerance of the clustering algorithm was ' num2str(FM.tol) ','];
fprintf(fid,'%s\n',deblank(trow));
trow = ['and the random initial partition was generated with seed equal to ' int2str(FM.seed) '.'];
fprintf(fid,'%s\n',deblank(trow));
trow = ['The output-specific parameters are given in the following table.'];
fprintf(fid,'%s\n',deblank(trow));
fprintf(fid,'\n\n');

%%%%%%%%%% generate table with params per output %%%%%%%%%%%%%%%%%%%%
ptab = ['output & antecedent & $c$ & $m$ ' ...
	'& $n_y$ & $n_u$ \\ \hline'];
for k = 1 : NO,
   nystr = {'', ''};
   nustr = {'', ''};
   for s = 1:2
      for j = 1:size(ny{s},2)
         nystr{1,s} = [nystr{1,s} '[ ']; 
         for i = 1:size(ny{s}{k,j},2),
            if i == size(ny{s}{k,j},2)
               nystr{1,s} = [nystr{1,s} sprintf('%d\\, ', ny{s}{k,j}(1,i))];
            else   
               nystr{1,s} = [nystr{1,s} sprintf('%d,\\, ', ny{s}{k,j}(1,i))];
            end   
         end   
         if j == size(ny{s},2),
            nystr{1,s} = [nystr{1,s} ']']; 
         else
            nystr{1,s} = [nystr{1,s} '] ']; 
         end   
      end
      for j = 1:size(nu{s},2)
         nustr{1,s} = [nustr{1,s} '[ ']; 
         for i = 1:size(nu{s}{k,j},2),
            if i == size(nu{s}{k,j},2)
               nustr{1,s} = [nustr{1,s} sprintf('%d\\, ', nu{s}{k,j}(1,i))];
            else   
               nustr{1,s} = [nustr{1,s} sprintf('%d,\\, ', nu{s}{k,j}(1,i))];
            end   
         end
         if j == size(nu{s},2),
            nustr{1,s} = [nustr{1,s} ']']; 
         else
            nustr{1,s} = [nustr{1,s} '] ']; 
         end   
      end
   end 
  prow = [num2str(k) ' & ' num2str(FM.ante(k)) ' & ' num2str(c(k)) ' & ' ...
          num2str(FM.m(k)) ' & \{\{ ' nystr{1,1} ' \}, & \{\{ ' nustr{1,1} ' \}, \\'];
  %prow = [prow ' \\ \hline'];
    
  ptab = str2mat(ptab,prow);
  prow = [' &  &  &  & \{ ' nystr{1,2} ' \}\} & \{ ' nustr{1,2} ' \}\} \\ \hline'];
  ptab = str2mat(ptab,prow);

end;

ncol = ['{|c|' setstr(abs('c')*ones(1,5)) '|}'];
ptab = str2mat(['\begin{tabular}' ncol '\hline'],ptab,'\end{tabular}');
ptab = str2mat( '\begin{table}[htbp]','\centering',...
		'\caption{Model parameters.}',ptab,...
                '\label{tab:params}','\end{table}');

for i = 1 : size(ptab,1),
  fprintf(fid,'%s\n',deblank(ptab(i,:)));
end;
fprintf(fid,'\n\n');

trow = ['In the following, the output-specific information is shown for each output.'];
fprintf(fid,'%s\n',deblank(trow));
fprintf(fid,'\n');


%%%%%%%%%% now loop for all outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for kk = 1 : NO, k = kk;
   
   fprintf(fid,'%s\n\n\n',['Output' num2str(k) ':']);
   
   p     = FM.th{kk};
   V     = FM.V{kk};
   
   K = size(p,1);
   lA = size(FM.rls{k},2);
   lC = size(FM.th{k},2);
   
   rules = [];
   for j = 1 : K,
      r = [num2str(j) '. & \If '];
      for i = 1 : lA,
         if lA == 1,
            r = [r deblank(avars{kk}{i}) ' \Is A_{' num2str(j) '}'];
         else
            r = [r deblank(avars{kk}{i}) ' \Is A_{' num2str(j) num2str(i) '}'];
         end;   
         if i == lA, 
            r = [r ' \Then \\'];
         else 
            r = [r '\And '];
         end
      end;
      rules = str2mat(rules,r);
      
 %%%     %if all(ny(k,:) == 0),
      %   cons = ['   & \; ' outvar{kk} ' = '];
      %else
         cons = ['   & \; ' outvar{kk} '(k) = '];
      %end;   
      
      for i = 1 : lC-1,
         cf = sprintf('%1.2e',p(j,i));
         cfexp = cf(length(cf)-3:length(cf)); 
         if cfexp(1) == '+', cfexp(1) = []; end;
         cfind = ~(cfexp == '0');
         if sum(cfind) == 0, cfind(length(cfind)) = 1; end;
         cf = cf(1:length(cf)-5);
         %    if sum(cfind) > 0,
         cf = [cf '\cdot 10^{' cfexp(cfind) '}'];
         %    end;
         if cf(1) ~= '-' & i ~= 1, cf = ['+' cf]; end;
         cons = [cons cf deblank(cvars{kk}{i})];
      end;
      cf = sprintf('%1.2e',p(j,lC));
      cfexp = cf(length(cf)-3:length(cf)); 
      if cfexp(1) == '+', cfexp(1) = []; end;
      cfind = ~(cfexp == '0');
      if sum(cfind) == 0, cfind(length(cfind)) = 1; end;
      cf = cf(1:length(cf)-5);
      %  if sum(cfind) > 0,
      cf = [cf '\cdot 10^{' cfexp(cfind) '}'];
      %  end;
      if cf(1) ~= '-'; cf = ['+' cf]; end;
      cons = [cons cf ' \\ \\'];
      rules = str2mat(rules,cons);
   end;
   
   rules(1,:) = [];
   rules = str2mat('Rules:','$$','\begin{array}{l@{\hspace*{-0em}}l}', rules, '\end{array}','$$');
   
   %%%%%%%%%% generate cluster centers table %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   prow = 'rule & ';
   for i = 1 : lA,
      if i == lA ,
         cf = ['$' deblank(avars{kk}{i}) '$'];
         prow = [prow cf ' \\ \hline'];
      else 
         cf = ['$' deblank(avars{kk}{i}) '$'];
         prow = [prow cf ' & '];
      end;
   end;
   ptab = prow;
   for j = 1 : K,
      prow = ['   ' num2str(j) ' & '];
      for i = 1 : lA,
         cf = sprintf('%1.2e',V(j,i));
         cfexp = cf(length(cf)-3:length(cf)); 
         if cfexp(1) == '+', cfexp(1) = []; end;
         cfind = ~(cfexp == '0');
         cf = cf(1:length(cf)-5);
         if sum(cfind) == 0, cfind(length(cfind)) = 1; end;
         %    if sum(cfind) > 0,
         cf = [cf '\cdot 10^{' cfexp(cfind) '}'];
         %    end;
         if cf(1) ~= '-' & i ~= 1, cf = [' ' cf]; end;
         cf = ['$' cf '$'];
         if i == lA,
            prow =[prow cf ' \\'];
         else 
            prow = [prow cf ' & '];
         end;
      end;
      ptab = str2mat(ptab,prow);
   end;
   
   ncol = ['{|c|' setstr(abs('r')*ones(1,lA)) '|}'];
   
   ptab = str2mat(['\begin{tabular}' ncol '\hline'],ptab,'\hline','\end{tabular}');
   label = ['\label{tab:centers',num2str(kk),'}'];
   ptab = str2mat( '\begin{table}[htbp]','\centering',...
      '\caption{Cluster centers.}',ptab,...
      label,'\end{table}');
   ctab = ptab;

   %%%%%%%%%% generate consequent table %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   prow = 'rule & ';
   
   for i = 1 : lC,
         if i <= NI(1,kk),
            cf = ['$' deblank(cvars{kk}{i}) '$'];
            prow = [prow cf ' & '];
         else
            prow = [prow ' offset \\ \hline'];
	      end;
   end;
   
   
   ptab = prow;
   for j = 1 : K,
      prow = ['   ' num2str(j) ' & '];
      for i = 1 : lC,
         cf = sprintf('%1.2e',p(j,i));
         cfexp = cf(length(cf)-3:length(cf)); 
         if cfexp(1) == '+', cfexp(1) = []; end;
         cfind = ~(cfexp == '0');
         if sum(cfind) == 0, cfind(length(cfind)) = 1; end;
         cf = cf(1:length(cf)-5);
         %    if sum(cfind) > 0,
         cf = [cf '\cdot 10^{' cfexp(cfind) '}'];
         %    end;
         if cf(1) ~= '-' & i ~= 1, cf = [' ' cf]; end;
         cf = ['$' cf '$'];
         if i == lC,
            prow =[prow cf ' \\'];
         else 
            prow = [prow cf ' & '];
         end;
      end;
      ptab = str2mat(ptab,prow);
   end;
   
   ncol = ['{|c|' setstr(abs('r')*ones(1,lC)) '|}'];
   
   ptab = str2mat(['\begin{tabular}' ncol '\hline'],ptab,'\hline','\end{tabular}');
   label = ['\label{tab:cons',num2str(kk),'}'];
   ptab = str2mat( '\begin{table}[htbp]','\centering',...
      '\caption{Consequent parameters.}',ptab,...
      label,'\end{table}');

   %%%%%%%%%% write string variables into a file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   for i = 1 : size(rules,1),
      fprintf(fid,'%s\n',deblank(rules(i,:)));
   end;
   
   fprintf(fid,'\n\n');
   for i = 1 : size(ptab,1),
      fprintf(fid,'%s\n',deblank(ptab(i,:)));
   end;
   
   fprintf(fid,'\n\n');
   for i = 1 : size(ctab,1),
      fprintf(fid,'%s\n',deblank(ctab(i,:)));
   end;
   
end;

trow = ['\end{document}'];
fprintf(fid,'\n%s\n',deblank(trow));

fclose(fid);
fprintf('Results written in LaTEX file "%s"\n',filename)

