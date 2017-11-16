# Code Book
## Input files

### 'features.txt'
#### Description

List of all features. Each name corresponds to a variable column on the test and training data files.

#### Record format

Blank-separated text files

#### Record length

2 variable length columns

#### Record counts

561 records

#### Data items

Column 1: Integer, feature ID
Column 2: character string, feature name

### 'activity_labels.txt'

#### Description
Links the activity ID with their activity name.

#### Record format

Blank-separated text files

#### Record length

2 variable length columns

#### Record counts

6 records

#### Data items

Column 1: Integer, activity ID
Column 2: character string, activity name

### 'train/X_train.txt'

#### Description

Training set measurements. Each field corresponds to a feature.

#### Record format

Blank-separated fixed-width format text files.

#### Record length

561 fields of scientific notation measurements in 16 character strings. Exponent is zero-padded to 3 digits. Values are in the range [-1..1]

#### Record counts.

561 records

#### Data items

561 feature values
7352 records

### 'train/y_train.txt'
#### Description

Activity ID for each observation in the test data set.

#### Record format

Blank-separated fixed-width format text files.

#### Record length

1 integer field. Values are in the range [1..6]

#### Record counts.

7352 records

#### Data items

1 integer field corresponding to an activity ID in the test data set.

### 'train/subject_train.txt'
#### Description

Subject ID for each observation

#### Record format

Blank-separated fixed-width format text files.

#### Record length

1 integer field. Values are in the range [1..30]

#### Record counts.

7352 records

#### Data items

1 integer field. Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

### 'test/X_train.txt'

#### Description

Training set measurements. Each field corresponds to a feature.

#### Record format

Blank-separated fixed-width format text files.

#### Record length

561 fields of scientific notation measurements in 16 character strings. Exponent is zero-padded to 3 digits. Values are in the range [-1..1]

#### Record counts.

561 records

#### Data items

561 feature values
2947 records

### 'train/y_train.txt'
#### Description

Activity ID for each observation in the training data set.

#### Record format

Blank-separated fixed-width format text files.

#### Record length

1 integer field. Values are in the range [1..6]

#### Record counts.

2947 records

#### Data items

1 integer field corresponding to an activity ID.

### 'train/subject_train.txt'
#### Description

Subject ID for each observation in the training data set.

#### Record format

Blank-separated fixed-width format text files.

#### Record length

1 integer field. Values are in the range [1..30]

#### Record counts.

2947 records

#### Data items

1 integer field. Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

## Output files
### tidy_dataset.txt

#### Description

#### Record format
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
|X|double float|The average of each variable for each activity and each subject on axis 'X'|
|Y|double float|The average of each variable for each activity and each subject on axis 'Y'|
|Z|double float|The average of each variable for each activity and each subject on axis 'Z'|
| origin     | char       | Indicates if the measurement sensor is the ACCELEROMETER or the GYROSCOPE. Each origin also identifies the measurement domain: time or frequency.|
| domain       | char    | Indicates if the measurement is in the TIME or FREQUENCY domain|

#### Record counts.

2881 records
