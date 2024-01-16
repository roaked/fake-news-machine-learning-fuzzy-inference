function F = mff(x,xx,f,mfs,flag)
% MFF    calculate objective function for MFFIT.
%    Used internally in FMCLUST.

% (c) Robert Babuska, 1993-98

if flag == 1,
  x = [x(1) mfs(3:4) x(2)];
elseif flag == 2,
  x = [mfs(2) x mfs(5)];
end;

if ~all(x(1)<=x(2) & x(2)<=x(3) & x(3)<=x(4)),
  F = inf;
else  
  f = f - mgrade(xx',[mfs(1) x]);
  F = f'*f;
end;

