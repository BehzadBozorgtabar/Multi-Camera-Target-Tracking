function [motionScores, impossibilityMatrix] = motionAff(detectionCenters,detectionFrames,estimatedVelocity, speedLimit, beta)

numDetections       = size(detectionCenters,1);
impossibilityMatrix = zeros(length(detectionFrames));

frameDifference = pdist2(detectionFrames, detectionFrames);
velocityX       = repmat(estimatedVelocity(:,1), 1, numDetections );
velocityY       = repmat(estimatedVelocity(:,2), 1, numDetections );
centerX         = repmat(detectionCenters(:,1), 1, numDetections );
centerY         = repmat(detectionCenters(:,2), 1, numDetections );

errorXForward = centerX + velocityX.*frameDifference - centerX';
errorYForward = centerY + velocityY.*frameDifference - centerY';

errorXBackward = centerX' + velocityX' .* -frameDifference' - centerX;
errorYBackward = centerY' + velocityY' .* -frameDifference' - centerY;

errorForward  = sqrt( errorXForward.^2  + errorYForward.^2);
errorBackward = sqrt( errorXBackward.^2 + errorYBackward.^2);


predictionError = min(errorForward, errorBackward);
predictionError = triu(predictionError) + triu(predictionError)';

 
xDiff = centerX - centerX';
yDiff = centerY - centerY';
distanceMatrix = sqrt(xDiff.^2 + yDiff.^2);

sameFrame = frameDifference == 0;
skipMatrix = logical(sameFrame .* (distanceMatrix < 20));

maxRequiredSpeedMatrix = distanceMatrix ./ abs(frameDifference);
predictionError(maxRequiredSpeedMatrix > speedLimit) = inf;
impossibilityMatrix(maxRequiredSpeedMatrix > speedLimit) = 1;

impossibilityMatrix(skipMatrix) = 0;

motionScores = 1 - beta*predictionError;

