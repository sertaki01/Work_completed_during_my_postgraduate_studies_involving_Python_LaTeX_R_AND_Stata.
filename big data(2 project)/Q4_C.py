# Project 4 (3)
# Importing necessary libraries
# This one is used to split the dataset into training and testing sets.
from sklearn.model_selection import train_test_split
# imports the Gaussian Naive Bayes algorithm (probabilistic classifier)
from sklearn.naive_bayes import GaussianNB
#Metrics for evaluating the model's performance.
from sklearn.metrics import confusion_matrix, accuracy_score
# Data manipulator library, we use it to create data frame 
import pandas as pd
#This library is used for fetching datasets from the UCI Machine Learning Repository.
from ucimlrepo import fetch_ucirepo

# fetches the Mushroom dataset from the UCI Machine Learning Repository, id=73 refers to the datasets id in UCI 
mushroom = fetch_ucirepo(id=73)
# This variable represents the features or independent variables of the dataset, each row in X corresponds to a different mushroom, and each column represents a specific feature 
X = mushroom.data.features
# This variable represents the target or dependent variable of the dataset, in this case the "poisonous" variable, Each element in Y corresponds to the target label for the corresponding row in X
Y = mushroom.data.targets

# Combine features X and target Y into a single dataframe
mushrooms = pd.concat([X, Y], axis=1)

# Handle missing values by filling them with the most common value
mushrooms_imputed = mushrooms.apply(lambda x: x.fillna(x.value_counts().index[0]))

# One-hot encoding for categorical columns, creating dummies for all categories and drop the first variable to avoid multicollinearity
mushrooms_encoded = pd.get_dummies(mushrooms_imputed, drop_first=True)

# One-hot encoding for categorical columns, creating dummies for all categories and drop the first variable to avoid multicollinearity
X_train, X_test, Y_train, Y_test = train_test_split(
    mushrooms_encoded.drop("poisonous_p", axis=1),
    mushrooms_encoded["poisonous_p"],
    test_size=0.2,
    random_state=123
)

# Create a Naive Bayes (Gaussian) Classifier
naive_bayes_classifier = GaussianNB()
#Trains the Naive Bayes classifier on the training data
naive_bayes_classifier.fit(X_train, Y_train)

# Predict probabilities for both training and testing sets
probs_train = naive_bayes_classifier.predict_proba(X_train)
probs_test = naive_bayes_classifier.predict_proba(X_test)

# Display confusion matrix and accuracy for the Naive Bayes model
#Implement Naive_bayes on the test set and store results in variable (Y_pred_nb)
Y_pred_nb = naive_bayes_classifier.predict(X_test)
conf_matrix_nb = confusion_matrix(Y_test, Y_pred_nb)
accuracy_nb = accuracy_score(Y_test, Y_pred_nb)
print("Naive Bayes Confusion Matrix:")
print(conf_matrix_nb)
print("Naive Bayes Accuracy:", accuracy_nb)
