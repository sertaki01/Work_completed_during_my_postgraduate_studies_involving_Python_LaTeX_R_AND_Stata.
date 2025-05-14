#
# Working with functions, vectors and Principal Component Analysis in Python
#


#
# Functions
# 

# We need to import this to make use of
# math functions such as sqrt etc
import math

# A simple function that takes as input
# a number and returns it's square root if possible
def calculateSquareRoot(number):
    # Possible to calculate square root?
    if number < 0:
       return(None) # no! Return the special value None
    else:
        return(math.sqrt(number) ) # yes! Return the square root


# Calling the function with different arguments
numSqrt = calculateSquareRoot(15)
print("Square root of 15 is:", numSqrt)

numSqrt = calculateSquareRoot(3.789)
print("Square root of 3.789 is:", numSqrt)


#
#
# Working with vectors.
#
# To use vectors in python, we  use the NumPy library.
# Hence, we import this library here
#
import numpy as np



# Create a vector with elements [0,2,3,4] and store vector into variable v1
v1=np.array([0,2,3,4])

# Create another vector with elements [1,2,3,4] and store vector into variable v2
v2=np.array([1,2,3,4])

# You may also create vectors with string values
v3 = np.array(["aaa","bbb","ccc","ddd"])

# You may access specific elements of vectors via idexing
print("Position 2 of vector:", v3[2])

# Example of iterating over the elements of a vector
# Here we iterate over vector v3.
# NOTE: function len() returns the length of a vector i.e. how many
# elements it contains
for i in range(0, len(v3)):
    print("Value at position [", i, "] of vector v3:", v3[i])



# This function calculates and returns the difference of two vectors
# that are given as arguments
def vectorDifference(vector1, vector2):
    res = vector1 - vector2
    return(res)

# Call the function vectorDifference with the proper arguments
# to calculate the difference of the two vectors
# v1 and v2 that have been defined and initialized previously
vDiff = vectorDifference(v1, v2)
print("Difference is:", vDiff)


#
# Reading csv files with pandas
#

# The pandas library offers you a way to easily read data from a .csv file
# and handle the red data via a data.frame just like
# in R. Well not exactly like in R, but in a similar way with some
# syntactic differences.
import pandas as pd



# Read the csv dataset from the file
# The variable wineData is a data.frame that is provided by pandas
# NOTE: header=0 means that the file HAS a header and is located at line 0 of
# the file i.e. at the start.
# Files without header should be read with header=None
wineData = pd.read_csv("winequality-white.csv", header=0, sep=";", engine='python')


# Print out the data type of each variable to see if everything has been read fine from the file
print(wineData.dtypes)

# Print dimensions of the data frame in the form of (number of rows, number of columns)
print(wineData.shape)

# Check if each column of the data frame is numeric
for col in wineData.columns:
    if pd.api.types.is_numeric_dtype(wineData[col]):
        print ('Column', col, 'is numberic (', wineData[col].dtype, ')')
    else:
        print ('Column', col, 'is NOT numberic. It is', wineData[col].dtype)
        print('This error is FATAL. Program should terminate.')
        


# Remove entire rows, if at least one variable in row has a missing value.
# Store the "cleaned" data.frame in variable wineData
wineData = wineData.dropna()

# Get a peek at the data. Look at the first rows of the data frame
print('\nFirst 2 rows')
print( wineData.head(2) )
print('\nLast 2 rows')
print( wineData.tail(2) )

# Indexing using .iloc
# E.g. all rows (:) fifth column (remember, column numbering starts at 0)
print("Printing firth column (column at position 4) for all rows:")
print(wineData.iloc[:, 4])



#
# PCA
# 

# Next two lines required to properly use the PCA function
from sklearn import decomposition
from sklearn.decomposition import PCA



# Create the PCA object from the sklearn library
# Take a look at the documentation:
# https://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html
# HINT: ALWAYS look at the documentation to see what parameters to pass and what the
# return values are.
pca = decomposition.PCA(n_components=wineData.shape[1])

# Do the rest from here on yourself. Look at the file PCA.Python.py on eclass in
# section "Lecture 2: about data".

