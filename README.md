# Multi-Camera-Target-Tracking

The proposed tracker can process single and multiple cameras.

## Usage

To process all cameras, you can run `trackAllCams.m` then the video frames from multiple cameras will be processed sequentially.
Please note that you need to convert videos into the frame sequences using ffmpeg or any standard converter. Then, locate the dataset directory you want to use in `trackparam.m`. 

There are configuration files for the cameras named `camera<camnum>.config`, where `<camnum>` is camera number. In there, you can set start and end time by manipulating `startingFrame` and `endingFrame` respectively. Note that you should set time synced to master camera(e.g. camera no.5 in example dataset). Besides, you have to make desired fps detection data using the scrip `detFPS.m`, which is located in `tools/functions/`. 

In addition, `main.m` performs single camera tracking. 

## Dataset

You can use any multi-camera tracking dataset given the camera parameters. For example  DukeMTMC dataset from [here](http://vision.cs.duke.edu/DukeMTMC/).
