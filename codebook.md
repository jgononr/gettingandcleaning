# Code Book
## Files
### file 1, file 2, file 3

Record format
Code scheme
Record length
Record counts
Data items


## tidy_dataset.txt [OUTPUT FILE] 

### Record format: 
* Double quoted/Alphanumeric, Numeric, blank space-separator
* First line: Dataset column names
* Second line until EOF: Dataset values

The resulting dataset is composed for these columns:

|   Column   | Type       | Description                                                                                                                                                                |
|:----------:|------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| subject_id | int        | An integer identifying the person whose activity was measured                                                                                                              |
|     set    | factor/int | Indicates if the row belongs to the TRAIN or TEST dataset                                                                                                                  |
|  activity  | factor/int | A descriptive text identifying which activity the measurement is related to. Can be one of six: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING or LAYING |
| feature    | factor/int | One of the extracted features on the mean and standard deviation for each measurement.                                                                                     |
| origin     | char       | Indicates if the measurement sensor is the ACCELEROMETER or the GYROSCOPE. Each origin also identifies the measurement domain: time or frequency.                          |
| mean       | numeric    | The average of each variable for each activity and each subject.                                                                                                           |



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