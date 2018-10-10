global dataset;
dataset = [];

% Dependency configuration
ffmpegPath      = '/usr/bin/ffmpeg';
dataset.path    = '/media/bozorgta/My Passport/DukeMTMC/Data/';% local directory where the dataset is located

% data set parameters (no need to change below this point)
dataset.framesFormat = '%07d.jpg'; % set your image file type
dataset.imageWidth = 1920;
dataset.imageHeight = 1080;
