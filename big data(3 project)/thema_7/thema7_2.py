import pandas as pd
import numpy as np
from sklearn.cluster import AgglomerativeClustering
from scipy.cluster.hierarchy import dendrogram, linkage
import matplotlib.pyplot as plt
import csv
from sklearn.preprocessing import StandardScaler
# Specify the path to your CSV file
csv_file_path = 'C:\\Users\\kwstasbenek\\Desktop\\giannakopoulo_8\\Tsagkarakis_3h_ergasia\\3hErgasia\\europe.csv'

# Read the CSV file with specified encoding (e.g., UTF-8) and header row
europe_df = pd.read_csv(csv_file_path, encoding='utf-8', header=0)  # first row column names 

# Remove leading whitespaces from column names, since there are in almost everyone
europe_df.columns = europe_df.columns.str.strip()

# Display the DataFrame and its columns
print(europe_df)
print("Column Names:", europe_df.columns)

# Set 'Country' column as the index
#inplace=True specifies that the modification the modification operation should be performed directly on the object in memory, without creating a new object. 
europe_df.set_index('Country', inplace=True)

# Extract country names and features
country_names = europe_df.index
# iloc is a method in pandas that is used for integer-location based indexing.
# The : symbol in the indexing represents "all," so [:, :] is selecting all rows and all columns from the DataFrame 
numeric_features = europe_df.iloc[:, :] 
# Convert features to numeric, non numeric items will be NaN 
numeric_features = numeric_features.apply(pd.to_numeric, errors='coerce')
# Drop any rows with NaN values
numeric_features = numeric_features.dropna()
#basically all this is done to create a new df containing the same data points as the original europe_df except for country which is string 

#normalizing features
scaler = StandardScaler()
numeric_features_scaled = scaler.fit_transform(numeric_features)
# Perform hierarchical clustering using AgglomerativeClustering
n_clusters = 10

cluster = AgglomerativeClustering(n_clusters=n_clusters, metric='euclidean', linkage='ward')#'ward' minimizes variance within clusters 
cluster_labels = cluster.fit_predict(numeric_features)

# Linkage matrix for dendrogram, contains indices of merged clusters as well as distance/dissimillarity between the merged clusters 
linkage_matrix = linkage(numeric_features_scaled, method='ward')

# Plot the dendrogram
plt.figure(figsize=(15, 15))
dendrogram(linkage_matrix, labels=country_names, orientation='top', distance_sort='descending')
plt.title('Hierarchical Clustering Dendrogram')
plt.xlabel('Country')   
plt.ylabel('Distance')
plt.show()
