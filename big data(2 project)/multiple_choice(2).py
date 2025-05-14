# Import working tools essensial for our work.
import pandas as pd
import os
from matplotlib import pyplot as plt

# Working directory.
new_directory = r"C:\Users\admin\OneDrive\Υπολογιστής\big data(2 project)"
os.chdir(new_directory)

# Verify the change.
current_directory = os.getcwd()
print("Updated Working Directory:", current_directory)

respondentsData = pd.read_excel('dataset.xlsx')

# Display the first 5 rows of the DataFrame.
print(respondentsData.head())

# Display the last 5 rows of the DataFrame.
print(respondentsData.tail())

# Print the number of rows in the DataFrame.
r = respondentsData.shape[0]
print(r)

# Calculate and print the percentage distribution of 'Gender'.
g = respondentsData['Gender'].value_counts(normalize=True) * 100 
print(g)

# Create a horizontal bar plot of the counts of different age groups.
age_group_counts = respondentsData['Age Group'].value_counts().plot(kind='barh')
plt.show()

# Calculate and print the mean of 'Household size'.
mean_household_size = respondentsData['Household size'].mean()
print("Mean Household Size:", mean_household_size)

# Determine the type of the variable.
type_of_region = respondentsData['Region'].dtype
print(type_of_region)

# Type of the variables in our dataframe.
data_types=respondentsData.dtypes
print(data_types)

# Frequency Likes dogs yes or no.
Likes_dogs_value_counts=respondentsData['Likes dogs'].value_counts()
print(Likes_dogs_value_counts)
