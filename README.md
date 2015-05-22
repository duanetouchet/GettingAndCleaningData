---
title: "README"
author: "Duane Touchet"
date: "May 22, 2015"
output: html_document
---

# HOW MY run_analysis.R FILE WORKS

## MAJOR STEPS

1. Load labels 
2. Load raw data from files
3. Build basic data frame from raw data and labels
4. Tidy up the basic data
5. Produce averages from tidy data

## STEP 1 - Load labels

We load two main labels for the entire data source.

featureLabels contains the names used to replace the index numbers used in the test and train datasets.

          featureLabels <- read.table("features.txt", col.names = c("FeatureNum","FeatureName"))

activityLabels contains the names of the different types of activities that were tracked.

          activityLabels <- read.table("activity_labels.txt", col.names=c("Label","ActivityName"))


## STEP 2 - Load raw data

The raw data were divided into two datasets, called test and train, that were separated into sub-folders.

Each dataset was examined and the steps for loading the raw data for each was similar so I will explain how test dataset was loaded. The train dataset was loaded in the same way.

First, we read in the raw text file and apply the labels read into featureLabels in STEP 1.

          testRaw <- read.table("test/X_test.txt",col.names = featureLabels$FeatureName)

Next, we loaded a set of labels that was linked to the raw data. For each observation (row) in the raw data, there was a row in the labels file to show which feature was tracked for that row.

          testLabels <- read.table("test/y_test.txt",col.names = c("Label"))

Finally, we load the Subject data in the same was as the Labels. Each subject row was linked to the raw data to identify what subject the data was collected from for the corresponding row in the raw data file.

          testSubject <- read.table("test/subject_test.txt",col.names=c("Subject"))

The train dataset was processed in the same way.

          trainRaw <- read.table("train/X_train.txt",col.names = featureLabels$FeatureName)
          trainLabels <- read.table("train/y_train.txt",col.names = c("Label"))
          trainSubject <- read.table("train/subject_train.txt",col.names=c("Subject"))


## STEP 3 - Build basic data

To build the basic data, I combined the columns in the subject records, label records, and the raw data into one data frame. I made one for test and one for train.

          testData <- cbind(testSubject,testLabels,testRaw)
          trainData <- cbind(trainSubject,trainLabels,trainRaw) 

Finally, I combined the test and train datasets into one data frame.

          totalData <- merge(activityLabels,rbind(testData,trainData),by="Label")


## STEP 4 - Tidy data

Tidying up the data mainly required reducing the massive number of columns into the set of columns we were interested in. To do this, I stored the set of column names into a vector.

          totalCol <- colnames(totalData)

Then I used a logical vector to mark the columns to use based on the column name containing the words "mean" or "std". I also included the columns needed for the statistics processing later.

          colsToUse <- totalCol=="Subject" | totalCol=="ActivityName" | grepl("mean",totalCol) | grepl("std",totalCol)

Next, I applied the logical vector to filter the data into just the columns wanted.

          tidyData <- totalData[,c(seq_len(length(totalCol))[colsToUse])]

Finally, I converted the subject and activityname columns into factors for use in the statistics processing later.

          tidyData$Subject <- as.factor(tidyData$Subject)
          tidyData$ActivityName <- as.factor(tidyData$ActivityName)


## STEP 5 - Produce averages

Producing the averages required the aggregate function to compute the mean for all columns except Subject and ActivityName over the tidyData data frame.

          statData <- aggregate(.~Subject+ActivityName,data=tidyData,mean)


## Output

Finally, I generated a text file called "dataStep5.txt" from the statData data frame to upload and submit to Coursera.
