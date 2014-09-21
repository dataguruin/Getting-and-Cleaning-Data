library(data.table)
library(reshape2)
# load labels
actLabels <- read.table("./activity_labels.txt", stringsAsFactors=FALSE)
actLabels <- actLabels$V2
features <- read.table("./features.txt", stringsAsFactors=FALSE)
features <- features$V2
featMeanStd <- features[grep("mean\\(\\)|std\\(\\)", features)]
# load test and train data
testX <- read.table("./test/X_test.txt")
testY <- read.table("./test/y_test.txt")
testSubject <- read.table("./test/subject_test.txt")
trainX <- read.table("./train/X_train.txt")
trainY <- read.table("./train/y_train.txt")
trainSubject <- read.table("./train/subject_train.txt")
# prepare data
names(testX) = features
testX = testX[,featMeanStd]
testY[,2] = actLabels[testY[,1]]
names(testY) = c("ActivityID", "ActivityLabel")
names(testSubject) = "subject"
trainX <- read.table("./train/X_train.txt")
trainY <- read.table("./train/y_train.txt")
trainSubject <- read.table("./train/subject_train.txt")
names(trainX) = features
trainX = trainX[,featMeanStd]
trainY[,2] = actLabels[trainY[,1]]
names(trainY) = c("ActivityID", "ActivityLabel")
names(trainSubject) = "subject"
# merge and take mean to tidy up data
test <- cbind(as.data.table(testSubject), testY, testX)
train <- cbind(as.data.table(trainSubject), trainY, trainX)
dat = rbind(test, train)
idLabels   = c("subject", "ActivityID", "ActivityLabel")
dataLabels = setdiff(colnames(data), idLabels)
meltData      = melt(dat, id = idLabels, measure.vars = dataLabels)
tidyData   = dcast(meltData, subject + actLabels ~ variable, mean)
write.table(tidyData, file = "./tidy_data.txt")
