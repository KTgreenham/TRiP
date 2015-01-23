#TRiP 
##Tracking Rhythms in Plants: A motion detection algorithm for estimating circadian period from leaf movement data

###Table of Contents:
1. [Introduction to TRiP](#intro)
2. [TRiP Contents](#contents)
3. [Description of TRiP Functions](#desc)
4. [TRiP for Octave](#octave)


####<a id="intro"></a>1. Introduction to TRiP
TRiP is a matlab-based program for estimating circadian period from whole plant image data. TRiP includes a grid-based cropping function that takes each image stack as input and crops the images using grid coordinates to output image stacks for each plant. A motion estimation algorithm is applied to the image stacks and outputs a motion vector for each image over time. The motion vectors are used to estimate circadian period using a single frequency FFT-NLLS method. 

####<a id="contents"></a>2. TRiP Contents 

Within the TRiP folder are 3 directories: code/ input/ output/

The code directory contains the TRiP functions:

* cropAll.m
* errorFunc.m
* estimateAll.m
* estimateMotion.m
* evaluateModel.m
* modelFitAll.m
* space_time_deriv.m

Also within code/ is the README.txt file and the testdata.txt file required for the cropAll function described below.

The input directory contains 379 images of 9 plants that were imaged every 20 min. The README.txt file outlines the analyses of this sample data. Subsequently, the user can replace the sample images with their own image data and run the same command sequence with the directory format provided. 

####<a id="desc"></a>3. Description of TRiP Functions

* Make a .txt file containing the cropping coordinates for each image stack including the name of the subdirectory for each image (see testdata.txt for an example). Put the image stack files into the input directory. 

* run CropAll to generate ../input/subdir, each subdir contains an image stack for a single plant with the prefix 'crop_' and the name given in the 'txt' file.

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

* run estimateAll which will generate a .csv file for each <subdir> in output/. These .csv files contain a single column of the vertical motion as a function of time.

* run modelFitAll passing in as input all .csv files. This will create a .txt and .png file with the results of model fitting (the frequency of the estimated motion). 

####<a id="octave"></a>4. TRiP for Octave

NOTE: Running TRiP on Octave requires some modification to the code. We have only tested this modified code on Octave-GUI 3.8 (binary installation) run on a Mac OS X Maverick. Currently we have not found an Octave equivalent function for our ModelFit optimization step. We recommend Octave users to take the motion vectors from the EstimateAll '.csv' output files and use other available circadian period estimation platforms (ie. Biodare). We will continue to work on a modelFit code for Octave. 

* The following Octave packages and their dependencies should be installed and loaded prior to running TRiP:
```
image
optim
```
* The estimateAll step is much slower in Octave but does produce the same motion vector output.
* the matlab function 'getframe' is not available in Octave so there will be no '.png' files output with the plots. We are working on implementing an Octave equivalent function but at this time the user will have to generate the plot manually.
