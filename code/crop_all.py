# import libraries
from pathlib import Path
from PIL import Image
import os
import sys
import pandas as pd
import numpy as np
import time


# Print user's arguments
arg1 = str(sys.argv[1])  # images_path
arg2 = str(sys.argv[2]) # cropfile_path
arg3 = str(sys.argv[3]) # img_extension
print("\nImages folder: ", arg1)
print("Path to crop file: ", arg2)
print("Images' extension: .", arg3)
print("\n")

# Define `crop_all` function
def crop_all(images_path, cropfile_path, img_extension):

    img_extension = '*.' + img_extension
    images = Path(images_path).glob(img_extension)
    images = [str(p) for p in images]
    images.sort()

    # Read crop file
    crop_coords = pd.read_csv(cropfile_path, sep='\t', header=None)

    # Create empty lists for ID (key) and value (coordinates)
    keys = []
    values = []

    # Gather IDs and coordinates
    for plant in range(len(crop_coords)):
        # Get ID (path to each 'cropped' folder)
        plant_ID = crop_coords.iloc[plant,0] #
        plant_ID = plant_ID.split(" ")[0] # Split by " "; take the first
        keys.append(plant_ID) # Add this to the 'keys' list
        # Get coordinates
        coords = crop_coords.iloc[plant,0]
        coords = coords.split(" ")[1:]  # This must change if using \t sep!!
        coords = [int(i) for i in coords] # Convert values to integers
        values.append(tuple(coords))  # Append coords as tupple

    # Arrange keys and values in a dictionary
    regions = dict(zip(keys, values))

    ti = len(images)  # total images (ti)
    ci = 0  # current image (ci)

    # Loop thorugh each original image
    for i in images:
        # Current image
        ci = ci+1
        print(f'Processing image {ci}/{ti}: {i}')
        # Read image and convert to array
        image = Image.open(i)
        image = np.array(image)
        # Extract and save the cropped images (assuming imagej's format)
        for plant, coords in regions.items():
            imj_col1 = coords[0] # vertical left
            imj_row1 = coords[1] # hortizontal bottom
            imj_col2 = imj_col1 + coords[2] # vertical right
            imj_row2 = imj_row1 + coords[3] # horizontal top
            # Veryfy path exists, otherwise create folder
            cropped_path = '../cropped/' + plant + '/'  # path
            cropped_path = os.path.dirname(cropped_path) # convert to string
            if not os.path.exists(cropped_path):  # verify if exist
                os.makedirs(cropped_path)
            # Define cropped image's full path
            cropped_path = cropped_path + '/crop_' + i.split('/')[-1]
            # Crop image
            cropped_image = image[imj_row1:imj_row2,imj_col1:imj_col2,:] # crop
            sub_image = Image.fromarray(cropped_image)  # Convert to PIL format
            sub_image.save(cropped_path) # Save image

    # Print where images were saved
    print("\nAll folders were saved in: ../cropped/")




# Define input variables
images_path = arg1
crop_coords = arg2
img_extension = arg3

# Execute function
start_time = time.time() # #tart timer
crop_all(images_path, crop_coords, img_extension) # Crop images
end_time = time.time()  # End timer
total_time = round(end_time - start_time,2)
print("\nExecution time: ", total_time, " seconds\n")




# Instructions
# 1. Make sure you have a folder "input" with images, and another "code" with the code.
# 2. Open the terminal and set "code" as current directory:
#### cd code
# 3. Execute the python script providing three arguments separated by comma: input path; crop file; image extension. These arguments should be placed after calling python (python) and the cropping function (crop_all.py):
#### python crop_all.py ../input C1_crop.txt JPG
