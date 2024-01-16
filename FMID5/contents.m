% Fuzzy Modeling and Identification Toolbox for MATLAB 5
% Version 3.02 April 2001
% Copyright (c) 1997-99 Robert Babuska, all rights reserved
% Contributors to version 3.0 and higher: Magne Setnes, Stanimir Mollov, Peter van der Veen
%
% What's new -- see readme.m:
%
% Model building and simulation
%   fmclust    - build a MIMO NARX fuzzy model by product-space fuzzy clustering
%   fmdof      - compute the degree of fulfillment
%   fmest      - (re)estimates the consequent parameters in FM
%   fmsim      - simulate a MIMO NARX fuzzy model
%   fmtune     - simplify membership functions and reduce the fuzzy model
%
% Maintenance and documentation utilities
%   fmodel     - generate a fuzzy model structure 
%   fmsort     - sort rules in FM, using a given index vector
%   fmupgrade  - upgrade FM from previous versions
%   fm2tex     - export a fuzzy model into a LaTEX file
%   fm2ws      - export the fields of FM as variables to (local) workspace
%
% Model inspection and analysis
%   plotcons   - plot the consequent as functions of cluster centers
%   plotdata   - plot the data in Dat (time and scatter plots)
%   plotmfs    - plot membership functions
%   plotout    - plot the outputs as functions of individual inputs
%   plotpart   - plot the fuzzy partition obtained by FMCLUST
%
% Performance measures
%   rms        - root-mean squared error (performance index)
%   vaf        - variance accounted for (performance index)
%
% Demos
%   fmidemo    - menu with demos
%   endemo1    - SISO model of throttle--speed relation
%   endemo2    - MISO model of throttle--pressure relation
%   endemo3    - SIMO model of throttle--(speed,pressure) relation
%   lldemo1    - SISO model of one-tank process
%   ll4demo1   - MIMO model of four-tank process
%   statdemo   - static SISO function (sine)
%   wwdemo     - SIMO model of waste-water treatment process
%   see also the subdirectories of the Demos directory
