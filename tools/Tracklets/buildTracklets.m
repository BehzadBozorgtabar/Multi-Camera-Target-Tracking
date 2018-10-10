function  tracklets = buildTracklets(dataset, originalDetections, allFeatures, startFrame, endFrame, tracklets, VISUALIZE)

params          = dataset.tracklets;
totalLabels     = 0; currentInterval = 0;

% convert startFrame and endFrame to the synchronized time
startFrame  = startFrame    + syncTime30fps(dataset.camera);
endFrame    = endFrame      + syncTime30fps(dataset.camera); 


% find detections for the current frame interval
currentDetectionsIDX    = interlude(originalDetections(:,2), startFrame, endFrame);

if length(currentDetectionsIDX) < 2, return; end

% compute bounding box centeres
detectionCentersImage   = getBB(originalDetections(currentDetectionsIDX, 3:6)); 
detectionCenters        = detectionCentersImage;
detectionFrames         = originalDetections(currentDetectionsIDX, 2);

% Estimate velocities
estimatedVelocity       = computeVelocities(originalDetections, startFrame, endFrame, params.nearestNeighbors, params.speedLimit);

% Spatial groupping
spatialGroupIDs         = SpatialGroup(dataset.useGrouping, currentDetectionsIDX, detectionCenters, params);


%% Creating tracklets
fprintf('Building tracklets: ');
for spatialGroupID = 1 : max(spatialGroupIDs)
    
    elements = find(spatialGroupIDs == spatialGroupID);
    spatialGroupObservations        = currentDetectionsIDX(elements);
    
    % Appearance and motion affinity 
    appearanceScores                = AppearanceCorrelation(spatialGroupObservations, allFeatures, params.distanceType, params.alpha);
    spatialGroupDetectionCenters    = detectionCenters(elements,:);
    spatialGroupDetectionFrames     = detectionFrames(elements,:);
    spatialGroupEstimatedVelocity   = estimatedVelocity(elements,:);
    [motionScores, impMatrix]       = motionAff(spatialGroupDetectionCenters,spatialGroupDetectionFrames,spatialGroupEstimatedVelocity,params.speedLimit, params.beta);
    
    % Fuse affinities
    correlationMatrix               = motionScores + appearanceScores - 1; 
    correlationMatrix(impMatrix==1) = -inf;
    intervalDistance                = pdist2(spatialGroupDetectionFrames,spatialGroupDetectionFrames);
    discountMatrix                  = min(1, -log(intervalDistance/params.frameInterval));
    correlationMatrix               = correlationMatrix .* discountMatrix;
    
    
    % graph partitioning 
    fprintf('%d ',spatialGroupID);
    greedySolution = AL_ICM(sparse(correlationMatrix));
    
    if strcmp(dataset.method,'AL-ICM')
        labels = greedySolution;
    elseif strcmp(dataset.method,'BIP')
        labels = solveBIP(correlationMatrix,greedySolution);
    end
    
    labels      = labels + totalLabels;
    totalLabels = max(labels);
    identities  = labels;
    originalDetections(spatialGroupObservations, 1) = identities;
    
end
fprintf('\n');

%% FINAL TRACKLETS
trackletsToSmooth  = originalDetections(currentDetectionsIDX,:);
featuresAppearance = allFeatures.appearance(currentDetectionsIDX);
smoothedTracklets  = flatten(trackletsToSmooth, startFrame, params.frameInterval, featuresAppearance, params.minTrackletLength, currentInterval);

% assign IDs to all tracklets
for i = 1:length(smoothedTracklets)
    smoothedTracklets(i).id = i;
    smoothedTracklets(i).ids = i;
end

% attach new tracklets to the ones already exist 
if ~isempty(smoothedTracklets)
    ids = 1 : length(smoothedTracklets); %#ok
    tracklets = [tracklets, smoothedTracklets];
end


if ~isempty(tracklets)
    tracklets = nestedSortStruct(tracklets,{'startFrame','endFrame'});
end

