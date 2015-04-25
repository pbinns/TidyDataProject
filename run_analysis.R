
## This function is the code book script used to generate the tidy data set
## for the Coursera course from the JHSPH, "Getting and Cleaning Data"

## The primary sobjectives of this project/code book script are
##   1)  to input the raw data containing information derived from sensor 
##       data on a Samsung cell phone from multiple files and merge 
##       the training and test data, 
##   2)  select or extract only a subset of that data having to do with the mean
##       and standard deviation of the measurment data 
##   3)  to provide the data with descriptive variable names and data values for
##       the activity data, 
##    4) to organize the selected subset of data so that the data set meets the
##       critera of a tidy data set, and 
##    5) to process the tidy data set, collapsing the size of the data so that only
##       the sums of the included variables are reported for each subject-activity
##       combination.

##  More detailed documentation is embedded throughout the code.


run_analysis <- function()
{
  
  #  may need to install.packages("data.table)
  input_data_and_merge <- function() {
    
    ## Part 1:  Input the data files into data tables.
    # The original data is a zip file with url = 
    # https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
  
    # Unfortunately this script does not download and unzip the data because 
    # I could not find an unzip function in R that works on a Windows 7 platform, 
    # and don't know enough R or low level Windows commands to interface the R 
    # languages with Windows commands.
    # Ideally, this script would download and unzip the files, and log it with a date.
    # The assignment doesn't call for that, though.
  
    # The unzipped version of the data to be input is found in the UCI HAR Dataset 
    # subdirectory. The full directory and file structure is detailed in CodeBook.md     
  
    # comment: paste0 is a version of paste that leaves no blanks between strings
  
    directory <- "UCI HAR Dataset"
    
    # input the training data files in subdirectory /train
    
    train_path <- paste0(directory, "/train")
    
    # read subject training data
    subject_file <- paste0(train_path, "/subject_train.txt")
    train_subject <- read.fwf(subject_file, widths = 2, sep = " ")
    
    # read the activtity training data
    activity_file <- paste0(train_path, "/y_train.txt")
    train_activity <- read.fwf(activity_file, widths = 1, sep = " ")
    
    # read the sensor data in the X_train.txt file
    sensor_data_file <- paste0(train_path, "/X_train.txt")
    X_train <- read.table(sensor_data_file)
    ## Comment:  read.table only works because the separator is a blank, 
    ## otherwise we would need to read in fixed width columns, and read.fwf is
    ## very slow.   There is a package LaF, designed to do it quickly,
    ## but the installation of the package is not straight forward.
    ## So we used read.table because we have a very special case.
    
   
    ## Now read the test data files in subdirectory /test
    
    test_path <- paste0(directory,"/test")
    
   # read subject test data
    subject_file <- paste0(test_path, "/subject_test.txt")
    test_subject <- read.fwf(subject_file, widths = 2, sep = " ")
    
    # read the activtity test data
    activity_file <- paste0(test_path, "/y_test.txt")
    test_activity <- read.fwf(activity_file, widths = 1, sep = " ")
  
    # read the test sensor data using read.table for this very special format
    sensor_data_file <- paste0(test_path, "/X_test.txt")
    X_test <- read.table(sensor_data_file)
   
     # Now merge the training and test sets after creating
     # a collection category for the data called data_source (i.e. train or test)
     # This links the data files together, although this is not needed
     # for the project.
   
    data_source <- rep(1L, length(train_subject[[1]]))
    train_source <- data.frame(data_source)
   
    data_source <- rep(2L, length(test_subject[[1]]))
    test_source <- data.frame(data_source)
    
    # row bind is like an append of one file after another
    subject <- rbind(train_subject, test_subject)
    data_source <- rbind(train_source, test_source)
    activity <- rbind(train_activity, test_activity)
    sensor_data <- rbind(X_train, X_test)
   
    # now join the separate files with different columns
    merged_data <- cbind(subject, data_source, 
                         activity, sensor_data)
    
    return(merged_data)
  }  # end function input_data_and_merge
  
  extract_columns_and_names_to_keep <- function(){
    
    #  This function outputs the list of columns to keep and their 
    #  descriptive names.   These are most (but not all) of the operations
    #  for objectives 2 and 3.   Constuction of the tidy data structure
    #  and resetting of activity values is not done here.
    
    #  Because the names were not input with the data, we opted not
    #  to have R read the text file features_info, and parse the names,
    #  but rather we copied them with minor edits to make them suitable
    #  "R names" for a data frame.   Our selection criteria rationale 
    #  is provided in CodeBook.md.
    
    col_index_and_name = rbind( c(  1, "subject"),
                                c(  2, "data_source"), # deleted for final Tidy Set.
                                c(  3, "activity"),
                                c(  4, "tBodyAcc-mean-X"), 
                                c(  5, "tBodyAcc-mean-Y"),
                                c(  6, "tBodyAcc-mean-Z"),
                                c(  7, "tBodyAcc-std-X"),
                                c(  8, "tBodyAcc-std-Y"),
                                c(  9, "tBodyAcc-std-Z"),
                                c( 44, "tGravityAcc-mean-X"),
                                c( 45, "tGravityAcc-mean-Y"),
                                c( 46, "tGravityAcc-mean-Z"),
                                c( 47, "tGravityAcc-std-X"),
                                c( 48, "tGravityAcc-std-Y"),
                                c( 49, "tGravityAcc-std-Z"),
                                c( 84, "tBodyAccJerk-mean-X"),
                                c( 85, "tBodyAccJerk-mean-Y"),
                                c( 86, "tBodyAccJerk-mean-Z"),
                                c( 87, "tBodyAccJerk-std-X"),
                                c( 88, "tBodyAccJerk-std-Y"),
                                c( 89, "tBodyAccJerk-std-Z"),
                                c(123, "tBodyGyro-mean-X"),
                                c(125, "tBodyGyro-mean-Y"),
                                c(126, "tBodyGyro-mean-Z"),
                                c(127, "tBodyGyro-std-X"),
                                c(128, "tBodyGyro-std-Y"),
                                c(129, "tBodyGyro-std-Z"),
                                c(164, "tBodyGyroJerk-mean-X"),
                                c(165, "tBodyGyroJerk-mean-Y"),
                                c(166, "tBodyGyroJerk-mean-Z"),
                                c(167, "tBodyGyroJerk-std-X"),
                                c(168, "tBodyGyroJerk-std-Y"),
                                c(169, "tBodyGyroJerk-std-Z"),
                                c(204, "tBodyAccMag-mean"),
                                c(205, "tBodyAccMag-std"),
                                c(217, "tGravityAccMag-mean"),
                                c(218, "tGravityAccMag-std"),
                                c(230, "tBodyAccJerkMag-mean"),
                                c(231, "tBodyAccJerkMag-std"),
                                c(243, "tBodyGyroMag-mean"),
                                c(244, "tBodyGyroMag-std"),
                                c(256, "tBodyGyroJerkMag-mean"),
                                c(257, "tBodyGyroJerkMag-std"),
                                c(269, "fBodyAcc-mean-X"),
                                c(270, "fBodyAcc-mean-Y"),
                                c(271, "fBodyAcc-mean-Z"),
                                c(272, "fBodyAcc-std-X"),
                                c(273, "fBodyAcc-std-Y"),
                                c(274, "fBodyAcc-std-Z"),
                                c(348, "fBodyAccJerk-mean-X"),
                                c(349, "fBodyAccJerk-mean-Y"),
                                c(350, "fBodyAccJerk-mean-Z"),
                                c(351, "fBodyAccJerk-std-X"),
                                c(352, "fBodyAccJerk-std-Y"),
                                c(353, "fBodyAccJerk-std-Z"),
                                c(427, "fBodyGyro-mean-X"),
                                c(428, "fBodyGyro-mean-Y"),
                                c(429, "fBodyGyro-mean-Z"),
                                c(430, "fBodyGyro-std-X"),
                                c(431, "fBodyGyro-std-Y"),
                                c(432, "fBodyGyro-std-Z"),
                                c(506, "fBodyAccMag-mean"),
                                c(507, "fBodyAccMag-std"),
                                c(519, "fBodyBodyAccJerkMag-mean"),
                                c(520, "fBodyBodyAccJerkMag-std"),
                                c(532, "fBodyBodyGyroMag-mean"),
                                c(533, "fBodyBodyGyroMag-std"),
                                c(545, "fBodyBodyGyroJerkMag-mean"),
                                c(546, "fBodyBodyGyroJerkMag-std"))
    return(col_index_and_name)
  }  # end function extract_cols_and_names_to_keep
  
  
  #  start of the executable code for run_analysis begins here
  
  merged_data <- input_data_and_merge()

  col_index_and_name <- extract_columns_and_names_to_keep()
  
  ## produce tidy data set number 1 from the merged data that includes
  ## only those columns as variables specified in col_index_and_name.
  ## Also use more descriptive names for variable activity.

  activity_type <- c( "WALKING",
                      "WALKING_UPSTAIRS",
                      "WALKING_DOWNSTAIRS",
                      "SITTING",
                      "STANDING",
                      "LAYING")
  
  data_source <- c("TRAIN", "TEST")
  
  subject_range <- 1:30
  
  # find the number of rows and columns in the first tidy data set
  
  num_rows <- length(merged_data[[1]])
  num_cols <- length(col_index_and_name[,1])
  row_names <- rep("", num_rows)
  col_names <- col_index_and_name[,2]
  
  # The merged_data data.frame is a tidy data set containing all variables, 
  # but without the descriptive names.
  # First we will iterate through the columns to include only the 
  # 69 relevant columns. Then we will iterate through the rows and give
  # activity and source meaningful data value names.
  # Finally we give the columns names.
  
  tds1 <- merged_data[,1]
  
  for (j in 2:num_cols){
    
    col_to_keep <- as.integer(col_index_and_name[j,1])
    index <- floor(col_to_keep)       # need an integer index  
    data_col <- merged_data[index]
    tds1 <- cbind(tds1, data_col)

  }
    
  subject_col <- 1L
  dsource_col <- 2L   # defined in function col_index_and_name
  activity_col <- 3L
   
  for (j in 1:num_rows) {
    
    activity_index <- tds1[j,activity_col] 
    activity_index <- as.integer(activity_index)
    aindex <- floor(activity_index)     
    # aindex is redundant, originally used for type conversion 
    activity_name <- activity_type[aindex]
    
    source_index <- tds1[j,dsource_col]
    source_index <- as.integer(source_index)
    sindex <- floor(source_index)
    source_name <- data_source[sindex]
    
    tds1[j, activity_col] <- activity_name
    tds1[j, dsource_col] <- source_name

  }   # end for j in 1:num_rows
  
  names(tds1) <- col_names   # name the column headings for easier debugging
  
  write.table(tds1, "TidyDataTable1.txt", row.names = FALSE, col.names = col_names )
  
  #  Finally, we sum over each pairing of subject activity and store the results
  #  in a new tidy data set, which will be written to a file and uploaded to Coursera
  #  for review.   In the process, we eliminate the data_source columne (train, test)
  #  since it was not required, and so could be argued not to belong in the project's
  #  tidy data set.
  
  
  ## declare new data structures for the Tidy_Data data.frame to hold the 
  ## summed column data for each (subject_id, activity_type) pair.
  
  tidy_col_names <- col_names[c(1,3:num_cols)]    # omit the column with data_source
  tidy_row_count <- length(subject_range)*length(activity_type)
  tidy_col_count <- length(tidy_col_names)
  tidy_data_count <- tidy_row_count*tidy_col_count
  
  # create a vector that contains the summed data as it is produced and 
  # used to fill the Tidy_Data data.frame
  xtemp <- c(1:(tidy_col_count -2))
  New_Tidy_Row <- c(0,"e", xtemp)
  
  # create a data.frame of the right size and type to store the Tidy_Data
  subject <- 1:tidy_row_count
  activity <- c(rep("move", tidy_row_count))
  Tidy_Data <- data.frame(cbind(subject, activity), stringsAsFactors = FALSE)
  data_col <- c(rep(-4.327, tidy_row_count))  # an arbitrary value
  
  for (j in 3:tidy_col_count){
    Tidy_Data <- data.frame(cbind(Tidy_Data, data_col), stringsAsFactors = FALSE)
  }
  
  names(Tidy_Data) <- tidy_col_names
  
  tds1$data_source <- NULL       # pretty easy way to remove the unnecessary column
  activity_col <- 2              # reset the activity column
  
  for (i in subject_range){
      for (j in 1:length(activity_type)){
  
          subject_id <- i
          activity_name <- activity_type[j]
          
          # X_temp contains all rows for which the specified col value conditions hold
          X_temp <- tds1[(tds1$subject == subject_id 
                          & tds1$activity == activity_name), ]
          # names(X_temp) <- tidy_col_names
          # The index computation is standard into computer science computation for
          # indexing into an object with two dimensions of size nrows = 30, ncols = 6
          # If you haven't had an intro data structures course, you may not have 
          # seen this before.
          index <- as.integer((i-1)*length(activity_type) + j)
      
          D_temp <- colSums(X_temp[ , -c(subject_col, activity_col)])
      
          New_Tidy_Row <- c(subject_id, activity_name, D_temp)
          Tidy_Data[index, ] <- New_Tidy_Row
                      
    }   # end for j in activity_type
  }  # end for i in subject_range
  
  # col_Classes <- c("integer", "character", rep("numeric", 46))
  # factor variables are the default for character variables, which seems ok.
  
  write.table(Tidy_Data, "TidyProcessedSensorData.txt", quote = FALSE,
              row.names = FALSE, col.names = tidy_col_names )
  
  return(Tidy_Data)
  
  ## try reading it in as a test.
  
  # TD2 <- read.table("TidyProcessedSensorData.txt", 
  #           quote = "", row.names = NULL, header = TRUE)
  
  # return(TD2)
  
}