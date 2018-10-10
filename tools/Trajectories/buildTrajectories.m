function outputTrajectories = buildTrajectories( dataset, inputTrajectories, startTime, endTime, VISUALIZE)

% convert startFrame and endFrame to the synchronized time
startTime  = startTime    + syncTime30fps(dataset.camera); 
endTime    = endTime      + syncTime30fps(dataset.camera); 

% find current, old, and future tracklets
currentTrajectoriesInd    = findTrajectories(inputTrajectories, startTime, endTime);
currentTrajectories       = inputTrajectories(currentTrajectoriesInd);


if length(currentTrajectories) <= 1
    outputTrajectories = inputTrajectories;
    return;
end

% opt tracklets used in association
inAssociation = []; tracklets = []; trackletLabels = [];
for i = 1 : length(currentTrajectories)
   for k = 1 : length(currentTrajectories(i).tracklets) 
       tracklets        = [tracklets; currentTrajectories(i).tracklets(k)]; 
       trackletLabels   = [trackletLabels; i]; 
       
       inAssociation(length(trackletLabels)) = false; 
       if k >= length(currentTrajectories(i).tracklets) - 5
           inAssociation(length(trackletLabels)) = true; 
       end
       
   end
end
inAssociation = logical(inAssociation);


% partitioning using appearance features
result = partitionAppearance(dataset, tracklets(inAssociation), trackletLabels(inAssociation), VISUALIZE);

% merge tracklets 
labels = trackletLabels; labels(inAssociation) = result.labels;
count = 1;
for i = 1 : length(inAssociation)
   if inAssociation(i) > 0
      labels(trackletLabels == trackletLabels(i)) = result.labels(count);
      count = count + 1;
   end
end

% merge co-identified tracklets 
newTrajectories = trackletStitching(tracklets, labels);
smoothTrajectories = remeasureTrajectories(newTrajectories);

outputTrajectories = inputTrajectories;
outputTrajectories(currentTrajectoriesInd) = [];
outputTrajectories = [outputTrajectories; smoothTrajectories'];

% show merged tracklets in window 
if VISUALIZE
    visualizeTrajectories; 
end

end


