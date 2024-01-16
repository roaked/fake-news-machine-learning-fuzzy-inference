function [K,T] = fm2kt(FM)
% converts the fuzzy model FM into gains 
% and time constants of a continuous-time model
%
% [K,T] = p2kt(FM)
%   inputs:  FM ... fuzzy model
%   outputs: K  ... gain matrix (consequent per row, input per column)
%    	       T  ... time constants (consequent per row)
% currently only SISO

% (c) Robert Babuska, Stanimir Mollov 1999

p = FM.th{1};
NA = FM.Ny{2};
NB = FM.Nu{2};
Ts = FM.Ts;

mp = size(p,1);

for i = 1 : mp,
  den = [1 -p(i,1:size(NA{:},2))];
  [mm,wn] = ddamp(den,Ts);
  T(i,:) = 1./wn';
  for j = 1 : length(NB),
    num = [p(i,size(NA,2)+1:end-1)];
    K(i,j) = ddcgain(num,den);
  end;
end;
