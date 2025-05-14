# subject 3 (I)

# Includes functions for Naive Bayes.
library(e1071)

# The folder that stores and retrieves files is defined.
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\big data(2 project)")

# Deletes all variables located in the working environment.
rm(list = ls())

# Deletes all the plots that have been created.
graphics.off()

# Read the data from the file.
data<-read.csv("IMDBDataset.csv",header=TRUE)

# Take a quick look at the data.
head(data)

tail(data)

# we install package "stringr" for removing all characters that are not letters or numbers.
library(stringr)

# Use str_replace_all to remove special characters.
clean <- function(text) {
  cleaned <- str_replace_all(text, "[^[:alnum:] ]", "")
  return(cleaned)
}

# Apply the clean function to review column of the data frame, we also use sapply that applies a given function to each element of a list.
data$review <- sapply(data$review, clean)

# The to_lower function is used to transform text into lowercase(small).
to_lower<-function(text){
  return(tolower(text))
}

# load the dplyr package so you can apply the to_lower function.
library(dplyr)

# Apply the to_lower function at review column in the dataframe, we also use sapply that applies a given function to each element of a list .
data$review <- sapply(data$review, to_lower)

# We install package "tm",essential functions for text processing. 
install.packages("tm")
library(tm)

# Function to remove stopwords(i,me,my...).
rem_stopwords <- function(text) {
  words <- stopwords(kind ="english")
  return(removeWords(text, words))
}

# Apply the function stopwords in column review.
data$review <- sapply(data$review, rem_stopwords)

# We install package "SnowballC",essential function for stemming.
install.packages("SnowballC")
library(SnowballC)

# Function for stemming(To reduce words to a common form or root, we use stemming).
stem_text <- function(text) {
  return(wordStem(text, language = "en"))
}

# Apply the function stemming to column review.
data$review <- sapply(data$review, stem_text)

# For checking the preprocessing. 
head(data)

# Creating Term-Document Matrices.
dtm <- DocumentTermMatrix(data$review)

# Inspecting a term-document matrix.
inspect(dtm)

# Find those terms that occur at least five times.
findFreqTerms(dtm, 5)

# This function call removes those terms which have at least a 99.745% of sparse (terms occurring 0 times in a document).
dtm<-removeSparseTerms(dtm,0.99745)

# The conversion to a matrix using as.matrix() makes the matrix dense, meaning that all its values are stored in memory without sparse representations.
dtm_matrix<-as.matrix(dtm)

# Create a data frame with dtm_matrix and sentiment
data_for_model <- cbind(as.data.frame(dtm_matrix), sentiment = data$sentiment)

# Split into training and testing sets
train_size <- 0.8 # This line sets the proportion of the data that you want to use for training.
train_index <- sample(1:nrow(data_for_model), round(train_size * nrow(data_for_model))) # This line generates random indices for the training set.
train_data <- data_for_model[train_index, ] # This line creates the training set. 
test_data <- data_for_model[-train_index, ] # This line creates the test set.

# Train the Naive Bayes model.
model <- naiveBayes(sentiment ~ ., data = train_data)

# Make predictions on the test data.
predictions <- predict(model, test_data)

# Evaluate the model, computes the accuracy by dividing the total number of correct predictions by the total number of instances.
conf_matrix <- table(predictions, test_data$sentiment)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)

# Print the accuracy.
cat("Accuracy:", accuracy)


  