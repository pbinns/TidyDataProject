## Code Book for the Tidy Data Project

### Content Overview
   
The high level overall objectives of the **Tidy Data Project** and some of the application history behind the source data set are explained in README.md.   You are encouraged to review READM.md before reading this Code Book for context. 

This Code Book provides more details of the five steps taken when transforming and 
summarizing the Samsung data to produce the output tidy data set uploaded to the Coursera website (also included in this repo).   It does not provide further history or references of the source of the original Samsung data set.  The original Samsung data set has also been copied to this repo for the sake of reference and completeness.

The five steps of the **Tidy Data Project** addressed are:

1.  Merging the training and test sets to create one data set.

2.  Rationale for and extraction of the measurements of mean and standard deviation (pairs).

3.  The replacement of numbers with descriptive activity names for each activity type.

4.  The assignment of descriptive variable names to the data columns.

Once this step is completed, the data set is in a tidy format and has been output to file TidyDataTable1.txt, which is included in this repo.

5.  The processing of data in TidyDataTable1.txt to sum over each subject-activity pair, producing a new (and smaller) tidy data set stored in file TidyProcessedSensorData.txt (also uplodaded to the Coursera website).

Comments are also included in function run_analysis.R tying code chunks to the functional behavior described in these steps, and reference to relevant functions in run_analysis.R are made here.

### 1: Merging the Data Sets

The full Sumsung data set is found in directory UCI HAR Dataset.

Both a training and testing data set resides in subdirectories UCI HAR Dataset/train and UCI HAR Dataseet/test, respectively.  Each of these directories has a subdirectory called Inertial Signals which contains the raw sensor data collected from the gyro and accelerometer.  This raw data has not been included because it does not appear to be the mean or standard deviation of a variable.

In the experiment, there are 30 distinct subjects, each of whom performs six distinct activities.  
Files subject_test.txt and subject_train.txt contain the subject identifiers, with each file containing a single column of data with integer values in the range of 1:30.  

Files y_test.txt and y_train.txt contain the activity identifier, with each file containing a single column of data with integer values in the range of 1:6.  

The rows of files x_test.txt and y_train.txt contain data for 561 "features"" extracted from the raw data set.  These features are functions of the raw sensor data which appear to be navigation-related quantities that might be useful for predicting a person's position or heading when used for tracking.     

For all training data sets, there are 7352 rows of data.   For all test data sets, there are 2947 rows of data.   The subjects in the training set are distinct from the subjects in the test data set (as this would introduce experimental bias).  When combined, there are 10299 observations.  The file structure is described in **Table 1**.


#### Table 1:  Stucture of the input files

     Input data file        | dimensions (rowsxcolumns) | Variable descriptions; column count = #variables   
     -----------------------|--------------------------------------------------------------------------------------  
     subject_train.txt      | 7352x1                    | subject training id for sensor observational data  
     y_train.txt            | 7352x1                    | activity id for sensor observational data  
     X_train.txt            | 7352x561                  | feature data computed from raw data observations  
     -----------------------|---------------------------|----------------------------------------------------------  
     subject_test.txt       | 2947x1                    | subject training id for sensor observational data  
      y_test.txt            | 2947x1                    | activity id for sensor observational data  
      X_test.txt            | 2947x561                  | feature data computed from raw data observations  
   
   
The files are initially merged into a common data frame with 10299 rows and 564 columns.  This is performed by function input_data_and_merge in run_analysis.R.   The structure of the returned data frame is shown in **Table 2**.

#### Figure 1:  Initial Merged Data Frame Column Structure (10299 rows)

  * Column 1 = subject id; integer in 1:30
  * Column 2 = data source; 1 = train directory, 2 = test directory
  * Column 3 = subject activity; integer in 1:6
  * Columns 4 - 564 = the 561 features in X_train/X_test.

The data source is never used, so this was extra work, but it could be used to separate out the training and test cases in the future.   


### 2: Rationale and extraction of mean-std measurement pairs

The data declaration for which variables are to be kept and what the variables are to be named is found in function extract_columns_and_names_to_keep in run_analysis.R.   The returned data.frame is called col_index_and_names.

We differentiated data that appeared to be the result of an application of either the mean or standard deviation from data that was the function some mean-valued quantity.   For example, the mean of quantity fBodyGyro in the X direction might symbolically be characterized (not necessarily in R) as mean(fBodyGyro, X).  Thus quantities such as fBodyGyro-mean-X, fBodyGyro-std-X, fBodyGyro-mean-Y, etc. are included in the final tidy data set.  It turns out that for every feature with a mean, there is a corresponding feature with a std.

In contrast, a function to find the frequency about which a gyro oscillates on average is not included because a fequency is an input parameter to the gyro.  Certainly it would have been reasonable to include it, and to do so would require adding only one extra line of code per variable in data.frame col_index_and_names.   

We opted to use the factor names as descriptive variable names except the () was removed to make the names valid R names.  Using this convention, all variable names end in one of the following suffixes:

  * -mean
  * -mean-X
  * -mean-Y
  * -mean-Z
  * -std
  * -std-X
  * -std-Y
  * -std-Z

There are 66 such variables with these suffixes.  **Table 2** lists the variable names, their original file source, and in the case of physical quantities, the feature number, and the plausible units of the variables.  We discuss units and the descriptiveness of name selection in **Section 4**. 



#### Table 2: File Sources, Variable Names included in Tidy Sets and Units
   
   
      file source         | feature number  |  variable name            | plausible units 
                          | in features.txt |  in run_analysis          |  or type      
      --------------------|-----------------|---------------------------|-----------------    
      subject_test/train  |      NA         | subject                   |  id in 1:30 
      y_test/train        |      NA         | activity                  |  activity type
      --------------------|-----------------|---------------------------|-----------------  
      all physical        |       1         | tBodyAcc-mean-X           |  meters/sec^2  
      quantities below    |       2         | tBodyAcc-mean-Y           |     .
      are variables       |       3         | tBodyAcc-mean-Z           |     . 
       with data in       |       4         | tBodyAcc-std-X            |     . 
         files            |       5         | tBodyAcc-std-Y            |     .  
      x_test or x_train   |       6         | tBodyAcc-std-Z            |     .  
           .              |      41         | tGravityAcc-mean-X        |  meters/sec^2
           .              |      42         | tGravityAcc-mean-Y        |     .
           .              |      43         | tGravityAcc-mean-Z        |     .
                          |      44         | tGravityAcc-std-X         |     .
                          |      45         | tGravityAcc-std-Y         |     .
                          |      46         | tGravityAcc-std-Z         |     .
                          |      81         | tBodyAccJerk-mean-X       |  meters/sec^3 
                          |      82         | tBodyAccJerk-mean-Y       |     .
                          |      83         | tBodyAccJerk-mean-Z       |     .
           .              |      84         | tBodyAccJerk-std-X        |     .
           .              |      85         | tBodyAccJerk-std-Y        |     .
           .              |      86         | tBodyAccJerk-std-Z        |     .
                          |     121         | tBodyGyro-mean-X          |   rad/sec
                          |     122         | tBodyGyro-mean-Y          |     .
                          |     123         | tBodyGyro-mean-Z          |     .
                          |     124         | tBodyGyro-std-X           |     .
                          |     125         | tBodyGyro-std-Y           |     .
                          |     126         | tBodyGyro-std-Z           |     .
                          |     161         | tBodyGyroJerk-mean        |  rad/sec^3
           .              |     162         | tBodyGyroJerk-mean-Y      |     .
           .              |     163         | tBodyGyroJerk-mean-Z      |     .
           .              |     164         | tBodyGyroJerk-std-X       |     .
                          |     165         | tBodyGyroJerk-std-Y       |     .
                          |     166         | tBodyGyroJerk-std-Z       |     .
                          |     201         | tBodyAccMag-mean          | meters/sec^2
                          |     202         | tBodyAccMag-std           |     "
                          |     214         | tGravityAccMag-mean       | meters/sec^2
                          |     215         | tGravityAccMag-std        |     "
                          |     227         | tBodyAccJerkMag-mean      | meters/sec^3
                          |     228         | tBodyAccJerkMag-std       |     "
           .              |     240         | tBodyGyroMag-mean         |   rad/sec
           .              |     241         | tBodyGyroMag-std          |     "
           .              |     253         | tBodyGyroJerkMag-mean     |   rad/sec^3
                          |     254         | tBodyGyroJerkMag-std      |     "
                          |     266         | fBodyAcc-mean-X           | meters/sec^2
                          |     267         | fBodyAcc-mean-Y           |     "
                          |     268         | fBodyAcc-mean-Z           |     "
                          |     269         | fBodyAcc-std-X            |     "
                          |     270         | fBodyAcc-std-Y            |     "
                          |     271         | fBodyAcc-std-Z            |     "
                          |     345         | fBodyAccJerk-mean-X       | meters/sec^3
                          |     346         | fBodyAccJerk-mean-Y       |     "
                          |     347         | fBodyAccJerk-mean-Z       |     "
                          |     348         | fBodyAccJerk-std-X        |     "
                          |     349         | fBodyAccJerk-std-Y        |     "
                          |     350         | fBodyAccJerk-std-Z        |     "
            .             |     424         | fBodyGyro-mean-X          |  rad/sec
            .             |     425         | fBodyGyro-mean-Y          |     "
            .             |     426         | fBodyGyro-mean-Z          |     "
                          |     427         | fBodyGyro-std-X           |     "
                          |     428         | fBodyGyro-std-Y           |     "
                          |     429         | fBodyGyro-std-Z           |     "
                          |     503         | fBodyAccMag-mean          | meters/sec^3
                          |     504         | fBodyAccMag-std           |     "
            .             |     516         | fBodyBodyAccJerkMag-mean  |     "
            .             |     517         | fBodyBodyAccJerkMag-std   |     "
            .             |     529         | fBodyBodyGyroMag-mean     |     "
                          |     530         | fBodyBodyGyroMag-std      |     "
                          |     542         | fBodyBodyGyroJerkMag-mean |     "
                          |     543         | fBodyBodyGyroJerkMag-std  |     "   
   
   
   
**Table 3** contains the names and indices of 19 other features that could very reasonably have been included.  
Again, including an additional variable only requires adding only one extra line of code in the data.frame declarations for col_index_and_names.  If all 19 were added,  there would be 85 = 19 + 66 physical quantities of data for each observation.

#### Table 3: Omitted Activites - function of a mean, not mean of a quantity

      index in feature.txt            |     feature name
      --------------------------------|---------------------------------------------------
          294                         | fBodyAcc-meanFreq()-X
          295                         | fBodyAcc-meanFreq()-Y
          296                         | fBodyAcc-meanFreq()-Z
          373                         | fBodyAccJerk-meanFreq()-X
          374                         | fBodyAccJerk-meanFreq()-Y
          375                         | fBodyAccJerk-meanFreq()-Z
          452                         | fBodyGyro-meanFreq()-X
          453                         | fBodyGyro-meanFreq()-Y
          454                         | fBodyGyro-meanFreq()-Z
          526                         | fBodyBodyAccJerkMag-meanFreq()
          539                         | fBodyBodyGyroMag-meanFreq()
          552                         | fBodyBodyGyroJerkMag-meanFreq()
          555                         | angle(tBodyAccMean,gravity)
          556                         | angle(tBodyAccJerkMean),gravityMean)
          557                         | angle(tBodyGyroMean,gravityMean)
          558                         | angle(tBodyGyroJerkMean,gravityMean)
          559                         | angle(X,gravityMean)
          560                         | angle(Y,gravityMean)
          561                         | angle(Z,gravityMean)


### 3: Replacing numers 1-6 with explicit activity names

Rather than encode an activity type by an integer number in 1:6, factors or strings can be used to describe the activity directly in the data.  This amounts to changing the type of the activity column.  The mapping between activity id or code and the activities descriptive name is:

   *  1 = WALKING
   *  2 = WALKING_UPSTAIRS
   *  3 = WALKING_DOWNSTAIRS
   *  4 = SITTING
   *  5 = STANDING
   *  6 = LAYING
 
This conversion is made and the descriptive activity types are present in both tidy data files TidyDataTable1.txt and TidyProcessedSensorData.txt.


### 4: Descriptive variable name assignment and their units

The variable names and their units are shown in **Table 2** above.  

We have used standard units of meters/sec (m/s) for velocity, meters/sec^2 (m/s^2) for acceleration, and meters/sec^3 (m/s^3) for jerk.  In a footnote in the Samsung README.md file, there is a note that gravity = g is in m/s^2 (or m/seg^2, a possible typo)

The gyro measurements are angular, which are reported as measured in rad/sec (r/s) for velocity and we assume rad/sec^3 
(r/s^3) for jerk.  (Note: there is no gyro acceleration recorded in the data.)

The names chosen largely preserve the names given to the features in the Samsung data, since presumably the names selected earlier had significance to the experimenters.  We were unable to determine what functions were actually computed for the different features so changing the names significantly would be presumptuous.  As noted earlier, the parentheses were deleted to make the syntax for names valid.

We comment that some of the names were confusing when thinking about physics.   For example, given jerk is the derivative of acceleration, which in turn is the derivative of velocity, we assume the quantity tBodyAccJerk-mean-X is the Jerk of tBody, not the Jerk of tBodyAcc which would have different units because it would be a higher order derivative.  A better name *might* be tBodyJerk-mean-X, if in fact, that corresponds to the physical quantity.   

At this point, we have a data.frame **tds1** with 69 columns and nrows = train_nrows + test_nrows = 7352 + 2947 = 10299 
observations in the data.frame, which we output to file **TidyDataTable.1**.  The structure of the file is shown in **Figure 2**.
   
#### Figure 2:  Initial Merged Data.Frame Column Structure (69 columns and 10299 data rows)
  * Column 1 = subject_id integer in 1:30
  * Column 2 = data_source in (TRAIN, TEST)
  * Column 3 = subject activity in (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, STANDING, SITTING, LAYING)
  * Columns 4 - 69 = the 66 features extracted and shown in **Table 2**


### 5: Sums for each subject-activity pair and file TidyProcessedSensorData

Beginning with data.frame **tds1** described in **Section 4**, delete column 2 (data_source), then sum each of the 66 extracted feature (using ColSums) by subject-activity pair.   There are 30 subjects and 6 activities, so there are 180 subject-activity pairs which is the number of observations in the final tidy data set.   

The final tidy data file is called **TidyProcessedSensorData.txt**.  It is tidy because each column is a variable and each row corresponds to an observation.  


#### Figure 3:  Final Tidy Structure (68 columns and 180 data rows)
  * the first row is a header which contains the names of the variables
  * Column 1 = subject_id integer in 1:30
  * Column 2 = subject activity in (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, STANDING, SITTING, LAYING)
  * Columns 3 - 68 = numeric values for the 66 features extracted and shown in **Table 2**
  
  
The following R code can be used to input the data:

    TD2 <- read.table("TidyProcessedSensorData.txt", 
                       quote = "", row.names = NULL, header = TRUE)


  

	