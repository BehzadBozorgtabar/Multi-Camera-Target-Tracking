clear; 
close all; 
trackparam; 
setup;
configFile   = 'camera_configs/camera3.config';
dataset      = loadSetting(configFile, dataset);
VISUALIZE    = false;

%% the total number of frames for each camera
NUM_OF_FRAMES = [359580, 360720, 355380, 374850, 366390, 344400, 337680, 353220]; 
if dataset.startingFrame + syncTimeAcrossCameras(dataset.camera) < 1 
    error('ERROR'); 
end

dataset = changeFPS(dataset); 


%% Generate Target Tracklets

Dets = parseDet(dataset); 
features  = []; 
tracklets = struct([]);


for startFrame   = dataset.startingFrame : dataset.tracklets.frameInterval : dataset.endingFrame

    fprintf('%d/%d\n', startFrame, dataset.endingFrame);
    endFrame     = startFrame + dataset.tracklets.frameInterval - 1;
    segmentRange = startFrame : endFrame;
    
    % extract appearance features
    [features, thisDets]         = parseFeatures(dataset, Dets, features, segmentRange);
    [filteredDetections, filteredFeatures] = nms(dataset, thisDets, features);
    tracklets = buildTracklets(dataset, filteredDetections, filteredFeatures, startFrame, endFrame, tracklets, VISUALIZE);
end

%% Generate Trajectories 
lastEndLoaded       = 0;

% initialize range
startTime = dataset.startingFrame - dataset.trajectories.windowWidth + 1;
endTime   = dataset.startingFrame + dataset.trajectories.windowWidth - 1;

trajectories = trackletStitching(tracklets,1:length(tracklets));

while startTime <= dataset.endingFrame

    close all;
    fprintf('Window %d...%d\n', startTime, endTime);
    
    trajectories = buildTrajectories( dataset, trajectories, startTime, endTime, VISUALIZE);
    
    % update loop range
    startTime = endTime   - dataset.trajectories.overlap;
    endTime   = startTime + dataset.trajectories.windowWidth;
end

% save trajectories
trackerOutput = saveTrajectories(trajectories);

%% Change into the real video fps% 
dataset = revertFPS(dataset);
myOutput = changeOutput(dataset, trackerOutput);

if exist('results','dir') == 0
    mkdir('results');
end
fname = sprintf('results/cam%d_%07d_%07d.txt',[dataset.camera, dataset.startingFrame, dataset.endingFrame]);
dlmwrite(fname, myOutput, 'delimiter', ' ', 'precision', 6);

rmpath(genpath('Optimization'));
rmpath(genpath('tools'));

