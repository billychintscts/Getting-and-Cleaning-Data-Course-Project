library(data.table)
library(dplyr)
library(gsubfn)
# set the working firectory
# the data is unzip in this working directory
setwd("C:/DataScience/Course3/project")


combined <- function(){
  ## Read in all of the data, subject, X_test, y_test
  subj_test <- as.data.table(read.table("UCI HAR Dataset/test/subject_test.txt"))
  X_test <- as.list(read.table("UCI HAR Dataset/test/X_test.txt"))
  y_test <- as.data.table(read.table("UCI HAR Dataset/test/y_test.txt"))
  
  ## Read in the labels, convert to a comma-separated data set which plays nicely
  ## with assigning colnames
  features <- readLines("UCI HAR Dataset/features.txt")
  features <- replace(features, "\n", ",")
  
  ## Set up initial data table with subject and test numbers
  test <- data.table(subject = subj_test[[1]], testlabel = y_test)
  
  ##  Adds the various data columns from the X_test file
  for (i in 1:length(X_test)){
    test <- cbind(test, X_test[[i]])
  }
  
  ## Assigns the colnames to the provided features data
  colnames(test) <- c("subject", "testlabel", features[1:length(features)-1])
  
  ## organized header names and remove extraneous numbers
  names(test) <- tolower(unlist(names(test)))
  headers <- names(test)
  headers <- strsplit(headers, " ")
  for (i in 3:length(headers)){
    headers[i] <- headers[[i]][2]
  }
  names(test) <- unlist(headers)
  
  ## Repeat using the trainig set of data
  subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
  X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
  y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
  
  ## set up the training data table with subject and test numbers
  train <- data.table(subject = subj_train[[1]], testlabel = y_train)
  
  ##  Adds the various data columns from the X_test file
  for (i in 1:length(X_test)){
    train <- cbind(train, X_train[[i]])
  }
  
  ## Assigns the colnames to the provided features data
  colnames(train) <- c("subject", "testlabel", features[1:length(features)-1])
  
  ## Organizes header names and remove extraneous numbers
  names(train) <- tolower(unlist(names(train)))
  headers <- names(train)
  headers <- strsplit(headers, " ")
  for (i in 3:length(headers)){
    headers[i] <- headers[[i]][2]
  }
  names(train) <- unlist(headers)
  
  ## Merged the two datasets together, one on top of the other.
  merged <- rbind(test, train)
  
  ## Eliminates non-mean and non-std dev measurements
  meanstdcols <- c(1:2, grep("[Mm]ean\\(|std", headers))
  merged <- merged[,..meanstdcols]
  
  ## Assign the numerical values with the predefined description
  testlabelnames <- c("walking"=1, "walking_upstairs" = 2, "walking_downstairs" = 3,"sitting" = 4, "standing" = 5, "laying" = 6)
  merged$test <- names(testlabelnames)[match(merged$testlabel, testlabelnames)] 
  
  ## Reorders columns
  merged <- merged[,c(1, 69, 2:68)]
  
  merged
}

tidydata <- function(dt) {
  ## generates tidy table with no duplicates, input from the combined function
  
  ## Takes the header names and creates an empty table
  tidytable <- dt[0,]
  
  ## Creates a vector with the data-containing columns
  cols <- colnames(dt)[!grepl('subject|test',colnames(dt))]
  
  ## Creates an empty vector in which to contain the indices of rows where 
  ## subject and test are identical
  values <- numeric()
  
  ## Loops through all observations (records/rows)
  for (i in 1:nrow(dt)){
    ## Checks whether the test columns in 2 rows are identical AND if
    ## the subject columns are ALSO identical
    if (identical(dt$test[i], dt$test[i+1]) && identical(dt$subject[i], dt$subject[i+1])){
      ## If identical, then add the current row number to the
      ## list of identical rows
      values <- append(values, i)   
    } else if (length(values) != 0 | i == nrow(dt)){
      ## If that is not identical, then still add the current row number to
      ## the list (meaning that this is the last identical row)
      values <- append(values, i)
      results <- numeric() # Create new, empty vector to place results in
      
      ## For each column, take the mean over all of the rows stored in
      ## values
      for (j in cols){
        result <- sapply(dt[values,..j], mean, na.rm=TRUE)
        results <- append(results, result) # Append to temporary vector
      }
      ## Add these values to the new table, set the subject and test
      ## values, then reset the values vector
      tidytable <- rbind(tidytable, as.list(results), fill = TRUE)
      tidytable$subject[nrow(tidytable)] <- dt$subject[i]
      tidytable$test[nrow(tidytable)] <- dt$test[i]
      values <- numeric()
    }
  }
  tidytable$testlabel <- NULL # Remove the testlabel column
  print(tidytable)
  write.table(tidytable, "tidydata.txt", row.names = FALSE)
  tidytable # Return tidytable
}

tidydata(combined())
