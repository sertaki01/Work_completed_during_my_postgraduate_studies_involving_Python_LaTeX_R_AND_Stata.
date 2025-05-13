# For dataframe.
import pandas as pd

# Random samples.
import random

# Create matrices and arrays.
import numpy as np

# For gradient boosting.
from sklearn.ensemble import GradientBoostingClassifier

# For split the data into training and test set.
from sklearn.model_selection import train_test_split

# Set the random seed for the loop.
random.seed(42)

# Set random seed for the dataset.
np.random.seed(1234)

# Genarate random numbers from 0 to 1 (10 rows, 4 columns).
Random = np.random.rand(100,4)

# But all the random numbers in a dataframe named df.
df = pd.DataFrame(Random)

# Assign names in our dataframe in respect to its columns.
df.columns=['A','B','C','D']

# Display our dataframe.
print(df)

# Create an empty list.
vector = []

# From i 1 to 10 add a random number between 0 and 1 in the list and at the end displayed it.
for i in range(100):
    random_number=random.randint(0,1)
    vector.append(random_number)
print(vector)

# I define it as an array.
pd.array(vector)

# Insert a new column(vector) in our dataframe and display our results.
df.insert(0,"vector",vector,True)

print(df)

# Set up dependent and independent variables.

x=df[['A','B','C','D']]

print(x)

y=df['vector'] # Not double brackets for 1d array!!

print(y)

# Split in training and test set.
x_train,x_test,y_train,y_test=train_test_split(x,y,test_size=0.3)

# The number of rows.
rows=len(x_train)

print(rows)

print(y_train)

# Gradient boosting classifier.
GBC= GradientBoostingClassifier(n_estimators=100, learning_rate=0.01,max_depth=2,random_state=0).fit(x_train,y_train)

# Calculate the accuracy score.

accuracy=GBC.score(x_test,y_test)

print("Accuracy:", accuracy)

