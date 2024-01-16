%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mfs = mffit(x,f,mfini,OPT,flag)
% MFFIT find optimal parameters of membership function(s) fitted on
% fuzzy set(s) defined point-wise on the universe of discourse.
% Uses FMINS.
%
% MFS = MFFIT(X,F,MFINI,OPT,FLAG)
%
% Input:   X      ... universe of discourse (column or row vector)
%          F      ... fuzzy set(s) defined point-wise on X in columns or
%                     rows of F
%          MFINI  ... initial guess of membership function parameters or
%                     just their type(s) (scalar or column vector). In
%                     the latter case, initial guess is made automatically.
%	   OPT    ... optional parameter, gives access to the FMINS OPTIONS
%		      parameter	
%          FLAG   ... optional optimization parameter,
%                       FLAG(1) - optimize bottoms
%                       FLAG(2) - optimize shoulders
%                       FLAG(3) - optimize both
%
% Outputs: MFS    ... membership functions parameter matrix (see MGRADE)

% (c) Robert Babuska, April 1994

if nargin < 4, OPT = foptions; end;
if ~all(size(OPT)), OPT = foptions; end;
if nargin < 5, flag = [1 0 0]; end;
delta = 0.1;                                    % 1-delta and delta alpha-cuts

[sx,xi] = sort(x);                              % sort X and F accordingly
f = f(xi,:);
[m,n] = size(f);

if size(mfini,2) == 1,                            % no initial MFS supplied
  mftype = mfini.*ones(n,1);
  mfs = ones(n,1)*[sx(1) sx(1) sx(m) sx(m)];      % initialize mfs
  for i = 1 : n,                                  % detect kernels
    peak(i) = round(mean(find(f(:,i)==max(f(:,i)))));
  end;
  for j = 1 : n;                                   % initial MF params
    for i = 1 : peak(j),
      if f(i,j) >= delta, minfl(j) = f(i,j); mfs(j,1) = sx(i); break; end;
    end;
    for i = peak(j) : -1 : 1,
      if f(i,j) <= 1-delta, mfs(j,2) = sx(i); break; end;
    end;
    for i = peak(j) : m,
      if f(i,j) <= 1-delta, mfs(j,3) = sx(i); break; end;
    end;
    for i = m : -1 : peak(j),
      if f(i,j) >= delta, minfr(j) = f(i,j); mfs(j,4) = sx(i); break; end;
    end;  
    minx(j) = mfs(j,1); maxx(j) = mfs(j,4); 
    if minfl(j) ~= 1, mfs(j,1) = mfs(j,2) - (mfs(j,2) - mfs(j,1)) ./ (1 - minfl(j)); end
    if minfr(j) ~= 1, mfs(j,4) = mfs(j,3) + (mfs(j,4) - mfs(j,3)) ./ (1 - minfr(j)); end
  end;
  mfs = [mftype mfs];
else                                                    % initial MFS supplied
  mfs = mfini; mftype = mfini(:,1);
  minx = mfs(:,2); maxx = mfs(:,5); 
end;

for i = 1 : n,                                          % optimize per 1 MF
%# call mff
  if flag(1),
    %p = fmins('mff',mfs(i,[2,5]),OPT,[],sx(sx>=minx(i) & sx<=maxx(i)),f(sx>=minx(i) & sx<=maxx(i),i),mfs(i,:),1);
    p = fminsearch('mff',mfs(i,[2,5]),OPT,sx(sx>=minx(i) & sx<=maxx(i)),f(sx>=minx(i) & sx<=maxx(i),i),mfs(i,:),1);
    mfs(i,[2,5]) = p;
  end;
  if flag(2),
    p = fminsearch('mff',mfs(i,[3,4]),OPT,sx(sx>=minx(i) & sx<=maxx(i)),f(sx>=minx(i) & sx<=maxx(i),i),mfs(i,:),2);
    mfs(i,[3,4]) = p;
  end;
  if flag(3),
    p = fminsearch('mff',mfs(i,2:5),OPT,sx(sx>=minx(i) & sx<=maxx(i)),f(sx>=minx(i) & sx<=maxx(i),i),mfs(i,:),3);
    mfs(i,2:5) = p;
  end;
end;
