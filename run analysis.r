setwd("C:/Users/Admin/Documents/DS from Coursera/ProgAssignmentGettingCleaning/ready")

library(dplyr)
library(data.table)

# read features description and extract mean and std only 
features <- read.table("features.txt")

features <- features[, 2] # read the names vector only
features_names <- as.character(features) # turn names into characters

features_names_indicies <- grep("mean\\(\\)|std\\(\\)", features_names) # find positions of "mean" or "std" variables
features_names <- features_names[features_names_indicies] # subset to "mean" and "std" variables

# read train data and bind into one set 
features_train <- read.table("X_train.txt")[, features_names_indicies]
activity_train <- read.table("Y_train.txt")
subject_train <- read.table("subject_train.txt")
train <- cbind(subject_train, activity_train, features_train)

# read test data and bind into one set 
features_test <- read.table("X_test.txt")[features_names_indicies]
activity_test <- read.table("Y_test.txt")
subject_test <- read.table("subject_test.txt")
test <- cbind(subject_test, activity_test, features_test)

# read activity labels
activity_labels <- read.table("activity_labels.txt")

# merge train and test datasets and add labels
full_set <- rbind(train, test) # merge by rows
colnames(full_set) <- c("subject", "activity", features_names)

# turn activities & subjects into factors
full_set$activity <- factor(full_set$activity, levels = activity_labels[,1], labels = activity_labels[,2])
full_set$subject <- as.factor(full_set$subject)

#reshape and calculate means 
full_set <- melt(full_set, id = c("subject", "activity")) #stack a set of columns into a single column 
full_set.mean <- dcast(full_set, subject + activity ~ variable, mean) #reshape molten dataset with means

#write the delivwerable into a a new csv file
write.csv(full_set.mean, "tidy.csv", row.names = FALSE, quote = FALSE) 