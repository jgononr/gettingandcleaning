# Getting and Cleaning Data final assignment README

## Introduction
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 

The purpose of this script is to collect, work with, and clean a data set from experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The goal is to prepare a tidy data that can be used for later analysis. 

## Analysis steps

'run_analysis' goes through the following steps:
* Reading common files: activities and features indicating which reading belongs to each column of the data files
* Reading "test" and "train" datasets: Once read, the column data is labeled using the previously read features data file.
* Identifies each dataset as belonging to the TEST or TRAIN dataset adding a new column 'set' to the merged one.
* Filters out the mean and std features columns for each row of the merged dataset. These columns are those ending in std()-<axis> and mean-<axis
* Tidies up the merged dataset:
        - All the features column become a row for each different subject, activity and set, with
          those three column values repeated on each row for each diffent subject
        - From the resulting dataset, a new column 'origin' is added to split some data from the                   'feature' name. 
          
          'origin' indicates if the measurement was made from the accelerometer or gyroscope   
          sensor (acc or gyro in the 'feature' column value). Values are: ACCELEROMETER or GYROSCOPE
          
          This column also allows to select data depending if time or frequency domains are to be 
          used on further analysis
* The tidied dataset is written to the 'tidy_dataset.txt' file
* And also is returned to allow it to be used as a call to the run_analysis function

Data transformation is discused in the "Data transformations" section on this document

## Input data
Input data is collected reading the corresponding files from the experiment. Measurements are split between 2 datasets, test and training, each in a different folder.

However, a couple of common files with the activites and data column names exist in the base folder.

Common files are:
* activity_labels.txt: a blank delimited file with 2 columns representing an activity number and the corresponding activity name. 

The activity number is used in the measurement data to indicated which activity corresponds to each measurement row.

* features.txt: a blank delimited file with 2 columns representing a measurement ID and the corresponding feature name. There are as many rows as measurement data columns.

Each row is a different measurement and corresponds to a measurement column in the measurements files.

As for the test and training datasets folders, both of them contain three files:

* subject_test.txt: a list of subjects identified with a number, each row corresponding to a measurement row. There are as many rows as measurements.
* y_test.txt: a list of activities identified with a number, each row corresponding to a measurement row. The corresponding activity name is on the "activity_labels.txt" file. There are as many rows as measurements.
* X_test.txt: the measurement data. There are as many rows as activities and subjects and as many columns as feature rows.

Given a set (test/training) the complete information is built using the 3 set files to identify which measurement is related to which subject and activity. Each measurement value is identified by the features order of labels.

## Output data

Output data is returned as the text file "tidy_dataset.txt" and also as a data frame. The resulting dataset is composed for these columns:

|   Column   | Type       | Description                                                                                                                                                                |
|:----------:|------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| subject_id | int        | An integer identifying the person whose activity was measured                                                                                                              |
|     set    | factor/int | Indicates if the row belongs to the TRAIN or TEST dataset                                                                                                                  |
|  activity  | factor/int | A descriptive text identifying which activity the measurement is related to. Can be one of six: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING or LAYING |
| feature    | factor/int | One of the extracted features on the mean and standard deviation for each measurement.                                                                                     |
| origin     | char       | Indicates if the measurement sensor is the ACCELEROMETER or the GYROSCOPE. Each origin also identifies the measurement domain: time or frequency.                          |
| mean       | numeric    | The average of each variable for each activity and each subject.                                                                                                           |
The output dataset is considered tidy data as:
* Each variable forms a column
* Each observation forms a row
* Each type of observational unit forms a table

Nevertheless, input data had some problems that had to be solved beforehand to get a tidy dataset.

These were the following:
* Column headers were values, not variable names
        Each measurement column name was referring to the variable "measurement" or "feature", the              latter being used to maintain coherence with file names. Each value on each column was the
        "value" for each "feature".
        
* Multiple variables are stored in one column
        As for the sensor origin that also is related to the measurement domain, a new column 'origin'
        is used to split that variable from the "feature" variable. As 'origin' and 'domain'
        have corresponding values (e.g. the accelerometer value will always be in the time domain and
        gyroscope's in the frequency domain) only the 'origin' variable is used as 'domain' would be
        redundant

## Data transformations



## `readdataset` returns the resulting data frame from reading the files containing the measurement data
## and description
## Files:
## - 'X' file:       measurements
## - 'y' file:       activity corresponding to each measurement file row
## - 'subject' file: subject that was measured during the activity
##
## The returned data frame contains the mean and standard deviation for each measurement, represented
## by all the columns that have "-mean()" or "-std()" as its feature name.
##
## This function receives the following arguments
## - set:          being one of "train" or "test" as the data folder to be read
## - path:         the path where the set files are stored
## - features:     a dataframe containing the column number and description for each measurement
## - selcolumns:   an optional parameter (defaults to TRUE) to indicate if only
##                 the "mean" and "std" measurements should be included in the resulting
##                 dataframe
##
## The returned dataframe is composed by (in column order):
## - subject_id:   an integer identifying the subject
## - activity_id:  an integer identifying the activity
## - data columns: if selcolumns argument is set to TRUE (default), the mean and std columns, else
##                 all columns read are part of the dataframe