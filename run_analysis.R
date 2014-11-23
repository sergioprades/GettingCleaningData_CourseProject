
# first of all, automatically install required packages 

if (!suppressWarnings(require("reshape")))
{
  install.packages("reshape")
  if(!require("reshape")) stop("Package not found")
}

#####################################################################
## 1 Merges the training and the test sets to create one data set. ##
#####################################################################

# load x_train and x_test file and merge by rows in one dataset

x_train <- read.table(file="UCI HAR Dataset/train/x_train.txt")
x_test <- read.table(file="UCI HAR Dataset/test/x_test.txt")
x_merge <- rbind(x_train, x_test)

# load train and test subject file and merge by rows in one dataset.

subject_train  <- read.table(file="UCI HAR Dataset/train/subject_train.txt")
subject_test  <- read.table(file="UCI HAR Dataset/test/subject_test.txt")
subject_merge <- rbind(subject_train, subject_test)
colnames(subject_merge)[1] <- "Subject"

# load y_train and y_test file and merge by rows in one dataset

y_train <- read.table(file="UCI HAR Dataset/train/y_train.txt")
y_test <- read.table(file="UCI HAR Dataset/test/y_test.txt")
y_merge <- rbind(y_train, y_test)
colnames(y_merge)[1] <- "Activity"


# merge x, y and subject datasets and merge all by columns in one dataset 

tidydataset <- cbind(x_merge, subject_merge, y_merge)

###############################################################################################
## 2 Extracts only the measurements on the mean and standard deviation for each measurement. ##
###############################################################################################

# read the features file. Force casting to character in the second column to avoid the automatic cast to factor

features <- read.table("UCI HAR Dataset/features.txt", colClasses = c("integer", "character"))

# filter the features names to mean or standard deviation ones as described in features_info.txt
#  mean(): Mean value
#  std(): Standard deviation

features_meanstd <- features[grep("-mean\\(\\)|-std\\(\\)", features$V2),1]

# filter point 1 dataset to features_meanstd, Activity and Subject columns

tidydataset <- tidydataset[,c(features_meanstd,length(tidydataset)-1,length(tidydataset))]

##############################################################################
## 3 Uses descriptive activity names to name the activities in the data set ##
##############################################################################

# read activity file 

activity_names = read.table(file="UCI HAR Dataset/activity_labels.txt")

# change Activity column ids by its name in activity file

tidydataset$Activity <- activity_names[tidydataset$Activity,2]

#########################################################################
## 4 Appropriately labels the data set with descriptive variable names ##
#########################################################################

# First, with gsub remove the parentheses from the features names dataset previously obtained.

features_names <- gsub("\\(\\)","",features[features_meanstd,2])

# After that, I substitute the abbreviations by its meanings (as indicated in features_info.txt)

features_names <- gsub("Acc","Accelerometer",features_names)
features_names <- gsub("Gyro","Gyroscope",features_names)
features_names <- gsub("Mag","Magnitude",features_names)
features_names <- gsub("^f","FrequencySignal-", features_names)
features_names <- gsub("^t","TimeSignal-", features_names)
features_names <- gsub("mean","Mean", features_names)
features_names <- gsub("std","StandardDeviation", features_names)

# example: 'tBodyAcc-mean()-X' -> 'TimeSignal-BodyAccelerometer-Mean-X'

# Substitute the automatic column names of the first length(features_meanstd) columns 
# with the correspondant feature name

colnames(tidydataset)[1:length(features_names)] <- c(features_names)

#########################################################################################
## 5 From the data set in step 4, creates a second, independent tidy data set with the ##
## average of each variable for each activity and each subject.                        ##
#########################################################################################

# with melt function create a new narrow dataset with four columns: Subject, Activity, Variable, Value

molten <- melt(tidydataset, id.vars = c("Subject", "Activity"))

# In molten dataset I have several rows per Subject + Activity + Feature (variable), one per observation in
# the original dataset

# Subject Activity        variable     value
#       1 STANDING tBodyAcc-mean-X 0.2885845
#       1 STANDING tBodyAcc-mean-X 0.2784188

# Next I have to merge all rows with the same Subject + Activity + Feature in one only row, with the mean of
# all observations. This can be done with cast function

tidydataset <- cast(molten, Subject + Activity ~ variable, fun = mean)

# The resultant dataset is a tidy dataset in a wide form. Each Subject + Activity observation in one row, with each
# measured variable in one different column

# Because of the mean aggregation of the observations, I add the word "Average" to the name of each feature column  

colnames(tidydataset)[3:length(tidydataset)] <- paste(colnames(tidydataset)[3:length(tidydataset)], "Average")

# return the tidy dataset

print(tidydataset)

