## Merge and clean human activity recognition data.

# Check all required files exist.
datasetDir   <- './dataset'




## Build and return a data frame from raw values of subject ids, activity ids
## and feature vectors. These three entities are read from the files containing
## them and then merged into a single data frame. The first column of the data
## frame contains subject ids, its second column contain activity ids and
## every subsequent column contains values of one feature variable.
loadRawData <- function(path,tagname) {
    
    ## Check if directory and files exist.
    path <-  paste(as.character(path),'/',sep='')
    tagname <- as.character(tagname)
    dirname <- paste(path,tagname,sep='')
    
    if(!file.exists(dirname)) {
        stop('Directory not found!',call. = T)
    }
    
    subjectFile  <- paste(dirname,'/subject_',tagname,'.txt',sep='')
    activityFile <- paste(dirname,'/y_',tagname,'.txt',sep='')
    featuresFile <- paste(dirname,'/X_',tagname,'.txt',sep='')
    
    if(!file.exists(c(subjectFile))) {
        stop('One or more data files do not exist!')
    }
    
    ## Read actual data.
    features <- read.table(featuresFile,colClasses='numeric')
    
    ## Read subject IDs.
    subjects <- read.table(subjectFile)
    
    ## Read activity IDs.
    activities <- read.table(activityFile)
    
    ## Return a single coalesced data frame.
    cbind(subjects,activities,features)

}



## Merge two data sets into a single data set. The data frame for the second
## data set is stacked below the first one and the resulting data frame re-
## turned.
combineDataSets <- function(tagname1, tagname2) {
    data1 <- loadRawData(datasetDir,tagname1)
    data2 <- loadRawData(datasetDir,tagname2)
    
    rbind(data1,data2)
}


## Read activity names(labels).
loadActivityNames <- function(path) {
    labelsFile <<- paste(as.character(path),'/','activity_labels.txt',sep='')
    
    if(!file.exists(labelsFile)) {
        stop('File not found!')
    }    
    activityLabels <- read.table(labelsFile)
}



## Read feature(variable) names(labels). The names are filtered by the regular
## expression filter.regex.
loadFeatureNames <- function(path,filter.regex='*') {
    labelsFile <<- paste(as.character(path),'/','features.txt',sep='')
    
    if(!file.exists(labelsFile)) {
        stop('File not found!')
    }
    featureLabels <- read.table(labelsFile)
    
    ## Adjust feature index (column id) to account for the two columns 
    ## added by us.
    
    # Shift column indeces by 2.
    featureLabels[[1]] <- featureLabels[[1]] + 2
    
    # Create a new data frame for the adjusted columns.
    prepend <- data.frame(c(1,2),c('subjectID','activity'))
    names(prepend) <- names(featureLabels)
    featureLabels <- rbind(prepend,featureLabels)
    
    ## Apply filter to label names and return matching rows only.
    featureLabels[grep(filter.regex,featureLabels[[2]]),]
}



## Replace every activity ID with a label mapped to that ID.
labelActivities <- function(activityIDs,labelMap) {
    
    labelnames <- character(length=length(activityIDs))
    
    replace <- function(id){ 
            as.character(labelMap[which(labelMap[[1]]==id),2])
    }
    labelnames <- sapply(activityIDs,replace)
    return(labelnames)
}



## Perform steps 1 to 5 mentioned in the project description.
runAnalysis <- function() {
    ## Step1: Merge train and test data.
    mergedSet <- combineDataSets('train','test')
    
    ## Step2: Select only mean and std features(columns).
    featureNames <- loadFeatureNames(datasetDir,'subjectID|activity|mean|std')
    filteredIndices <- featureNames[[1]]
    
    filteredSet <- mergedSet[,filteredIndices]
    
    ## Step3: Replace activity IDs (column 2) with corresponding activity
    ## names.
    activityNames <- loadActivityNames(datasetDir)
    filteredSet[2] <- labelActivities(filteredSet[[2]],
                                               activityNames)
    
    ## Step4: Name features(columns).
    names(filteredSet) <- featureNames[[2]]
    
    ## Step5. Avergae features (variable) in all columns
    ## but column 1 and column 2.
    tidyData <- aggregate(filteredSet[-c(1,2)],
                          by=list(filteredSet$activity,
                                  filteredSet$subjectID),
                          FUN='mean')
    names(tidyData)[1:2] <- names(filteredSet)[1:2]
    
    write.table(tidyData,'tidydata.txt',row.names=F)
    
    return(tidyData)
}