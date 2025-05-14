
"""
How to work with data using python's library numpy 


Should you have any question with respect to pandas,
please refer to the documentation that you may find here:
http://www.numpy.org/

"""

# Import the proper library.
# without this line, we won't be able to use any function/object from the numpy package.
# In addition, we prefix each function in this library with np.
import numpy as np



# Create an one dimensional array which will function as a vector
v1 = np.array( [12, -7, 7, 9, -6] )

# Create another one dimensional array which is also a vector
v2 = np.array( [8, 10, 11, 17, -1])

#numpy gives you functions to interrogate these arrays/vectors

#You can get the dimensions of the created arrays 
print(np.shape(v1))

# You may reference items in the array with the operator []
# E.g. the forth item in the array/vector v1
# IMPORTANT! IN PYTHON INDEXES START AT 0!
print( v1[3] )


#
# Operations between arrays are supported. These are carried out always itemwise
#

# Double each number in the vector
doubleVec = 2*v1
print(doubleVec)

# Find the difference between the arrays v1 and v2 and store result in a new variable
vecDiff = v1 - v2
print(vecDiff)

# Find the sum of two arrays - store result in a new variable
vecSum = v2 + v1
print(vecSum)

# Raise each number in vector v1 to the power of 2
# with the operator ** (power)
vecPower2 = v1**2
print(v1)
print(vecPower2)


# Define a function to carry out an operation.

# Function to return the sum of all numbers in a vector.
# Takes as input a numerical vector, and returns the sum of the numbers
# in the vector
def elementSum(v):
    eSum = np.sum(v)
    # return the calculated sum of the elements
    return(eSum)


# Call the function to calculate the sum of numbers in vector v1
sumV1 = elementSum(v1)
print("Sum of numbers in vector v1 is", sumV1)

#Calculate the sum of squares of the numbers in vector v2
sumV2 = elementSum( v2**2 )
print("Sum of squared numbers in vector v2 is", sumV2)


# Define another function.
# The function squareRootVector calculates the square root
# of each number in vector v
def squareRootVector(v):

    # First we check if vector v
    # contains any negative number. We do this
    # by using numpy's function np.any(<condition>).
    # If so we cannot calculate the square root of
    # the numbers in the vector. In such case
    # we return the special value None which in
    # Python means nothing.
    if np.any(v < 0):
       return None  # yes, contains negative value. We cannot proceed and hence return the special value None

    #Vector seems ok! Calculate the square root of
    newVector = np.sqrt(v)
    return(newVector)


sqrtVector = squareRootVector(v1)
#After we have called the function, check what has been
#returned. If the value None was returned, that means
# that something went wrong. If that case, print a message.
if sqrtVector is None:
    print("Could not calculate square root of numbers in vector")
else:
    #otherwise, print out the new vector.
    print(sqrtVector)


