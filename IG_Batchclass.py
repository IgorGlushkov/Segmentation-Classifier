##IGBatchclass=name

##Select_directory=folder

##Input_model=file

#   ##Result=output vector



import os

import glob



#   Folder path of output shapefiles

path_res = '/media/S500/Thematic/Mada/Analysis2015/Masoala/RESsegm'

path_in = Select_directory

#   Select required directory

os.chdir(Select_directory)



def rank():



#   Set directory and search for all .shp files 

    os.chdir(Select_directory)

    for fname in glob.glob("*.shp"): 





#   Classfication and convert to raster     

        

      #outputs=processing.runalg("r:rfpred",path_in+'/'+fname, Input_model, path_res  + '/'+ fname)
      #outputs_2=processing.runalg("qgis:fieldcalculator", path_in  + '/'+ fname,'CLASSID', 1, 10,0,1, "pred_rf" , path_res  + '/fin/'+ fname)
      input = processing.getObjectFromUri(path_res +"/fin/"+ fname)
      width = (input.extent().xMaximum() - input.extent().xMinimum())/5
      height = (input.extent().yMaximum() - input.extent().yMinimum())/5
      outputs_3=processing.runalg("gdalogr:rasterize", path_res +"/fin/"+ fname, 'CLASSID', 0, width, height, True,2,"0",2,75,6,1,False,0,path_res +"/fin/"+ fname.split('.')[0]+".tif")
      outputs_4=processing.runalg("gdalogr:rasterize", path_res +"/fin/"+ fname, 'd7_mean', 0, width, height, True,2,"0",2,75,6,1,False,0,path_res +"/Density/"+ fname.split('.')[0]+".tif")
      #os.remove(path_res  + '/'+ fname.split('.')[0]+".shp")
      #os.remove(path_res  + '/'+ fname.split('.')[0]+".dbf")  
      #os.remove(path_res  + '/'+ fname.split('.')[0]+".prj")
#      outputs_3=processing.runalg("gdalogr:ogr2ogr", outputs_2['OUTPUT_LAYER'],14,path_res  + "/csv/"+ fname)

#   Paths of the shapefiles in the Output folder with list comprehension

#    output = [shp for shp in glob.glob(path_res + "*.shp")]



#   Merge the shapefiles

#   processing.runalg("saga:mergeshapeslayers", output[0], ";".join(output) , Result)

    



if Select_directory:

    rank()

else:

    pass
