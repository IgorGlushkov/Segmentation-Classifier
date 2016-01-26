##IGRFmodel=name
##Output_directory=folder
##Input_vector=vector


#   Folder path of output shapefiles

path_res = Output_directory+'/'+'RF_model.RData'

input = processing.getObjectFromUri(Input_vector)

output=processing.runalg("r:rfmodel", input, path_res)


