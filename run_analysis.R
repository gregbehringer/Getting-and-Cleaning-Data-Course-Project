install.packages("dplyr")
library(dplyr)




#store paths in variables for ease of use

datacleaningProjectZip <- "C:/Users/ghb206/Documents/DataSciTrack_JHU/datacleaningProject.zip"
datacleaningURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 
 
#download the data in question

download.file(datacleaningURL, datacleaningProjectZip, mode = "wb")


#create a new directory for the unzip so as to not touch the raw download
 
datacleaningOutDir<-"C:/Users/ghb206/Documents/DataSciTrack_JHU/datacleaningProjectDirectory"
unzip(datacleaningProjectZip,exdir = datacleaningOutDir)
 

#download all relevant files
 
activityLabels <- read.table("C:/Users/ghb206/Documents/DataSciTrack_JHU/datacleaningProjectDirectory/UCI HAR Dataset/activity_labels.txt")
featureLabels <- read.table("C:/Users/ghb206/Documents/DataSciTrack_JHU/datacleaningProjectDirectory/UCI HAR Dataset/features.txt")
trainX <- read.table("C:/Users/ghb206/Documents/DataSciTrack_JHU/datacleaningProjectDirectory/UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("C:/Users/ghb206/Documents/DataSciTrack_JHU/datacleaningProjectDirectory/UCI HAR Dataset/train/Y_train.txt")
trainSubject <- read.table("C:/Users/ghb206/Documents/DataSciTrack_JHU/datacleaningProjectDirectory/UCI HAR Dataset/train/subject_train.txt")
testX <- read.table("C:/Users/ghb206/Documents/DataSciTrack_JHU/datacleaningProjectDirectory/UCI HAR Dataset/test/X_test.txt")
testY <- read.table("C:/Users/ghb206/Documents/DataSciTrack_JHU/datacleaningProjectDirectory/UCI HAR Dataset/test/Y_test.txt")
testSubject <- read.table("C:/Users/ghb206/Documents/DataSciTrack_JHU/datacleaningProjectDirectory/UCI HAR Dataset/test/subject_test.txt")
 

#add the column names and bind the data to form a consolidated table

colnames(trainX) <- t(featureLabels[2])
colnames(testX) <- t(featureLabels[2])
trainX$activities <- trainY[, 1]
trainX$participants <- trainSubject[, 1]
testX$activities <- testY[, 1]
testX$participants <- testSubject[, 1]
totalTrainTestBind <- rbind(trainX, testX)


#good place to check what things look like
#execute write.csv(totalTrainTestBind,"C:/Users/ghb206/Documents/DataSciTrack_JHU/test.csv")
#looks correct so proceed


#Because there were only a few codes that corresponded to activities they were set equal to their text values manually

totalTrainTestBind$activities <- as.character(totalTrainTestBind$activities)
totalTrainTestBind$activities[totalTrainTestBind$activities == 1] <- "Walking"
totalTrainTestBind$activities[totalTrainTestBind$activities == 2] <- "Walking Upstairs"
totalTrainTestBind$activities[totalTrainTestBind$activities == 3] <- "Walking Downstairs"
totalTrainTestBind$activities[totalTrainTestBind$activities == 4] <- "Sitting"
totalTrainTestBind$activities[totalTrainTestBind$activities == 5] <- "Standing"
totalTrainTestBind$activities[totalTrainTestBind$activities == 6] <- "Laying"


#logical grep was used to include only mean, std, activities, and participants columns

totalTrainTestBindLogical<-totalTrainTestBind[,grepl("mean|std|activities|participants",colnames(totalTrainTestBind))]

#another checkpoint for the data
#execute write.csv(totalTrainTestBindLogical,"C:/Users/ghb206/Documents/DataSciTrack_JHU/test.csv")
#again, data looks correct


#arrange participants and activities columns with dplyr for ease of reading current table and pending summarized table

arrangedTotalTrainTestBindLogical <- totalTrainTestBindLogical %>% select(participants,activities,everything())

#another checkpoint with write.csv(arrangedTotalTrainTestBindLogical,"C:/Users/ghb206/Documents/DataSciTrack_JHU/test.csv")
#data looks correct


#now write out per my understanding of tidy data

write.table(arrangedTotalTrainTestBindLogical, "C:/Users/ghb206/Documents/DataSciTrack_JHU/tidy.txt", row.names = FALSE)



#aggregate the second tidy set for mean analysis

secondTidySet <- aggregate(. ~participants + activities, arrangedTotalTrainTestBindLogical, mean)


#confirm again with write.csv(secondTidySet,"C:/Users/ghb206/Documents/DataSciTrack_JHU/test.csv")
#Now order by participant and activity for more natural viewing

secondTidySetArranged <- secondTidySet[order(secondTidySet$participants, secondTidySet$activities),]

write.table(secondTidySetArranged,"C:/Users/ghb206/Documents/DataSciTrack_JHU/tidy2.txt", row.names = FALSE)






















