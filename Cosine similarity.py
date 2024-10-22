# Θέμα 5

# Για να μπορέσουμε να χρησιμοποιήσουμε διανύσματα.
import numpy as np

# παρέχει πολλές μαθηματικές λειτουργίες που θα χρειαστούμε όπως sqrt. 
import math

# Δημιουργία συνάρτησης που υπολογίζει την ομοιότητα συνημιτόνου των δύο διανυσμάτων διαστάσεων n.
def cosineSimilarity(vector1, vector2):
     dot_product= sum(vector1*vector2)
     norm_vector1= math.sqrt(sum(vector1**2))
     norm_vector2= math.sqrt(sum(vector2**2))
     similarity= dot_product/(norm_vector1*norm_vector2)
     return similarity

# Δημιουργία διανυσμάτων με στοιχεία [n].
v1=np.array([9.32, -8.3, 0.2])
v2=np.array([-5.3, 8.2, 7])
v3=np.array([6.5, 1.3, 0.3, 16, 2.4, -5.2, 2, -6, -6.3])
v4=np.array([0.5, -1, -7.3, -7, -9.4, 8.2, -9, 6, 6.3])
v5=np.array([-0.5, 1, 7.3, 7, 9.4, -8.2])
v6=np.array([1.25, 9.02, -7.3, -7, 15, 12.3])
v7=np.array([2, 8, 5.2])
v8=np.array([2, 8, 5.2])

# Υπολογίζουμε την ομοιότητα συνημιτόνου.
similarity1=cosineSimilarity(v1,v2)
similarity2=cosineSimilarity(v3,v4)
similarity3=cosineSimilarity(v5,v6)
similarity4=cosineSimilarity(v7,v8)

# εμφανίζει στην οθόνη την ομοιότητα συνημιτόνου μεταξύ δυο διανυσμάτων για κάθε ζευγάρι.
print("Cosine Similarity:", round(similarity1,ndigits=4))
print("Cosine Similarity:", round(similarity2,ndigits=4))
print("Cosine Similarity:", round(similarity3,ndigits=4))
print("Cosine Similarity:", round(similarity4,ndigits=4))



