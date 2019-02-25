#Link for the data
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download and unzip the data
library(downloader)
f<-file.path(getwd(),"dataset.zip")
download(url,dest=f,mode="wb")
path_unzip<-file.path(getwd(),"dt")
unzip(f,exdir=path_unzip)


#list unzipped files
filest<-list.files(path=path_unzip,recursive = TRUE)

#Choose files for analysis
View(filest)
files<-filest[c(14,15,16,26,27,28)]

#Read files for analysis
library(data.table)
subject_train<-read.table(file.path(path_unzip,files[4]))
subject_test<-read.table(file.path(path_unzip,files[1]))
activity_train<-read.table(file.path(path_unzip,files[6]))
activity_test<-read.table(file.path(path_unzip,files[3]))
data_train<-read.table(file.path(path_unzip,files[5]))
data_test<-read.table(file.path(path_unzip,files[2]))
#combine subject,activity,data 
subject<-rbind(subject_train,subject_test)
setnames(subject,"V1","subject")
activity<-rbind(activity_train,activity_test)
setnames(activity,"V1","actinum")
data<-rbind(data_train,data_test)
#Merge column
mdata<-as.data.table(cbind(subject,activity,data))
#Set key
setkey(mdata,subject,actinum)

#Read features.It is the third element in the unzipped files(filest)
features<-read.table(file.path(path_unzip,filest[3]))

#Extracts only the measurements on the mean and standard deviation for each measurement.
featuresnames<-as.vector(features[,2])
measurementsind<-grep("*mean[[()]]*|*std()*",featuresnames)
measurement<-features[measurementsind,]
setnames(measurement,c("V1","V2"),c("featurenum","features"))
featurenum<-as.vector(measurement$featurenum)+2
dt<-mdata[,c(1,2,featurenum),with=FALSE]

#Uses descriptive activity names to name the activities in the data set
activity_labels<-read.table(file.path(path_unzip,filest[1]))
setnames(activity_labels,c("V1","V2"),c("actinum","actiname"))
dt<-merge(dt,activity_labels, by = "actinum", all.x = TRUE)
setcolorder(dt,c("subject","actiname",colnames(dt)[3:68],"actinum"))
#Drop activity number column
dt$actinum<-NULL
#Appropriately labels the data set with descriptive variable names.
setnames(dt,colnames(dt)[3:68],as.vector(measurement$features))
                                
#From the data set in step 4, creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject."reshape"package is required.
library(reshape)
#Shape the data by subject and acivitity 
new_dt_m<-melt(dt,id=c("subject","actiname"))
#Calcuate the average of each variable for each activity and each subject
tidydt<-cast(new_dt_m,subject+actiname~variable,mean)

#Output the tidy data
write.table(tidydt,file=file.path(getwd(),"tidydt"),row.name=FALSE)

