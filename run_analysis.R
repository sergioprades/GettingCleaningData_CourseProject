
if (!suppressWarnings(require("reshape")))
{
  install.packages("reshape")
  if(!require("reshape")) stop("Package not found")
}

## 1 Merges the training and the test sets to create one data set.

# merge x

x_train <- read.table(file="UCI HAR Dataset/train/x_train.txt")
x_test <- read.table(file="UCI HAR Dataset/test/x_test.txt")
x_merge <- rbind(x_train, x_test)

# merge subject

subject_train  <- read.table(file="UCI HAR Dataset/train/subject_train.txt")
subject_test  <- read.table(file="UCI HAR Dataset/test/subject_test.txt")
subject_merge <- rbind(subject_train, subject_test)
colnames(subject_merge)[1] <- "Subject"

# merge y

y_train <- read.table(file="UCI HAR Dataset/train/y_train.txt")
y_test <- read.table(file="UCI HAR Dataset/test/y_test.txt")
y_merge <- rbind(y_train, y_test)
colnames(y_merge)[1] <- "Activity"


# merge all

tidydataset <- cbind(x_merge, subject_merge, y_merge)

## 2 Extracts only the measurements on the mean and standard deviation for each measurement.v 

# we need to obtain what features are related to mean and standard deviation

features <- read.table("UCI HAR Dataset/features.txt", colClasses = c("integer", "character"))

features_meanstd <- features[grep("-mean\\(\\)|-std\\(\\)", features$V2),1]

tidydataset <- tidydataset[,c(features_meanstd,length(tidydataset)-1,length(tidydataset))]

## 3 Uses descriptive activity names to name the activities in the data set

activity_names = read.table(file="UCI HAR Dataset/activity_labels.txt")

tidydataset$Activity <- activity_names[tidydataset$Activity,2]

## 4 Appropriately labels the data set with descriptive variable names. 

colnames(tidydataset)[1:length(features_meanstd)] <- gsub("\\(\\)","",features[features_meanstd,2])

## 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

molten <- melt(tidydataset, id.vars = c("Subject", "Activity"))

tidydataset <- cast(molten, Subject + Activity ~ variable, fun = mean)

colnames(tidydataset)[3:length(tidydataset)] <- paste(colnames(tidydataset)[3:length(tidydataset)], "Avg")

print(tidydataset)
