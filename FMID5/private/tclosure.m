function RT=tclosure(R,TTYPE)
% RT=TCLOSURE(R,TTYPE)
% Calculates transitive closure of the (nxn) relation R
%
% R		= Relation, nxn
% RT		= Transitive closure of R, nxn
%
% TTYPE		=	'mm' ... MAX-MIN (default)
%			'mp' ... MAX-PRODUCT
%

% M.Setnes 15.05.97

if (nargin<2), TTYPE='mm'; end;

if (TTYPE=='mm')
	RT=max(R,sup_min(R,R));	%Calculate trans. closure
	while any(any(RT~=R));
		R=RT;
		RT=max(R,sup_min(R,R));
	end;
	return;
end;

if (TTYPE=='mp')
	RT=max(R,sup_prod(R,R));	%Calculate trans. closure
	while any(any(RT~=R));
		R=RT;
		RT=max(R,sup_prod(R,R));
	end;
	return;
end;