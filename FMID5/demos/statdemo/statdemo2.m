% generate a fuzzy model for a SISO static function

clear FM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FM.c = 3;          	% number of clusters
FM.m =  2;         	% fuzziness parameter
FM.tol = 0.01;         % termination criterion
FM.ante = 2;           % type of antecedent:   1 - product-space MFS
                       %                       2 - projected MFS
FM.cons = 2;           % type of consequent:   1 - global LS
                       %                       2 - weighted LS      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[xx,yy] = meshgrid((0:0.02:1)');
zz = sin(7*(0:0.02:1)')*ones(1,size(xx,2)) + ones(size(xx,1),1)*(0:0.02:1);
Dat.U = [xx(:) yy(:)];
Dat.Y = zz(:);
Dat.InputName = {'x_1' 'x_2'};
Dat.OutputName = {'y'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate a fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FM,Part] = fmclust(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf
zm = zz; zlm = zz;
[zm(:),VAF] = fmsim(Dat.U,Dat.Y,FM,[],[],0);
subplot(211); mesh(xx,yy,zz);
title('Function');
xlabel(FM.InputName{1}); ylabel(FM.InputName{2}); zlabel(FM.OutputName{1});
subplot(212); mesh(xx,yy,zm);
title('Model'); set(gca,'zlim',[-2 2]);
xlabel(FM.InputName{1}); ylabel(FM.InputName{2}); zlabel(FM.OutputName{1});
VAF
disp('Hit any key to examine the results ...'); pause
plotres