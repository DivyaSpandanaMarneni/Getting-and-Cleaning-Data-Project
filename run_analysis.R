fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl,destfile = "./Data/Data.zip")
unzip(zipfile="./Data/Data.zip",exdir="./Data")
dir <- "V:/OwnProjects/R-Directory/Getting&Cleaning/Data/UCI HAR Dataset"
setwd(dir)
getwd()
files<-list.files(".", recursive=TRUE)

## This lists all the files in UCI HAR dataset. From this we extract features data, subject data and activity data seperately
## activity
activityTest <- read.table(file.path(".","test","Y_test.txt"),header=FALSE)
activityTrain <- read.table(file.path(".","train","Y_train.txt"),header=FALSE)
## merging the testing and training dataset
activityData <- rbind(activityTrain,activityTest)

## subject

subjectTest <- read.table(file.path(".","test","subject_test.txt"),header=FALSE)
subjectTrain <- read.table(file.path(".","train","subject_train.txt"),header=FALSE)
## merging the testing and training dataset
subjectData <- rbind(subjectTrain,subjectTest)

## features

featuresTest <- read.table(file.path(".","test","X_test.txt"),header=FALSE)
featuresTrain <- read.table(file.path(".","train","X_train.txt"),header=FALSE)
## merging the testing and training dataset
featuresData <- rbind(featuresTrain,featuresTest)

names(subjectData)<-c("subject")
names(activityData)<- c("activity")
## for features data the names are available in features.txt file
featuresNames <- read.table(file.path(".","features.txt"),header = FALSE)
names(featuresData) <- featuresNames$V2

## We merge the data so that it forms a data frame that variables and dependencies

mergeContent <- cbind(featuresData,subjectData,activityData)

## Next we obtain only those observatios that have mean and std information using names of featuresData
mean_std_Data_Names <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)",featuresNames$V2)]

selectNames<-c(as.character(mean_std_Data_Names), "subject", "activity" )
## subset the content of mergeContent that has mean and std observations
mergeContent <- subset(mergeContent,select = selectNames)

## Naming the activites in the data set using the names given in activity_labels.txt
activityLabels <- read.table(file.path(".","activity_labels.txt"),header=FALSE)

colnames(activityLabels) <- c('activityId','activityKind')
activityNames <- full_join(mergeContent,activityLabels,by=(activityLabels$activityId),all.x=TRUE)






