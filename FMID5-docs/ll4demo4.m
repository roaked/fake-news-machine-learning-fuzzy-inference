%clc;
clear all
load insingle
%load singstep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
control = in.u(1:2879,2);
%control{2} = Dat2.U(1:1500,:);
system  = in.y(1:2879,2);
%system{2}  = Dat2.Y(1:1500,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = control(1:2000,:);
y = system(1:2000,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%disp('Validation data - Remaining 499 data samples')
%disp('ue = control(1501:end,:)')
%disp('ye = system(1501:end,:)')

ue = control(2001:end,:);
ye = control(2001:end,:);

% generate a fuzzy model for the 4 vessel liquid level process model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = [4];            % number of clusters
m = [2.0 ];     % fuzziness parameter
tol = 0.01;         % termination criterion
Ts = 2.5;           % sample time [s]
FMtype = [2];   % type of fuzzy model:  1 - product-space MFS
                %                               2 - projected MFS

%  1) y(k) = f(y(k-1),u(k))
%  2) y(k) = f(y(k-1),u(k-1))
%  3) y(k) = f(y(k-1),u(k-3))
%  4) y(k) = f(y(k-1),u(k-2),u(k-3))

% The ante's are the same for (1) through (4)
Ny = {{[1] };
        {[1] }}         % denominator order

%1) y(k) = f(y(k-1),u(k))
%Nu = {{[0 ]};x`
%       {[0 ]}}         % numerator order

% y(k) = f(y(k-1),u(k-1))
%Nu = {{[1 ]};
%       {[1 ]}}         % numerator order

%y(k) = f(y(k-1),u(k-3))
%Nu = {{[3 ]};
%       {[3 ]}}         % numerator order

%y(k) = f(y(k-1),u(k-2),u(k-3))
Nu = {{[2 3 ]};
        {[2 3 ]}}           % numerator order

%pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dat.U = u; Dat.Y = y; Dat.Ts = Ts;
FM.c = c; FM.m = m; FM.ante = FMtype; FM.tol = tol;
FM.Ny = Ny; FM.Nu = Nu;
%FM.Nd = Nd;

[FM,Part] = fmclust(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model for validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%disp(' ')
%disp('Simulate the obtained fuzzy model for the identification data');
%disp(' ')
drawnow
figure(1)
pause(2)
[ym,VAF,dof,yl,ylm] = fmsim(u,y,FM); VAF
pause(4)
disp(' ')
disp('Validate the fuzzy model');
disp(' ')
drawnow
[ym,VAF,dof,yl,ylm] = fmsim(ue,ye,FM); VAF
