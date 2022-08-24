# The W4submission.R script will make the necessary transformations to answer the questions asked in the subject

library(dplyr)
# We first need to download the files and dataset and unzip them in the data/UCI HAR Dataset folder.
# Reading the files that we need to create the data frames
features_df <- read.table("./data/UCI HAR Dataset/features.txt", col.names = c("id","pattern"))
activities_df <- read.table("./data/UCI HAR Dataset/activity_labels.txt", col.names = c("id","label"))

subjects_test_df <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test_df <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = features_df$pattern)
y_test_df <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "Y")

subjects_train_df <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train_df <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = features_df$pattern)
y_train_df <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "Y")



# Merges the training and the test sets to create one data set.
# We have 2 sets of 3 tables of the same size. We’re going to stack their respective data.
mergedDataX <- rbind(x_train_df, x_test_df)
names(mergedDataX)

mergedDataY <- rbind(y_train_df, y_test_df)
names(mergedDataY)

mergedSubjects <- rbind(subjects_train_df, subjects_test_df)
names(mergedSubjects)

# We now group all these rows of data into a single table with all the columns combined.
mergedData <- cbind(mergedSubjects, mergedDataX, mergedDataY)
str(mergedData)


# Extracts only the measurements on the mean and standard deviation for each measurement. 
tidyMergedData <- select(mergedData, subject, Y, contains("mean"), contains("std"))
View(tidyMergedData)

# Uses descriptive activity names to name the activities in the data set
# So, we replace the activity id with their text value
tidyMergedData$Y <- activities_df[tidyMergedData$Y, 2]

# Now we appropriately labels the data set with descriptive variable names.
names(tidyMergedData)

# The column Y represents the activities, so it will be renamed that way:
names(tidyMergedData)[2] = "activity"

# The other names are composed with the following abbreviations:
    # tBody -> time.body
    # Acc -> acceleration
    # tGravity -> time.gravity
    # Jerk -> jerk.signal
    # Gyro -> gyroscope
    # Mag -> magnitude
    # fBody -> frequency.body
    # BodyBody -> body

names(tidyMergedData) <- gsub("BodyBody", "Body", names(tidyMergedData))
names(tidyMergedData) <- gsub("tGravity", "time.gravity", names(tidyMergedData))
names(tidyMergedData) <- gsub("tBody", "time.body", names(tidyMergedData))
names(tidyMergedData) <- gsub("Jerk", ".jerk.signal", names(tidyMergedData))
names(tidyMergedData) <- gsub("Gyro", ".gyroscope", names(tidyMergedData))
names(tidyMergedData) <- gsub("Mag", ".magnitude", names(tidyMergedData))
names(tidyMergedData) <- gsub("fBody", "frequency.body", names(tidyMergedData))
names(tidyMergedData) <- gsub("Acc", ".acceleration", names(tidyMergedData))
names(tidyMergedData) <- gsub("([^.])(Mean)", "\\1.mean", names(tidyMergedData))
names(tidyMergedData) <- gsub(".std", ".standard.deviation", names(tidyMergedData))
names(tidyMergedData) <- gsub("meanFreq", "mean.frequency", names(tidyMergedData))
names(tidyMergedData)

# create a new data set with the average of each variable for each activity and each subject
by_subject_activity <- tidyMergedData %>% group_by(subject, activity) %>% summarise_all(.funs=mean)
head(by_subject_activity, 20)
str(by_subject_activity)

write.table(by_subject_activity, "CourseraDataCleaningSubmission.txt", row.name=FALSE)
