#TRiP 
##Tracking Rhythms in Plants: A motion detection algorithm for estimating circadian period from leaf movement data

###Table of Contents:
1. [Introduction to TRiP](#intro)
2. [TRiP Contents](#contents)
2. [Description of TRiP Functions](#desc)
3. [Running TRiP on Sample Data](#data)
4. [TRiP for Octave](#octave)
5. [Running TRiP on Octave](#runOc)

####<a id="intro"></a>1. Introduction to TRiP
TRiP is a matlab-based program for estimating circadian period from whole plant image data. TRiP includes a grid-based cropping function that takes each image stack as input and crops the images using grid coordinates to output image stacks for each plant. A motion estimation algorithm is applied to the image stacks and outputs a motion vector for each image over time. The motion vectors are used to estimate circadian period using a single frequency FFT-NLLS method. 

####<a id="contents"></a>1. TRiP Contents 

Within the TRiP folder are 3 directories: code/ input/ output/

The code directory contains the TRiP functions:

* cropAll.m
* errorFunc.m
* estimateAll.m
* estimateMotion.m
* evaluateModel.m
* modelFitAll.m
* README.txt
* screen_shot_matlab.pptx
* space_time_deriv.m
* testdata.txt

Also within code/ is the README.txt file and the testdata.txt file required for the cropAll function described below. 

The input directory contains 379 images of 9 plants that were imaged every 20 min. 

####<a id="desc"></a>2. Description of TRiP Functions

* Make a .txt file containing the cropping coordinates for each image stack including the name of the subdirectory for each image (see testdata.txt for an example). Put the image stack files into the input directory. 

* run CropAll to generate ../input/<subdir>, each <subdir> contains an image stack for a single plant with the prefix 'crop_' and the name given in the 'txt' file.

NOTE: If you are using the ImageJ record macros function to obtain the coordinates for the crop you will need to include the following code to line 62 of the cropAll.m function in order to convert the ImageJ coordinates to the matlab format where the upper left corner is (1,1):

```
y3 = y2;
y4 = y2 + x2;
x3 = y1;
x4 = y1 +x1;
```

In addition, replace line 64 with:
```
imC = im(y3:y4,x3:x4, :);
```

* run estimateAll which will generate a .csv file for each <subdir> in input. This csv files contains a single column of the vertical motion over time.

* run modelFitAll passing in as input all .csv files ('../output/*.csv'). This will create a .txt and .png file with the results of model fitting (the frequency of the estimated motion). 

####<a id="data"></a>3. Running TRiP on Sample Data

Provided in the input/ directory is a test set of images from 9 col-0 plants imaged every 20 min.

* open matlab

* change directories to TRiP/code

* at the matlab prompt: 
```
cropAll('testdata.txt');
```
* when cropAll is done, you should see 9 folders in TRiP/input. Each of these folders contains 379 frames of a single plant.
* at the matlab prompt: 
```
estimateAll;
```
* when estimateAll is done, you should see 9 .csv files and 9 .png files in TRiP/ouput. Each .csv file contains the motion trace over time, and each .png file contains a plot of this motion trace over time.
* at the matlab prompt: 
```
modelfitAll('../output/*.csv');
```
* when modelFitAll is done, you should see Plant1_model.txt and Plant1_model.png for all 9 plants in TRiP/ouput. These contain the results of fitting a single harmonic to the motion trace.

NOTE: the output of modelFitAll is frequency, not period. We have not included the calculation for period because it depends on the time-series resolution. To calculate period from frequency, use the following equation:

```
T = No. of frames/frequency
Period = T/No. of images per hour
```
Example:
The test data plants were imaged every 20 min. The period for Plant1:
```
T = 360/4.744690
P = 75.87/3
P = 25.3
```
NOTE: We have provided a .pptx file ('screen_shot_matlab.pptx') showing screen shots of each step. We have tested TRiP on MAtlab_2014a for MacOS X and Windows.

####<a id="octave"></a>4. TRiP for Octave

NOTE: Running TRiP on Octave requires some modification to the code. We have only tested this modified code on Octave-GUI 3.8 (binary installation) run on a Mac OS X Maverick. Currently we have not found an Octave equivalent function for our ModelFit optimization step. We recommend Octave users to take the motion vectors from the EstimateAll '.csv' output files and use other available circadian period estimation platforms (ie. Biodare). We will continue to work on a modelFit code for Octave. 

* The following Octave packages and their dependencies should be installed and loaded prior to running TRiP:
```
image
optim
```
* The estimateAll step is much slower in Octave but does produce the same motion vector output.
* the matlab function 'getframe' is not available in Octave so there will be no '.png' files output with the plots. We are working on implementing an Octave equivalent function but at this time the user will have to generate the plot manually.

#####<a id="runOc"></a>5. Running TRiP on Octave
* Open Octave
* In the file browser window, change directories to TRiP/code
* In the Octave command window:
```
pkg load image
pkg load optim
```
* In the Octave command window:
```
cropAll('testdata.txt');
```
* When cropAll is complete, you should see 9 folders in TRiP/input. Each of these folders should contain 379 frames of a single plant.
* In the command window:
```
EstimateAll;
```
* When estimateAll is complete, you should see 9 .csv files in TRiP/output. Each .csv file contains the motion vectors over time.
* The motion vectors are the input to the circadian period estimation method of choice. 
