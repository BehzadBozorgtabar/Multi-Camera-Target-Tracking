function tracklets   = loadTracklets(dataset)
% init tracklets
tracklets           = struct([]);


startingFrame   = syncTimeAcrossCameras(dataset.camera) + dataset.startingFrame;
endingFrame     = syncTimeAcrossCameras(dataset.camera) + dataset.endingFrame;


fileList = dir(dataset.trackletsDir); fileList = fileList(3:end);
for i = 1 : length(fileList)
    C = strsplit(fileList(i).name, '_');
    a = str2double(C{5});
    b = str2double(C{6}(1:end-4));
    
    if b > startingFrame && a < endingFrame
        temp = load(fullfile(dataset.trackletsDir, fileList(i).name));
        tracklets = [tracklets, temp.tracklets]; 
    end
end

end
