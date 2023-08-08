#!/usr/bin/env python

import PyTRiP as pt
import argparse
import sys
import time
import os



# Parser
parser = argparse.ArgumentParser(description='Run TRiP on an a folder of images')
parser.add_argument('-d','--img_directory', type=str, required=True, help='Path to images to crop, or to cropped images')
parser.add_argument('-e','--img_extension', type=str, required=False, help='Image extension (e.g. JPG, PNG, TIF)', default="JPG")
parser.add_argument('-c','--crop_coords', type=str, required=False, help='Path to file containing crop coordinates', default=None)
parser.add_argument('-mt','--motion', type=str, required=False, help='Estimate motion', default=None)
parser.add_argument('-m','--model', type=str, required=False, help='Fit model to motion data', default=None)
parser.add_argument('-s','--start_img', type=int, required=False, help='Start image number', default=None)
parser.add_argument('-f','--end_img', type=int, required=False, help='End image number', default=None)
args = parser.parse_args()


# Define the arguments
images_path = args.img_directory # Path to images to crop, or to cropped images
img_extension = str(args.img_extension) # Image extension (e.g. JPG, PNG, TIF)
crop_coords = args.crop_coords # Path to file containing crop coordinates
# check if start_img is int
if args.start_img is not None:
    try:
        start_img = int(args.start_img)
    except ValueError:
        start_img = None
        print("start_img must be an integer")
else:
    start_img = None
# check if end_img is int
if args.end_img is not None:
    try:
        end_img = int(args.end_img)
    except ValueError:
        end_img = None
        print("end_img must be an integer")
else:
    end_img = None


if str(args.motion) == "True":
    motion = True
else:
    motion = False
if str(args.model) == "True":
    model = True
else:
    model = False


# Run the functions
def TRiP():
    start_all = time.time()
    # Check if images_path exists
    assert os.path.exists(images_path), "I did not find the file at, "+str(images_path)

    if crop_coords is not None:
        start_time = time.time() # start timer
        pt.crop_all(images_path, crop_coords, img_extension, start_img=start_img, end_img=end_img)
        end_time = time.time()  # End timer
        total_time = round(end_time - start_time,2)
        print("\nTime to crop: ", total_time, " seconds")
        print("-----------------------------------\n")

    if motion == True:
        start_time = time.time() # start timer
        pt.estimateAll(img_extension=img_extension) # Estimate motion
        end_time = time.time()  # End timer
        total_time = round(end_time - start_time,2)
        print("\nTime to estimate motion: ", total_time, " seconds")
        print("-----------------------------------\n")
    
    if model == True:
        start_time = time.time()
        pt.ModelFitALL() # Fit model to motion data
        end_time = time.time()  # End timer
        total_time = round(end_time - start_time,2)
        print("\nTime to fit model: ", total_time, " seconds")
        print("-----------------------------------")
    
    end_all = time.time()
    total_time_all = round(end_all - start_all,2)
    print("\nPyTRiP Execution completed!\n")
    print("Total time: ", total_time_all, " seconds\n\n")


if __name__ == "__main__":
    TRiP()

# Example usage:
# python3 TRiP.py -d ../../input/ -c ../crop.txt -mt True -m True
