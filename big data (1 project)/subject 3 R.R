#Θέμα 3 πρώτο ερώτημα.

#Ορίζεται ο φάκελος που αποθηκεύει και αναζητά τα αρχεία.
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\big data (1 project)")

#διαγράφει όλες τις μεταβλητές που βρίσκονται στο περιβάλλον εργασίας.
rm(list = ls())

#διαγράφει όλα τα διαγράμματα που έχουν δημιουργηθεί.
graphics.off()

#Για να προσθέση την βιβλιοθήκη που περιέχει τα δεδομένα που θέλω.
library(MASS)

# Συνάρτηση ή οποία τραβάει τα δεδομένα που θέλω απο την βιβλιοθήκη MASS.
data(Cars93)

# 6 πρώτες παρατηρήσεις απο το πλαίσιο δεδομένων.
head(Cars93)

# 6 τελευταίες παρατηρήσεις απο το πλαίσιο δεδομένων.
tail(Cars93, 6)

# Για να δούμε τι τύπου δεδομένων είναι κάθε μεταβλητή που διαβάσαμε από το αρχείο.
str(Cars93)

# Μετατροπή της μεταβλητής Cylinders από factor σε int.
Cars93$Cylinders<- as.integer(Cars93$Cylinders)

#μετατρέπουμε τα δεδομένα μας ώστε να είναι μόνο αριθμητικά
numeric_data<-Cars93[sapply(Cars93, is.numeric)]

#αφαιρούμε τα στοιχεία που απουσιάζουν.
numeric_data<-na.omit(numeric_data)

#Εμφανίζει τον νέο πίνακα με μόνο αριθμητικά δεδομένα
print(numeric_data)

# Εκτελούμε μια ανάλυση Κύριων Συνιστωσών (PCA) χρησιμοποιώντας τον πίνακα συνδιακυμάνσεων.
library(stats)
covariance_matrix <- cov(numeric_data)
pca_result <- prcomp(covariance_matrix)

#Ιδιοτιμές (Eigenvalues).
eigenvalues <- pca_result$sdev^2
print(eigenvalues)

#Ιδιοδιανύσματα (Eigenvectors).
eigenvectors <- pca_result$rotation
print(eigenvectors)

#Ποσοστό εξήγησης της διακύμανσης.
variance_explained <- (eigenvalues / sum(eigenvalues)) * 100
print(variance_explained)

#Show the structure of a data set
str(eigenvalues)
str(variance_explained)

# Δημιουργούμε ένα DataFrame με τις ιδιοτιμές.
eigenvalues_df <- data.frame("Eigenvalues" = round(eigenvalues[1:2],3))

# Δημιουργούμε ένα DataFrame με το ποσοστό εξήγησης της διακύμανσης.
variance_explained_df <- data.frame("Variance_Explained" = round(variance_explained[1:2],3))

# Συνδυάζει τα DataFrames.
pca_results_df <- data.frame(eigenvalues_df,variance_explained_df)

# Θέτει labels στις γραμμές του DataFrame.
rownames(pca_results_df) <- c("pc1", "pc2")

# Αποθηκεύη το DataFrame ως αρχείο CSV.
write.csv((pca_results_df), file = "pca_results.csv")























