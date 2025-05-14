from sklearn.linear_model import LinearRegression
from math import sqrt # We'll need sqrt()
import statistics # for mean()
from sklearn.metrics import mean_squared_error  
from sklearn.model_selection import KFold 
from sklearn.preprocessing import PolynomialFeatures
import numpy as np
import pandas as pd


# Read the data
hhData = pd.read_csv("HouseholdData.csv", header=0, sep=",", engine='python')

# Randomly shuffle the data i.e. mix it up randomly.
# We do this in order to get different partitions during k-fold cross validation between
# different executions of the program.
# This isn't required per se, but we do it for educational purposes
hhData = hhData.sample(frac=1).reset_index(drop=True)

# We will execute k-fold cross validation to assess the regression model with respect to
# its accuracy to predict the value of the dependent variable.
# The linear regression model that will be assessed is the following:
# FoodExpenditure = b1Income + b2FamilySize + b0
# We will assess its accurace in predicting the dependent value using k-fold cross validation


# First, we setup the k-fold cross validation object.
# We will do a 5-fold cross validation model (i.e. k=5) i.e. the dataset will
# be split in 5 partitions with an approximately equal number of observation in each part.
# We use the KFold object from sklearn and initialize it properly
kf = KFold(n_splits=5) 


print("\nLinear regression model: FoodExpenditure = b1Income + b2FamilySize + b0\n")

# Create an empty array where we will store the calculated RMSE values
# so that we may be able to 
allRMSE = np.empty(shape=[0, 1])

# Just a variable to count at which test we currently are
testNumber = 0

# Start now iterating over the partitioned dataset, selecting each time a different subset as the testing set.
#
# .split(hhData) will split the dataset into 5 parts.
# Now we iterate over these parts. This iteration works as follows:
# variables train_index and test_index will get the indexes of the original dataset (hhData)
# that will constitute the training- and testing-set respectively.
# This for loop will be executed 5 times, equal to the number of partitions.
for train_index, test_index in kf.split(hhData):

 # Next test
 testNumber += 1
 
 # Use the current indexes train_index and test_index to get the actual observations for the
 # training and testing of the model respectively.

 # From the original, complete dataset get the data with which we will use TRAIN our model (aka the training set),
 # i.e. estimate the coefficients. We get the rows designated by train_index and all their columns/variables
 trainingData = hhData.iloc[train_index,:]

 # From the original, complete dataset get the data with which we will TEST our model, i.e. estimate its
 # accuracy. This is the "unknown" dataset.
 # Note: we do know the value of the dependent variable FoodExpenditure for the testing set
 # and hence we will be able to estimate the prediction error/accuracy
 testData = hhData.iloc[test_index,:]

 # Use the training data to estimate the coefficients of the multiple linear regression model.
 # The model we will estimate is: FoodExpenditure = b1Income + b2FamilySize + b0
 lm = LinearRegression(fit_intercept=True)

 # Since the linear regression model has as independent variables Income and FamilySize,
 # we get these variables from the training dataset.
 # The method .fit() does the actual estimation of the coefficients for the linear regression
 # model using OLS (Ordinary Least Squares).
 # The first argument of the .fit() method are the values of the independent variables -in our case
 # trainingData.loc[:,['Income','FamilySize']] - and the second
 # argument are the values of the dependent variable, here trainingData.loc[:,['FoodExpenditure']].
 estimatedModel = lm.fit(trainingData.loc[:,['Income','FamilySize']], trainingData.loc[:,['FoodExpenditure']])

 # Coefficients have been estimated. Take a look at them. Not that it is important but heck, why not.
 # NOTE: the coefficients are returned (.coef_) as an array. The two numbers you'll see when
 # printing .coef_  must be interpreted as follows: first number is the coefficient
 # for Income, second number the coefficient for FamilySize. The estimated constant term b0 can retrieved 
 # via the .intercept_ variable.
 print(">>>Iteration ", testNumber, sep='')
 print("\tEstimated coefficients:")
 print("\t\tb1=", estimatedModel.coef_[0][0] , sep='')
 print("\t\tb2=", estimatedModel.coef_[0][1] , sep='') 
 print("\t\tb0=", estimatedModel.intercept_, sep='')
 
 
 # Now, use the estimated model to predict the value for FoodExpenditure for the observations in the testing set
 # (i.e. the unknown data that was not used for estimating the coefficients).
 # For this, we'll use the model's .predict() method which takes as argument the values of the independent variables
 # in the linear regression model.
 # IMPORTANT NOTE: Since we gave to the .fit() method above the the variables in a specific order (Income and FamilySize) we
 # have to give the respective variables of the testing set in the same order.
 # The .predict() method will return a vector of predicted values, one for each observation in testData.loc[:,['Income','FamilySize']].
 # More specifically, the first value in the vector predictedExpenditure is the predicted value for FoodExpenditure for the first row in
 # testData.loc[:,['Income','FamilySize']], the second value is the predicted value for FoodExpenditure for the second row
 # testData.loc[:,['Income','FamilySize']] etc. 
 predictedExpenditure = estimatedModel.predict(testData.loc[:,['Income','FamilySize']])

 # Calculate the Root Mean Squared Error (RMSE) for this testing set.
 # We have the real values of the dependent variable from the original dataset
 # which is testData.loc[:,['FoodExpenditure']] and the model's predicted values in predictedExpenditure
 # IMPORTANT: Please note the following: the function mean_squared_error() calculate the MSE NOT the RMSE. In
 # order to get the RMSE, we need to square the value returned by mean_squared_error(). See your notes on
 # how MSE and RMSE differ.
 RMSE = sqrt(mean_squared_error(testData.loc[:,['FoodExpenditure']], predictedExpenditure))

 # Display the RMSE value
 print("\t\tModel RMSE=", RMSE, sep='')
 
 # Also, store the calculated RMSE value into an array, so that we can calculate the mean error after k-fold cross
 # validation has been finished 
 allRMSE = np.append(allRMSE, RMSE)

 # Here the for-loop ends and restarts again for a different training- and testing set.





# Ok. The iterations of k-fold cross validation have been done.
#
# We have now 5 values of RMSE, one for each testing set.
# We calculate the mean RMSE which gives a better estimate on how accurate the predictions
# of the linear regression model is for unknown data and thus
# a better estimate for the generalization error.
print("\n=======================================================")
print(" Final result: Mean RMSE of tests:", statistics.mean(allRMSE), sep='' )
print("=======================================================")


