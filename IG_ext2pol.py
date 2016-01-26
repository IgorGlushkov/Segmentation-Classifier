##IG_ext2pol =name
##Select_directory=folder
##Result=output vector

import os
import glob

#   Folder path of output shapefiles
path_res ='/home/koltsov/Thematic/MADA'

os.chdir(Select_directory)

def rank():

#   Set directory and search for all .shp files 
    os.chdir(Select_directory)
    for fname in glob.glob("*.shp"): 
#   Select    
     outputs=processing.runalg("qgis:polygonfromlayerextent", fname,'No', None)
     outputs1=processing.runalg("qgis:advancedpythonfieldcalculator", outputs['OUTPUT'], 'SOURCE',2,50,0,'','value='+'"'+fname+'"',path_res  + '/EXT/'+ fname)  
     
    
    output = [shp for shp in glob.glob(path_res + '/EXT/'+"*.shp")]
#   Merge the shapefiles
    processing.runalg("saga:mergeshapeslayers", output[0], ";".join(output) , Result) 
    
    

if Select_directory:
    rank()
else:
    pass

