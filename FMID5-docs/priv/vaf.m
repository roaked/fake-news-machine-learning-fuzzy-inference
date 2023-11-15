function v = vaf(y,y_est)
% Purpose:
%            Compute the percentage Variance Accounted For (%VAF)
%            between two signals. the % VAF is calculated
%            as:
%                       var(y-y_est)
%               v= (1 - ------------) * 100%
%                          var(y)
% 
%            The %VAF of two signals that are the same is
%            100%. If they differ, the  %VAF will be lower. 
%            When x and y are matrices, the %VAF returned 
%            will be a square matrix, with on the diagonals,
%            the vaf of corresponding columns of x and y. 
%            The %VAF is often used to verify the
%            correctness of a model, by comparing the real
%            output with the output of the model.
% 
% Syntax:
%            v = vaf(y,y_estimate)
% Input:     
%  y         Signal 1, often the real output
%  y_est     Signal 2, often the output of a model
%
% Output:
%   v        %VAF, computed for the two signals

% Bert Haverkamp, April 1996
% copyright (c) 1996 B.R.J. Haverkamp
% LAST MODIFIED:
% 15/04/97 BRJ Created

v=diag(100*(eye(size(y,2))-cov(y-y_est)./cov(y)));

