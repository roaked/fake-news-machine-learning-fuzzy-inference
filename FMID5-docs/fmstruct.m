function fmstruct
% The parameters of fuzzy models are stored in a structure named
% FM (fuzzy model), similarly as, for instance, FISMAT in the
% Fuzzy Toolbox of the Mathworks or THETA the Identification 
% Toolbox. Note, however, that the FM structure is not compatible 
% with these toolboxes. 
%
% FM is a structure with the following fields:
%
%    Ts         sample time
%    ni         number of inputs
%    no         number of outputs
%    N          number of data samples used for identification
%    tol        termination tolerance for clustering
%    seed       seed for random initialization of fuzzy partition
%    ny         number of output lags
%    nu         number of input lags
%    nd         number of pure delays
%    ante       type of the antecedent
%    cons       type of the consequent (0-1=a-cut;1=GLS;2=WLS;
%                       4=tradeoff alg1.;5=tradeoff alg2.)
%    c          number of clusters
%    m          fuzziness exponent
%    rls        rule matrix
%    mfs        membership function matrix
%    th         consequent parameters
%    s          standard deviation of the consequent parameters
%    V          cluster centers
%    P          cluster covariance matrices
%    zmin       minima of each column of the pattern matrix Z
%    zmax       maxima of each column of the pattern matrix Z
%    InputName  names of input variables (cell array)
%    OutputName names of output variables (cell array)
%
%    beta       weighting parameters on local model accuracy
%    sens       parameter sensitivities corresponding to GLS optim.
%    thetath    boundaries on global LS parameter estimation
%    lambdas    langrange multipliers resulting from QP GLS Optim. 
%
% See also FMCLUST, FMSIM, FM2TEX.

% (c) Robert Babuska 1997

% Changes by Koen Maertens November 2002

help fmstruct
