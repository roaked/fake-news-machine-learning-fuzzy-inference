function [sx,fm] = smoothmf(x,f)
% SMOOTHMF smooth a fuzzy set defined point-wise on the universe of
% discourse. Can be used e.g. for obtaining membership functions from
% multidimensional fuzzy clusters projected on the individual dimensions.
%
% [SX,FM] = SMOOTHMF(X,F)
%
% Input:   X      ... universe of discourse (column vector)
%          F      ... fuzzy partition matrix N x C, N is number of data
%                     points, C is number of clusters
% Outputs: SX     ... sorted universe of discourse
%          FM     ... smoothed fuzzy partition matrix

% (c) Robert Babuska, 1993-94

[sx,xi] = sort(x);                              % sort X and F accordingly
f = f(xi,:);
[m,n] = size(f);

b = [0.1367 0.1367];                            % original 0.1
a = [1 -0.7265];
%b = [0.2452 0.2452];                            % new 0.2
%a = [1 -0.5095];
%[b,a] = butter(1,0.2);

for i = 1 : n,                                  % filter all columns of F
  fi1 = filter(b,a,f(:,i)-f(1,i)) + f(1,i);      % top-bottom
  fi2 = filter(b,a,f(m:-1:1,i)-f(m,i)) + f(m,i); % bottom-top  
  fi(:,i) = (fi1 + fi2(m:-1:1)) / 2;                % average
  j = 0;
  ind = find(diff(sx)>0);
  if isempty(ind), ind = 0;end
  fi(1:ind(1),i) = fi(ind(1)+1,i);
  fi(end:-1:ind(end),i) = fi(ind(end-1),i);
%  fi(:,i) = fi(:,i)/max(fi(:,i));                  % normalize
end;
%fm = fi; return

lf = zeros(1,n); rf = lf;
left = zeros(size(f)); right = left;
for i = 1 : m,                                  % peak detector, i.e.
  lf = max(lf,fi(i,:));                         % make F convex by
  rf = max(rf,fi(m-i+1,:));                     % taking its envelope
  right(m-i+1,:) = rf;
  left(i,:) = lf;
end;
fm = min(left,right);

fm(1,:) = fm(3,:);
fm(end,:) = fm(end-2,:);
fm = fm./(ones(size(fm,1),1)*max(fm));                  % normalize
