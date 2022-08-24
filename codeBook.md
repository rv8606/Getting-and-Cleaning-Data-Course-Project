# Peer reviewed Code Book 
## Submission for the Coursera Getting and Cleaning Data Course Project

*The purpose of this exercise is to clean up and consolidate in a tidy dataset the data collected in the Human Activity Recognition Using Smartphones Dataset.*

The **run_analysis.R** script will make the necessary transformations to answer the questions asked in the subject

The *dplyr* library is required for these operations.
 
##1 We first need to download the files and dataset and unzip them in the data/UCI HAR Dataset folder.
A full description of the source data is available at the site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
The data for the project are stored in the following zip file:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Download and unzip the "getdata_projectfiles_UCI HAR Dataset.zip" in your data folder.
It must contain the following files:
1. *activity_labels.txt*		80 octet: The list of the text labels and their ids
2. *features.txt*				16 ko: The list of the features
3. *features_info.txt*		3 ko: The description of the features listed in the features.txt file.
4. *README.txt*				5 ko: A short description of the Human Activity Recognition Using Smartphones Dataset and its methodology
And the following folders containing respectively:
1. **test** (folder):
	1.1. *subject_test.txt*	8 ko: Identifies the subject who performed the activity for each sample
	1.2. *X_test.txt*			25 839ko : The test sets
	1.3. *y_test.txt*			6 ko: The list of activities ids associated with each test set row. 

2. **train** (folder):
	1.1. *subject_train.txt*	20 ko: Identifies the subject who performed the activity for each sample
	1.2. *X_train.txt*		64 460 ko: The train sets
	1.3. *y_train.txt*		15 ko: The list of activities ids associated with each train set row

##2 Reading the files that we need to create the original data frames
We performed the read.table function to create :
	- the dataframe **features_df** (561 rows, 2 cols) with the content of "*./data/UCI HAR Dataset/features.txt*" and named the columns "id" and "pattern". It is the list of the features collected by the various sensors described in the "features_info.txt" document.
	- the dataframe **activities_df** (6 rows, 2 cols) with the content of "*./data/UCI HAR Dataset/activity_labels.txt*" and named the columns "id" and "label", it gives us a readable label for the activities listed in the y_test and y_train datasets.

	- the dataframe **subjects_test_df** (2947 rows, 1 col) with the content of "*./data/UCI HAR Dataset/test/subject_test.txt*" and named the column "subject"
	- the dataframe **x_test_df** (2947 rows, 561 cols) with the content of "*./data/UCI HAR Dataset/test/X_test.txt*" and named the columns with the labels contained in the _features_df dataframe
	- the dataframe **y_test_df** (2947 rows, 1 col) with the content of "*./data/UCI HAR Dataset/test/y_test.txt*" and named the column "Y"

	- the dataframe **subjects_train_df** (7352 rows, 1 col) with the content of "*./data/UCI HAR Dataset/train/subject_train.txt*" and named the column "subject"
	- the dataframe **x_train_df** (7352 rows, 561 cols) with the content of "*./data/UCI HAR Dataset/train/X_train.txt*" and named the columns with the labels contained in the _features_df dataframe
	- the dataframe **y_train_df** (7352 rows, 1 col) with the content of "*./data/UCI HAR Dataset/train/y_train.txt*" and named the column "Y"

##3 Merging the training and the test sets to create one data set.
###3.1 We have 2 sets of 3 tables of the same size. We’re going to stack their respective data.

	- **mergedDataX**: 10299 rows 561 cols contains the data of *x_train_df* and *x_test_df*
	- **mergedDataY**: 10299 rows 1 col contains the data of *y_train_df* and *y_test_df*
	- **mergedSubjects**:10299 rows 1 col contains the data of *subjects_train_df* and *subjects_test_df*

###3.2 We now group all these rows of data into a single table with all the columns combined.
	- **mergedData**: 10299 rows 563 cols contains *mergedSubjects*, *mergedDataX* and *mergedDataY*

##4 Extracting only the measurements on the mean and standard deviation for each measurement. 
	- The **tidyMergedData** data frame is created with the columns *subject*, *Y* and all the columns with a name containing the strings "*mean*" or "*std*" of the *mergedData* dataset.

##5 Uses descriptive activity names to name the activities in the data set
*Now we replace the* **activities ids** *in the dataset with their text value stored in the* **label** column of the **activities_df** *dataset*

##6 Appropriately labels the data set with descriptive variable names.
	- The column **Y** represents the activities, so it will be renamed "*activity*"
	- The other names are composed with the following abbreviations or string repetition are replaced with the "gsub" function:
		+ **tBody** replaced with *time.body*
		+ **Acc** replaced with *acceleration*
		+ **tGravity** replaced with *time.gravity*
		+ **Jerk** replaced with *jerk.signal*
		+ **Gyro** replaced with *gyroscope*
		+ **Mag** replaced with *magnitude*
		+ **fBody** replaced with *frequency.body*
		+ **BodyBody** replaced with *body*

##7 create a new data set with the average of each variable for each activity and each subject
	- Creation of the dataframe **by_subject_activity** with *tidyMergedData* rows grouped by "*subject*" and "*activity*" columns and summarised with the *mean* function on each variable thanks to the summarise_all function.
	- Export the tidy dataset **by_subject_activity** into the "*CourseraDataCleaningSubmission.txt*" file.
	

