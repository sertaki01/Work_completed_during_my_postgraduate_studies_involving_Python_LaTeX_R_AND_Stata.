import pandas as pd
import os

#working directory
os.chdir("C:/Users/admin/OneDrive/Υπολογιστής/big data(2 project)")

# Read the file dataset.xlsx
Data = pd.read_excel('dataset.xlsx')

# See the columns.
print(Data.columns)

# Επιλογή των γραμμών όπου 'Likes travel' και 'Likes football' είναι και τα δύο ίσα με 1
filtered_data = Data[(Data['Likes travel'] == 1) & (Data['Likes football'] == 1)]

# Υπολογισμός του ποσοστού για κάθε φύλο
percentage_by_gender = filtered_data.groupby('Gender').size() / Data.groupby('Gender').size() * 100

print(percentage_by_gender)
