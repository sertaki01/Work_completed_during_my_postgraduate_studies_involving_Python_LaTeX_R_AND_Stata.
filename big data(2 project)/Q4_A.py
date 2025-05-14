# Subject 4 (1)
# Download the neccesary libraries
#This library is used for fetching datasets from the UCI Machine Learning Repository.
from ucimlrepo import fetch_ucirepo
# This one is used to split the dataset into training and testing sets.
from sklearn.model_selection import train_test_split
#This is a classifier based on decision tree algorithms, plot_tree is used for visualizing decision trees, export_text is used for generating a text repressentation of deccison tree rules
from sklearn.tree import DecisionTreeClassifier, plot_tree, export_text
#Metrics for evaluating the model's performance.
from sklearn.metrics import confusion_matrix, accuracy_score
# Data manipulator library, we use it to create data frame 
import pandas as pd
#used for preproccesing the data, OneHotEncoder we use for transphorming categorical variables into numeric ones
from sklearn.preprocessing import OneHotEncoder
#SimpleImputer is used to fill missing values in the dataset, and ColumnTransformer allows us to manipulate certain columns 
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
# Library for plotting graphs
import matplotlib.pyplot as plt

# fetches the Mushroom dataset from the UCI Machine Learning Repository, id=73 refers to the datasets id in UCI 
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
# One-hot encoding for categorical columns, creating dummies for all categories and drop the first variable to avoid multicollinearity
mushrooms_encoded = pd.get_dummies(mushrooms_imputed, drop_first=True)

# Split the data into training(80%) and testing sets(20%), poisonous_p is the dummy for poisonous(=0 if edible, =1 if poisonous)
X_train, X_test, Y_train, Y_test = train_test_split(
    mushrooms_encoded.drop("poisonous_p", axis=1),
    mushrooms_encoded["poisonous_p"],
    test_size=0.2,
    random_state=123
)

# Create a Decision Tree Classifier, random_sta=123 refers to the seed for the random number generator, the specific number is arbitrary any integer would do. This ensure that  the same seed will lead to the same random processes during the training of the decision tree, providing consistency in the results
mushroom_tree = DecisionTreeClassifier(random_state=123)
#train it on the train data set
mushroom_tree.fit(X_train, Y_train)

# This line uses the trained decision tree classifier, to make predictions on the test set, storing those predictions in the Y-pred variable
Y_pred = mushroom_tree.predict(X_test)

#The confusion matrix is a table that is often used to describe the performance of a classification model on a set of test data for which the true values are known. It takes four entries True Positive, True Negative, False Positive and False Negative basically telling us where the model made invalid and where accurate predictions 
conf_matrix = confusion_matrix(Y_test, Y_pred)
#The accuracy is the ratio of correctly predicted instances to the total instances in the test set
accuracy = accuracy_score(Y_test, Y_pred)

# Display the confusion matrix and accuracy
print("Confusion Matrix:")
print(conf_matrix)
print("Accuracy:", accuracy)

# Visualize the decision tree (text representation)
tree_rules = export_text(mushroom_tree, feature_names=list(X_train.columns))
print(tree_rules)

#visualize decision tree as plot, replacing labels 

plt.figure(figsize=(12, 8))
plot_tree(mushroom_tree, feature_names=list(X_train.columns), class_names=["edible", "poisonous"], filled=True, rounded=True)
plt.show()
