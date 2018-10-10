function dataset = revertFPS(dataset)

startFrame = dataset.startingFrame;
endFrame = dataset.endingFrame;

dataset.startingFrame = dataset.startingFrame_temp;
dataset.endingFrame = dataset.endingFrame_temp;

dataset.startingFrame_temp = startFrame;
dataset.endingFrame_temp = endFrame;
