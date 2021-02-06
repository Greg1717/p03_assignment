README
================

Code description:

Using **data.table package** for importing & processing data.

  - Download ZIP file into ‘data’ directory.
  - Unzip ZIP file.

Load & Process **Training** Data - Import training set x\_train.txt -
Import features.txt & use features$feature\_descr as variable names in
x\_train - Import activity labels and name variables to “activity\_code”
& “activity\_descr” - Import subject\_train.txt, rename variable to
“subject\_label” - Import y\_train.txt, rename variable to
“activity\_code” & add description from activity\_labels - Create
combined ‘train’ dataset by combining (cbind) subject\_train, y\_train &
x\_train.

Load & Process **Test** Data - Import testing set x\_test.txt - Use
features$feature\_descr as variable names in x\_test - Import
y\_test.txt, rename variable to “activity\_code” & add description from
activity\_labels - Import subject\_test.txt, rename variable to
“subject\_label” - Create combined ‘test’ dataset by combining (cbind)
subject\_test, y\_test & x\_test.

Merge the training and the test sets to create one data set using
**rbind**.

**Extract** only the measurements on the **mean and standard deviation**
for each measurement using **grep**: Use GREP to extract ‘mean’ & ‘std’
from variable names, i.e. identify index of required variable names, but
also use the first three columns which contain subject label, activity
code & activity description

`my_vars_mean_std <- c(1, 2, 3, grep(pattern = "mean|std", x =
names(dt_tidy_dataset)))`

**Extract variables** determined above.

`dt_tidy_mean_std <- dt_tidy_dataset[, ..my_vars_mean_std]`

Create second dataset named dt\_tidy\_averages with **mean** of each
variable for each activity and each subject:

`dt_tidy_averages <- dt_tidy_mean_std[, lapply(.SD, mean),` `keyby =
.(subject_label, activity_code, activity_descr)]`
