% generate a fuzzy model for the engine speed and pressure SIMO model

clear FM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FM.c = [3 4];    % number of clusters
FM.m = [2 2];    % fuzziness parameter
FM.tol = 0.01;   % termination criterion
FM.seed = 0;     % seed
FM.ante = [1 1]; % type of fuzzy model:  1 - product-space MFS
                 %                       2 - projected MFS
                  
FM.Ny = [1 0;    % denominator orders
      	1 2];
FM.Nu = [1;
         1];     % numerator orders
FM.Nd = [1;
         1];     % transport delays
                 % (set to 1 for y(k+1) = f(u(k),....))

Dat.Ts = 0.1;     % sample time [s] 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load data
skip = 10;				% decimation
N = size(engine_speed,1);              % split data in halves
N2 = floor(size(engine_speed,1)/2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dat.U = throttle(1:skip:N2);
Dat.Y = [engine_speed(1:skip:N2), pressure(1:skip:N2)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ue = throttle(N2+1:skip:N);
ye = [engine_speed(N2+1:skip:N), pressure(N2+1:skip:N)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FM,Part] = fmclust(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model for validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ym,VAF] = fmsim(ue,ye,FM); VAF
title('Process output (blue) and model output (magenta)');

disp('Hit any key to finish ...'); pause

close(1); clc