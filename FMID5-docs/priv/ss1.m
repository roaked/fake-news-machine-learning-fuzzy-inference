function s=ss1(x,mfs)
%	S=SS1(X,MFS) similarity measure based on set theoretic operations.
%	SS1 is defined as: S=card(min(A,B),'rel')/card(max(A,B),'rel), where
%	A and B are the vectors containing the membership grade of elements of 
% 	row vector X. (i.e. the relative cardinality of the union divided by the 
%	relative cardinality of the intersection)
%
%	S is a matrix containing the similarities measured between the different
%  	pairs of membership functions. Its size is M x M, where M is the number
%  	of membership functions. S(i,j) is the similarity between the two
%  	membership functions defined on the i'th and j'th row in the MFS matrix.
% 	Each element (similarity) in S take on a value in [0,1]. If S(i,j)=1, then
%	the two membership functions corresponding to this index are equal.
%	S(i,j) becomes 0 when the membership functions are non overlapping.
%	S is symmetric and entries on the main diagonal are all 1.
%
%	See also: SS2, SS3, SCHEN
%
%	example:
%		x=-1:.01:1.5; fs=[-1 -.5 -.5 0];
%  		mfs=[1 fs;1 fs+.2;1 fs+.4;1 fs+.6;1 fs+.8;1 fs+1;1 fs+1.2];
% 		subplot(2,1,1);mfplot(x,mfs);ylabel('Membership grade');
% 		xlabel('A, B, C, D, E, F and G');similarity=ss1(x,mfs)
% 		subplot(2,1,2),bar(similarity(1,:)),ylabel('Similarity');
% 		xlabel('S(A,A), S(A,B), S(A,C),..., S(A,G)');
%

% THIS ONE IS BEEING EXPERIMENTED WITH!

% Magne Setnes, 28. September 1995

m=size(mfs,1);
Z=mgrade(x,mfs)';
j=1;			%for rubustness, if mfs is 1 mf only
p=1;
for i=1:m-1;
	for j=i+1:m;
%		s(i,j) = 2*card(min(Z(i,:),Z(j,:))) / (card(Z(i,:))+card(Z(j,:)));
		s(i,j) = card((min(Z(i,:),Z(j,:))).^p) / card((max(Z(i,:),Z(j,:))).^p);
		s(j,i) = s(i,j);
	end;
	s(i,i)=1;	% The diagonal is 1
end;
s(j,j)=1;		% The diagonal is 1


