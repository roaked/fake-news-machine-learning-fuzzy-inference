 load ll4
clear FM
% generate a fuzzy model for the 4 vessel liquid level process model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = [3 3 2 2];          % number of clusters
m = 2.2;        % fuzziness parameter
tol = 0.01;     % termination criterion
Ts = 10;       % sample time [s]
FMtype = [1 1 1 2];     % type of fuzzy model:  1 - product-space MFS
        %           2 - projected MFS
Ny = [  1 0 1 1
        0 1 1 1
         0 0 1 0
         0 0 0 1 ];         % denominator order
Nu = [0 0
      0 0
      1 0
      0 1];       % numerator orders
Nd = [0 0
      0 0
      1 0
      0 1];       % transport delays
                % (set to 1 for y(k+1) = f(u(k),....))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
control = ll4data(:,5:6);
system  = ll4data(:,1:4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = control*1e5;
y = system;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ue = [control(:,2) control(:,1)]*1e5;
ye = [system(:,2) system(:,1) system(:,4) system(:,3)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dat.U = u; Dat.Y = y; Dat.Ts = Ts;
FM.c = c; FM.m = m; FM.ante = FMtype; FM.tol = tol;
FM.Ny = Ny; FM.Nu = Nu; FM.Nd = Nd;

[FM,Part] = fmclust(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model for validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ym,VAF,dof,yl,ylm] = fmsim(ue,ye,FM,[],[],1,2); VAF

disp('Hit any key to finish ...'); pause

close(1); clc
