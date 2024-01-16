% generate a fuzzy model for the engine pressure model

clear FM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FM.c = 3;      % number of clusters
FM.Ts = 0.1;   % sample time [s] 
FM.seed = 0;   % seed
FM.ante = 2;   % type of antecedent:  1 - product-space MFS
                %                      2 - projected MFS
FM.Ny = 1;     % denominator order
FM.Nu = [1 1]; % numerator orders
FM.Nd = [1 1]; % transport delays
                % (set to 1 for y(k+1) = f(u(k),....))
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load data
skip = 10;				% decimation
N = size(throttle,1);                  % split data in halves
N2 = floor(N/2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dat.U = [throttle(1:skip:N-N2) engine_speed(1:skip:N-N2)];
Dat.Y = pressure(1:skip:N-N2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ue = [throttle(N2+1:skip:N) engine_speed(N2+1:skip:N)];
ye = pressure(N2+1:skip:N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FM,Part] = fmclust(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model for validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ym,VAF] = fmsim(ue,ye,FM,[],[],2); VAF
title('Process output (blue) and model output (magenta)');
disp('Hit any key to finish ...'); pause

close(1); clc
