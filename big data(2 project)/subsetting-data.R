#Read data from file
data<-read.csv("demo.csv",sep=",",header=T)


#Show the first n observations of a data frame
head(data,10)

#Print out the last observations in the data
tail(data)

#Show the structure of a data set
str(data)

#Return the dimension (the number of columns and rows) of a dataframe
dim(data)

#Number of data rows of a data frame 
nrow(data)

#Number of columns of a data frame
ncol(data)


#Return row 1
data[1, ]

#Return column 5
data[,3]

#Rows 1:5 and column 2
data[1:5,2]

#Rows 1:3 and columns 1 and 3
data[1:3, c(1,3)]

#Extract 3rd and 5th row with 2nd and 3th column.
data[c(3,5),c(2,3)]

#Create a new dataframe with only the rows of data
#where income is over 39000
data.income.over<-subset(data,data$Income>39000)

#or
data.income.over<-data[which(data$Income>42000),]

#or
data.income.over.mean<-subset(data, data$Income>mean(data$Income))

#Extract Specific columns
result <- data.frame(data$Family,data$FoodExpenditure)
#or 
result<-data[,c("Family","Income")]

