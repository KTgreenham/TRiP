
# PyTRiP - a Python version of TRiP

[TRiP](https://plantmethods.biomedcentral.com/articles/10.1186/s13007-015-0075-5) is a program for estimating circadian period from whole plant image data. PyTRiP is an open-source version of the [original TRiP code](https://github.com/KTgreenham/TRiP) written in Matlab. This version was also designed to be more flexible and easier to run. 
*NOTE*: Requires Python 3.5 or higher.

To start using PyTRiP from command line, clone the repository to your local machine. \
    ```git clone https://github.com/joanmanbar/TRiP.git``` 

Navigate to the PyTRiP folder \
    ```cd TRiP/code/PyTRiP/``` 

Run the program \
    ```python3 TRiP.py -d <input directory> -e <image extension> -c <txt crop file> -mt <True/False> -m <True/False> -s <start image> -f <final image>``` 

**Example:**  \
```cd PyTRiP/code``` \
```python3 TRiP.py -d ../../input/ -e JPG -c ../../input/crop_coords.txt -mt True -m True``` 

The arguments specify the following: \
    `-d` <input directory> - The directory containing the image stacks to be analyzed \
    `-e` <image extension> - The file extension of the image stacks to be analyzed \
    `-c` <txt crop file> - (Optional) The text file containing the plant ID, followed by the four coordinates to crop each plant. **NOTE**: Al five elements must be separated by a single space, and contained in a single column. \
    `-mt` <True/False> - Whether or not to estimate motion from the cropped stacks \
    `-m` <True/False> - Whether or not to model period from the motion data \
    `-s` <start image> - The first image to start cropping at, i.e., the first frame \
    `-f`  <final image> - The last image to crop, i.e., the last frame  


## Output
An `output` folder withih the clone repository with two subfolders: `motion` and `model`. `motion` contains a csv file per plant with their raw motion data. `model` contains a plot per plant with their fitted model, and a single file (MODELS_DATA.csv) with the plant ID, Period, CTP, Rsquared, and RAE, as columns.





