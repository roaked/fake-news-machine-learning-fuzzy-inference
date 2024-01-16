% generate a fuzzy model for the waste-water treatment process
clear FM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = [3 3 3];      % number of clusters
m = [2.2 2.2 2.2];      % fuzziness parameter
tol = 0.01;       % termination criterion
Ts = 1;           % sample time [s]
seed = 210545; 	  % seed for random initial partition
FMtype = [2 2 2]; % type of fuzzy model:  1 - product-space MFS
                  %                       2 - projected MFS
Ny = [1 1 1;        % denominator orders
      1 1 1;
      1 1 1];
Nu = [1;
      1;
      1];       % numerator orders
Nd = [1;
      1;
      1];       % transport delays
                % (set to 1 for y(k+1) = f(u(k),....))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read indentification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load wwdata1		% 1 ... cell_conc
			% 2 ... xen_subst
			% 3 ... eng_subst
			% 4 ... dilution
			% 5 ... time

skip = 2;				% decimation
Ts = Ts*skip;
N = size(wwdata,1);

y = wwdata(1:skip:N,1:3);
u = wwdata(1:skip:N,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load wwdata3		% 1 ... cell_conc
			% 2 ... xen_subst
			% 3 ... eng_subst
			% 4 ... dilution
			% 5 ... time

N = size(wwdata,1);
ye = wwdata(1:skip:N,1:3);
ue = wwdata(1:skip:N,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dat.U = u; Dat.Y = y; Dat.Ts = Ts; FM.c = c; FM.m = m; 
FM.seed = seed; FM.ante = FMtype; FM.tol = tol; 
FM.Ny = Ny; FM.Nu = Nu; FM.Nd = Nd;

[FM,Par] = fmclust(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model for validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ym,VAF] = fmsim(ue,ye,FM,[0 0 0]); VAF

disp('Hit any key to finish ...'); pause

close(1); clc
