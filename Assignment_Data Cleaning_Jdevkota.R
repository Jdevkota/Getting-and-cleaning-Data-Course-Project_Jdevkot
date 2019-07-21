##Getting and cleaning Data Course Project##


##1. Get and merge the data##


setwd("D:/Coursera/UCI HAR Dataset")
library(plyr)
install.packages("data.table")
library(data.table)
subjectTrain = read.table('./train/subject_train.txt',header=F)
xTrain = read.table('./train/x_train.txt',header=F)
yTrain = read.table('./train/y_train.txt',header=F)
subjectTest = read.table('./test/subject_test.txt',header=F)
xTest = read.table('./test/x_test.txt',header=F)
yTest = read.table('./test/y_test.txt',header=F)
xDataSet=rbind(xTrain, xTest)
yDataSet=rbind(yTrain, yTest)
subjectDataSet=rbind(subjectTrain, subjectTest)
dim(xDataSet)
dim(yDataSet)
dim(subjectDataSet)


##2. Extracts only the measurements on the mean and standard deviation for each measurement.##

xDataSet_mean_std=xDataSet[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xDataSet_mean_std)=read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 
View(xDataSet_mean_std)
dim(xDataSet_mean_std)


##3. Uses descriptive activity names to name the activities in the data set##

yDataSet[, 1]=read.table("activity_labels.txt")[yDataSet[, 1], 2]
names(yDataSet)="Activity"
View(yDataSet)

##4. Appropriately labels the data set with descriptive variable names##

names(subjectDataSet)="Subject"
summary(subjectDataSet)

singleDataSet=cbind(xDataSet_mean_std, yDataSet, subjectDataSet)
names(singleDataSet)=make.names(names(singleDataSet))
names(singleDataSet)=gsub('Acc',"Acceleration",names(singleDataSet))
names(singleDataSet)=gsub('GyroJerk',"AngularAcceleration",names(singleDataSet))
names(singleDataSet)=gsub('Gyro',"AngularSpeed",names(singleDataSet))
names(singleDataSet)=gsub('Mag',"Magnitude",names(singleDataSet))
names(singleDataSet)=gsub('^t',"TimeDomain.",names(singleDataSet))
names(singleDataSet)=gsub('^f',"FrequencyDomain.",names(singleDataSet))
names(singleDataSet)=gsub('\\.mean',".Mean",names(singleDataSet))
names(singleDataSet)=gsub('\\.std',".StandardDeviation",names(singleDataSet))
names(singleDataSet)=gsub('Freq\\.',"Frequency.",names(singleDataSet))
names(singleDataSet)=gsub('Freq$',"Frequency",names(singleDataSet))
View(singleDataSet)

##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject##


names(singleDataSet)
DataSet2=aggregate(. ~Subject + Activity, singleDataSet, mean)
DataSet2=DataSet2[order(DataSet2$Subject,DataSet2$Activity),]
write.table(DataSet2, file = "tidydata.txt",row.name=F)

