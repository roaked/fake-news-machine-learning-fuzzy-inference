function c=card(a,rel)

%       C = CARD(A) Scalar cardinality of a fuzzy set.
%       Scalar cardinality is defined as Card A = sum(Ax).
%       C = CARD(A,'rel') Relative cardinality of a fuzzy set.
%       Relative cardinality is defined as Cardr A = Card A / Card X.

% (c) Robert Babuska, March 1993

c = sum(a')';
if nargin == 2,
  c = c / length(a(1,:));
end;

