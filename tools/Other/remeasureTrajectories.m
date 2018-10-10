function newTrajectories = remeasureTrajectories( trajectories )

segmentLength = 25;

for i = 1:length(trajectories)

    segmentStart = trajectories(i).segmentStart;
    segmentEnd = trajectories(i).segmentEnd;
    
    numSegments = (segmentEnd + 1 - segmentStart) / segmentLength;
    
    alldata = {trajectories(i).tracklets(:).data};
    alldata = cell2mat(alldata');
    alldata = sortrows(alldata,2);
    [~, uniqueRows] = unique(alldata(:,2));
    
    alldata = alldata(uniqueRows,:);
    dataFrames = alldata(:,2);
    
    frames = segmentStart:segmentEnd;
    interestingFrames = round([min(dataFrames), frames(1) + segmentLength/2:segmentLength:frames(end),  max(dataFrames)]);
        
    keyData = alldata(ismember(dataFrames,interestingFrames),:);
        
    newData = interpolateTrajectories(keyData);
    
    newTrajectory = trajectories(i);
    sampleTracklet = trajectories(i).tracklets(1);
    newTrajectory.tracklets = [];
    
    
    for k = 1:numSegments
       
        tracklet = sampleTracklet;
        tracklet.segmentStart = segmentStart + (k-1)*segmentLength;
        tracklet.segmentEnd   = tracklet.segmentStart + segmentLength - 1;
        
        trackletFrames = tracklet.segmentStart:tracklet.segmentEnd;
        
        
        rows = ismember(newData(:,2), trackletFrames);
        
        tracklet.data = newData(rows,:);
        
        tracklet.startFrame = min(tracklet.data(:,2));
        tracklet.endFrame = max(tracklet.data(:,2));
        
        newTrajectory.startFrame = min(newTrajectory.startFrame, tracklet.startFrame);
        newTrajectory.endFrame = max(newTrajectory.endFrame, tracklet.endFrame);
        
        newTrajectory.tracklets = [newTrajectory.tracklets; tracklet];
        
    end
    
    newTrajectories(i) = newTrajectory;
    

end

