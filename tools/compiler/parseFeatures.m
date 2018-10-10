function [featuresAppearance, thisDet ]= parseFeatures(dataset, Dets, featuresAppearance, segmentRange)

fileName = sprintf('features_%d_%d.mat', segmentRange(1), segmentRange(end));
if isempty(featuresAppearance), featuresAppearance.appearance = []; featuresAppearance.frames = []; end

if ~dataset.loadAppearance
    % extract features for all frames
    if dataset.halfFrameRate
        thisDet.detections = Dets.detections(ismember(Dets.detections(:, 2), segmentRange+syncTime30fps(dataset.camera)), :); 
        thisDet.partBasedDetections = Dets.partBasedDetections(ismember(Dets.detections(:, 2), segmentRange+syncTime30fps(dataset.camera)), :); 
    else
        thisDet.detections = Dets.detections(ismember(Dets.detections(:, 2), segmentRange+syncTimeAcrossCameras(dataset.camera)), :);
        thisDet.partBasedDetections = Dets.partBasedDetections(ismember(Dets.detections(:, 2), segmentRange+syncTimeAcrossCameras(dataset.camera)), :);
    end
    
    this_featuresAppearance = extractPartBasedFeatures(dataset, thisDet);    
    featuresAppearance.appearance   = [featuresAppearance.appearance; this_featuresAppearance.appearance];
    featuresAppearance.frames       = [featuresAppearance.frames, this_featuresAppearance.frames];
else
    assert(exist(fullfile(dataset.path, 'appearance', sprintf('camera%d', dataset.camera), fileName), 'file')>0,...
        'feature file does not exist...');
    
    % load precomputed features
    featuresAppearance_last = load(fullfile(dataset.path, 'appearance', sprintf('camera%d', dataset.camera), fileName));
    featuresAppearance_last = featuresAppearance_last.this_featuresAppearance;
    
    featuresAppearance.appearance   = [featuresAppearance.appearance;   featuresAppearance_last.appearance];
    featuresAppearance.frames       = [featuresAppearance.frames,       featuresAppearance_last.frames];
    
    thisDet = Dets; 
end

end
