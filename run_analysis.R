# Please refer to the Codebook for a detailed explanation of the procedures of each step
# I will just explain the essential here.

library(dplyr)

# Get the data, download the zip file from its URL and unzip
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "HAR_Dataset.zip"
download.file(url = url, destfile = destFile, method = "curl")
unzip(zipfile = destFile, overwrite = FALSE)
file.remove(destFile)


##### Point 1 ######
# First, extract the feature and activity names from the source files
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
aLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# Let's organise data into tables and create the dataframes we need
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

Subject <- rbind(subject_train, subject_test)
X <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)

# Merge!
mergedDataFrame <- cbind(Subject, y, X)


##### Point 2 #####
# The selected features are the ones which contain "subject" and "mean", plus the subjectID and the code (obviously). 
# It is easy to do it by means of the select function of the library dplyr
selectedData <- select(mergedDataFrame, subject, code, contains("mean"), contains("std"))

# To see what fields are contained in selectedData, we can create a vector containing their names. 
# We will work on them at the next step
fieldNames <- names(selectedData)


##### Point 3 #####
# Let's rename the activities in the new dataset with descriptive names
selectedData$code <- aLabels[selectedData$code, 2]


##### Point 4 #####
# Let's give more descriptive names to the fields by removing shortenings.
# See Codename.md for a more complete explanation

fieldNames[2] <- "activity"
fieldNames <- gsub("^t", "Time", fieldNames)
fieldNames <- gsub("^f", "Frequency", fieldNames)
fieldNames <- gsub("Acc", "Accelerometer", fieldNames)
fieldNames <- gsub("BodyBody", "Body", fieldNames)
fieldNames <- gsub("Gyro", "Gyroscope", fieldNames)
fieldNames <- gsub("Mag", "Magnitude", fieldNames)
fieldNames <- gsub("angle", "Angle", fieldNames)
fieldNames <- gsub("gravity", "Gravity", fieldNames)
fieldNames <- gsub("[\\.-]mean()", "Mean", fieldNames, ignore.case = TRUE)
fieldNames <- gsub("[\\.-]std()", "STDev", fieldNames, ignore.case = TRUE)
fieldNames <- gsub("[\\.-]freq()", "Frequency", fieldNames, ignore.case = TRUE)

# Finally, rename since everything is alright
names(selectedData) <- fieldNames

##### Point 5 #####
# Create the tidy dataset
tidyData <- group_by(selectedData, subject, activity)
tidyData <- summarise_all(tidyData, funs(mean))

# Export the results
write.table(tidyData, "tidyData.txt", row.name = FALSE)