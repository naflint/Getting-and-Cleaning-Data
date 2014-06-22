testnames <- list.files("test", pattern="*.txt", full.names=TRUE)
tests <- lapply(testnames, read.table)
names(tests) <- basename(testnames)

trainnames <- list.files("train", pattern="*.txt", full.names=TRUE)
trains <- lapply(trainnames, read.table)

names(trains) <- basename(trainnames)

subject <- rbind(trains[[1]],tests[[1]])
X <- rbind(trains[[2]],tests[[2]])
y <- rbind(trains[[3]],tests[[3]])

features <- read.table("features.txt", stringsAsFactors = FALSE)
selectedfeatures <- lapply(features[2],function (x)grepl("mean|std", x))
selectedfeatures <- features[unlist(selectedfeatures),]
selectedX <- X[,unlist(selectedfeatures[1])]
names(selectedX) <- unlist(selectedfeatures[2])

activities <- read.table("activity_labels.txt")
activities <- merge(activities,y,by.x="V1",by.y="V1",all.y=TRUE)

selectedX <- cbind(subject,activities[2],selectedX)
names(selectedX)[[1]] <- "subject"
names(selectedX)[[2]] <- "activity"

meanX <- selectedX[,which(grepl("mean",names(selectedX)))]
meanX <- cbind(subject,activities[2],meanX)
names(meanX)[[1]] <- "subject"
names(meanX)[[2]] <- "activity"

groups= list(meanX$subject,meanX$activity)
s <- split(meanX, groups, drop=TRUE)

df1 <- sapply(s, function(x) colMeans(x[3:48]))
df1 <- t(df1)


library(reshape2)
df2 <- colsplit(row.names(df1), "\\.", names=c("subject", "activity"))
tidy_data_set <- cbind(df2,df1)
write.table(tidy_data_set,"tidy_data_set.txt", row.names = FALSE, sep = "\t")
