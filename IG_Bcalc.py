##IG_Bcalc=name
##Select_directory=folder
##Count_field_name=string PNTCNT
import os
import glob
#Folder path of output shapefiles
path_res = '/home/koltsov/Thematic/Mada/ANALISYS/Von1/GC_output'
#Select required directory
os.chdir(Select_directory)


def rank():

#   Set directory and search for all .shp files 
    os.chdir(Select_directory)
    for fname in glob.glob("*.shp"):     
        outputs_1=processing.runalg("qgis:advancedpythonfieldcalculator", fname, 'AREA', 1,10,6,"","value = $geom.area()" ,None)
        outputs_2=processing.runalg("qgis:advancedpythonfieldcalculator", outputs_1['OUTPUT_LAYER'],'Dens',1,10,6,"","value=<pc_sum>/<AREA>", path_res  + "/"+ fname)        
           
if Select_directory:
    rank()
else:
    pass

