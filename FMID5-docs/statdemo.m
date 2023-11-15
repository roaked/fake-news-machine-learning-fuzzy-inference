% generate a fuzzy model for a SISO static function

clear FM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FM.c = 5;          	% number of clusters
FM.m =  2;         	% fuzziness parameter
FM.tol = 0.01;         % termination criterion
FM.ante = 2;           % type of antecedent:   1 - product-space MFS
                       %                       2 - projected MFS
FM.cons = 1;           % type of consequent:   1 - global LS
                       %                       2 - weighted LS      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make data for the new syntax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = (0:0.02:1)';
y = sin(7*u);
Dat.U = u;
Dat.Y = y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate a fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FM,Part] = fmclust(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf
[ym,VAF,dof,yl,ylm] = fmsim(u,y,FM);
title('Original function (blue) and fuzzy model (magenta)');
ylabel('Output');
disp('Hit any key to plot the membership functions and the corresponding local models ...'); pause

figure(1); clf
subplot(211); plot(u,ylm{1},u,y);
title('Original function (yellow) and local models');
xlabel('Input'); ylabel('Output');
subplot(212); plot(u,dof{1})
title('Membership functions');
xlabel('Input'); ylabel('Membership grade');
VAF

if exist('anfis') == 2,
disp('Hit any key to optimize the fuzzy model by using ANFIS ...'); pause

FM2 = anfisfm(Dat,FM,1,100);

figure(3); clf
[ym2,VAF2,dof2,yl2,ylm2] = fmsim(u,y,FM2);
title('Original function (blue) and optimized fuzzy model (magenta)');
ylabel('Output');
disp('Hit any key to plot the membership functions and the corresponding local models ...'); pause

figure(3); clf
subplot(211); plot(u,ylm2{1},u,y);
title('Original function (yellow) and optimized local models');
xlabel('Input'); ylabel('Output');
subplot(212); plot(u,dof2{1})
title('Optimized membership functions');
xlabel('Input'); ylabel('Membership grade');

disp(' ');
disp('VAF before    after');
disp([VAF VAF2])

end;
disp('Hit any key to finish ...'); pause
close(1); if exist('anfis') == 2, close(3); end; clc;
