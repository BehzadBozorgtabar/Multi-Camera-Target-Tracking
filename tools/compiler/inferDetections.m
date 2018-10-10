function [detections, partBasedDetections] = inferDetections(dataset, newSetOfDetections)

% feature extraction for the bounding box 
partBasedDetections = newSetOfDetections(:, 3:end);
detections          = newSetOfDetections(:, 1:6);

% use camera transformation 
if dataset.world
    
    feetPosition = [0.5*(detections(:,5) + detections(:,3)), detections(:,6)];
    
    % check if we are running on the stairs of camera 2
    stairs_idx = zeros(size(feetPosition, 1), 1);
    addToDetections = zeros(size(feetPosition, 1), 2);  
    H = findHomography(dataset.imagePoints', dataset.worldPoints');
    worldcoords = H*[feetPosition(~stairs_idx, :) ones(size(feetPosition(~stairs_idx, :), 1), 1)]';
    worldcoords = worldcoords(1:2, :) ./ repmat(worldcoords(3, :), 2, 1);
    addToDetections(~stairs_idx, :) = worldcoords';
    detections = [detections, addToDetections];
    

else
    
    % use body centers as coordinates
    bodyCenters = getBoundingBoxCenters(detections(:,3:6));
    detections = [detections, bodyCenters];
end





