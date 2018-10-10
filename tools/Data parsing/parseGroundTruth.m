function [ groundTruth ] = parseGroundTruth( dataset )

groundTruth = csvread(dataset.groundTruth);

% Keep frames for which we have ground truth
timeFilter = groundTruth(:,2)<=dataset.numberOfFrames;

% Keep only detections within the frame borders
frameFilter = (groundTruth(:,3)>=1) .* (groundTruth(:,4)>=1) ...
    .* (groundTruth(:,5)<=dataset.imageWidth).* (groundTruth(:,6)<=dataset.imageHeight);

filter = logical( frameFilter .* timeFilter );
groundTruth = groundTruth(filter,:);
groundTruth  = sortrows(groundTruth,[2 1]);

% Use camera transformation 
if dataset.world

    projectiveTransformation = fitgeotrans(dataset.movingPoints, dataset.fixedPoints, 'Projective');

    % Add world coordinates
    feetPositionGT = [ 0.5*(groundTruth(:,5) + groundTruth(:,3)), groundTruth(:,6) ];
    worldcoordsGT = transformPointsForward(projectiveTransformation, feetPositionGT)/100;
    groundTruth = [ groundTruth, worldcoordsGT ];
    
end
    
    
