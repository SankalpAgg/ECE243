from scipy.signal import *
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as anim
import pandas as pd 
from scipy.ndimage import rotate
import sys

np.set_printoptions(threshold=sys.maxsize)
from PIL import Image
from numpy import asarray


img = Image.open("scratch-green-maze.jpg")
img=img.resize((50,100))  #resize to whatever shape you want.
width = img.width 
height = img.height 
img.show()

print(width)
print(height)



def rgb888_to_rgb565(r, g, b):
    r_565 = (r * 31) // 255
    g_565 = (g * 63) // 255
    b_565 = (b * 31) // 255
    rgb_565 = (r_565 << 11) | (g_565 << 5) | b_565
    return rgb_565
numpydata=asarray(img)



f = open("colouredPixel.txt", "w")
f.write("int pickachuPic [" +str(width) + "][" +str(height)+ "] = ")
f.write("{")

for eachRowInImage in range(height):
    f.write("{")

    for eachZarrayNumber in range(width):
        tempNum=rgb888_to_rgb565(numpydata[eachRowInImage][eachZarrayNumber][0],numpydata[eachRowInImage][eachZarrayNumber][1],numpydata[eachRowInImage][eachZarrayNumber][2])
        f.write(str(tempNum))
        print(tempNum)
        if eachZarrayNumber < width:
            f.write(", ")
    f.write("},")
    f.write("\n")
f.write("};")
f.close()
