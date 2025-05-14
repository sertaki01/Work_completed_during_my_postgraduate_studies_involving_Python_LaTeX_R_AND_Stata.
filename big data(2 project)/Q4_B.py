# Project 4 (2)
# Imports the pandas library, which is used for data manipulation and analysis
import pandas as pd
#Imports the log2 function from the math module. This will be used for calculating logarithms with base 2
from math import log2
#This function is used to fetch datasets from the UCI Machine Learning Repository.
from ucimlrepo import fetch_ucirepo
# fetch dataset( data sets id_number, in UCI Machine Learning Respitory, is 73)
mushroom = fetch_ucirepo(id=73) 
  
# This variable represents the features or independent variables of the dataset, each row in X corresponds to a different mushroom, and each column represents a specific feature 
X = mushroom.data.features 
# This variable represents the target or dependent variable of the dataset, in this case the "poisonous" variable, Each element in Y corresponds to the target label for the corresponding row in X
Y = mushroom.data.targets 
  
# metadata 
print(mushroom.metadata) 
  
# variable information 
print(mushroom.variables) 
#combine features X and target Y into a single dataframe
mushrooms = pd.concat([X, Y], axis=1)
# Handle missing values, by filling the missing values with the most common value, the lambda function takes each column (x) of the DataFrame, and for each missing value(na), it fills it with the most frequent value in that column, computed by the function inside the x.fillna()
mushrooms_imputed = mushrooms.apply(lambda x: x.fillna(x.value_counts().index[0]))

#subsetting_data, creating data set with just the first 30 obs. of the original data set
data_subset = mushrooms_imputed.head(30)

# Defines a function that calculates the entropy of a set based on the frequencies of the positive ('e' - edible) and negative ('p' - poisonous) classes in the set.
def calculate_entropy(s):
    p_plus = s[s == 'e'].count() / len(s)
    p_minus = s[s == 'p'].count() / len(s)
    entropy = -p_plus * log2(p_plus) - p_minus * log2(p_minus) if p_plus > 0 and p_minus > 0 else 0
    return entropy

#Defines a function that calculates the weighted entropy after splitting the data on a given attribute
#unique_values stores the unique values that the specified attribute can take within the given dataset
def calculate_weighted_entropy(data, attribute, target):
    unique_values = data[attribute].unique()
    entropy_weighted = 0
#The function iterates through each unique value of the specified attribute, and selects the subset where the data values is found It then calculates the weighted entropy for that subset and adds it to the overall entropy(entropy_weighted), the weight is determined by the relative size of the subset compared to the original dataset
    for value in unique_values:
        subset = data[data[attribute] == value][target]
        entropy_weighted += len(subset) / len(data) * calculate_entropy(subset)

    return entropy_weighted

# calculate the entropy gain when splitting a dataset based on a specified attribute
def calculate_entropy_gain(data, attribute, target):
#calculates the entropy of the original dataset with respect to the target variable
    entropy_original = calculate_entropy(data[target])
#calculates the weighted entropy after splitting the dataset based on the specified attribute
    entropy_weighted = calculate_weighted_entropy(data, attribute, target)
#s the difference between the original entropy and the weighted entropy after splitting, generally a higher entropy gain indicates a more effective split in terms of reducing uncertainty about the target variable
    entropy_gain = entropy_original - entropy_weighted
    return entropy_gain

# Calculate entropy gains for the "habitat" attribute
entropy_gains_habitat = {}

for attribute in ['habitat']:
    entropy_gains_habitat[attribute] = calculate_entropy_gain(data_subset, attribute, 'poisonous')

# Print entropy gains
entropy = calculate_entropy(data_subset['poisonous'])
entropy_weighted = calculate_weighted_entropy(data_subset, 'habitat', 'poisonous')
print("Entropy of set:", entropy)
print("Weighted entropy after splitting at habitat:", entropy_weighted)

for attribute, entropy_gain in entropy_gains_habitat.items():
    print(f"Entropy Gain for {attribute}:", entropy_gain)
