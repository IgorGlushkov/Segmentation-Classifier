##IGRFmodel=name
##Output_directory=folder
##Input_vector=vector


#   Folder path of output shapefiles

path_res = Output_directory+'/'+'RF_model.RData'
test_data = Output_directory+'/'+'testdata.csv'

input = processing.getObjectFromUri(Input_vector)

output=processing.runalg("r:rfmodel", input, test_data, path_res)


