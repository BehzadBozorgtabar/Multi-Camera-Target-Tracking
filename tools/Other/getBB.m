function [ centers ] = getBB( boundingBoxes )
% Returns the centers of the bounding boxes:
% left, top, right, botom

centers = [ boundingBoxes(:,1) + boundingBoxes(:,3), boundingBoxes(:,2) + boundingBoxes(:,4)];
centers = 0.5 * centers;



