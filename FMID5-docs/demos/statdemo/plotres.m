set(0,'DefaultAxesFontname','times')
set(0,'DefaultAxesFontSize',10)

load trash

figure(1); clf;
subplot(211);
dofz = zz;
for i = 1 : FM.c(1),
   dofz(:) = dof{1}(:,i);
   mesh(xx,yy,dofz); hold on
end;
plot3(FM.V{1}(:,1),FM.V{1}(:,2),1.02*ones(FM.c(1),1),'.','Markersize',30)
hold off
xlabel(FM.InputName{1}); ylabel(FM.InputName{2}); zlabel('\mu');
view(300,35);
print -depsc stat2dof

plotout(FM,[],2);
print -depsc stat2out

plotmfs(FM,[],3);
print -depsc stat2mfs

plotcons(FM,[],4);
for i = 1 : size(FM.th{1},2),
   figure(i);
   eval(['print -depsc stat2th' num2str(i)]); 
end;   