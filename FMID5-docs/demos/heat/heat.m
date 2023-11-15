% generate a fuzzy model for heat transfer process

clear FM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FM.c = 3;           % number of clusters
FM.m = 2;              % fuzziness parameter
%FM.seed = 0;           % seed
FM.ante = 2;            % antecedent:   1 - product-space MFS
                            %               2 - projected MFS
FM.Ny = {{[1 2 3]};{[1 2 3]}}          % denominator order
FM.Nu = {{[4]};{[4]}}         % numerator orders
%FM.Nd = [4];         % transport delays
                        % (set to 1 for y(k+1) = f(u(k),....))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load tortr.asc;
%Dat.U = [tortr(:,1) 18*tortr(:,2)];
%Dat.Y = tortr(:,3);
load tor20.asc;
Dat.U = tor20(:,1);
Dat.Y = tor20(:,3);
Dat.Ts = 1.1;           % sample time [s]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load torval.asc;
%ue = [torval(:,1) 18*torval(:,2)];
%ye = torval(:,3);
ue = Dat.U;
ye = Dat.Y;

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
ylabel('Output');
disp('Hit any key to see the local models ...'); pause

figure(1); clf
subplot(211); plot([ylm{1}]);
title('Individual local models');
xlabel('Time'); ylabel('Output');
subplot(212); plot(dof{1})
title('Degrees of fulfillment');
xlabel('Time'); ylabel('Membership grade');

disp('Hit any key to finish ...'); pause

%close(1); clc
