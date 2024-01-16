% generate a fuzzy model for the liquid level process model

clear FM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = 3;          % number of clusters
m = 1.2;        % fuzziness parameter
tol = 0.01;     % termination criterion
Ts = 2;       % sample time [s]
FMtype = 2;     % type of fuzzy model:  1 - product-space MFS
        %           2 - projected MFS
Ny = 1;         % denominator order
Nu = [1];       % numerator orders
Nd = [1];       % transport delays
                % (set to 1 for y(k+1) = f(u(k),....))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load lloct8
skip = 1;               % decimation
N = size(system,1);              % split data in halves
N2 = floor(size(system,1)/2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = control(1:skip:N2);
y = system(1:skip:N2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ue = control(N2+1:skip:N);
ye = system(N2+1:skip:N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dat.U = u; Dat.Y = y; Dat.Ts = Ts; FM.c = c;
FM.ante = FMtype; FM.tol = tol;
FM.Ny = Ny; FM.Nu = Nu; FM.Nd = Nd;

[FM,Part] = fmclust(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model for validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf;
[ym,VAF,dof,yl,ylm] = fmsim(ue,ye,FM,[],[],2); VAF
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

close(1); clc
