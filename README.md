
## Tidy Data Project for "Getting and Cleaning Data"

Coursera Course Project README file on Tidy Data for the Johns Hopkins Bloomberg School of
Public Health course, "Getting and Cleaning Data"

### 1: Project Data References

The data used in this project is from the Human Activity Recognition Using Smartphones Dataset, 
Version 1.0 developed and/or documented by:

Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università  degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
activityrecognition '@' smartlab.ws 

For the interested reader, further descriptions are available at the site where the data was obtained:
 
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
  
The data found in subdirectory UCI HAR Dataset is an unzipped version of the data downloaded from site:

  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  
A video of the experiment including an example of the 6 recorded activities with one of the participants
can be seen in the following link: 
  
  http://www.youtube.com/watch?v=XOEN9W05_4A
  
  
More specific information about both the dataset and the design of the experiment used to produce the
data can be found in UCI HAR Dataset/HARS_README.md and UCI HAR Dataset/features_info.md.  Later sections
of this file and the associated Code Book (file = CodeBook.md) also discuss aspects of the data in 
connection with the Tidy Data project.

### 2: Tidy Data Project High Level Overview

The high level objective of the "Getting and Cleaning Data" course project is input a dataset that is 
not tidy and create one that is tidy after performing subsetting and other processing operations on
the merged data.  A tidy dataset resides in a single table, with columns as variables and rows as 
observations. Tidy datasets have other desirable attributes such as descriptively named variables. 


The steps of the process are elaborated in only slightly greater detail below. The Tidy Data project 
Code Book (file = CodeBook.md) for more detailed explanations of the steps.

  1. Input the data from the Human Activity Recognition dataset (aka Samsung dataset) and 
  merge it into a single tidy data.frame.  The dataset is distributed across \train and 
  \test subdirectories, and within each subdirectory there are multiple files that need 
  to be merged to form a complete dataset.  
 
  2. Select a subset of the 561 features (i.e. variables corresponding to sensor measurement data) 
  in the merged data.frame that corresponds to the mean and standard deviations (std) of sensor
  signals used in the Human Activity Recognition using Smartphones project.

  We restricted attention to only those factors with both a mean and std 
  pair present.  The rationale and the variables selected are 
  described in the Tiny Data Code Book.   A total of 66 of the 561 features were 
  retained for inclusion as variables in the Tidy Data set.  19 features involving the mean without
  a corresponding measurement for standard deviation were not included.

  3. Activity names, initially coded as integers in 1:6 are redefined with activity names
  in WALKING, WALKING_UP, WALKING_DOWN, SITTING, STANDING, and LAYING.  
  
  4. The 66 variables selected (in item 2) as corresponding to the mean or standard deviation 
  of quantities derived from physical sensor measurements are given descriptive variable names.
  The naming process and names are described in the Tidy Data Code Book.  The output of this stage
  is an intermediary tidy data file named **TidyDataTable1.txt**.
  
  
  5. For each subject-activity pair, the 66 numeric data columns are summed.  
  30 subjects participated, and each subject performed six distinct activities.   
  The number of observations in the tidy data set is then 30*6 = 180 rows.
  The number of columns is 68 = 2 + 66, where the first column is subject id and 
  the second column is actitity type.   The final file output, **TidyProcessedSensorData.txt**,
  has a header containing the variable names, followed by 180 rows of data, each with 
  68 fields (i.e. named variables).


### 3: Executing the Code and Reading the Tidy Data file

The code to produce the Tidy Data file is in run_analysis.R.  To generate the described tidy dataset 
using the data in directory UCI HAR Dataset using R

  * copy this directory to your local computer (I don't think compilation is supported on GitHub)
  * set the working directory to the directory containing the contents of this directory
  * source the file run_analysis.R and enter 
  *     Tidy_Data <- run_analysis()
  
The final tidy data file produced in the working directory is called **TidyProcessedSensorData.txt**.  
  
To directly read the existing tidy data file,  **TidyProcessedSensorData.txt** as a named data.frame in R

  * set the working directory to the directory containing the file TidyProcessedSensorData.txt and enter
  *     Tidy_Data <- read.table("TidyProcessedSensorData.txt", quote = "", 
                                  row.names = NULL, header = TRUE)
  
  

