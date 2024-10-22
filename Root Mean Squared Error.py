# Python program to change the current working directory. 
import os

# set working directory.
os.chdir("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\big data(3 project)")

# Import pandas library for reading a CSV file.
import pandas as pd

# Read the csv file.
forestfires=pd.read_csv("forestfires.csv",sep=",")

# View the first 5 rows.
print(forestfires.head())

# View the last 5 rows.
print(forestfires.tail())

# Dimensions of the dataframe.
print(forestfires.shape)

# We need it so we can calculate the square root of a number.
from math import sqrt 

# We need it so we can calculate the mean of a number.
import statistics

# For linear regression analysis.
from sklearn.linear_model import LinearRegression

# Mean squared error loss.
from sklearn.metrics import mean_squared_error  

# K-Fold cross-validator.
from sklearn.model_selection import KFold

# For performing array processing.
import numpy as np

# i)



# Function that will calculate the mean RMSE of test set.
def RMSE_MEAN(data):

# 10-Fold Cross Validation.
    kf = KFold(n_splits=10)

# Create an empty array where we will store the calculated RMSE values.
    allRMSE = np.empty(shape=[0, 1])

# Start now iterating over the partitioned dataset, selecting each time a different subset as the testing set.
# split(forestfires) will split the dataset into 10 parts.
# variables train_index and test_index will get the indexes of the original dataset (hhData)
# that will constitute the training-set and testing-set respectively.
    for train_index, test_index in kf.split(data): 
    
    # Train set.
        trainingData = data.iloc[train_index,:]

    # Test set.
        testData = data.iloc[test_index,:]

    # Using this command we will estimate a linear regression model(𝑎𝑟𝑒𝑎 = 𝛽1𝑡𝑒𝑚𝑝 + 𝛽2𝑤𝑖𝑛𝑑 + 𝛽3𝑟𝑎𝑖𝑛 + 𝛽0).
        lm = LinearRegression(fit_intercept=True)

    # We estimate a model from the training set with 'temp,' 'wind,' and 'rain' as independent variables and 'area' as dependent.
        estimatedModel = lm.fit(trainingData.loc[:,['temp','wind','rain']], trainingData.loc[:,['area']])

    # Now we will use the estimated model to predict the values of dependent variable (area) in test set.
        predictedarea = estimatedModel.predict(testData.loc[:,['temp','wind','rain']])

    # Calculate the Root Mean Squared Error (RMSE) for this testing set.
        RMSE = sqrt(mean_squared_error(testData.loc[:,['area']], predictedarea))

    # Store all the RMSE, so we can calculate the mean after.
        allRMSE = np.append(allRMSE, RMSE)

    # Calculate the mean of RMSE.
    MeanRMSE= statistics.mean(allRMSE)

    return MeanRMSE

# Call the function to calculate the mean RMSE.
result_i = RMSE_MEAN(forestfires)

# Display the result.
print("Final result (i): Mean RMSE of tests:", result_i, sep='')



# ii)

# Remove the rows that the variable area is <3.2 .
forestfires=forestfires[forestfires.area<3.2]

# View the first 5 rows.
print(forestfires.head())

# View the last 5 rows.
print(forestfires.tail())

# Dimensions of the dataframe.
print(forestfires.shape)

# Call the function with the filtered dataset.
result_ii = RMSE_MEAN(forestfires)

# Display the result.
print("Final result (ii): Mean RMSE.small_fires of tests:", result_ii, sep='')

