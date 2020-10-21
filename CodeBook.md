---
title: "CodeBook"
---

In this code book you will find all the information about the `run_analysis.R` script used to tidying the original Human Activity Data as given in the project's course description. The explanation of each step is below.

## Cleaning Up, Transforming, Analyzing and Summarizand Data Process

1. **Obtain the dataset**

 The dataset was downloaded from the link in the README file to the `data` folder of this project.

2. **Load the different data for the variables of interest and assign them to different variables**

 + `variables <- read.table("data/features.txt")[,2] ` : 561 rows vector  
 *The original measurements names from the study for this database*
 + `var_int <- grep("(mean|std)\\(\\)",variables)` : 66 row vector  
 *The index of the variables of interest for this analysis (Those containing mean and standard deviation of the measurements)*
 + `data_test <- read.table("data/test/X_test.txt", col.names = variables)[,var_int]` : 2947 rows, 66 columns  
 *Measurements data of 30% of the volunteers (9/30 subjects) in the original study. Note that only the columns with the mean and standard deviation of the measurements are stored, instead of the original 561 rows to occupy less memory. Note also that the variable names are assigned in this same step*
 + `data_act_test <- read.table("data/test/y_test.txt", col.names = "Activity")` : 2947 rows, 1 column  
 *Data of the Activity associated to each row of `data_test` coded by `activity_labels.txt`. Note that the name of this data was assigned*
 + `data_sub_test <- read.table("data/test/subject_test.txt", col.names = "Subject")` : 2947 rows, 1 column  
 *Data of the Subject associated to each row of `data_test`. Note that the name of this data was assigned*
 + `data_train <- read.table("data/train/X_train.txt", col.names = variables)[,var_int]` : 7352 rows, 66 columns  
 *Measurements data of 70% of the volunteers (21/30 subjects) in the original study. Note that only the columns with the mean and standard deviation of the measurements are stored, instead of the original 561 rows to occupy less memory. Note also that the variable names are assigned in this same step*
 + `data_act_train <- read.table("data/train/y_train.txt", col.names = "Activity")` : 7352 rows, 1 column  
 *Data of the Activity associated to each row of `data_train` coded by `activity_labels.txt`. Note that the name of this data was assigned*
 + `data_sub_train <- read.table("data/train/subject_train.txt", col.names = "Subject")` : 7352 rows, 1 column  
 *Data of the Subject associated to each row of `data_test`. Note that the name of this data was assigned*

3. **Mergin the test and train data**

 + `test <- cbind(data_sub_test, data_act_test, data_test)` : 2947 rows, 68 columns  
 *Using the cbind(), the activities, subjects and measurements for the test data are put in the same data frame*
 + `test <- cbind(data_sub_test, data_act_test, data_test)` : 7352 rows, 68 columns  
 *Using the cbind() command, the activities, subjects and measurements for the train data are put in the same data frame*
 + `total_data <- full_join(test, train, by = names(test)) %>% arrange(Subject)` : 10299 rows, 68 variables  
 *Using the full_join() command, the two data frames are merged in just one with all the information for the variables of interest. This dataframe is sorted by Subject for the analysis and it is the final tidy data*
 + After merging the two data frames, all the previous objects are removed from the environment. Just the total data is conserved.
 
4. **Assign activity names to name the activities in the data set**
 
 + `activity <- tolower(read.table("data/activity_labels.txt")[,2])` : 6 row vector  
 *Names data for the different activities on the study*
 + `for(i in 1:length(activity)){total_data$Activity <- gsub(i, activity[i],total_data$Activity)}`  
 *Using the gsub() command, all the activities codes are changed for its respective name*
 
5. **Descriptive variable names in the dataset**
 * First variable is called `Subject` since the file load
 * Second variable is called `Activity` since the file load
 * For the other variables, the names are changed as follow:
  + "X" in the end was changed to "X_axis"
  + "Y" in the end was changed to "Y_axis"
  + "Z" in the end was changed to "Z_axis"
  + "t" in the start was changed to "Time_Domain"
  + "f" in the start was changed to "Frequency_Domain
  + "Acc" was changed to "Accelerometer"
  + "Gyro" was changed to "Gyroscope"
  + "Mag" was changed to "Magnitude"
  + "mean" was changed to "Mean"
  + "std"was changed to "StandardDeviation"
  
6. **A second, independent tidy data set with the average of each variable for each activity and each subject**
 + `averages <- total_data %>% group_by(Activity, Subject) %>% summarize_all(funs(mean))` : 180 rows, 68 columns  
 *Data frame containing the summarized tidy data of the mean of each variable grouped by activity and by subject*
 + Export the final `averages` dataset to the `final_tidy_data.txt` file

## Variables in the final dataset

 * The first variable corresponds to the Human Activity realized during the measurements
 * The second variable corresponds to the Subject number in the original study for each activity
 * The other variables correspond to the mean value of the measurements in the study for each variable in the following list. As the original study presented values normalized with a range between -1 and 1, this results are also normalized (adimensional values) with a range between -1 and 1.

[3] "Time_Domain_Body_Accelerometer_Mean_X_axis"                               
 [4] "Time_Domain_Body_Accelerometer_Mean_Y_axis"                               
 [5] "Time_Domain_Body_Accelerometer_Mean_Z_axis"                               
 [6] "Time_Domain_Body_Accelerometer_StandardDeviation_X_axis"                  
 [7] "Time_Domain_Body_Accelerometer_StandardDeviation_Y_axis"                  
 [8] "Time_Domain_Body_Accelerometer_StandardDeviation_Z_axis"                  
 [9] "Time_Domain_Gravity_Accelerometer_Mean_X_axis"                            
[10] "Time_Domain_Gravity_Accelerometer_Mean_Y_axis"                            
[11] "Time_Domain_Gravity_Accelerometer_Mean_Z_axis"                            
[12] "Time_Domain_Gravity_Accelerometer_StandardDeviation_X_axis"               
[13] "Time_Domain_Gravity_Accelerometer_StandardDeviation_Y_axis"               
[14] "Time_Domain_Gravity_Accelerometer_StandardDeviation_Z_axis"
[15] "Time_Domain_Body_Accelerometer_Jerk_Mean_X_axis"                          
[16] "Time_Domain_Body_Accelerometer_Jerk_Mean_Y_axis"                          
[17] "Time_Domain_Body_Accelerometer_Jerk_Mean_Z_axis"                          
[18] "Time_Domain_Body_Accelerometer_Jerk_StandardDeviation_X_axis"             
[19] "Time_Domain_Body_Accelerometer_Jerk_StandardDeviation_Y_axis"             
[20] "Time_Domain_Body_Accelerometer_Jerk_StandardDeviation_Z_axis"             
[21] "Time_Domain_Body_Gyroscope_Mean_X_axis"                                   
[22] "Time_Domain_Body_Gyroscope_Mean_Y_axis"                                   
[23] "Time_Domain_Body_Gyroscope_Mean_Z_axis"                                   
[24] "Time_Domain_Body_Gyroscope_StandardDeviation_X_axis"                      
[25] "Time_Domain_Body_Gyroscope_StandardDeviation_Y_axis"                      
[26] "Time_Domain_Body_Gyroscope_StandardDeviation_Z_axis"                      
[27] "Time_Domain_Body_Gyroscope_Jerk_Mean_X_axis"                              
[28] "Time_Domain_Body_Gyroscope_Jerk_Mean_Y_axis"
[29] "Time_Domain_Body_Gyroscope_Jerk_Mean_Z_axis"                              
[30] "Time_Domain_Body_Gyroscope_Jerk_StandardDeviation_X_axis"                 
[31] "Time_Domain_Body_Gyroscope_Jerk_StandardDeviation_Y_axis"                 
[32] "Time_Domain_Body_Gyroscope_Jerk_StandardDeviation_Z_axis"                 
[33] "Time_Domain_Body_Accelerometer_Magnitude_Mean"                            
[34] "Time_Domain_Body_Accelerometer_Magnitude_StandardDeviation"               
[35] "Time_Domain_Gravity_Accelerometer_Magnitude_Mean"                         
[36] "Time_Domain_Gravity_Accelerometer_Magnitude_StandardDeviation"            
[37] "Time_Domain_Body_Accelerometer_Jerk_Magnitude_Mean"                       
[38] "Time_Domain_Body_Accelerometer_Jerk_Magnitude_StandardDeviation"          
[39] "Time_Domain_Body_Gyroscope_Magnitude_Mean"                                
[40] "Time_Domain_Body_Gyroscope_Magnitude_StandardDeviation"                   
[41] "Time_Domain_Body_Gyroscope_Jerk_Magnitude_Mean"                           
[42] "Time_Domain_Body_Gyroscope_Jerk_Magnitude_StandardDeviation"
[43] "Frequency_Domain_Body_Accelerometer_Mean_X_axis"                          
[44] "Frequency_Domain_Body_Accelerometer_Mean_Y_axis"                          
[45] "Frequency_Domain_Body_Accelerometer_Mean_Z_axis"                          
[46] "Frequency_Domain_Body_Accelerometer_StandardDeviation_X_axis"             
[47] "Frequency_Domain_Body_Accelerometer_StandardDeviation_Y_axis"             
[48] "Frequency_Domain_Body_Accelerometer_StandardDeviation_Z_axis"             
[49] "Frequency_Domain_Body_Accelerometer_Jerk_Mean_X_axis"                     
[50] "Frequency_Domain_Body_Accelerometer_Jerk_Mean_Y_axis"                     
[51] "Frequency_Domain_Body_Accelerometer_Jerk_Mean_Z_axis"                     
[52] "Frequency_Domain_Body_Accelerometer_Jerk_StandardDeviation_X_axis"        
[53] "Frequency_Domain_Body_Accelerometer_Jerk_StandardDeviation_Y_axis"        
[54] "Frequency_Domain_Body_Accelerometer_Jerk_StandardDeviation_Z_axis"        
[55] "Frequency_Domain_Body_Gyroscope_Mean_X_axis"                              
[56] "Frequency_Domain_Body_Gyroscope_Mean_Y_axis"
[57] "Frequency_Domain_Body_Gyroscope_Mean_Z_axis"                              
[58] "Frequency_Domain_Body_Gyroscope_StandardDeviation_X_axis"                 
[59] "Frequency_Domain_Body_Gyroscope_StandardDeviation_Y_axis"                 
[60] "Frequency_Domain_Body_Gyroscope_StandardDeviation_Z_axis"                 
[61] "Frequency_Domain_Body_Accelerometer_Magnitude_Mean"                       
[62] "Frequency_Domain_Body_Accelerometer_Magnitude_StandardDeviation"          
[63] "Frequency_Domain_Body_Body_Accelerometer_Jerk_Magnitude_Mean"             
[64] "Frequency_Domain_Body_Body_Accelerometer_Jerk_Magnitude_StandardDeviation"
[65] "Frequency_Domain_Body_Body_Gyroscope_Magnitude_Mean"                      
[66] "Frequency_Domain_Body_Body_Gyroscope_Magnitude_StandardDeviation"         
[67] "Frequency_Domain_Body_Body_Gyroscope_Jerk_Magnitude_Mean"                 
[68] "Frequency_Domain_Body_Body_Gyroscope_Jerk_Magnitude_StandardDeviation"
