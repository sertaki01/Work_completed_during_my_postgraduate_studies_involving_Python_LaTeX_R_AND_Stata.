# Remove all objects from the workspace
rm(list = ls())

# Close all open graphical devices
graphics.off()

# Read the CSV file
europe_data <- read.csv("C:\\Users\\kwstasbenek\\Desktop\\giannakopoulo_8\\Tsagkarakis_3h_ergasia\\3hErgasia\\europe.csv", header = TRUE)

# Remove leading whitespaces from column names
names(europe_data) <- trimws(names(europe_data))
#save country names 
country_names <- europe_data$Country
# Set 'Country' column as the row names
rownames(europe_data) <- europe_data$Country
europe_data$Country <- NULL  # Remove 'Country' column

# Convert data to numeric, non-numeric items will be converted to NA
europe_data <- apply(europe_data, 2, as.numeric)

# Remove rows with NA values
europe_data <- na.omit(europe_data)

# Normalize features
scaled_data <- scale(europe_data)

# Perform hierarchical clustering using hclust
#distance matrix using dist(), specifying euclidean 
distance_matrix <- dist(scaled_data, method = "euclidean")
#"ward.D2" refers to the variant of the Ward's method used, which is a criterion for measuring the dissimilarity between two clusters.
#The "D2" in "ward.D2" stands for squared Euclidean distance.
hierarchical_cluster <- hclust(distance_matrix, method = "ward.D2")

# Plot the dendrogram with 'Country' values as labels
plot(hierarchical_cluster, hang = -1, cex = 0.8, main = "Hierarchical Clustering Dendrogram",
     xlab = "Country", ylab = "Distance", labels = country_names)

