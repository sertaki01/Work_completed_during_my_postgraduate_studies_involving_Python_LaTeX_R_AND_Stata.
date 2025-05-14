# Θέμα 6

# Για να μπορέσουμε να χρησιμοποιήσουμε διανύσματα.
import numpy as np

# παρέχει πολλές μαθηματικές λειτουργίες που θα χρειαστούμε όπως sqrt. 
import math

# Ορίζουμε τα διανύσματα που θα χρησιμοποιήσουμε
v1 = ["Green", "Potato", "Ford"]
v2 = ["Tyrian purple", "Pasta", "Opel"]
v3 = ["Eagle", "Ronaldo", "Real madrid", "Prussian blue", "Michael Bay"]
v4 = ["Eagle", "Ronaldo", "Real madrid", "Prussian blue", "Michael Bay"]
v5 = ["Werner Herzog", "Aquirre, the wrath of God", "Audi", "Spanish red"]
v6 = ["Martin Scorsese", "Taxi driver", "Toyota", "Spanish red"]



# Συνάρτηση με όνομα nominalDistance, η οποία Υπολογίζει την απόσταση με βάση ενός δείκτη που κυμαίνεται απο το 0 εώς το 1. Όσο αυξάνεται ο δείκτης τόσο μεγαλύτερη απόσταση έχουν τα δυο διανύσματα μεταξύ τους.
def nominalDistance(vec1, vec2):
    distance=0
    for i in range (len(vec1)):
        if vec1[i] != vec2[i]:
            distance+=1
    index = distance / len(vec1)
    return index

# Καλεί τη συνάρτηση nominalDistance και υπολογίζει την απόσταση μεταξύ δυο διανυσμάτων.
index1 = nominalDistance(v1, v2)
index2 = nominalDistance(v3, v4)
index3 = nominalDistance(v5, v6)


print("distance 1:", index1)
print("distance 2:", index2)
print("distance 3:", index3)
