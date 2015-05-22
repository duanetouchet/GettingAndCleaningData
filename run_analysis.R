###############################################
##
##  Assume this script is in the main folder
##  with subfolders called 'test' and 'train'
## 
###############################################

## Read test and training sets, and labels 

## Features and Activity labels
featureLabels <- read.table("features.txt", col.names = c("FeatureNum","FeatureName"))
activityLabels <- read.table("activity_labels.txt", col.names=c("Label","ActivityName"))

## Test set
testRaw <- read.table("test/X_test.txt",col.names = featureLabels$FeatureName)
testLabels <- read.table("test/y_test.txt",col.names = c("Label"))
testSubject <- read.table("test/subject_test.txt",col.names=c("Subject"))

## Training set
trainRaw <- read.table("train/X_train.txt",col.names = featureLabels$FeatureName)
trainLabels <- read.table("train/y_train.txt",col.names = c("Label"))
trainSubject <- read.table("train/subject_train.txt",col.names=c("Subject"))

## Build basic Data set from Raw data and Labels
testData <- cbind(testSubject,testLabels,testRaw)
trainData <- cbind(trainSubject,trainLabels,trainRaw) 
totalData <- merge(activityLabels,rbind(testData,trainData),by="Label")

## Figure out which columns to use and filter them out.
totalCol <- colnames(totalData)
colsToUse <- totalCol=="Subject" | totalCol=="ActivityName" | grepl("mean",totalCol) | grepl("std",totalCol)
tidyData <- totalData[,c(seq_len(length(totalCol))[colsToUse])]
tidyData$Subject <- as.factor(tidyData$Subject)
tidyData$ActivityName <- as.factor(tidyData$ActivityName)

## Get averages for the mean and std columns from tidyData
statData <- aggregate(.~Subject+ActivityName,data=tidyData,mean)

