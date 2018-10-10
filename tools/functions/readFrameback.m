function [ frame ] = readFrameback( dataset, i )

i2 = i*2;
frame = imread(fullfile(dataset.path, 'frames', sprintf(['camera%d/' dataset.framesFormat], dataset.camera, i2)));
