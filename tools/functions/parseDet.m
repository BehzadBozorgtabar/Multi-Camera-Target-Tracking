function [allDets] = parseDet(dataset)

% parse detections results 

allDets.currentDetections   = [];
allDets.detections          = [];
allDets.partBasedDetections = [];

temp = load(fullfile(dataset.path, 'detections', sprintf('camera%d_30.mat', dataset.camera)));
temp.detections = temp.newdet;
temp.detections = temp.detections(temp.detections(:, 2) >= (dataset.startingFrame+syncTime30fps(dataset.camera)) & temp.detections(:, 2) <= (dataset.endingFrame+syncTime30fps(dataset.camera)), :);
[temp_det, temp_part]       = inferDetections(dataset, temp.detections);
allDets.detections          = temp_det;
allDets.partBasedDetections = temp_part;
allDets.currentDetections   = temp.detections;

end

