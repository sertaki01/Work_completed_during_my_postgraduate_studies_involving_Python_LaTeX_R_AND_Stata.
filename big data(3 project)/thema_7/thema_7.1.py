#import necessary libraries
import csv
import pandas as pd
from kmodes.kmodes import KModes
import numpy as np
# Specify the path to your CSV file
csv_file_path1 = 'C:\\Users\\kwstasbenek\\Desktop\\giannakopoulo_8\\Tsagkarakis_3h_ergasia\\3hErgasia\\movies.csv'

# Open the CSV file with specified encoding (e.g., UTF-8)
with open(csv_file_path1, 'r', encoding='utf-8') as file:
    # Create a CSV reader object
    csv_reader = csv.reader(file)

    # Convert the CSV data into a list of lists
    data = [row for row in csv_reader]

# Create a Pandas DataFrame from the list of lists
movies_df = pd.DataFrame(data)
print(movies_df)
csv_file_path2 = 'C:\\Users\\kwstasbenek\\Desktop\\giannakopoulo_8\\Tsagkarakis_3h_ergasia\\3hErgasia\\ratings.csv'
# Open the CSV file with specified encoding (e.g., UTF-8)
with open(csv_file_path2, 'r', encoding='utf-8') as file:
    # Create a CSV reader object
    csv_reader = csv.reader(file)

    # Convert the CSV data into a list of lists
    data = [row for row in csv_reader]

# Create a Pandas DataFrame from the list of lists
ratings_df = pd.DataFrame(data)
print(ratings_df)

# Extract only the category variables (dummy variables) from the movies DataFrame(starting from the 3rd column) 
categories_data = movies_df.iloc[:, 2:]

# Choose the number of clusters (K) using the Elbow method
# Assume that k_values is a list containing values from 2 to 100
sum_of_squared_distances = []
k_values = range(2, 101)
#loop over each k in k_values
for k in k_values:
    #initialize kmodes cluster model
    #init, Specifies the initialization method. 'Huang' is one of the initialization methods available in the KModes algorithm.
    #It is a method that initializes the centroids based on the density of the categorical data.
    #n_init specifies the number of times the K-modes algorithm will be run with different centroid seeds.
    #This is done to mitigate the impact of random initialization, and the best result in terms of clustering cost will be retained.
    #int=5 is the number of times the algorythm will be run with different centroid seeds. This is done to mitigate the effect of the random initialization
    #of centroids at the begining of the algorythm, something which does affect the final outcome, basically it represents a trade-off between computational
    #cost and obtaining a robust solution.
    #the number 5 is chosen since it is not too big(high comutatonal cost) neither too small(loss in robustness of results)
    kmeans = KModes(n_clusters=k, init='Huang', n_init=5, verbose=0)
    #fits the model to the categories data
    kmeans.fit_predict(categories_data)
    #After fitting and predicting, this attribute stores the cost of the clustering, which is the sum of squared distances.
    #The lower the cost, the better the clustering.

    sum_of_squared_distances.append(kmeans.cost_)

# Plot the Elbow graph
import matplotlib.pyplot as plt
#design the plot of the elbow graph
plt.plot(k_values, sum_of_squared_distances, 'bx-')
plt.xlabel('Number of Clusters (K)')
plt.ylabel('Sum of Squared Distances')
plt.title('Elbow Method For Optimal K')
plt.show()

# Choose the optimal number of clusters (K) based on the Elbow method
#This funcion finds the index where the first derivative of the sum of squared distances is minimized
optimal_k = np.argmin(np.diff(sum_of_squared_distances)) + 2  # Assuming K starts from 2
print(f"Optimal number of clusters (K): {optimal_k}")
print("doone")
#re-run the k-clustering model with the optimal n of clsters
kmeans = KModes(n_clusters=optimal_k, init='Huang', n_init=5, verbose=0)
# fits k-model to categories and predict cluster assignment of each data point
cluster_labels = kmeans.fit_predict(categories_data)
#add column to movies_df with the cluster id for each data point 
movies_df['clusterId'] = cluster_labels
# Calculate the average rating for each movie
average_ratings = ratings_df.groupby('movieId')['rating'].mean()
#merge the two df based on the unique "movieId" left_on mean that the "movieId" column of the movies_df will be used as key for merging, while right_index=True that
#index of the average_ratings will be used as key for merging, how='left', refers to the type of merge (left joint)
#The resulting merged df will contain all columns of the movies_df + the average rating of each movie, if a movie doe not have a corresponding entry in average ratings
#then the value of the column will be NaN 
movies_df = pd.merge(movies_df, average_ratings, left_on='movieId', right_index=True, how='left')

#Specifie the user for whom movie recommendations are being generated
user_id = 198
# extract ratings from the ratings_df for the specific user 
user_ratings = ratings_df[ratings_df['userId'] == user_id]

# Merge user_ratings_df and movies_df on movieId and clusterId
user_ratings = pd.merge(user_ratings, movies_df[['movieId', 'clusterId']], on='movieId', how='left')

# Group user ratings by clusterId and calculate the mean rating for each cluster
cluster_avg_ratings = user_ratings.groupby('clusterId')['rating'].mean()

# Display the average ratings for each cluster
print("\nAverage Ratings for Each Cluster:")
for cluster_id, avg_rating in cluster_avg_ratings.iteritems():
    print(f"Cluster {cluster_id}: {avg_rating:.2f}")#2f is for the numer of digits displayed

# Filter clusters with average rating >= 3.5(.index retrievs the index values(clusterId's))
high_rated_clusters = cluster_avg_ratings[cluster_avg_ratings >= 3.5].index

# Check if there are clusters with average rating >= 3.5
if not high_rated_clusters.empty:
    # For each high-rated cluster, find top 2 movies user hasn't seen
    #empty df 

    recommendations = pd.DataFrame()
    for cluster_id in high_rated_clusters:
        #keep only movies that belong to the current cluster
        cluster_movies = movies_df[movies_df['clusterId'] == cluster_id]
        #keep only the unrated movies using '~'
        unrated_movies = cluster_movies[~cluster_movies['movieId'].isin(user_ratings['movieId'])]
        
        # Check if there are unrated movies in the cluster
        if not unrated_movies.empty:
            #if unrated movie in cluster select the top 2 (with the highest rating)
            top_movies = unrated_movies.nlargest(2, 'rating')
            #put the in the recommndations df
            recommendations = recommendations.append(top_movies)

    # Check if there are recommendations
    if not recommendations.empty:
        # Display recommendations
        print("\nMovie Recommendations:")
        #for each row in recommendations df 
        for _, movie in recommendations.iterrows():
            print(f"Movie Title: {movie['title']}, Average Rating: {movie['rating']:.2f}")
    else:
        print("\nSorry, no new movies to recommend from high-rated clusters!")

else:
    print("\nSorry, no high-rated clusters found for recommendations!")
