function fmidemo
%FMIDEMO Demonstration to the Fuzzy Modeling and Identification Toolbox.
%        Presents a menu with different examples.

%       Copyright (c) 1997 Robert Babuska.

while 1
close all

labels = {...
        'Static SISO function', ...
        'SISO model of throttle--speed relation', ...
        'MISO model of throttle--pressure relation', ...
        'SIMO model of throttle--(speed,pressure) relation', ...
        'SIMO model of waste-water treatment process', ...
        'SISO model of one-tank process', ...
        'MIMO model of four-tank process', ...
        'Quit'};

% Callbacks
callbacks = [ ...
        'statdemo  '
        'endemo1   '
        'endemo2   '
        'endemo3   '
        'wwdemo    '
        'lldemo1   '
        'll4demo1  '
        '          '];

opt = menu('Fuzzy Modeling and Identification Toolbox Demos',labels);
eval(callbacks(opt,:));
if opt == 8, return; end;
end;