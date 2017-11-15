library(dplyr)
library(reshape2)

## `read_features` reads the features.txt file as a blank space delimited file
##
## Argments:
## 'path': Path to the root of the decompressed data
## 'file': File name of the features file
##
## Features are the column names that will be used for the merged and
## tidy data sets

readfeatures <- function(path = "UCI HAR Dataset", file = "features.txt") {
        features <- read.delim(paste(path, file, sep="/"),
                               sep = " ",
                               header = FALSE)
}

## `read_activities` reads the features.txt file as a blank space delimited file
##
## Argments:
## 'path': Path to the root of the decompressed data
## 'file': File name of the features file
##
## Features are the column names that will be used for the merged and
## tidy data sets

readactivities <- function(path = "UCI HAR Dataset", file = "activity_labels.txt") {
        activities <- read.delim(paste(path, file, sep="/"), 
                                      sep = " ", 
                                      header = FALSE)
        
        names(activities) <- c("activity_id", "activity")
        
        activities
}
        
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

readdataset <- function(set, path, featlabels, selcolumns = TRUE) {
        
        ## path and file name character transformations
        path <- paste(path, set, sep = "/")
        
        xfile <- paste(path, paste("X_", set, ".txt", sep = ""), sep = "/")
        yfile <- paste(path, paste("y_", set, ".txt", sep = ""), sep = "/")
        sfile <- paste(path, paste("subject_", set, ".txt", sep = ""), sep = "/")

        
        ## The X file (measurement data) is a fixed width file 
        ## with 561 columns of 16 character-wide fields for each row
        colwidth <- 16
        numcols <- 561
        
        fwf <- rep(colwidth, numcols)
        dataset <- read.fwf(xfile, widths = fwf, header = FALSE)
        names(dataset) <- featlabels
        
        ydata  <- read.delim(yfile, sep = " ", header = FALSE)
        names(ydata)   <- ("activity_id")
        
        sdata  <- read.delim(sfile, sep = " ", header = FALSE)
        names(sdata)   <- ("subject_id")

        ## subject_id and activity_id columns are prepended to the measurement data
        dataset <- cbind(sdata, ydata, dataset)
        
        dataset
}


## 'tidydataset' tidies up the dataset passed as argument
tidydataset <- function(tds) {
        
        colvars <- c("activity", "subject_id", "set")
        msrvars <- grep ("-(mean|std)\\(\\)-[XYZ]$", colnames(tds), value = TRUE)

        tds <- melt(tds, id.vars = colvars, measure.vars = msrvars, value.name = "value")
        
        ## Once melt, the 'variable' column is renamed to 'feature', the dataset is grouped by 
        ## 'subject_id', 'activity_id', 'origin' 
        ## and summarised using the "mean" function to each group
        
        tds <- (rename(tds, feature = variable) %>%
                group_by(subject_id, set, activity, feature) %>%
                summarise(mean = mean(value))) 
        
        ## Axis observation is split between rows, thus same variables being stored in different rows
        tds <- ungroup(tds)
        tds.axis <- sapply(tds$feature, function(str) substr(str, str_length(str), str_length(str)))
        tds$axis <- tds.axis
        tds <- mutate(tds, feature = sub("\\(\\)-[XYZ]", "", tds$feature))
        tds <- dcast(tds, subject_id + set + activity + feature ~ axis, value.var = "mean")

        ## The 'variable' column values are the column names. Each column name
        ## stores some other variables as the measurement source (accel/gyro) that
        ## is added to the tidy dataset.
        
        tds$origin <- rep("ACCELEROMETER", nrow(tds))
        index <- grep ("[a-z]Gyro", tds$feature)
        tds$origin[index] <- c("GYROSCOPE")
        
        tds$domain <- rep("TIME", nrow(tds))
        index <- grep ("^f", tds$feature)
        tds$domain[index] <- c("FREQUENCY")
        tds
}

## `run_analysis` does the following:
##
## - Reads the "activities" and "features" files
## - Reads the "test" and "train" datafiles through the `readdataset` function
##       * `readdataset` uses the "features" file information - as a dataframe - to
##         (2) extract only the measurements on the mean and standard deviation for each 
##             measurement
##         (4) Appropriately labels the data set with descriptive variable names through
##             the use of the "features" data frame, 'activity_id' as a link to the
##             activities file data and 'subject_id'
##         
## - (1) Merges the training and test sets to create one data set
##       * A new vector "set_id" is built with as many level ids of
##         test/train row numbers. (4) "set_id" is the descriptive column
##         name set identification
##       * Once the test and train dataframes are merged, the "set" vector
##         is column-binded to keep the set whose information belongs to
##
## - (3) Uses descriptive activity names to name the activities in the data set
##       * "activities" is considered as another set of data, so a merge() join
##         is done on 'activity_id'. The resulting dataframe includes the activity_id
##         and 'activity' column as the descriptive activity name
##
## - (5) From the data set in step 4, creates a second, independent tidy data set 
##       with the average of each variable for each activity and each subject.

run_analysis <- function() {
        ## Uncompressed file path defaults to "UCI HAR Dataset", but assignment
        ## indicates to use files on working directory
        ## 'test' and 'train' folders are assumed to exist
        
        path  <- c(".")
        
        activities <- readactivities(path)
        features   <- readfeatures(path)
        featlabels <- sapply(features[,2], as.character)
        
        test  <- readdataset("test",  path, featlabels)
        train <- readdataset("train", path, featlabels)
        
        set <- factor(c(rep(1, nrow(test)), rep(2, nrow(train))), labels=c("TEST", "TRAIN"))
        names(set) <- "set_id"
        
        dataset <- cbind(set, rbind(test, train))
        
        dataset <- merge(activities, dataset)
        
        ## Only the data columns ending in -mean() or -std() are extracted
        ## 'features' contains the labels for each column. Those column names are passed
        ## as a function argument
       
        dataset <- dataset[, c(1:4,  grep ("-(mean|std)\\(\\)-[XYZ]$", names(dataset)))]

        tidyds <- tidydataset(dataset)
        
        write.table(tidyds, "tidy_dataset.txt", row.names = FALSE)
        tidyds
}


## Coge el "eje" de la medición: sapply(x$feature, function(str) substr(str, str_length(str), str_length(str)))