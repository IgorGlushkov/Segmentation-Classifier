##[R-class]=group
##layer=vector
# ##model=file
##output_path=string

library(randomForest)
library(MASS)
test<-data.frame(layer)
#  outliers by classes
cl=length(levels(as.factor(test$CLASS_FIN)))
for(j in 1:cl){
test1<-test[test$CLASS_FIN==levels(as.factor(test$CLASS_FIN))[j],]
col=dim(test1)[2]-1
for(i in col){
x<-test1[,i]
remove_outliers <- function(x, na.rm = TRUE) {
qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm)
H <- 1.5 * IQR(x, na.rm = na.rm)
y <- x
y[x < (qnt[1] - H)] <- NA
y[x > (qnt[2] + H)] <- NA
y
}
y <- remove_outliers(x)
test1[,i]<-y
}
test[test$CLASS_FIN==levels(as.factor(test$CLASS_FIN))[j],]<-test1
}

#NAremove
# ##showplots
col=dim(test)[2]
for(i in 1:col){
test=test[!is.na(test[,i]),]
}
write.csv(test, file ="/media/S500/Thematic/Mada/Analysis2015/Masoala/R/sample.txt" )
m<-rbind(c(1,2),c(3,4))
layout(m)
par(mar=c(3,3,2,2))
ch1_bx<-boxplot(main="CH1-Classes", test$c1_mean~test$CLASSID, data=test, col = "lightgray", las=2, cex.axis=0.8, add=F)
ch2_bx<-boxplot(main="CH2-Classes", test$c2_mean~test$CLASSID, data=test, col = "lightgray", las=2, cex.axis=0.8, add=F)
ch3_bx<-boxplot(main="CH3-Classes", test$c3_mean~test$CLASSID, data=test, col = "lightgray", las=2, cex.axis=0.8, add=F)
#ch4_bx<-boxplot(main="CH4-Classes", test$ch4_mean~test$CLASSID, data=test, col = "lightgray", las=2, cex.axis=0.8, add=F)
# ##showplots
#m<-rbind(c(1,2),c(3,4))
#layout(m)
#par(mar=c(3,3,2,2))
#sr_bx<-boxplot(main="SR-Classes", test$srtm_mean~test$CLASSID, data=test, col = "lightgray", las=2, cex.axis=0.8, add=F)
#sl_bx<-boxplot(main="SL-Classes", test$sl_mean~test$CLASSID, data=test, col = "lightgray", las=2, cex.axis=0.8, add=F)
#as_bx<-boxplot(main="AS-Classes", test$as_mean~test$CLASSID, data=test, col = "lightgray", las=2, cex.axis=0.8, add=F)
#ti_bx<-boxplot(main="TI-Classes", test$ti_mean~test$CLASSID, data=test, col = "lightgray", las=2, cex.axis=0.8, add=F)
# ##showplots
#dens_bx<-boxplot(main="DENS-Classes", test$Dens~test$CLASSID, data=test, col = "lightgray", las=2, cex.axis=0.8, add=F)

testRFall.rf <- randomForest(as.factor(test$CLASS_FIN) ~ ., data=test[,-c(1)], ntree=10000, mtry=10, importance=TRUE, proximity=T, na.action=na.omit)
print(testRFall.rf)
save(testRFall.rf, file=output_path)
