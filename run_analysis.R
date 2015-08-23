library(reshape2)

#Get the mean and std. dev. names
Features <- read.table("UCI HAR Dataset/Features.txt")
Features[,2] <- as.character(Features[,2])
MeanAndStd <- grep(".*mean.*|.*std.*", Features[,2])
MeanAndStd.names <- Features[MeanAndStd,2]

#Get Train Data
TrainX <- read.table("UCI HAR Dataset/train/X_train.txt")[MeanAndStd]
TrainY <- read.table("UCI HAR Dataset/train/Y_train.txt")
TrainSubj <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Get Test Data
TestX <- read.table("UCI HAR Dataset/test/X_test.txt")[MeanAndStd]
TestY <- read.table("UCI HAR Dataset/test/Y_test.txt")
TestSubj <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Merge all data
TrainMerge <- cbind(TrainSubj, TrainY, TrainX)
TestMerge <- cbind(TestSubj, TestY, TestX)
DataComplete <- rbind(TrainMerge, TestMerge)

#Add labels
colnames(DataComplete) <- c("Subject", "Activity", MeanAndStd.names)
Labels <- read.table("UCI HAR Dataset/activity_labels.txt")
Labels[,2] <- as.character(Labels[,2])

# calculate averages
DataComplete$Activity <- factor(DataComplete$Activity, levels = Labels[,1], labels = Labels[,2])
DataComplete$Subject <- as.factor(DataComplete$Subject)
DataComplete.Cleaned <- melt(DataComplete, id = c("Subject", "Activity"))
DataComplete.Average <- dcast(DataComplete.Cleaned, Subject + Activity ~ variable, mean)

# output final tidy data
write.table(DataComplete.Average, "TidyData.txt", row.names = FALSE, quote = FALSE)