
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

activity_labels <- data.table::fread(
    file = "./data/UCI HAR Dataset/activity_labels.txt")

names(activity_labels) <- c("activity_code", "activity_descr")

subject_train <- data.table::fread(
    file = "./data/UCI HAR Dataset/train/subject_train.txt")

names(subject_train) <- "subject_label"

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
dt <- rbind(test, train); remove(test); remove(train)


# Extract Mean & SD ============================================================
my_vars <- c(1, 2, 3, grep(pattern = "mean|std", x = names(dt)))
dt <- dt[, ..my_vars]


# Averages =====================================================================
dt_averages <- dt[, lapply(.SD, mean),
                  keyby = .(subject_label, activity_code, activity_descr)]

dt_averages
