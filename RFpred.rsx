##[R-class]=group
##layer=vector
##model=file
##output_layer=output vector
library(randomForest)
library(MASS)
load(model)
data<-data.frame(layer)
layer@data$pred_rf = predict(testRFall.rf, data, type="response")
output_layer=SpatialPolygonsDataFrame(layer, as.data.frame(layer))
