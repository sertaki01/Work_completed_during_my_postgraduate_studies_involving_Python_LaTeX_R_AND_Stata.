# διαχείριση φακέλου μέσω της python. 
import os

# Λάβετε τον τρέχοντα κατάλογο εργασίας.
current_directory = os.getcwd()

print("Current Directory:", current_directory)

# Για να ψάχνει απο άλλο φακελό τα αρχεία που θέλουμε να τραβήξει.
new_directory = 'C:\\Users\\admin\\OneDrive\\Υπολογιστής\\big data (1 project)'

os.chdir(new_directory)

# Για να επιβεβαιώσουμε οτι όντως άλλαξε το path που τραβάει αρχεία.
current_directory = os.getcwd()

print("New Current Directory:", current_directory)

# Πακέτο για να διαβάζουμε αρχεία csv.
import pandas as pd

# Διαβάζουμε ενα αρχείο csv σε ένα dataframe.
WineData = pd.read_csv("winequality-white.csv", header=0, sep=";", engine='python')

# Του λέμε να μας δείξει τις πρώτες 5 γραμμές του πίνακα δεδομένων.
print(WineData.head())

# Του λέμε να μας δείξει τις τελευταίες 5 γραμμές του πίνακα δεδομένων.
print(WineData.tail())

# Έλεγχος ελλειπούσων τιμών στα δεδομένα μας.
missing_values = WineData.isna().sum()

# Θα δείξει για κάθε μεταβλητή πόσες τιμές λείπουν.
print(missing_values)

# Βρίσκει τον δείκτη της στήλης όπου βρίσκεται η μεταβλητή 'quality'.
column_index = WineData.columns.get_loc('quality')

# Εδω του λεμε να μας το εμφανισει την στηλη που βρίσκει.
print("Η μεταβλητή 'quality' βρίσκεται στη στήλη με δείκτη:", column_index)

# Εδώ διώχνουμε τη μεταβλητή 'quality' διότι είναι διατακτική για να μπορούμε να κάνουμε pca.
WineData=WineData.drop('quality', axis=1)

#Του ζητάμε να τυπώσει τις 5 πρώτες γραμμές για να δούμε εαν εκτελέστηκε σωστά η προηγούμενη εντολή.
print(WineData.head())

# Αυτές η δύο γραμμές χρειάζοντα για να μπορούμε να τρέξουμε την python.
from sklearn import decomposition

from sklearn.decomposition import PCA

# Για να μπορέσουμε να χρησιμοποιήσουμε διανύσματα.
import numpy as np

# Τρέχουμε την συνάρτηση pca και του λέμε πόσα principal components θελουμε.
pca = decomposition.PCA(n_components=2)

# Εδώ τρέχουμε το pca στον πίνακα δεδομένων που έχουμε κάνει import. 
pca.fit(WineData)

#Για να μετατρέψoυμε τα δεδομένα του συνόλου δεδομένων WineData στο νέο σύστημα συντεταγμένων που καθορίστηκε από τα δύο ιδιοδιανύσματα που προέκυψαν από το (PCA).
transformedWineData = pca.transform(WineData)

# Εκτύπωση των ιδιοτιμών
print("Ιδιοτιμές:")
print(pca.explained_variance_)

# Εκτύπωση των ιδιοδιανυσμάτων
print("Ιδιοδιανύσματα:")
print(pca.components_)

# Εκτύπωση του ποσοστού της διακύμανσης που εξηγείται από κάθε κύρια συνιστώσα
print("Ποσοστό Διακύμανσης που Εξηγείται από κάθε Κύρια Συνιστώσα:")
print(pca.explained_variance_ratio_)


# Δημιουργία ενός DataFrame που περιέχει τις ιδιοτιμές, ιδιοδιανύσματα, ποσοστό της διακύμανσης που εξηγείται από κάθε κύρια συνιστώσα.
df = pd.DataFrame({'eigenvalues': pca.explained_variance_.round(3) ,'explained_variance_ratio': pca.explained_variance_ratio_.round(3)})

# Αποθηκεύστε το DataFrame σε ένα αρχείο CSV
df.to_csv('pca_results_subset.csv', index=False)







