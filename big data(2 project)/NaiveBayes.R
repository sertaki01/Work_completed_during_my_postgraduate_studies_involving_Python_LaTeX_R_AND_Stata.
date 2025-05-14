#Includes functions for Naive Bayes
library(e1071)

#We will be using the Congressional Voting Records Data Set
#Download it from: http://archive.ics.uci.edu/ml/datasets/Congressional+Voting+Records

#Set our working directory
setwd("C:\\Users\\user\\Desktop")

#First read the data. Note the dataset HAS NO headers, hence set header to FALSE. 
#We well add headers later. NOTE: Change your path to data appropriately!
voteData = read.csv("house-votes-84.data", header=FALSE)


#Add headers to data. Makes working with dataset easier
colnames(voteData) <- c("party", "infants", "water-cost", "budgetRes", "PhysicianFr", "ElSalvador", "ReligSch", "AntiSat", "NicarAid", "Missile", "Immigration", "CorpCutbacks", "EduSpend", "RightToSue", "Crime", "DFExports", "SAExport")

#Take a quick look at the data. Is everything ok?
head(voteData)

#Looks fine. NOTE: in some records, the party variable has value ? meaning that its value is unknown.
#We are now ready to train our model and derive our Naive Bayes
#classifier. We want to predict the party based on how a congress delegate
#has voted on various issues.
NaiveBayesModel <- naiveBayes (party ~ ., data = voteData)

#Done! Model created. Variable NaiveBayesModel contains now our naive bayes model 
#as it resulted from the training data (voting records dataset)
#Now, try to predict the party based on the voting history of some congressman. 

#Now, try to apply the Naive Bayes model to an unknown record.

#Add a new unknown record to existing voteData. Note that first attribute (party) has
#value ? meaning we don’t know it and try to guess it from all the other
#attributes. NOTE: we will get a warning but we ignore it.
voteData[nrow(voteData)+1, ] <-c("?","n","n","y","y","y","n","n","y","n","n","y","n","y","y","y","y")

#Apply Naive Bayes model to unknown record i.e. to last record that was
#added to voteData
unknownRecordClass = predict(NaiveBayesModel, voteData[nrow(voteData), ])

#Now unknownRecordClass has the class i.e. party predicted for unknown record.
#Let’s see it
print( unknownRecordClass )

#You can also plot it (sigh)
plot(unknownRecordClass)
