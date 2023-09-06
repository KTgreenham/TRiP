% This is a single script that runs TRiP.
% 

%% Create folders if they don't exist
mkdir '../cropped'
mkdir '../output'

%% Crop images
cropAll_ImageJ( '../input', 'crop.txt');

%% Estimate motion
estimateAll();

%% Fit model
modelFitAll_JAN2023();


