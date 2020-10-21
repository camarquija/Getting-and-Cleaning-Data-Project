library(dplyr)
##Getting and Cleaning Data Project Script

##Reading the variable data
variables <- read.table("data/features.txt")[,2]
var_int <- grep("(mean|std)\\(\\)",variables)

## Reading the interest variables from the test dataset and merging with the activity
## and subject information
data_test <- read.table("data/test/X_test.txt", col.names = variables)[,var_int]
data_act_test <- read.table("data/test/y_test.txt", col.names = "Activity")
data_sub_test <- read.table("data/test/subject_test.txt", col.names = "Subject")
test <- cbind(data_sub_test, data_act_test, data_test)
rm("data_test", "data_act_test", "data_sub_test")

## Reading the interest variables from the train dataset and merging with the activity
## and subject information
data_train <- read.table("data/train/X_train.txt", col.names = variables)[,var_int]
data_act_train <- read.table("data/train/y_train.txt", col.names = "Activity")
data_sub_train <- read.table("data/train/subject_train.txt", col.names = "Subject")
train <- cbind(data_sub_train, data_act_train, data_train)
rm("data_train", "data_act_train", "data_sub_train")

## Merging the two datasets
total_data <- full_join(test, train, by = names(test)) %>%
  arrange(Subject)
rm("test", "train", "variables", "var_int")

## Assigning activity names to the coded activity obtained
activity <- tolower(read.table("data/activity_labels.txt")[,2])
for(i in 1:length(activity)){total_data$Activity <- gsub(i, activity[i],total_data$Activity)}
rm("activity","i")

## Changing the name variables
new_names <- gsub("X$", "X_axis", names(total_data))
new_names <- gsub("Y$", "Y_axis", new_names)
new_names <- gsub("Z$", "Z_axis", new_names)
new_names <- gsub("^t", "Time_Domain_", new_names)
new_names <- gsub("^f", "Frequency_Domain_", new_names)
new_names <- gsub("Body", "Body_", new_names)
new_names <- gsub("Gravity", "Gravity_", new_names)
new_names <- gsub("Acc", "Accelerometer", new_names)
new_names <- gsub("Gyro", "Gyroscope", new_names)
new_names <- gsub("Mag", "_Magnitude", new_names)
new_names <- gsub("Jerk", "_Jerk", new_names)
new_names <- gsub("mean", "Mean", new_names)
new_names <- gsub("std", "StandardDeviation", new_names)
new_names <- gsub("\\.+", "_", new_names)
new_names <- gsub("_$", "", new_names)
names(total_data) <- new_names
rm("new_names")
names(total_data)

## Grouping, summarizing, Generating a new dataset with the mean value of each
## variable for each activity and for each subject and Exporting it to a txt file
averages <- total_data %>% group_by(Activity, Subject) %>%
  summarize_all(funs(mean))
write.table(averages, file = "final_tidy_data.txt", row.name=FALSE)
head(averages)
