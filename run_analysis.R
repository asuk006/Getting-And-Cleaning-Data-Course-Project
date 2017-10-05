##Downloading and unziping the dataset:

        if (!file.exists("gettingAndCleaning.zip")){
                url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
                download.file(url, "gettingAndCleaning.zip", method="curl")
        }
        
        if (!file.exists("UCI HAR Dataset")) { 
                unzip("gettingAndCleaning.zip")
        }
        
        setwd("./UCI HAR Dataset")
##loading the required packages:
        library(data.table)
        library(reshape2)
        library(dplyr)

##1. Merging the training and the test sets to create one data set:
        
        ##reading the identifiers of the subjects who carried out the experiment from the training and the test data:
        
                idTrain <- fread("./train/subject_train.txt", col.names = c("id"))
                idTest <- fread("./test/subject_test.txt", col.names = c("id"))
                
        ##reading activity codes from the training and the test data:
                
                activityCodesTrain <- fread("./train/y_train.txt", col.names = c("activity_code"))
                activityCodesTest <- fread("./test/y_test.txt", col.names = c("activity_code"))
                
        ##reading the names of the features from "features.txt" file and assign them to featureVectorsColNames:
                
                featuresNames <- fread("features.txt")[, 2]
                featureVectorsColNames <- unlist(featuresNames)
                featureVectorsColNames <- unname(featureVectorsColNames)
                
        ##reading the 561-feature vectors with time and frequency domain variables from the training and the test data:
                
                featureVectorsTest <- fread("./test/X_test.txt", col.names = featureVectorsColNames)
                featureVectorsTrain <- fread("./train/X_train.txt", col.names = featureVectorsColNames)
                
        ##combining the id, activity codes, and 561-feature vectors from the training and the test data together:
                
                activityRecognitionTest <- cbind(idTest, activityCodesTest, featureVectorsTest)
                activityRecognitionTrain <- cbind(idTrain, activityCodesTrain, featureVectorsTrain)
                
        ##combining the activity recognition tables for the test and the training data into a signle data set:
                
                activityRecognition <- rbind(activityRecognitionTrain,activityRecognitionTest)

##2. Extracting only the measurements on the mean and standard deviation for each measurement.
        ##Only those mean and standard deviation estimates on signals that meet the descriptions of the mean() and std() from
        ##"features_info.txt" file in a stricter sense were exctracted - i.e. meanFreq() variables and angle() variables that
        ##use vectors obtained by averaging the signals were omitted.
                
        ##obtaining indeces for extracting mean() and std() measurements:
                
                meanColIndex <- grep("mean\\(.*)", names(activityRecognition), value = T)
                stdColIndex <- grep("std\\(.*)", names(activityRecognition), value = T)
                
        ## extracting the mean() and std() mesurements and assigning them to activityRecognition data set:
                
                activityRecognition <- activityRecognition[, c("id", "activity_code", meanColIndex, stdColIndex), with = FALSE]
                
                ##the data set containing only mean() and std() measurements.
                
##3. Assigning descriptive activity names from "activity_labels.txt" to the activity codes in the data set:
        
        #reading the activity names table:
                
                activityNames <- fread("activity_labels.txt", col.names = c("activity_code", "activity_name"))
        
        #merging the activityRecognition data set with activity names table:
                
                activityRecognition <- merge(activityNames, activityRecognition, by = "activity_code", all = T)
                        ##this data set is ardered by activity names
        
        ##removing the activity code variable from the data set:
                
                activityRecognition$activity_code <- NULL

##4. Assigning more descriptive variable names to the columns of the data set( the names were obtained in step 1):
                
                ##I've decided to keep most parts of the names since I find them descriptive enough and the exact meaning
                ##of them can be found in the codebook.
                
                ##I am removing all the "-" and "() symbols from the names, so they are easier to work with and appear tidier
                
                names(activityRecognition) <- gsub("-std\\()-", "_SD_", names(activityRecognition))
                names(activityRecognition) <- gsub("-std\\()", "_SD", names(activityRecognition))
                names(activityRecognition) <- gsub("-mean\\()-", "_Mean_", names(activityRecognition))
                names(activityRecognition) <- gsub("-mean\\()", "_Mean", names(activityRecognition))
                
##5. Creating a tidy data set with the average of each variable for each activity and each subject:
                
                ##melt the data set and dcast it with the mean function:
                melted <- melt(activityRecognition, id = c("id", "activity_name"))
                activityRecognition <- dcast(melted, id + activity_name ~ variable, mean)
                
                ##melt again and name the features and mean columns:
                activityRecognition <- melt(activityRecognition, id = c("id", "activity_name"))
                activityRecognition <- rename(activityRecognition, feature = variable, average = value)
                
##writing the tidy activity recognition data set:
                
                write.table(activityRecognition, "activity_recognition.txt", row.names = FALSE, quote = FALSE)
                