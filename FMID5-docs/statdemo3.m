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
FM.cons = 4;           % type of consequent:   1 - global LS
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
set(gcf,'position',[4   371   510   326]);

figure(2); clf
subplot(211); plot(u,ylm{1},u,y);
title('Original function (yellow) and local models');
xlabel('Input'); ylabel('Output');
subplot(212); plot(u,dof{1})
title('Membership functions');
xlabel('Input'); ylabel('Membership grade');
set(gcf,'position',[522   371   510   327]);

figure(3); clf
bar(FM.sensl{1})
grid on;
xlabel('local model')
ylabel('\pi_{i,j}^l(\beta)')
title(['Local criterion sensitivities, \beta_i=' num2str(mean(FM.beta{:}))])
legend('b_i','d_i')
set(gcf,'position',[4   371   510   326]);

figure(4); clf
bar(FM.sens{:})
grid on;
xlabel('local model')
ylabel('\pi_{i,j}^G(\beta)')
title(['Global criterion sensitivities, \beta_i=' num2str(mean(FM.beta{:}))])
legend('b_i','d_i')
set(gcf,'position',[4   371   510   326]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ANFIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FM2 = anfisfm(Dat,FM,1,100);

FM2.beta{1} = 0.1*ones(FM2.c,1);
%FM2.beta = 0.01;
FM2 = fmest(FM2,Dat);

figure(5); clf
[ym2,VAF2,dof2,yl2,ylm2] = fmsim(u,y,FM2);
title('Original function (blue) and optimized fuzzy model (magenta)');
ylabel('Output');
set(gcf,'position',[3    33   512   334]);


figure(6); clf
subplot(211); plot(u,ylm2{1},u,y);
title('Original function (yellow) and optimized local models');
xlabel('Input'); ylabel('Output');
subplot(212); plot(u,dof2{1})
title('Optimized membership functions');
xlabel('Input'); ylabel('Membership grade');
set(gcf,'position',[520    32   514   336]);

figure(7); clf
bar(FM2.sensl{1})
grid on;
xlabel('local model')
ylabel('\pi_{i,j}^l(\beta)')
title(['Local criterion sensitivities, \beta_i=' num2str(mean(FM.beta{:}))])
legend('b_i','d_i')
set(gcf,'position',[3    33   512   334]);

figure(8); clf
bar(FM2.sens{:})
grid on;
xlabel('local model')
ylabel('\pi_{i,j}^G(\beta)')
title(['Global criterion sensitivities, \beta_i=' num2str(mean(FM.beta{:}))])
legend('b_i','d_i')
set(gcf,'position',[3    33   512   334]);

disp(' ');
disp('VAF before    after');
disp([VAF VAF2])

figure(8); figure(4); figure(7); figure(3); figure(5); figure(6); figure(1); figure(2); 