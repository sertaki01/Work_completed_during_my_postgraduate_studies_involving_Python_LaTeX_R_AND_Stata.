# Θέμα 5 

# Ορίζεται ο φάκελος που αποθηκεύει και αναζητά τα αρχεία.
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\big data (1 project)")

# Διαγράφει όλες τις μεταβλητές που βρίσκονται στο περιβάλλον εργασίας.
rm(list = ls())

# Διαγράφει όλα τα διαγράμματα που έχουν δημιουργηθεί.
graphics.off()

# Εδώ θα ορίσουμε τα διανύσματα που θα χρησιμοποιήσουμε.
v1<- c(9.32, -8.3, 0.2)
v2<- c(-5.3, 8.2, 7)
v3<- c(6.5, 1.3, 0.3, 16, 2.4, -5.2, 2, -6, -6.3)
v4<- c(0.5, -1, -7.3, -7, -9.4, 8.2, -9, 6, 6.3)
v5<- c(-0.5, 1, 7.3, 7, 9.4, -8.2)
v6<- c(1.25, 9.02, -7.3, -7, 15, 12.3)
v7<- c(2, 8, 5.2)
v8<- c(2, 8, 5.2)

#Mία συνάρτηση με όνομα cosineSimilarity η οποία δέχεται ως είσοδο δύο διανύσματα και υπολογίζει  την ομοιότητα συνημιτόνου.
cosineSimilarity <- function(vector1, vector2) {
  dot_product<- sum(vector1*vector2)
  norm_vector1<- sqrt(sum(vector1^2))
  norm_vector2<- sqrt(sum(vector2^2))
  similarity<- dot_product/(norm_vector1*norm_vector2)
  return(similarity) }

# Καλεί τη συνάρτηση cosineSimilarity  και υπολογίζει την ομοιότητα συνημιτόνου.
similarity1<- cosineSimilarity(v1,v2)
similarity2<- cosineSimilarity(v3,v4)
similarity3<- cosineSimilarity(v5,v6)
similarity4<- cosineSimilarity(v7,v8)

# Εκτυπώνη την ομοιότητα συνημιτόνου των διανυσμάτων. 
cat("Cosine Similarity:",similarity1)
cat("Cosine Similarity:",similarity2)
cat("Cosine Similarity:",similarity3)
cat("Cosine Similarity:",similarity4)