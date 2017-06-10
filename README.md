# Couursea - Getting and Cleaning Data Course Project 
This is the course project for Getting and Cleaning Data course on Coursera. Code is written in R in file. Source file is run_analysis.R. 
Background:
==========
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data Set:
=========
- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
 
Objectives:
==========
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. 

Deliverables:
=============
1) a tidy data set which tidydata.txt
2) a link to a Github repository with your script for performing the analysis, run_analysis.R.
3) a code book, CodeBook.md, that describes the variables, the data, and any transformations or work performed to clean up the data.

run_analysis.R
==============
This R script does the following:
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement.
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names.
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Sample output
=============
tidydata.png, View the content in R studio before output to tidydata.txt

Output
======
The tidydata.txt is the tidy data set

CodeBook
========
An overview of the output data fields description.
