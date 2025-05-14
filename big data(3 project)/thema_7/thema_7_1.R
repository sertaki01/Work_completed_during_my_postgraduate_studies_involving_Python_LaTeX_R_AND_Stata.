# Remove all objects from the workspace
rm(list = ls())

# Set the working directory
setwd("C://Users//kwstasbenek//Desktop/giannakopoulo_8//Tsagkarakis_3h_ergasia")
#libraries/packages
install.packages(c("dplyr", "tidyr", "cluster", "ggplot2"))
library(dplyr)
library(tidyr)
library(cluster)
library(ggplot2)

# Read movies and ratings data
movies <- read.csv('C:\\Users\\kwstasbenek\\Desktop\\giannakopoulo_8\\Tsagkarakis_3h_ergasia\\3hErgasia\\movies.csv', header = TRUE)
ratings <- read.csv('C:\\Users\\kwstasbenek\\Desktop\\giannakopoulo_8\\Tsagkarakis_3h_ergasia\\3hErgasia\\ratings.csv', header = TRUE)

# Extract category variables (dummy variables) from the movies DataFrame
categories_data <- movies[, 3:ncol(movies)]

# Choose the number of clusters (K) using the Elbow method
# Assume that k_values is a vector containing values from 2 to 100
sum_of_squared_distances <- numeric(length = 0)
k_values <- 2:100

for (k in k_values) {
  # Initialize k-modes cluster model
  #iteration=5 for the same reason as metioned in the python script
  kmeans_result <- KMeans(categories_data, centers = k, algorithm = "Hartigan-Wong", iter.max = 5, nstart = 5)
  
  # After fitting and predicting, store the cost of clustering (sum of squared distances)
  #The withinss attribute represents the sum of squared distances from each point in a cluster to the center of that cluster. 
  #Essentially, it is a measure of how tight or compact the clusters are.
  #Then, we append the total sum of squared distances for the current value of k (number of clusters) to the vector
  sum_of_squared_distances <- c(sum_of_squared_distances, sum(kmeans_result$withinss))
}

# Plot the Elbow graph
plot(k_values, sum_of_squared_distances, type = 'b', xlab = 'Number of Clusters (K)', ylab = 'Sum of Squared Distances', main = 'Elbow Method For Optimal K')

# Choose the optimal number of clusters (K) based on the Elbow method
# Find the index where the first derivative of the sum of squared distances is minimized
#The diff(sum_of_squared_distances) calculates the differences between consecutive elements in the vector sum_of_squared_distances. 
#The which.min() function is then applied to find the index where these differences are minimized.
optimal_k <- which.min(diff(sum_of_squared_distances)) + 1 #assuming k starts from 2


cat("Optimal number of clusters (K):", optimal_k, "\n")

# Re-run the k-clustering model with the optimal number of clusters
kmeans_result <- kmeans(categories_data, centers = optimal_k, algorithm = "Hartigan-Wong", iter.max = 5, nstart = 5)
cluster_labels <- kmeans_result$cluster

# Add the 'clusterId' column to the movies data frame
movies$clusterId <- cluster_labels

# Calculate the average rating for each movie
#FUN = mean: Specifies the function to be applied to each subset of data. 
#Here, we are using the mean function to calculate the average rating for each movie.
average_ratings <- aggregate(rating ~ movieId, data = ratings, FUN = mean)

# Merge the two data frames based on the unique "movieId"
#all.x specifies that all the rows from the left data frame (movies in this case) should be included in the merged data frame.
movies <- merge(movies, average_ratings, by = 'movieId', all.x = TRUE)

# Specify the user for whom movie recommendations are being generated
user_id <- 198

# Extract ratings from the ratings data frame for the specific user
user_ratings <- subset(ratings, userId == user_id)

# Merge user_ratings_df and movies_df on movieId and clusterId
#cbind
user_ratings <- merge(user_ratings, movies[, c('movieId', 'clusterId')], by = 'movieId', all.x = TRUE)

# Group user ratings by clusterId and calculate the mean rating for each cluster
#aggregate function is used to to group the 'user_ratings' data frame by the 'clusterId' column and calculate the mean rating for each cluster.
cluster_avg_ratings <- aggregate(rating ~ clusterId, data = user_ratings, FUN = mean)

# Display the average ratings for each cluster
cat("\nAverage Ratings for Each Cluster:\n")
print(cluster_avg_ratings)

# Filter clusters with average rating >= 3.5
#and keep their clusterId
high_rated_clusters <- subset(cluster_avg_ratings, rating >= 3.5)$clusterId

# Check if there are clusters with average rating >= 3.5
#check if not empty
if (length(high_rated_clusters) > 0) {
  # For each high-rated cluster, find top 2 movies user hasn't seen
  recommendations <- data.frame()
  
  for (cluster_id in high_rated_clusters) {
    # Keep only movies that belong to the current cluster and subset them
    
    cluster_movies <- subset(movies, clusterId == cluster_id)
    
    # Keep only the unrated movies using '~'
    #!(movieId %in% user_ratings$movieId): This part is a logical condition. 
    #It checks for each movie in cluster_movies whether its movieId is NOT in the vector of movie IDs that the user has rated (user_ratings$movieId).
    #Then we subset based on this logical condition
    unrated_movies <- subset(cluster_movies, !(movieId %in% user_ratings$movieId))
    
    # Check if there are unrated movies in the cluster
    if (nrow(unrated_movies) > 0) {
      # If unrated movies in the cluster, select the top 2 (with the highest rating)
      #we order the unrated _movies df in a decreasing order and only keep the first 2 movies
      top_movies <- unrated_movies[order(unrated_movies$rating, decreasing = TRUE), ][1:2, ]
      
      # Put them in the recommendations data frame
      recommendations <- rbind(recommendations, top_movies)
    }
  }
  
  # Check if there are recommendations
  if (nrow(recommendations) > 0) {
    # Display recommendations
    cat("\nMovie Recommendations:\n")
    print(recommendations)
  } else {
    cat("\nSorry, no new movies to recommend from high-rated clusters!\n")
  }
  
} else {
  cat("\nSorry, no high-rated clusters found for recommendations!\n")
}
