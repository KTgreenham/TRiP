#TRiP
###Tracking Rhythms in Plants: Applying motion detection for estimating circadian period from leaf movement data

#####1. CONTENTS OF TRiP.zip 

Within the TRiP folder are 3 directories: code/ input/ output/

The code directory contains the TRiP functions:

* cropAll.m
* errorFunc.m
* estimateAll.m
* estimateMotion.m
* evaluateModel.m
* modelFit.m
* space_time_deriv.m

Also within code/ is the README.txt file and the testdata.txt file required for the cropAll function described below. 

The input directory contains 379 images of 9 plants that were imaged every 20 min. 

#####2. HOW TO RUN TRiP

1. Make a .txt file containing the cropping coordinates for each image stack including the name of the subdirectory for each image (see testdata.txt for an example). Put the image stack files into the input directory. 

2. run CropAll to generate ../input/<subdir>, each <subdir> contains an image stack for a single plant with the prefix 'crop_' and the name given in the 'txt' file.

NOTE: If you are using the ImageJ record macros function to obtain the coordinates for the crop you will need to include the following code to line 62 of the cropAll.m function in order to convert the ImageJ coordinates to the matlab format where the upper left corner is (1,1):

