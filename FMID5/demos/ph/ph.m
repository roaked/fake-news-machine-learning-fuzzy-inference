% generate a fuzzy model for heat transfer process

clear FM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FM.c = 4;           % number of clusters
FM.m = 1.2;              % fuzziness parameter
FM.seed = 0;           % seed
FM.ante = 2;            % antecedent:   1 - product-space MFS
                            %               2 - projected MFS
FM.cons = 4;           % consequent estimation

FM.Ny = {{[1 2]};{[1 2]}};         % denominator order
FM.Nu = {{[1 2]};{[1 2]}};         % numerator orders
FM.Ny = {{[1]};{[1]}};         % denominator order
FM.Nu = {{[1]};{[1]}};         % numerator orders
%FM.Nd = 1;         % transport delays
                   % (set to 1 for y(k+1) = f(u(k),....))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load phset2; 
Dat.U = Qbase(:);
Dat.Y = pH(:);
Dat.Ts = 15;           % sample time [s]
Dat.InputName = 'Base flow-rate';
Dat.OutputName = 'pH';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load evaldata; 
ue = Qbase(:);
ye = pH(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FM,Part] = fmclust(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model for validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf
[ym,VAF,dof,yl,ylm] = fmsim(ue,ye,FM); VAF
title('Process output (blue) and model output (magenta)');
ylabel('pH');
disp('Hit any key to see the local models ...'); pause

figure(2); clf
subplot(211); plot([ylm{1}]);
title('Individual local models');
xlabel('Time'); ylabel('pH');
subplot(212); plot(dof{1})
title('Degrees of fulfillment');
xlabel('Time'); ylabel('Membership grade');
disp('Hit any key to see the membership functions ...'); pause

figure(3); clf
plotmfs(FM);
