function [features] = extractPartBasedFeatures(dataset, allDets)
% This function computes feature histograms for all parts of each detection 

partBasedDetections     = allDets.partBasedDetections;
detections              = allDets.detections;

features.appearance = cell(size(detections, 1), 1);

count = 1;
for frame = unique(detections(:, 2))'
    
    % clc
    fprintf('Computing features, \n');
    if dataset.halfFrameRate
        fprintf('%d/%d\n', frame-syncTime30fps(dataset.camera), max(detections(:, 2))-syncTime30fps(dataset.camera));
    else
        fprintf('%d/%d\n', frame-syncTimeAcrossCameras(dataset.camera), max(detections(:, 2))-syncTimeAcrossCameras(dataset.camera));
    end
    
    rows = find(detections(:,2) == frame);
      
    image = readFrameback(dataset, frame); 
    
    if isempty(rows)
        continue;
    end
     
    partBasedDetectionsFrame = int32(partBasedDetections(rows,:));
    height = dataset.imageHeight;
    width = dataset.imageWidth;
    
    maxIndex = size(partBasedDetectionsFrame,2) - 2;
    
    left = max(1,partBasedDetectionsFrame(:,9:4:maxIndex));
    top = max(1,partBasedDetectionsFrame(:,10:4:maxIndex));
    right = min(width,partBasedDetectionsFrame(:,11:4:maxIndex));
    bottom = min(height,partBasedDetectionsFrame(:,12:4:maxIndex));
    
    for k = 1 : size(left,1)
        
        feature = [];
        
        for i = 1 : size(left,2)
            
            y1 = min(top(k,i),height);
            y2 = max(bottom(k,i),1);
            x1 = min(left(k,i),width);
            x2 = max(right(k,i),1);
                        
            histogram = featureHistogram(image(y1:y2,x1:x2,:));
            feature = [feature, histogram];
            
        end
        
        features.appearance{count}  = feature;
        features.frames(count)       = frame;
        count = count + 1;
    end
    
%     pause
end


