##IG_msel =name
##Select_directory=folder
##Input_vector=vector
#Result=output vector

import os
import glob
from qgis.core import *
from processing.tools.vector import VectorWriter

#Folder path of output shapefiles
path_res ="/home/koltsov/Thematic/MADA"
Input = processing.getObjectFromUri(Input_vector)
os.chdir(Select_directory)

def rank():
    #Set directory and search for all .shp files 
    os.chdir(Select_directory)
    for fname in glob.glob("*.shp"): 
       processing.runalg("qgis:selecttbylocation",Select_directory+"/"+fname,Input,"['intersects']",0)
       processing.runalg("qgis:saveseletedfeatures",Select_directory+"/"+fname,path_res +"/sel/"+fname)       
    
    #output = [shp for shp in glob.glob(path_res + '/sel/'+"*.shp")]
    #Merge the shapefiles
    #processing.runalg("saga:mergeshapeslayers", output[0], ";".join(output) , Result) 

if Select_directory:
    rank()
else:
    pass

