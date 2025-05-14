# Clear R enviroment.
rm(list = ls())

# Set seed to encounter the same numbers.
set.seed(1234)

# Generates 100 random variables, each with 5 observations, from a normal distribution between 0 and 1.
randomdataframe<-replicate(100,runif(100,min=1,max=10))

# Number of columns of the matrix.
x<-as.integer(ncol(randomdataframe))

# Data type of variable x.
typeof(x)

# Using for loop(2,100).
for (i in 2:100) {
  # Keeps the columns from 1 to i of matrix randomdataframe . 
  rd<-randomdataframe[,1:i]
  #Use 70% of dataset as training set and remaining 30% as testing set
  sample <- sample(nrow(rd), 0.70*nrow(rd))
  train <- as.data.frame(rd[sample, ])
  test  <- as.data.frame(rd[-sample, ])
  # Estimation of the multiple linear regression model using our train set. 
  lm_train<-lm(V1~., data = train)
  # Calculate Mean Squared Error (MSE) for our training set.
  MSE_train_set <- mean((train[, 1] - lm_train$fitted.values)^2)
  # Use the estimated model to predict (Y=V1) the dependent variable for the test set.
  predicted_test<-predict( lm_train,test)
  # Calculate Mean Squared Error (MSE) for our test set.
  MSE_test_set<-mean((test[,1]-predicted_test)^2)
  # Print only when MSE_test_set is greater than 100 times MSE_train_set
  if (MSE_test_set > 100 * MSE_train_set) {
  print(paste("MSE Training Set (", i-1, " variables): ", MSE_train_set, 
              " | MSE Test Set (", i-1, " variables): ", MSE_test_set))
  }
}

# A new dataframe that will contain 63 variables.
new_randomdataframe<-as.data.frame(randomdataframe[,1:63])

# Here we define the percentage of the data that will be used in the train set(0.7) and the percentage that will be used in the test set(0.3).
indices<-sample(nrow(new_randomdataframe),0.70*nrow(new_randomdataframe))
trainset<- as.data.frame(new_randomdataframe[indices,])
testset<- as.data.frame(new_randomdataframe[-indices,])

# Estimation of the multiple linear regression model.
lm_trainset<-lm(V1~.,data =trainset )

# The calculation of Mean Squared Error(MSE) for the training set.
training_error<-mean((trainset[,1]-lm_trainset$fitted.values)^2)

#Using our model, we will make predictions on the unknown data.
Predicted_testset<-predict(lm_trainset,newdata=testset)

# The calculation of Mean Squared Error(MSE) for the test set.
generalization_error<-mean((testset[,1]-Predicted_testset)^2)

# Print training_error, generalization_error.
print(c("training_error"=training_error,"generalization_error"=generalization_error))

#We observe a very small training error and a significantly large generalization error, indicating a situation known as overfitting.
