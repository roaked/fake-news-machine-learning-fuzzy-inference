function [p,ps] = cov2sug(c,V,D,x)
% COV2SUG converts the cluster centers c and smallest eigenvectors V 
% (obtained) from GKCLUST or GKFAST to the consequent parameters of 
% Sugeno fuzzy-linear model, i.e. an explicit hyperplane equation
% y = a1.x1 + a2.x2 + ..... aM.xM + a0
%
% p = COV2SUG(c,V,D,X)
%     Input:
%       c  ... cluster center (means) matrix
%              M is the number of data points and N data dimension
%       V  ... eigenvectors of the cluster covariance matrices, 
%	       corresponding to the smallest eigenvalues
%       D  ... eigenvalues of the cluster covariance matrices
%       X  ... clustering data
%
%     Output:
%       p  ... consequent parameter matrix p = [a11 a12 ... a1M a10; 
%					        a21 a22 ... a2M a20;
%					        ...
%					        aC1 aC2 ... aCM aC0;]
%	ps ... standard deviations of the parameters
%
%     where C is the number of clusters and M the subspace dimension
%
%    Example:
%	x = (0:0.02:1)'; y = sin(7*x);
%       figure(1); clf; [f,c,P,V] = gkfast([x y],3,[],[],1);
% 	p = cov2sug(c,V)
%	figure(2); clf; subplot(211); 
%	plot(x,y,x,sugval(p,[x ones(size(x))],f));
%	title('Consequents obtained from centers and eigenvectors')
%       [p1,ym,yl,ylm] = suglms([x ones(size(x))],y,f);
%	subplot(212); plot(x,y,x,ym);
%	title('Consequents obtained as LMS solution')

% (c) Robert Babuska, 1993-96

[mV,nV] = size(V);
p = [V(:,1:nV-1) -sum((V.*c)')']./(-V(:,nV)*ones(1,nV));

if nargout > 1,
  D = min(D');
  [mx,nx] = size(x);
  x = x(:,1:nx-1);
  for i = 1 : mV,
    ps(i,:) = sqrt(diag((1 + norm(p(i,1:nx)).^2)* ...
              (D(i)/(mx-nx))*inv(x'*x - ...
              (D(i))*eye(nx-1))))';
  end;
end;