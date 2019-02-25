**# Getting-and-Cleaning-Data-Course-Project**  
The goal is to prepare tidy data from data collected from the accelerometers from the Samsung Galaxy S smartphonethatused for 
later analysis.

**# Here is what the R script is supposed to do.**  
#### Merges the training and the test sets to create one data set.  
#### Extracts only the measurements on the mean and standard deviation for each measurement.  
#### Uses descriptive activity names to name the activities in the data set.  
#### Appropriately labels the data set with descriptive variable names.  
#### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  




**# Prerequisities**  
Install.packages ("downloader","data.table","reshape")   

**# The followings are the steps to complete the project.**    
#### 1. create the link to download the original data.  
#### 2. Download the unzip the data. You need to create a file path to store and unzip the files.  
#### 3. List the unzipped files with list.files function. The View function is useful for choosing the files to be analyzed.  
#### 4. Read.table functions are used to read the dataset.  
#### 5. rbind, cbind functions are used to combine the datasets.  
#### 6. read the features data and extracts only the measurements on the mean and standard deviation for each measurement.  
#### 7.Uses descriptive activity names to name the activities in the data set.  
#### 8.Appropriately labels the data set with descriptive variable names.  
#### 9.creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
   melt and cast functions in the reshape package will do the tricks.   
 
