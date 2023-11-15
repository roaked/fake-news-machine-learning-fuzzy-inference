function [p,ps] = tls(x,y)
% TLS total least squares estimate for a linear regression model
%
% [P,Ps] = TLS(X,Y)
%    Input:
%       X .....	input data matrix
%	Y .....	output data vector
%    Output:
%       P  .... parameter etimates
%       Ps .... standard deviations
%		

% (c) Robert Babuska, 1994-96

[mx,nx] = size(x); 

xy = [x y];
[U,S,V]= svd(xy,0);
p = -1/V(nx+1,nx+1)*V(1:nx,nx+1);

% van Huffel, p.242
ps = sqrt(diag((1 + norm(p).^2)* ...
     (S(nx+1,nx+1)^2/(mx-nx))*inv(x'*x - ...
     (S(nx+1,nx+1)^2)*eye(nx))));

return

v = [zeros(1,nx-1) p(nx)];
r = [ones(1,nx-1) sum(p(1:nx-1))];
r = r/norm(r);
rv = ones(mx,1)*r;
xv = ones(mx,1)*v;
v,r
d1 = sum((([x(:,1:nx-1) y] - xv).^2)')';
d2 = sum(([x(:,1:nx-1) y].*rv)').^2';
res = ((d1-d2));

xx = x'*x;
%ps2 = sqrt(diag(sum(res)/(mx-nx)*inv(xx)));
