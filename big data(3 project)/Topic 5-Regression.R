# Clear the R enviroment.
rm(list=ls())

# Set working directory.
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\big data(3 project)")

# Import a csv file in R.
forestfires<- read.csv("forestfires.csv", header = TRUE)

# Return the first and last 6 rows of the dataframe.
head(forestfires)
tail(forestfires)


# i).


# This function calculates the Root Mean Squared Error (RMSE).
calculateRMSE<-function(predictedValues, actualValues){
  err<- sqrt( mean((actualValues - predictedValues)^2)  )
  return( err )
}

# A function that uses k-Fold Cross validation method.
kFoldCrossValidation<-function(data, frml, k){
  
  #It is a vector indicating in which "bin" each observation belongs, thus dividing the total observations into 10 subsets.
  folds <- cut(seq(1,nrow(data)), breaks=k, labels=FALSE)
  
  #An empty vector named RMSE.
  RMSE<-vector()
  
  #A loop from 1 to k.
  for(i in 1:k){
    
    # It locates the positions of observations belonging to the specific fold and stores them in the variable testIndexes. 
    testIndexes <- which(folds==i,arr.ind=TRUE)
    
    # Testing set.
    testData <- data[testIndexes, ]
    
    # Training set.
    trainData <- data[-testIndexes, ]
    
    #Estimation of a multiple linear model.
    candidate.linear.model<-lm( frml, data = trainData)
    
    #Using the linear model, we will estimate unseen data.
    predicted<-predict(candidate.linear.model, testData)
    
    # Calculate the Root Mean Squared Error (RMSE).
    error<-calculateRMSE(predicted, testData[, "area"])
    
    # Assigned the values of the RMSE errors calculated in each iteration of the loop.
    RMSE<-c(RMSE,error)
  }
  return( mean(RMSE) )
}

# Calculate mean.RMSE(estimate of the generalization error). 
mean.RMSE<-kFoldCrossValidation(forestfires,area~ temp+wind+rain,10)

# Display Mean-RMSE.
print(c("Mean-RMSE"=mean.RMSE))


# ii).


# Keep the lines that have area<3.2 of the dataframe(forestfires).
forestfires<- forestfires[forestfires$area<3.2,]

# Calculate mean.RMSE(estimate of the generalization error). 
mean.RMSE.small_fires<-kFoldCrossValidation(forestfires,area~ temp+wind+rain,10)

# Display Mean-RMSE.
print(c("Mean-RMSE.small_fires"=mean.RMSE.small_fires))