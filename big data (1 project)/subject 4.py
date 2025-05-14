# Θέμα 4 (I)

# Για να μπορέσουμε να χρησιμοποιήσουμε διανύσματα.
import numpy as np

# παρέχει πολλές μαθηματικές λειτουργίες που θα χρειαστούμε όπως sqrt. 
import math

# Δημιουργία συνάρτησης που υπολογίζει την Ευκλείδεια απόσταση των δύο διανυσμάτων διαστάσεων n.
def euclideanDistance(vector1, vector2,do_print=True):
    distance=math.sqrt(sum((np.array(vector1) - np.array(vector2))**2))
    if do_print:
        print("Ευκλείδεια απόσταση:", distance)
    return distance
    
# Δημιουργία διανυσμάτων με στοιχεία [n].
v1=np.array([1,2,3,4,5,6])
v2=np.array([1,2,3,4,5,6])
v3=np.array([-0.5, 1, 7.3, 7, 9.4, -8.2, 9, -6, -6.3])
v4=np.array([0.5, -1, -7.3, -7, -9.4, 8.2, -9, 6, 6.3])
v5=np.array([-0.5, 1, 7.3, 7, 9.4, -8.2])
v6=np.array([1.25, 9.02, -7.3, -7, 5, 1.3])
v7=np.array([0, 0, 0.2])
v8=np.array([0.2, 0.2, 0])

# Υπολογίζουμε την ευκλείδια απόσταση.
euclideanDistance(v1,v2)
euclideanDistance(v3,v4)
euclideanDistance(v5,v6)
euclideanDistance(v7,v8)


# Θέμα (II)

def find_max_and_position(a, b, c, d):
    numbers = [a, b, c, d]
    max_value = max(numbers)
    max_index = numbers.index(max_value)+1
    return max_value, max_index

# Δημιουργία διανυσμάτων με στοιχεία [n].
v1=np.array([25000,14,7])
v2=np.array([42000,17,9])
v3=np.array([55000,22,5])
v4=np.array([27000,13,11])
v5=np.array([58000,21,13])

# Υπολογίζουμε την ευκλείδια απόσταση.
d1=euclideanDistance(v5,v1,do_print=False)
d2=euclideanDistance(v5,v2,do_print=False)
d3=euclideanDistance(v5,v3,do_print=False)
d4=euclideanDistance(v5,v4,do_print=False)

# Μετατρέπουμε την ευκλείδια απόσταση σε μέτρο ομοιότητας.
s1=1/(1+d1)
s2=1/(1+d2)
s3=1/(1+d3)
s4=1/(1+d4)

result, position = find_max_and_position(s1,s2,s3,s4)

print("Ο χρήστης με την μεγαλύτερη ομοιότητα:", result)

print("Είναι το προφίλ του χρήστη με κωδικό:", position)












 
    
