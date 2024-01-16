%% Example 1
%% ---------

clear all
% Nonlinear function
f = inline('u.^3');

% Data generation
N = 401;                  % number of datapoints 
u = [-1:2/(N-1):1]';      % input vector 
y = f(u);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis with FMID toolbox %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data
Dat.X = u;
Dat.Y = y;

% Definition of membership functions
MFS=[2 -1.0  -1.0 -1.0 -0.4;
     2 -1.2  -0.6 -0.6  0.0;
     2 -1.0  -0.3 -0.3  0.4;
     2 -0.65  0.2  0.2  1.05;
     2 -0.4   0.85 1.0  1.0];
RLS=[1 2 3 4 5]';

FM = fmodel(RLS,MFS);

FM.OutputName={'y'};
FM.InputName={'u'};

% Choice of algorithm and definition of trade-off parameters
FM.cons=4;  % 4=alg1; 5=alg2
FM.beta{1}=0.1*[1 1 1 1 1]';

% Estimation of consequent parameters
[FM,dof]=fmest(FM,Dat);

% Show results
figure(1); clf
[ym,VAF,dof,yl,ylm] = fmsim(u,y,FM);
title('Original function (blue) and fuzzy model (magenta)');
ylabel('Output');
set(gcf,'position',[4   375   510   325]);

figure(2); clf
subplot(211); plot(u,ylm{1},u,y);
title('Original function (yellow) and local models');
xlabel('Input'); ylabel('Output');
subplot(212); plot(u,dof{1})
title('Membership functions');
xlabel('Input'); ylabel('Membership grade');
set(gcf,'position',[522   375   510   325]);

figure(3); clf
bar(FM.sensl{1})
grid on;
xlabel('local model')
ylabel('\pi_{i,j}^l(\beta)')
title(['Local criterion sensitivities, \beta_i=' num2str(mean(FM.beta{:}))])
legend('b_i','d_i')
set(gcf,'position',[3    33   512   334]);

figure(4); clf
bar(FM.sens{:})
grid on;
xlabel('local model')
ylabel('\pi_{i,j}^G(\beta)')
title(['Global criterion sensitivities, \beta_i=' num2str(mean(FM.beta{:}))])
legend('b_i','d_i')
set(gcf,'position',[520    32   514   336]);

figure(1); figure(2)