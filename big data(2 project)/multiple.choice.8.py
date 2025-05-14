import pandas as pd
import matplotlib.pyplot as plt
import os

#working directory
os.chdir("C:/Users/admin/OneDrive/Υπολογιστής/big data(2 project)")



# Διαβάζουμε το αρχείο dataset.xlsx
Data = pd.read_excel('dataset.xlsx')

# Δημιουργούμε ένα πίνακα συχνοτήτων για τον συνδυασμό ηλικιακής ομάδας και φύλου.
cross_table = pd.crosstab(Data['Age Group'], Data['Gender'], normalize='index') * 100

# Εμφανίζουμε τα ποσοστά.
print("Ποσοστά Συμμετοχής ανά Ηλικιακή Ομάδα και Φύλο:")
print(cross_table)

