The script "run_analysis.R" is a step-by-step implementation of the instructions of the project "Getting and Cleaning data" on Coursera.

The steps are:

1. **Merge the training and the test sets to create one data set.** </br>

First I downloaded and extracted the data in the folder "*~/UCI HAR Dataset*". Then 
each dataset has been read into a dataframe, yielding:

* ```features```: 561 obs. of 2 vars. </br>
Names of the measurements derived by the raw signals tAcc and tGyro of the accelerometer and the gyroscope. The data is extracted from the file *features.txt*;
* ```activities```: 6 obs. of 2 vars. </br>
Activities performed during the measurement and relative labels (from *activity_labels.txt*);
* ```subject_test```: 2947 obs. of 1 var. </br>
Test data of the volunteer subjects. Data contained in *test/subject_test.txt*;
* ```x_test```: 2947 obs. of 561 vars. </br>
Recorded test data, contained in the file *test/X_test.txt*;
* ```y_test```: 2947 obs. of 1 var. </br>
Test data of code labels, in *test/y_test.txt*;
* ```subject_train```: 7352 obs. of 1 var. </br>
Train data of the volunteer subjects being observed. Data extracted from *test/subject_train.txt*;
* ```x_train```: 7352 obs. of 561 vars. </br>
Recorded train data of features from *test/X_train.txt*;
* ```y_train```: 7352 obs. of 1 var. </br>
Train data of code labels, as from *test/y_train.txt*.

Next, the training and test sets have been merged using the function *rbind()*. The results are:

* ```X```: 10299 obs. of 561 vars. 
* ```y```: 10299 obs. of 1 var.
* ```Subject```: 10299 obs. of 1 var.

Finally, these 3 dataframes have been merged calling the function *cbind()* into:

* ```mergedDataFrame```: 10299 obs. of 563 vars.

2. **Extract only the measurements on the mean and standard deviation for each measurement.** </br>
 
The dataframe ```SelectedData``` (10299 obs. of 88 vars.) has been created by selecting
the fields "subject", "code" and the ones containing either "mean" or "std" in their 
description.

3. **Use descriptive activity names to name the activities in the data set.** </br>

Before this step, the "code" field in ```selectedData``` was described by integers.
I replaced it with the "activity" field (second column of ```activity``` dataframe),
which is factorised in 6 levels and is more explanatory.

4. **Label the dataset appropriately with descriptive variable names.** </br>

A repeated use of the function *gsub()* has been made in order to unify the notation in substrings and to remove shortenings.
In particular (the arrow --> reads "subsituted with" to avoid repetitions):

* "t" at the beginning of a field --> "Time"
* "f" at the beginning of a field --> "Frequency"
* "Acc" --> "Accelerometer"
* "BodyBody" --> "Body"
* "Gyro" --> "Gyroscope"
* "Mag" --> "Magnitude"
* "angle" --> "Angle"
* "gravity" --> "Gravity"
* ".mean" and "-mean" --> "Mean"
* ".std" and "-std" --> "STDev"
* ".freq" and "-freq" --> "Frequency"


5. **From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.** </br>