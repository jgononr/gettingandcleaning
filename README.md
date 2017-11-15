# Getting and Cleaning Data final assignment README

## Introduction
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 

The purpose of this script is to collect, work with, and clean a data set from experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The goal is to prepare a tidy data set that can be used for later analysis. 

## Analysis steps

### 1. Reading common files

The activities and features files are read indicating which reading belongs to each column of the data files

### 2. Reading "test" and "train" datasets

Once read, the column data is labeled using the previously read features data file.

### 3. Test and training records are identified

A new column 'set' is added to the merged one to keep which set each record belongs to.

### 4. Filtering out the mean and std features

These columns are those ending in std()-<axis> and mean()-<axis>

### 5. Tidying up the merged dataset

Each feature column becomes a new column 'feature' where each column name is the value. Thus, a diffent row for each subject, activity, set and column name combination is created.

As each feature includes an axis measurement, it's considered that the 3 axis measurements correspond to only one observation, so 3 rows for each feature are casted into 1 with each axis measurement put on a column (X, Y and Z). Feature value is trimmed to not include the axis name.

Two last columns are added to the resulting dataset: 'origin' to indicate which sensor was used and 'domain' to indicate if the measurement value corresponds to the time or frequency domain.

Data transformation is discused in the "Data transformations" section on this document

### 6. Outputting data

The file 'tydy_dataset.txt' is created in the working directory and it's returned to the calling environment.

## Data transformations
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

### Constructing the dataset

After reading the deatures and activities files, the actual data set are read. The X_<set>.txt file is the actual data fomatted in 561 fields of 16-character width. Each column is named using the feature
dataframe, as it contains the very same 561 rows (same row number as X_<set> columns).

subject and activity set files have as many rows as the measurement set, so each vector of subjects and activities are prepended to the original dataset.

After these transformations, the data set is as follows:

|subject_id|activity_id|tBodyAcc-mean()-X|tBodyAcc-mean()-Y| (...) | angle(Z,gravityMean) |
|:--------:|:---------:|:---------------:|:---------------:|:-----:|:--------------------:|
|1|1|<value>|<value>|(...)|<value>|

The 'readdataset' functions is used to read each set, having one for each set. Each set contains an
implicit variable that is set the data belongs to. As we want to merge both datasets without losing
any variable, a new column is created and the sets are merged.

Now we have the following dataframe:

|set_id|subject_id|activity_id|tBodyAcc-mean()-X|tBodyAcc-mean()-Y| (...) | angle(Z,gravityMean) |
|:----:|:--------:|:---------:|:---------------:|:---------------:|:-----:|:--------------------:|
|TEST|1|1|\<value\>|\<value\>|(...)|\<value\>|
|TEST|1|1|\<value\>|\<value\>|(...)|\<value\>|
|(...) |(...)     |(...)      |(...)            |(...)            |(...)  |(...)|
|TRAIN |\<value\>   |\<value\>    |\<value\>            |\<value\>            |\<value\>  |\<value\>|

As the activities should have descriptive names, a merge is done between the activity data read and the merged dataset on activity_id. The resulting dataframe:

|activity_id|activity|set_id|subject_id|tBodyAcc-mean()-X|tBodyAcc-mean()-Y| (...) | angle(Z,gravityMean) |
|:----------|:------:|:----:|:--------:|:---------------:|:---------------:|:-----:|:--------------------:|
|1          |LAYING  |TEST  |1         |\<value\>          |\<value\>          |(...)  |\<value\>|
|TEST|1|1|\<value\>|\<value\>|(...)|\<value\>|
|(...) |(...)     |(...)      |(...)            |(...)            |(...)  |(...)|
|TRAIN |\<value\>   |\<value\>    |\<value\>            |\<value\>            |\<value\>  |\<value\>|

The assignment asks to extract the mean and standard deviation columns, so columns not ending in -std()-\<axis\> or -mean()-\<axis\> are discarded. The dataframe: 

|activity_id|activity|set_id|subject_id|tBodyAcc-mean()-X|tBodyAcc-mean()-Y| (...) | tGravityAcc-std()-Z  |
|:----------|:------:|:----:|:--------:|:---------------:|:---------------:|:-----:|:--------------------:|
|1          |LAYING  |TEST  |1         |\<value\>        |\<value\>        |(...)  |\<value\>             |
|1          |LAYING  |TEST  |1         |\<value\>        |\<value\>        |(...)  |\<value\>             |
|(...)      |(...)   |(...) |(...)     |(...)            |(...)            |(...)  |(...)                 |
|6          |WALKING_UPSTAIRS   |TRAIN   |\<value\>    |\<value\>            |\<value\>            |\<value\>  |\<value\>|

This dataframe is used as step 4 data and to be tidied up. Function 'tidydataset' is responsible for doing this.

### Tidying up the dataset

The output dataset is considered tidy data as long as:
* Each variable forms a column
* Each observation forms a row
* Each type of observational unit forms a table

Nevertheless, input data had some problems that had to be solved beforehand to get a tidy dataset.

#### Column headers were values, not variable names

Each measurement column name was referring to the variable "measurement" or "feature", the latter being used to maintain coherence with file names. Each value on each column was the "value" for each "feature".

From the original data frame:

|activity_id|activity           |set_id|subject_id|tBodyAcc-mean()-X|tBodyAcc-mean()-Y| (...) | tGravityAcc-std()-Z  |
|:----------|:-----------------:|:----:|:--------:|:---------------:|:---------------:|:-----:|:--------------------:|
|1          |LAYING             |TEST  |1         |\<value\>        |\<value\>        |(...)  |\<value\>             |
|1          |LAYING             |TEST  |1         |\<value\>        |\<value\>        |(...)  |\<value\>             |
|(...)      |(...)              |(...) |(...)     |(...)            |(...)            |(...)  |(...)                 |
|6          |WALKING_UPSTAIRS   |TRAIN |\<value\> |\<value\         |\<value\>        |(...)  |\<value\>             |

It's melted to get all the features columns (tBodyAcc-mean()-X, tBodyAcc-mean-Y,...) and substitute them with 2 columns, feature and value as follows:

|activity_id|activity|set_id|subject_id|variable|value|
|:----------|:------:|:----:|:--------:|:---------------:|:---------------:|
|1          |LAYING  |TEST  |1         |tBodyAcc-mean()-X|\<value\>          |
|1          |LAYING  |TEST  |1         |tBodyAcc-mean()-Y|\<value\>          |
|1          |LAYING  |TEST  |1         |tBodyAcc-mean()-Z|\<value\>          |
|1          |LAYING  |TEST  |1         |\<feature\>      |\<value\>|
|(...)      |(...)   |(...) |(...)     |(...)            |(...)|
|6         |WALKING_UPSTAIRS  |TRAIN  |29         |tGravityAcc-std()-Z     |\<value\>|

Once melt, the dataset get its 'variable' column renamed to 'feature', grouped by subject_id, set, activity and feature. For each group the values mean is calculated. The dataset is transformed as:

|activity|set_id|subject_id|feature|value|
|:------:|:----:|:--------:|:---------------:|:---------------:|
|LAYING  |TEST  |1         |tBodyAcc-mean()-X|\<summarised_value_X\>          |
|LAYING  |TEST  |1         |tBodyAcc-mean()-Y|\<summarised_value_Y\>          |
|LAYING  |TEST  |1         |tBodyAcc-mean()-Z|\<summarised_value_Z\>          |
|LAYING  |TEST  |1         |\<feature\>      |\<summarised_value\>|
|(...)      |(...)   |(...) |(...)     |(...)            |(...)|
|WALKING_UPSTAIRS  |TRAIN  |29         |tGravityAcc-std()-Z     |\<summarised_value_Z\>|

As it might seem tidy data, the X, Y and Z features correspond to the same observation, so they must be in the same row. This is the "Variables are stored in both rows and columns" problem, and is addressed as follows:

#### Variables are stores in both rows and columns

As for "tBodyAcc-mean" as an example, the 3 axis measurement are considered as the same observation, so the 3 rows must be collapsed in only one. The same has to be done to each feature.

To cast the melted data in such a way, a new column 'axis' is derived from the feature column as follows:

|activity|set_id|subject_id|feature|value|axis|
|:------:|:----:|:--------:|:---------------:|:---------------:|:---:|
|LAYING  |TEST  |1         |tBodyAcc-mean()-X|\<summarised_value_X\>          |X|
|LAYING  |TEST  |1         |tBodyAcc-mean()-Y|\<summarised_value_Y\>          |Y|
|LAYING  |TEST  |1         |tBodyAcc-mean()-Z|\<summarised_value_Z\>          |Z|
|LAYING  |TEST  |1         |\<feature\>      |\<summarised_value\>|
|(...)   |(...) |(...)     |(...)            |(...)|(...)|
|WALKING_UPSTAIRS  |TRAIN  |29         |tGravityAcc-std()-Z     |\<summarised_value_Z\>|Z|

As the axis is in a different column, the axis is trimmed from the 'feature' column:

|activity|set   |subject_id|feature      |value|axis|
|:------:|:----:|:--------:|:---------------:|:---------------:|:---:|
|LAYING  |TEST  |1         |tBodyAcc-mean|\<summarised_value_X\>          |X|
|LAYING  |TEST  |1         |tBodyAcc-mean|\<summarised_value_Y\>          |Y|
|LAYING  |TEST  |1         |tBodyAcc-mean|\<summarised_value_Z\>          |Z|
|LAYING  |TEST  |1         |\<feature\>      |\<summarised_value\>|\<axis\>|
|(...)   |(...) |(...)     |(...)            |(...)               |(...)|
|WALKING_UPSTAIRS  |TRAIN  |29         |tGravityAcc-std     |\<summarised_value_Z\>|Z|

And now the dataset has 3 rows for the *same* feature and *different* axis. 'feature' has the same value in 3 rows, differring in the axis data. Data is rearranged and casted with axis to be unstacked using 'value' as the value for each new axis column:

|subject_id|set   |activity  |feature          |X                |Y    |Z       |
|:--------:|:----:|:--------:|:---------------:|:---------------:|:---:|:------:|
|1         |TEST  |LAYING      |tBodyAcc-mean|\<summ_value_X\>|\<summ_value_Y\>|\<summd_value_Z\>|
|(...)     |(...) |(...)     |(...)            |(...)|(...)|(...)|
|29  |TRAIN  |WALKING_UPSTAIRS         |tGravityAcc-std    |\<summ_value_X\>|\<summ_value_Y\>|\<summ_value_Z\>|
        
#### Multiple variables are stored in one column
As for the sensor origin , a new column 'origin' is used to split that data from the "feature" column. 'origin' can be one of "ACCELEROMETER" or "GYROSCOPE". This column is derived on the feature value depending on "Acc" or "Gyro" is contained in the value.

Same criteria is used for the measurement value domain: "TIME" or "FREQUENCY", depending if "feature" begins by "t" or "f". For this data, the 'domain' column is used.

|subject_id|set   |activity  |feature          |X                |Y    |Z       |origin|domain|
|:--------:|:----:|:--------:|:---------------:|:---------------:|:---:|:------:|:----:|:----:|
|1         |TEST  |LAYING      |tBodyAcc-mean|\<X\>|\<Y\>|\<Z\>|ACCELEROMETER|TIME|
|(...)     |(...) |(...)     |(...)            |(...)|(...)|(...)|\<origin\>|\<domain\>|
|29  |TRAIN  |WALKING_UPSTAIRS         |tGravityAcc-std    |\<X\>|\<Y\>|\<Z\>|ACCELEROMETER|TIME|

This final data format is considered tidy data.

Output data is returned as the text file "tidy_dataset.txt" and also as function output. 
