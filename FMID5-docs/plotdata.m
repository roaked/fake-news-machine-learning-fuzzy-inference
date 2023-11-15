function plotdata(Dat,FM,opt,fig)
% PLOTDATA    Plot data contained in the Dat structure.
%    PLOTOUT(DAT,FM,OPT,FIG) .... FM is the fuzzy model. The OPT parameter
%    can be used to specify the PLOT options (linetype, color).
%    The FIG parameter (optional) specifies the figure where to 
%    begin  with the plots. The default is 1. 

% Copyright (c) Robert Babuska, 1999.

if nargin < 2, FM = []; end;
if nargin < 3, opt = []; end;
if nargin < 4, fig = 1; elseif isempty(fig), fig = 1; end;

if isfield(Dat,'U'); U = Dat.U;
elseif isfield(Dat,'X')'; U = Dat.X;
elseif isfield(Dat,'x')'; U = Dat.x;
elseif isfield(Dat,'u')'; U = Dat.u; else U = []; end;
if isfield(Dat,'Y'); Y = Dat.Y;
elseif isfield(Dat,'y'); Y = Dat.y; else Y = []; end;
if ~iscell(U), U = {U}; end; if ~iscell(Y), Y = {Y}; end;

if isfield(Dat,'Ts'); Ts = Dat.Ts; else Ts = 1; end;

Ninps = size(U{1},2);
Nouts = size(Y{1},2);

if isfield(Dat,'InputName'); InputName = Dat.InputName;
elseif Ninps > 1, for j = 1 : Ninps, InputName{j} = ['u_' num2str(j)]; end;
else InputName{1} = 'u'; end;
if isfield(Dat,'OutputName'); OutputName = Dat.OutputName;
elseif Nouts > 1, for j = 1 : Nouts, OutputName{j} = ['y_' num2str(j)]; end;
else OutputName{1} = 'y'; end;

if ~iscell(OutputName), OutputName = {OutputName}; end;
if ~iscell(InputName), InputName = {InputName}; end;

FontSize = 6;
col = get(0,'defaultaxescolororder');
col = [col;col;col;col];

%set(gcf,'numbertitle','off','name',['Output ' num2str(i)]);
tend = 0;
for i = 1 : length(U),
   t = Ts*(tend : tend+length(U{i})-1)';
   figure(fig);
   for j = 1 : Ninps,
      subplot(Ninps,1,j);
      set(gca,'FontSize',FontSize,'ColorOrder',col(i,:))
      if ~isempty(opt), stairs(t,U{i}(:,j),opt);
      else stairs(t,U{i}(:,j)); end;
      hold on;
      xlabel('Time [s]','FontSize',9);
      ylabel(InputName{j},'FontSize',9);
   end;   
   figure(fig+1);
   for j = 1 : Nouts,
      subplot(Nouts,1,j);
      set(gca,'FontSize',FontSize,'ColorOrder',col(i,:))
      if ~isempty(opt), stairs(t,Y{i}(:,j),opt);
      else stairs(t,Y{i}(:,j)); end;
      hold on;
      xlabel('Time [s]','FontSize',9);
      ylabel(OutputName{j},'FontSize',9);
   end;   
   tend = t(end);
end;

figure(fig); hold off; 
set(gcf,'numbertitle','off','name','Input(s)');
figure(fig+1); hold off
set(gcf,'numbertitle','off','name','Output(s)');

figure(fig+2);
set(gcf,'numbertitle','off','name','Scatter plot(s)');
k = 0;
for j = 1 : Ninps,
   for i = 1 : Nouts,
      k = k + 1;
      for ii = 1 : length(U),
         subplot(Ninps,Nouts,k);
         set(gca,'FontSize',FontSize,'ColorOrder',col(ii,:))
         if ~isempty(opt), plot(U{ii}(:,j),Y{ii}(:,i),opt);
         else plot(U{ii}(:,j),Y{ii}(:,i),'.'); end;
         hold on
      end;
      hold off
      xlabel(InputName{j},'FontSize',9);
      ylabel(OutputName{i},'FontSize',9);
   end;
end;
