# Please refer to the cookbook for a detailed explanation of the procedures
# of each step

##############################
# Load requested libraries
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
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

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

#Merging
mergedDataFrame <- cbind(Subject, X, y)

##### Point 2 #####
# The selected features are the ones which contain "subject" and "mean",
# plus the subjectID and the code (obviously). It is easy to do it by means
# of the select function of the library dplyr
selectedData <- select(Merged_Data, subject, code, contains("mean"), contains("std"))

# To see what fields are contained in selectedData, we can create a vector
# containing their names. We will work on them at the next step
undescNames <- names(selectedData)