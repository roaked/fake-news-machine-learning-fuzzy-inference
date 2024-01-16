function C=sup_min(A,B)
% Sup-min (MAX-MIN) composition
% C(x,z) = S(x,y) o R(y,z)
%        = max { min [R(x,y),S(y,z)] }

% (c) Robert Babuska, March 1993

[bm,bn] = size(B); [am,an] = size(A); bn1 = ones(1,bn);

if ( am > 1 & an == 1 & bm == 1 & bn > 1)
    A=A*ones(1,bn); B=ones(am,1)*B;
end;

A=A';

for i=1:am
    C(i,:)=max(min(A(:,i)*bn1,B));
end

