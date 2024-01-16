% generate a fuzzy model for the MISO pressure system

clear FM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FM.c = 3;          	% number of clusters
FM.seed = 0;            % seed
%FM.m = 2;              % fuzziness
FM.ante = 2;            % antecedent:   1 - product-space MFS
                        %               2 - projected MFS
FM.Ny = {{[1]};{[1]}};              % denominator order
FM.Nu = {{[1] [1]} ;{[1] [1]}};% numerator orders
%FM.Ny = 1;
%FM.Nu = [1 1];          % transport delays
%FM.Nd = [1 1];          % transport delays
                        % (set to 1 for y(k+1) = f(u(k),....))

FM.Ts = 5;              % sample time [s]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load identification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DATA(:,1) - time                 DATA(:,2) - output pressure
% DATA(:,3) - measured gas flow    DATA(:,4) - disturbance
% DATA(:,5) - valve position       DATA(:,6) - setpoint for gas flow
% DATA(:,7) - n.a.

load misotr1; Dat.U{1} = DATA(:,5:6); Dat.Y{1} = DATA(:,2);
load misotr3; Dat.U{2} = DATA(:,5:6); Dat.Y{2} = DATA(:,2);

Dat.InputName{1}  = 'Valve position';
Dat.InputName{2}  = 'Gas flow setpoint';
Dat.OutputName{1} = 'Pressure';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load misots1; ue = DATA(:,5:6); ye = DATA(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FM,Part] = fmclust(Dat,FM);

%%% Initialize figures %%%
SCRSIZE = get(0,'screensize');
Xs = SCRSIZE(3); Ys = SCRSIZE(4);
uleft=[1 (Ys/2)-10 Xs/2 Ys/2-10];
uright=[Xs-Xs/2+3 (Ys/2)-10 Xs/2-2 (Ys/2)-10];
lleft=[1 0 Xs/2 Ys/2-30];
lright=[Xs-Xs/2+3 0 Xs/2-2 (Ys/2)-30];

figure(1),set(gcf,'pos',uleft,'menubar','none','numbertitle','off','name','Pressure');clf;
figure(2);set(gcf,'pos',uright,'menubar','none','numbertitle','off','name','Local models');clf;
figure(3);set(gcf,'pos',lright,'menubar','none','numbertitle','off','name','Membership functions');clf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model for validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf
[ym,VAF,dof,yl,ylm] = fmsim(ue,ye,FM,[],[],1); VAF
title('Process output (blue) and model output (magenta)');

figure(2); clf
subplot(211); plot([ylm{1}]); set(gca,'ylim',[1 2])
title('Individual local models');
xlabel('Time'); ylabel('Pressure');
subplot(212); plot(dof{1})
title('Degrees of fulfillment');
xlabel('Time'); ylabel('Membership grade');

plotmfs(FM,[],3)
