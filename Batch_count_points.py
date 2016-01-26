##CPBatch=name
##Select_directory=folder
#   ##Input_vector=vector
##Count_field_name=string PNTCNT
#   ##Result=output vector

import os
import glob

#   Folder path of output shapefiles
path_res = '/home/koltsov/Thematic/Mada/ANALISYS/Von1/GC_output'

#   Select required directory
os.chdir(Select_directory)
#input = processing.getObjectFromUri(Input_vector)

def rank():

#   Set directory and search for all .shp files 
    os.chdir(Select_directory)
    for fname in glob.glob("*.shp"):     

#   Count  
#        outputs=processing.runalg("qgis:fieldcalculator", fname, 'PNTCNT', 0, 10,6,'pn_sm', None)
               
#        outputs=processing.runalg('qgis:countpointsinpolygon', fname, input, Count_field_name, None)
        outputs_1=processing.runalg("qgis:advancedpythonfieldcalculator", fname, 'AREA', 0, 10,6,"","value = $geom.area()" ,None)
        outputs_2=processing.runalg("qgis:fieldcalculator", outputs_1['OUTPUT_LAYER'],'Dens',0,10,6,1,'pc_sum'+'/'+'AREA',path_res  + "/"+ fname)
       
#       outputs_3=processing.runalg("gdalogr:ogr2ogr", outputs_2['OUTPUT_LAYER'],14,path_res  + "/csv/"+ fname)
#   Paths of the shapefiles in the Output folder with list comprehension
#    output = [shp for shp in glob.glob(path_res + "*.shp")]
#   Merge the shapefiles
#   processing.runalg("saga:mergeshapeslayers", output[0], ";".join(output) , Result)    
if Select_directory:
    rank()
else:
    pass

