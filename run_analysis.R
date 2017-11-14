


readfeatures <- function(path = "UCI HAR Dataset", file = "features.txt") {
        features <- read.delim(paste(path, file, sep="/"),
                               sep = " ",
                               header = FALSE)
}

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

readdataset <- function(set, path, features, selcolumns = TRUE) {
        
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
        
        ## 'features' contains the labels for each column. Those column names are passed
        ## as a function argument
        featlabels <- sapply(features[,2], as.character)
        names(dataset) <-  featlabels
        
        if (selcolumns) dataset <- dataset[, grep ("-(mean|std)\\(\\)", featlabels)]
        
        ydata  <- read.delim(yfile, sep = " ", header = FALSE)
        names(ydata)   <- ("activity_id")
        
        sdata  <- read.delim(sfile, sep = " ", header = FALSE)
        names(sdata)   <- ("subject_id")

        ## subject_id and activity_id columns are prepended to the measurement data
        cbind(sdata, ydata, dataset)
}

colextract <- function(set, features) {

}

tidydataset <- function(ds) {
        
        library(reshape2)
        
        cn <- colnames(ds)
        colvars <- c("activity_id", "activity", "subject_id", "set")
        msrvars <- grep ("(-(mean|std)\\(\\))", colnames(ds), value = TRUE)
        ds <- melt(ds, id.vars = colvars, measure.vars = msrvars, value.name = "value")
        
        ## Once melt, the dataset is grouped by 'subject_id', 'activity_id', and the "mean"
        ## function is applied to each variables
        
        tds <- (rename(ds, feature = variable) %>%
                group_by(subject_id, activity, feature) %>%
                summarise(mean = mean(value)))
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
        
        test  <- readdataset("test",  path, features)
        train <- readdataset("train", path, features)
        
        set <- factor(c(rep(1, nrow(test)), rep(2, nrow(train))), labels=c("TEST", "TRAIN"))
        names(set) <- "set_id"
        
        dataset <- cbind(set, rbind(test, train))
        
        dataset <- merge(activities, dataset)

        #tidyds <- tidydataset(dataset)
        
        write.table(tidyds, "tidy_dataset.txt", row.name=FALSE)
        tidyds
}