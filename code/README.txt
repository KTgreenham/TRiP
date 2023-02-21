--------------------
Introduction to TRiP
--------------------

TRiP is a matlab-based program for estimating circadian period from whole plant image data. TRiP includes a grid-based cropping function that takes each image stack as input and crops the images using grid coordinates to output image stacks for each plant. A motion estimation algorithm is applied to the image stacks and outputs a motion vector for each image over time. The motion vectors are used to estimate circadian period using a single frequency FFT-NLLS analysis. The current code has been tested on Matlab 2014b for Mac.

-------------
TRiP Contents 
-------------

Within the TRiP folder are 3 directories: code/ input/ output/

The code directory contains the TRiP functions:
cropAll_ImageJ.m
errorFunc.m
estimateAll.m
estimateMotion.m
evaluateModel.m
modelFitAll_JAN2023.m
space_time_deriv.m

Also within code/ is the crop.txt file required for the cropAll function described below. 

The input directory contains 384 images of 50 plants that were imaged every 20 min. 

-----------------------------
Description of TRiP Functions
-----------------------------

1. Make a .txt file containing the cropping coordinates for each image stack including the name of the subdirectory for each image (see crop.txt for an example). Put the image stack files into the input directory. 

2. run CropAll_ImageJ to generate ../input/<subdir>, each <subdir> contains an image stack for a single plant with the prefix 'crop_' and the name given in the 'txt' file.


3. run estimateAll. This will generate a .csv and a .png file for each <subdir> in output. These .csv files contain a single column of the vertical motion as a function of time and the .png files shows a plot of the vertical motion for each plant.

4. run modelFitAll. This takes all the .csv files found in the output directory. This will create a .txt and a .png file with the results of model fitting (the frequency of the estimated motion) for each plant and one .csv file with 4 columns containing the 'Period', 'Phase', 'Rsquared', and 'RAE'. 

---------------------------
Running TRiP on Sample Data
---------------------------

1. open matlab

2. change directories to the /code directory.

3. at the matlab prompt: 

cropAll_ImageJ( '../input', 'crop.txt');

4. when cropAll is done, you should see 50 folders in /input. Each of these folders contains 384 frames of a single plant.

5. at the matlab prompt: 

estimateAll;

6. when estimateAll is done, you should see 50 .csv files and 50 .png files in /ouput. Each .csv file contains the motion trace over time, and each .png file contains a plot of this motion trace over time.

7. at the matlab prompt: 

modelfitAll_JAN2023;

8. when modelFitAll is done, you should see Plant1_model.txt and Plant1_model.png for all 50 plants in /ouput. These contain the results of fitting a single harmonic to the motion trace.

NOTE: The .txt output of modelFitAll is frequency, not period. We have not included the calculation for period because it depends on the time-series resolution. You can include this calculation in the modelFitAll code (which we have done in modelfitAll_JAN2023) or do it separately in a spreadsheet application. To calculate period from frequency, use the following equation:


To calculate period from frequency:

T = No. of frames (based on estimateAll output .csv file)/frequency
Period= T/# of images per hour

Example:

The testdata plants were imaged every 20 min. The period for Plant1:

T = 360/4.730735
P = 76.09/3
Period = 25.4

