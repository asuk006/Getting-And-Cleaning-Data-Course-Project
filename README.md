# Getting and Cleaning Data Course Project

Here I'll explain how the run_analysis.R file creates the required tidy activity_recognition.txt data set.

## CodeBook
The description of the data, the experiment and variables is available in CodeBook.md

## run_analysis.R

This is a very detailed script that creates the required tidy dataset from the raw input.
Here's, briefly, what the script does:

Downloads the zipped raw data and unzips it in the working directory. Required packages are loaded.

1. Merges the training and the test sets to create one data set

2. Extracts only the measurements on the mean and standard deviation for each measurement.
Only those mean and standard deviation estimates on signals that meet the descriptions of the mean() and std() from "features_info.txt" file in a stricter sense were exctracted - i.e. meanFreq() variables and angle() variables that use vectors obtained by averaging the signals were omitted.

3. Assigns descriptive activity names from "activity_labels.txt" to the activity codes in the data set

4. Assigns more descriptive variable names to the columns of the data set( the names were obtained in step 1):

5. Creates a tidy data set with the average of each variable for each activity and each subject

and writes the tidy activity recognition data set to "activity_recognition.txt"

## IMPORTANT: why the resulting data set is tidy?

I chose to present the data set in the narrow form, which as well as the wide form, is acceptable and satisfies the "tidyness". Here, the names of the mean and standard deviation variables for each signal are presented in the varibale column and the average value for each varibale, each subject and each activity is also a variable.

The data sets satisfies all conditions of the "tidy" data, specifically:

Each variable measured is in one column;
Each different observation of that variable is in a different row;
There is be one table for each "kind" of variable

For a more detailed arguemnet about the tidyness of the narrow fromat see David Hood's post from thoughtfulbloke.wordpress.com:

[Getting and Cleaning the Assignment](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/6)

## activity_recognition.txt
Please read the data set with:

read.table(), header = TRUE, row.name = FALSE


## Acknowledgments

Thanks David Hood from (https://thoughtfulbloke.wordpress.com) for the inspiration for the assignment
