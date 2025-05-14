# Subject 4 (1) 

# Deletes all variables located in the working environment.
rm(list = ls())

# Deletes all the plots that have been created.
graphics.off()

# Set working directory.
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\big data(2 project)")

# Read the Mushroom dataset.
mushroom_data<-read.table("agaricus-lepiota.data",header = FALSE,sep = ",")

# Adjust the column names.
colnames(mushroom_data)<-c("poisonous","cap-shape","cap-surface","cap-color","bruises","odor","gill-attachment","gill-spacing","gill-size","gill-color","stalk-shape","stalk-root","stalk-surface-above-ring","stalk-surface-below-ring","stalk-color-above-ring","stalk-color-below-ring","veil-type","veil-color","ring-number","ring-type","spore-print-color","population","habitat")

# Shows first few rows.
head(mushroom_data)

# Shows the last few rows.
tail(mushroom_data)

# Structure.
str(mushroom_data)

# Download package.
install.packages("rpart")
library(rpart)
install.packages("rpart.plot")
library(rpart.plot)

# Calculate the total number of question marks and NA values for the specific column.
missing_values <- sum(is.character(mushroom_data$"stalk-root") & (mushroom_data$"stalk-root" == "?" | is.na(mushroom_data$"stalk-root")))

# Print the result.
print(missing_values)

# Remove rows with missing values(?) in the "stalk-root" column. 
mushroom_data <- subset(mushroom_data, mushroom_data$"stalk-root" != "?")

# Shows first few rows.
head(mushroom_data)

# Shows the last few rows.
tail(mushroom_data)

# Create training and testing sets for our model.
set.seed(8)  
train = sample( 1:nrow(mushroom_data), nrow(mushroom_data)*0.8)
test = -train
training_data =mushroom_data[train,]
test_data=mushroom_data[-train,]

# Create the decision tree using the training data. We want to predict poisonous based on all other attributes of the mushroom_data dataset.
tree_model = rpart(poisonous  ~ . , data=training_data, method="class",cp=0.001 )

# Visualize the dicision tree
rpart.plot(tree_model, main="Decision Tree",fallen.leaves = TRUE, branch = 1)

# Predict the class attribute (poisonous) for the testing dataset. Apply testing dataset.
tree_predict = predict(tree_model, test_data, type="class")

# Create Confusion Matrix.
testingDataConfusionTable = table(tree_predict, test_data$poisonous)

# The table distinguishes the following four elements: True e(up left),True p (down right),False e (down left),False p (up right). 
print(testingDataConfusionTable)

# We see how many variables are correctly categorized based on certain characteristics.
modelAccuracy = sum( diag(testingDataConfusionTable)/sum(testingDataConfusionTable))

# Print Accuracy of our model, This means the percentage of instances that a feature correctly classified into the correct category based on certain characteristics.
cat("Accuracy:",modelAccuracy)



# Subject 4 (2) 

# Frequency table of poisonous.
frequency_table1 <- table(mushroom_data$poisonous[1:30])

# Print frequency table of poisonous.
print(frequency_table1)

# We created a subset with rows from 1 to 30 and columns(1,23).
subset <- mushroom_data[1:30,c(1,23)]

# Frequency table of subset.
frequency_table2 <- table(subset)

# Print frequency table of subset.
print(frequency_table2)

# Calculate the entropy before the split.
Entropy_poisonous<- function(a,b){
  total<- a+b
  p_a<- a/total
  p_b<- b/total
  if (p_a == 0) {
    log_p_a <- 0
  } else {
    log_p_a <- log2(p_a)
  }
  if (p_b == 0) {
    log_p_b <- 0
  } else {
    log_p_b <- log2(p_b)
  }
  entropy_before_split<- -p_a * log_p_a - p_b * log_p_b
  return(entropy_before_split)
}

# Entropy before split with habit. 
entropy.before.split <- Entropy_poisonous(21, 9)
print(entropy.before.split)

# Entropy_split(habitat).
Entropy_habitat<-function(a,b,c,d){
  total<-a+b+c+d
  na_n<-a/total
  nb_n<-b/total
  nc_n<-c/total
  nd_n<-d/total
  Entropy_split<-na_n*Entropy_poisonous(1,0)+nb_n*Entropy_poisonous(7,4)+nc_n*Entropy_poisonous(11,0)+nd_n*Entropy_poisonous(2,5)
  return(Entropy_split)
}

# Entropy split(habitat).
Entropy.split<-Entropy_habitat(1,11,11,7)

# Entropy Gain from Splitting Based on Habitat.
Entropy.Gain<-entropy.before.split-Entropy.split
print(Entropy.Gain)
