function smoothedTracklets = flatten( tracklets, segmentStart, segmentInterval, featuresAppearance, minTrackletLength, currentInterval )


trackletIDs          = unique(tracklets(:,1));
numTracklets         = length(trackletIDs);
smoothedTracklets    = struct([]);

for i = 1:numTracklets

    mask = tracklets(:,1)==trackletIDs(i);
    detections = tracklets(mask,:);
    
    % Reject tracklets of short length
    start = min(detections(:,2));
    finish = max(detections(:,2));
    
    if (size(detections,1) < minTrackletLength) || (finish - start < minTrackletLength)
        continue;
    end

    intervalLength = finish-start + 1;
    
    datapoints = linspace(start, finish, intervalLength);
    frames     = detections(:,2);
    
    currentTracklet      = zeros(intervalLength,size(tracklets,2));
    currentTracklet(:,1) = ones(intervalLength,1) .* trackletIDs(i);
    currentTracklet(:,2) = [start : finish];
    
    % Fit left, top, right, bottom, xworld, yworld
    for k = 3:size(tracklets,2)
       
        points    = detections(:,k);
        p         = polyfit(frames,points,1);
        newpoints = polyval(p, datapoints);
        
        currentTracklet(:,k) = newpoints';
    end
    
    
    
    % Compute appearance features
    medianFeature    = median(cell2mat(featuresAppearance(mask)));
    centers          = getBB(currentTracklet(:,[3:6]));
    centerPoint      = median(centers); 
    centerPointWorld = median(currentTracklet(:,[7,8]));
    
    % Add to tracklet list
    smoothedTracklets(end+1).feature       = medianFeature; 
    smoothedTracklets(end).center          = centerPoint;
    smoothedTracklets(end).centerWorld     = centerPointWorld;
    smoothedTracklets(end).data            = currentTracklet;
    smoothedTracklets(end).features        = featuresAppearance(mask);
    smoothedTracklets(end).realdata        = detections;
    smoothedTracklets(end).mask            = mask;
    smoothedTracklets(end).startFrame      = start;
    smoothedTracklets(end).endFrame        = finish;
    smoothedTracklets(end).interval        = currentInterval;
    smoothedTracklets(end).segmentStart    = segmentStart;
    smoothedTracklets(end).segmentInterval = segmentInterval;
    smoothedTracklets(end).segmentEnd      = segmentStart + segmentInterval - 1;
    
end



