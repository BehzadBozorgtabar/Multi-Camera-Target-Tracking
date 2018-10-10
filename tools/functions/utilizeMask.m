function [ frame ] = utilizeMask( dataset, i )

i2 = i*2;
frame = imread(fullfile('/media/bozorgta/My Passport/DukeMTMC/masks', sprintf('camera%d/%d.png', dataset.camera, i2)));
