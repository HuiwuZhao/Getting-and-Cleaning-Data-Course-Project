
#Link for the data  
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  

#Download and unzip the data  
library(downloader) ##downloader package works for download multiples files  
f<-file.path(getwd(),"dataset.zip") ##create file path to store the downloaded files.  
download(url,dest=f,mode="wb")  
path_unzip<-file.path(getwd(),"dt") ##create file path to unzip the downloaded files.  
unzip(f,exdir=path_unzip) ##uzip the files to the folder called "dt"  


#list unzipped files  
filest<-list.files(path=path_unzip,recursive = TRUE) ##filest store the file paths for the unzip files.  
View(filest) ##show the file paths of the unzip files.

#Choose files for analysis  
files<-filest[c(14,15,16,26,27,28)]  

#Read files for analysis  
library(data.table)  
subject_train<-read.table(file.path(path_unzip,files[4])) ##read train subject  
subject_test<-read.table(file.path(path_unzip,files[1])) ##read test subject
activity_train<-read.table(file.path(path_unzip,files[6])) ##read activity number in the train data set    
activity_test<-read.table(file.path(path_unzip,files[3])) ##read activity number in the test data set   
data_train<-read.table(file.path(path_unzip,files[5])) ##read train data  
data_test<-read.table(file.path(path_unzip,files[2])) ##read test data  
#combine subject,activity,data   
subject<-rbind(subject_train,subject_test)  
setnames(subject,"V1","subject") ##name the variable in the combined subject table as "subject"       
activity<-rbind(activity_train,activity_test)  
setnames(activity,"V1","actinum") ##name the variable in the combined activity table as "actinum"   
data<-rbind(data_train,data_test)  
#Merge column  
mdata<-as.data.table(cbind(subject,activity,data))  ##"mdata"This is the data for the part 1 in the project   
#Set key  
setkey(mdata,subject,actinum) ##order the merged data by subject, then by activity.    

#Read features.It is the third element in the unzipped files(filest)  
features<-read.table(file.path(path_unzip,filest[3])) ##the third element in the filest is the file path for the features.    

#Extracts only the measurements on the mean and standard deviation for each measurement.  
featuresnames<-as.vector(features[,2])  
measurementsind<-grep("*mean[[()]]*|*std()*",featuresnames) ##find index for the featuresnames that contain mean and std.  
measurement<-features[measurementsind,] ## Extract the featuresnames with mean and std.
setnames(measurement,c("V1","V2"),c("featurenum","features"))   
featurenum<-as.vector(measurement$featurenum)+2 ##add 2 to the featurenum to match the locations of the features in the merged data "mdata"    
dt<-mdata[,c(1,2,featurenum),with=FALSE]  ##subset the merged data by the index of the feature number.##"dt"This is the data for the part 2 in the project  

#Uses descriptive activity names to name the activities in the data set  
activity_labels<-read.table(file.path(path_unzip,filest[1])) ##read the activity labels   
setnames(activity_labels,c("V1","V2"),c("actinum","actiname"))  
dt<-merge(dt,activity_labels, by = "actinum", all.x = TRUE) ##merge the activity labels to the data "dt"  
setcolorder(dt,c("subject","actiname",colnames(dt)[3:68],"actinum")) ##reordered the merged data, put activity labels in the second column.Complete the part3 of the project
#Drop activity number column  
dt$actinum<-NULL  
#Appropriately labels the data set with descriptive variable names. Complete the part4 in the project.
setnames(dt,colnames(dt)[3:68],as.vector(measurement$features))  
                                
#From the data set in step 4, creates a second, independent tidy data set with the average of   
#each variable for each activity and each subject."reshape"package is required.  
library(reshape)  
#Shape the data by subject and acivitity   
new_dt_m<-melt(dt,id=c("subject","actiname"))  
#Calcuate the average of each variable for each activity and each subject. Complete the part5 of the project.  
tidydt<-cast(new_dt_m,subject+actiname~variable,mean)  
