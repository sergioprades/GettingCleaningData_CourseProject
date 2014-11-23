Getting and Cleaning Data - Course Project
===========

The goal of this project is to prepare tidy data (collected from the accelerometers from the Samsung Galaxy S smartphone) that can be used for later analysis. 

This project contains 4 files:

* README.md
    * Description of how the script works

* CodeBook.md
    * Description of variables in the tidy dataset

* run_analysis.R
    * Script that create the tidy dataset

* tidydataset.txt
    * tidy dataset obtained from raw data


### 1. Raw data


Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You must download it and unzip in the same directory than run_analysis.R. 

```
./run_analysis.R
./UCI HAR Dataset
```


Be sure that the name of the data folder is 'UCI HAR Dataset'

### 2. Execute script


There is only one script in this project: run_analysis.R. It requires 'reshape' package but will try to download it automatically if there is not installed yet.

Be sure that your R studio or R console has its Working Directory in the same path where run_analysis.R and 'UCI HAR Dataset' are stored.

For run the script execute:

```
source('run_analysis.R')
```

### 3. Execution

1. Merges the training and the test sets to create one data set.
    1. Merge features 'UCI HAR Dataset/train/x_train.txt' and 'UCI HAR Dataset/test/x_test.txt' in one dataset
    1. Merge subjects 'UCI HAR Dataset/train/subject_train.txt' and 'UCI HAR Dataset/test/subject_test.txt' in one dataset
    1. Merge activities 'UCI HAR Dataset/train/y_train.txt' and 'UCI HAR Dataset/test/y_test.txt' in one dataset
    1. Merge by columns all features, subjects and activities in one dataset
1. Extracts only the measurements on the mean and standard deviation for each measurement. 
    1. Read 'UCI HAR Dataset/features.txt' and obtain the features related to mean and standard deviation
    1. Filter the features of the dataset created in step 1 to the features obtained in the previous step
1. Uses descriptive activity names to name the activities in the data set
    1. Read activity names from 'UCI HAR Dataset/activity_labels.txt' and use it to rename the Activity column
1. Appropriately labels the data set with descriptive variable names.
    1. Apply the next transformations to the features names:
        * remove ()
        * "Acc" -> "Accelerometer"
        * "Gyro"-> "Gyroscope"
        * "Mag" -> "Magnitude"
        * initial "f -> FrequencySignal-"
        * initial "t" -> "TimeSignal-"
        * "mean" -> "Mean"
        * "std"-> "StandardDeviation"
    1. Substitute the automatic columns names of the features with the new ones
1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
    1. With melt function create a new narrow dataset with four columns: Subject, Activity, Variable, Value: 
```
Subject Activity  variable         value
1       STANDING  tBodyAcc-mean-X  0.2885845
1       STANDING  tBodyAcc-mean-X  0.2784188
```

    1. With cast function merge all rows with the same Subject + Activity + Feature in one only row, with the mean of all observations
    1. Add the word "Average" to the name of each average feature column
    1. Print the tidy dataset 
    
### 4. Result
    
The resultant dataset is a tidy dataset in a wide form. Each Subject + Activity observation in one row, with each measured variable in one different column.

```
  Subject           Activity TimeSignal-BodyAccelerometer-Mean-X Average TimeSignal-BodyAccelerometer-Mean-Y Average ........
1       1             LAYING                                   0.2215982                                -0.040513953
2       1            SITTING                                   0.2612376                                -0.001308288
3       1           STANDING                                   0.2789176                                -0.016137590
4       1            WALKING                                   0.2773308                                -0.017383819
5       1 WALKING_DOWNSTAIRS                                   0.2891883                                -0.009918505
6       1   WALKING_UPSTAIRS                                   0.2554617                                -0.023953149
```

The new tidy dataset is accessible in the variable

```
tidydataset
```


