% call this first for Linux.
ones(10)*ones(10); 

addpath(genpath('Optimization'), genpath('tools'));

% A valid c++ compiler is needed to use the AL-ICM algorithm
run(fullfile('Optimization', '3rd party','LargeScaleCC', 'mexall.m'));


