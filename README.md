#TRiP
###Tracking Rhythms in Plants: A motion detection algorithm for estimating circadian period from leaf movement data

#####1. CONTENTS OF TRiP.zip 

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

The input directory contains 379 images of 9 plants that were imaged every 20 min. 

#####2. HOW TO RUN TRiP

1. Make a .txt file containing the cropping coordinates for each image stack including the name of the subdirectory for each image (see testdata.txt for an example). Put the image stack files into the input directory. 

2. run CropAll to generate ../input/<subdir>, each <subdir> contains an image stack for a single plant with the prefix 'crop_' and the name given in the 'txt' file.

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

3. run estimateAll which will generate a .csv file for each <subdir> in input. This csv files contains a single column of the vertical motion over time.

4. run modelFitAll passing in as input all .csv files ('../output/*.csv'). This will create a .txt and .png file with the results of model fitting (the frequency of the estimated motion). 

#####3. RUNNING TRiP ON SAMPLE DATA

Provided in the input/ directory is a test set of images from 9 col-0 plants imaged every 20 min.

1. open matlab

2. change directories to TRiP/code

3. at the matlab prompt: cropAll(’testdata.txt’);

4. when cropAll is done, you should see 9 folders in TRiP/input. Each of these folders contains 379 frames of a single plant.

5. at the matlab prompt: estimateAll;

6. when estimateAll is done, you should see 9 .csv files and 9 .png files in TRiP/ouput. Each .csv file contains the motion trace over time, and each .png file contains a plot of this motion trace over time.

7. at the matlab prompt: modelfitAll(‘../output/*.csv’);

8. when modelFitAll is done, you should see Plant1_model.txt and Plant1_model.png for all 9 plants in TRiP/ouput. These contain the results of fitting a single harmonic to the motion trace.

NOTE: the output of modelFitAll is frequency, not period. We have not included the calculation for period because it depends on the time-series resolution. To calculate period from frequency, use the following equation:

```
T = No. of frames/frequence
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

