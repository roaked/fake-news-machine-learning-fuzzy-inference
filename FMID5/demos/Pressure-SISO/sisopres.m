% generate a fuzzy model for the pressure system

clear FM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FM.c = 3;          	   % number of clusters
FM.seed = 0;            % seed
FM.m = 2;               % fuzziness
FM.ante = 2;            % antecedent:   1 - product-space MFS
                        %               2 - projected MFS
FM.Ny = {{[1]};{[1]}};              % denominator order
FM.Nu = {{[1]};{[1]}};              % numerator orders
%FM.Ny = {{[1]};{[1]}};              % denominator order
%FM.Nu = {{[1]};{[1]}};              % numerator orders
%FM.Nd = 1;              % transport delays
                        % (set to 1 for y(k+1) = f(u(k),....))

FM.Ts = 5;              % sample time [s]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load identification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DATA(:,1) - time                 DATA(:,2) - output pressure
% DATA(:,3) - measured gas flow    DATA(:,4) - disturbance
% DATA(:,5) - valve position       DATA(:,6) - setpoint for gas flow
% DATA(:,7) - n.a.

load trsart3; Dat.U{1} = DATA(:,5); Dat.Y{1} = DATA(:,2);
load trsart4; Dat.U{2} = DATA(:,5); Dat.Y{2} = DATA(:,2);

Dat.InputName{1}  = 'valve position';
Dat.OutputName{1} = 'pressure';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load tssart2; ue = DATA(:,5); ye = DATA(:,2);
load tssart3; ue = [ue;DATA(:,5)]; ye = [ye;DATA(:,2)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FM,Part] = fmclust(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model for validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf
[ym,VAF,dof,yl,ylm] = fmsim(ue,ye,FM,[],[],2); VAF
title('Process output (blue) and model output (magenta)');
ylabel('Output');
disp('Hit any key to plot the local models ...'); pause

figure(1); clf
subplot(211); plot([ylm{1}]); set(gca,'ylim',[1 2])
title('Individual local models');
xlabel('Time'); ylabel('Output');
subplot(212); plot(dof{1})
title('Degrees of fulfillment');
xlabel('Time'); ylabel('Membership grade');

disp('Hit any key to plot the membership functions ...'); pause
plotmfs(FM)

if exist('fuzblock','file') == 4,
    disp('Hit any key to open a Simulink model ...'); pause
    t = 5*(0:length(u)-1)';
    FIS = fm2fis(FM);
    pressure
end;
