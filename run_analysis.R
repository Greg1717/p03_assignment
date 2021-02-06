
# Download & Unzip =============================================================

## define URL
# url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## create data directory
# dir.create("data")

## download zip file
# download.file(url = url,
#               destfile = "./data/dataset.zip")

## unzip data
# unzip(zipfile = "./data/dataset.zip",exdir = "./data")



# Training Data ================================================================

# import training set x_train.txt
library(data.table)

x_train <- data.table::fread(file = "./data/UCI HAR Dataset/train/X_train.txt")

# load features.txt
features <- fread(file = "./data/UCI HAR Dataset/features.txt")
names(features) <- c("feature_id", "feature_descr")

# Use features$feature_descr as variable names in x_train
names(x_train) <- features$feature_descr

# import activity labels
activity_labels <- data.table::fread(
    file = "./data/UCI HAR Dataset/activity_labels.txt")

names(activity_labels) <- c("activity_code", "activity_descr")

# import subject data
subject_train <- data.table::fread(
    file = "./data/UCI HAR Dataset/train/subject_train.txt")

names(subject_train) <- "subject_label"

# import y_train
y_train <- data.table::fread(
    file = "./data/UCI HAR Dataset/train/y_train.txt")

# rename variable
names(y_train) <- "activity_code"

# add training description
y_train[, activity_descr := activity_labels$activity_descr[
    match(activity_code, activity_labels$activity_code)]]

# CBIND training data
train <- cbind(subject_train,
               y_train,
               x_train)

remove(subject_train)
remove(y_train)
remove(x_train)



# Test Data ====================================================================

# load x_test
x_test <- data.table::fread(
    file = "./data/UCI HAR Dataset/test/X_test.txt")

# get names for x_test from 'features'
names(x_test) <- features$feature_descr; remove(features)

# load y_test (activity_codes)
y_test <- data.table::fread(
    file = "./data/UCI HAR Dataset/test/y_test.txt")

names(y_test) <- "activity_code"

# add activity description
y_test$activity_descr <-
    activity_labels$activity_descr[match(y_test$activity_code,
                                         activity_labels$activity_code)]

remove(activity_labels)

# import subject data
subject_test <- data.table::fread(
    file = "./data/UCI HAR Dataset/test/subject_test.txt")

names(subject_test) <- "subject_label"

# combine all test data
test <- cbind(subject_test,
              y_test,
              x_test)

# remove unneeded files
remove(subject_test); remove(y_test); remove(x_test)


# MERGE ========================================================================
dt_tidy_dataset <- rbind(test, train); remove(test); remove(train)


# Extract Mean & SD ============================================================
# use GREP to extract 'mean' & 'std' from variable names, i.e. identify index of required variable names, but also use the first three columns which contain subject label, activity code & activity description
my_vars_mean_std <- c(1, 2, 3, grep(pattern = "mean|std", x = names(dt_tidy_dataset)))

# extract only Subject Label, Activity Code, Activity Description & 'mean' and 'std' variables
dt_tidy_mean_std <- dt_tidy_dataset[, ..my_vars_mean_std]


# Averages =====================================================================
# calculate the mean on the extracted variables
dt_tidy_averages <- dt_tidy_mean_std[, lapply(.SD, mean),
                                     keyby = .(subject_label, activity_code, activity_descr)]

# export
write.table(x = dt_tidy_averages,
            file = "dt_tidy_averages.txt",
            row.names = FALSE)
