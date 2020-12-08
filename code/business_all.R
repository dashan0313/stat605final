result=data.frame(matrix(data=rep(0,30),nrow = 3,ncol = 10))
filenames <- list.files("cdata", pattern="*.csv", full.names=TRUE)
a=read.csv(filenames[1])
for (i in c(2:22)) {
 temp=read.csv(filenames[i])
 a=rbind(a,temp)
}

data=a[,-c(1,3,7,13,14)]
park=data[,c(1,6)]
Noise=data[,c(1,3)]
data=data[,-c(3,6)]
data=data[,-c(8,11)]

result[1,]=c(colnames(data)[-1],"Parking","Noise")
for (i in c(2:9)){
  temp=factor(data[which(data[,i]!=0),i])
  model=aov(data$star[which(data[,i]!=0)]~temp)
  sum_temp=summary(model)
  if(sum_temp[[1]]$`Pr(>F)`[1]<0.05){
    result[2,i-1]="Significant"
    if(coefficients(model)[1]<0){
      result[3,i-1]="Negative"
    } else{
      result[3,i-1]="Positive"
    }
  } else{
    result[2,i-1]="Non-significant"
  }
}

park=park[which(park$Parking!=(-1)),]
park$Parking=factor(park$Parking)
model_park=aov(star~Parking,data=park)

if(summary(model_park)[[1]]$`Pr(>F)`[1]<0.05){
  result[2,9]="Significant"
  if(coefficients(model_park)[2]<0){
    result[3,9]="Negative"
  } else{
    result[3,9]="Positive"
  }
} else {result[2,9]="Non-significant"}

Noise=Noise[which(Noise$Noise!=0),]
Noise$Noise=factor(Noise$Noise)
model_noise=aov(star~Noise,data=Noise)
if(summary(model_noise)[[1]]$`Pr(>F)`[1]<0.05){
  result[2,10]="Significant"
  if(coefficients(model_noise)[2]<0){
    result[3,10]="Negative"
  } else{
    result[3,10]="Positive"
  }
} else {result[2,10]="Non-significant"}

setwd("../output_business/")
write.table(result,"results_of_full_model.csv",col.names = FALSE, row.names = FALSE, sep = ",")
