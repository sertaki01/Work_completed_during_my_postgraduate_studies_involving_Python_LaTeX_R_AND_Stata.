import pandas as pd
import os

#working directory
os.chdir("C:/Users/admin/OneDrive/Υπολογιστής/big data(2 project)")

# Read the file dataset.xlsx
Data = pd.read_excel('dataset.xlsx')

# See the columns.
print(Data.columns)

# Επιλογή των γραμμών όπου 'Likes Travel', 'Likes Dogs' και 'Aegean Product' είναι και τα τρία ίσα με 1
filtered_data = Data[(Data['Likes travel'] == 1) & (Data['Likes dogs'] == 1) & (Data['Aegean'] == 1)]

percentage = len(filtered_data) / len(Data) * 100

print(percentage)
