function varunion = getvarunion(FM,output)
% GETVARUNION give the union of the var names in
% the rule's antecedents and consequents for a given output.
%
% varunion = GETVARUNION(FM,regrestype,output)
%    Input:
%       FM 			 ..... fuzzy model
%		  output		 ..... output number
%
%    Output:
%		  varunion   ..... united pattern 
%
% (c) Stanimir Mollov, Robert Babuska, 1994-2000
%====================================================

avars = antename(FM);
cvars = consname(FM);

unitedoutputs = [];
unitedinputs = [];
offset = 0;

for united = 1:FM.no,
   unitedoutputs{output,united} = union(FM.Ny{1}{output,united},...
      FM.Ny{2}{output,united});
   for ind = 1:length(unitedoutputs{output,united}),
      varunion{ind+offset} = [FM.OutputName{united},'(k-',...
            num2str(unitedoutputs{output,united}(ind)),')'];
   end   
   offset = offset + length(unitedoutputs{output,united});
end

for united = 1:FM.ni,
   unitedinputs{output,united} = union(FM.Nu{1}{output,united},...
      FM.Nu{2}{output,united});
   for ind = 1:length(unitedinputs{output,united}),
      if unitedinputs{output,united}(ind)
         varunion{ind+offset} = [FM.InputName{united},'(k-',...
               num2str(unitedinputs{output,united}(ind)),')'];
      else
         varunion{ind+offset} = FM.InputName{united};
      end
   end   
   offset = offset + length(unitedinputs{output,united});
end
