#kandothAnno

#numBySample
numBySample<-as.data.frame(table(kandothAnno2$ShortTumor_Sample))
head(numBySample)
names(numBySample)[1]<-"ShortTumor_Sample"
head(numBySample)
dim(numBySample)
for (i in 1:nrow(numBySample))
{
  matchRow<-match(numBySample[i,1], kandothAnno2$ShortTumor_Sample)
  numBySample[i,3]<-as.character(kandothAnno2$Cancer[matchRow])
}
head(numBySample)

save(numBySample, file="numBySample.Rdata")