#!/usr/bin/env python

import PyTRiP as pt
import argparse
import time

# Parser
parser = argparse.ArgumentParser(description='Crop images given a .txt file with corresponding coordinates')
parser.add_argument('-d','--img_directory', type=str, required=True, help='Path to images to crop')
parser.add_argument('-c','--crop_coords', type=str, required=True, help='Path to file containing crop coordinates')
parser.add_argument('-e','--img_extension', type=str, required=False, help='Image extension (e.g. JPG, PNG, TIF)', default="JPG")
parser.add_argument('-s','--start_img', type=int, required=False, help='Start image number', default=None)
parser.add_argument('-f','--end_img', type=int, required=False, help='End image number', default=None)
args = parser.parse_args()

# Define the arguments
images_path = args.img_directory # Path to images to crop
crop_coords = args.crop_coords # Path to file containing crop coordinates
# if args.img_extension != None:
#     img_extension = str(args.img_extension) # Image extension (e.g. JPG, PNG, TIF)
# else:
#     img_extension = "JPG"
img_extension = str(args.img_extension)
start_img = args.start_img
end_img = args.end_img

# Run the function
start_time = time.time() # #tart timer
pt.crop_all(images_path, crop_coords, img_extension, start_img=start_img, end_img=end_img)
end_time = time.time()  # End timer
total_time = round(end_time - start_time,2)
print("\nTime to crop: ", total_time, " seconds\n")

# Example usage:
# python3 crop.py -d /Users/User/Documents/TRiP/PyTRiP/input/crop_coords.txt -e JPG -s 1 -f 2
