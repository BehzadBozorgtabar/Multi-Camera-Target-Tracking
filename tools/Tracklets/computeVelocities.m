function estimatedVelocities = computeVelocities(originalDetections, startFrame, endFrame, nearestNeighbors, speedLimit)

% Find detections in search range
searchRangeMask    = interlude(originalDetections(:,2), startFrame - nearestNeighbors, endFrame+ nearestNeighbors);
searchRangeCenters = getBB(originalDetections(searchRangeMask, 3:6));
searchRangeFrames  = originalDetections(searchRangeMask, 2);
detectionIndices   = interlude(searchRangeFrames, startFrame, endFrame);

% Compute all pairwise distances 
pairDistance        = pdist2(searchRangeCenters,searchRangeCenters);
numDetections       = length(detectionIndices);
estimatedVelocities = zeros(numDetections,2);

% Estimate the velocity of each detection
for i = 1:numDetections
    
    currentDetectionIndex = detectionIndices(i);
    
    velocities = [];
    currentFrame = searchRangeFrames(currentDetectionIndex);
    
    for frame = currentFrame-nearestNeighbors:currentFrame+nearestNeighbors
        
        % Skip original frame
        if abs(currentFrame-frame) <= 0
            continue;
        end
        
        detectionsAtThisTimeInstant = searchRangeFrames == frame;
        
        % Skip if no detections in the current frame
        if sum(detectionsAtThisTimeInstant) == 0
            continue;
        end
        
        distancesAtThisTimeInstant = pairDistance(currentDetectionIndex,:);
        distancesAtThisTimeInstant(detectionsAtThisTimeInstant==0) = inf;
        
        % Find detection closest to the current detection
        [~, targetDetectionIndex] = min(distancesAtThisTimeInstant);
        estimatedVelocity = searchRangeCenters(targetDetectionIndex,:) - searchRangeCenters(currentDetectionIndex,:);
        estimatedVelocity = estimatedVelocity / (searchRangeFrames(targetDetectionIndex) - searchRangeFrames(currentDetectionIndex));
        
        % Check if speed limit is violated
        estimatedSpeed = norm(estimatedVelocity);
        if estimatedSpeed > speedLimit
            continue;
        end
        
        % Update velocity estimates
        velocities = [velocities; estimatedVelocity];
        
    end
    
    if isempty(velocities)
        velocities = [0 0];
    end
    
    % Estimate the velocity
    estimatedVelocities(i,1) = mean(velocities(:,1));
    estimatedVelocities(i,2) = mean(velocities(:,2));
    
end




