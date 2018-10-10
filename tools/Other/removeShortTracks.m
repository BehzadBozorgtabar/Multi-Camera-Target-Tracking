function [ detectionsUpdated ] = removeShortTracks( detections, cutoffLength )

detectionsUpdated = detections;

detections = sortrows(detections, [1, 2]);

personIDs = unique(detections(:,1));
lengths = hist(detections(:,1), personIDs)';

[~,~, removedIDs] = find( personIDs .* (lengths <= cutoffLength));

detectionsUpdated(ismember(detectionsUpdated(:,1),removedIDs),:) = [];

