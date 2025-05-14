
##############################################################################
#
# This is an example how classification can be used to
# classify comments based on whether they express something
# positive or negative.
#
# The  important thing here is to see how text data can
# be modelled in a way so that these classification algorithms can
# be used. The example uses Naive Bayes to assign a sentiment (positive
# or negative) to movie comments.
#
##############################################################################


import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import re # for regex



# NLTK library
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem import SnowballStemmer


# Bag of Words
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB,MultinomialNB,BernoulliNB, CategoricalNB
from sklearn.metrics import accuracy_score,precision_score,recall_score



###########################################################
#
# First we define some functions to make our life easier.
# NOTE: these will be used mainly for preprocessing
#
###########################################################



#
# We clean up any HTML element that may lurk in our data
#
def clean(text):
    cleaned = re.compile(r'<.*?>')
    return re.sub(cleaned,'',text)

#
# Remove words that are contain symbols that are not
# letters or numbers.
#
def is_special1(text):
    rem = ''
    for i in text:
        if i.isalnum()==False and i != " ":
            text=text.replace(i,'')
            
    return text

# Self explaining...
def to_lower(text):
    return text.lower()



#
# Remove stopwords (i.e. words like the, as, if, that etc)
# We use stopwords for english available by the nltk package (that's really cool!)
#
def rem_stopwords(text):
    stop_words = set(stopwords.words('english'))
    words = word_tokenize(text)
    return [w for w in words if w not in stop_words]


#
# We use the SnowballStemmer to stem words.
# Stemming means getting the word stem of a word which does not have any inflectional part.
# i.e. cats will become cat (word stem)
# enemies will become enem (word stem)
# baby will become bab
# etc
#
# We do this in order to not recognize inflectional morphs of a word as a different word.
# 
#
def stem_txt(text):
    ss = SnowballStemmer('english')
    return " ".join([ss.stem(w) for w in text])




#
#NOTE: use IMDBDataset-small.csv as a demo to
#      show how the vectorized matrix will look like
#      when displayed as a data frame.
#
print("Reading dataset....", end="")
data = pd.read_csv('IMDBDataset.csv')

print("done")

print("Preprocessing...")

# Remember that Python does not have a Factor datatype as R does.
# Hence, encode accordingly nominal variables as integers
print("\tRecoding....", end="")
data.sentiment.replace('positive',1,inplace=True)
data.sentiment.replace('negative',-1,inplace=True)
data.sentiment.replace('neutral',0,inplace=True)

data.head(10)
print("done")

print("\tCleaning html entities....", end="")
data.review = data.review.apply(clean)
data.review[0]
print("done")


print("\tRemoving special characters....", end="")
data.review = data.review.apply(is_special1)
print( "done.")

print("\tLower case....", end="")
data.review = data.review.apply(to_lower)
data.review[0]
print("done.")

print("\tRemoving stopwords....", end="")
data.review = data.review.apply(rem_stopwords)
print( "done" )

print("\tStemming....", end="")
data.review = data.review.apply(stem_txt)
data.review[0]
print("done")

#
# Here we create the CountVectorizer.
# This means that we will create a huge matrix with individual words encounterred as columns
# and as rows, the movie reviews. Each position in that matrix tells us how many times that word
# appears in that review.
#
# You may visualize this matrix if you like (comments below indicated how this can be done), but
# pls DONT do this for large matricies. Do this ONLY for small number of words or text.
#
print("Creating count vectorizer....", end="")
X= np.array(data.iloc[:,0].values)
y = np.array(data.sentiment.values)
cv = CountVectorizer(max_features = 1000)
X_1= cv.fit_transform(data.review).toarray()
print("done")




#
# Show how the vectorized matrix actually looks like.
# We do this for educational purposes ONLY!
# Columns: individual tokens/words
# Rows: documents/text to be analysed
# Individual positions: how many times word appears in doument/text
#
# NOTE: uncomment only if the file has small number of texts. Does not
#       make sense for large files.

'''
print("")
print("===============================================================================")
print("How the vectorized matrix looks like:")
print("")
cvDF = pd.DataFrame(data = X_1, columns=cv.get_feature_names_out())
print(cvDF)
print("=============================================================================")
'''


# Prepare training and testing sets
print("Training multinomial model....", end="")
trainx,testx,trainy,testy = train_test_split(X_1,y,test_size=0.2,random_state=9)

#
# Train the Naive Bayes model.
# NOTE: we use multinomialNB() because this is the most appropriate one
#       when the data is counts. And we do have counts here (see CountVectorizer).
#       multinomialNB() refers to the distribution of the independent variables. MultinomialNB()
#       assumes multinomial distribution of our variables.
# alpha: smoothing factor (i.e. how to change counts when probability is 0).
# fit_prior: should prior probabilities be calculated or not.
mnb = MultinomialNB(alpha=1.0, fit_prior=True)

# Train the model using training set
mnb.fit(trainx,trainy)
print("done.")



print("Predicting categories on the testing set.")

# Use the testing set to do some predictions.
ypm = mnb.predict(testx)

# Calculate some metrics: accuracy, precision and recall for
# the testing set
print("\tMultinomial accuracy = ",accuracy_score(testy,ypm))
print("\tMultinomial precision= ",precision_score(testy,ypm))
print("\tMultinomial recall= ",recall_score(testy,ypm))



print("Predicting categories on unknown data.")

###############################################################
#
# Let's test some unknown data...
#
###############################################################

# We have 2 reviews here
unknownReviews = ["There is NO excuse for how bad this movie was. It's so out of touch with the world that it's actually offensive and not in a sexual like the title might lead you to believe.".lower(),
                  'A phenomenal achievement and a real candidate for the greatest motion picture ever made.'.lower()]

#
# Transform the text into a vector, indicating which word appears in the text and how many times, using
# the features (rows) of the trained Naive Bayes model.
# 
vectorizedReviews = cv.transform(unknownReviews)

# Ok done. Use Naive Bayes to predict sentiment
predictedSentiment = mnb.predict(vectorizedReviews)

# Use the model to predict sentiment for reviews.
# NOTE: we display also the probabilities for each
#      category/class (i.e. positive/negative) 
ypgP = mnb.predict_proba(vectorizedReviews)
idx = 0 # counting rows to be able to refer to specific review. 
for prb in ypgP :    
    pos = list(prb).index( max(prb) )
    idx+=idx
    print("\tUnknown review at ", str(idx), ") Probabilities: ", prb, end="")
    print(" predicted class = ", mnb.classes_[pos] )



