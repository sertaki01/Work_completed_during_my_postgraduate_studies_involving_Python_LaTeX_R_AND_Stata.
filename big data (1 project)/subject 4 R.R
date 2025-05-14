# Θέμα 4 (I)

# Ορίζεται ο φάκελος που αποθηκεύει και αναζητά τα αρχεία.
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\big data (1 project)")

# Διαγράφει όλες τις μεταβλητές που βρίσκονται στο περιβάλλον εργασίας.
rm(list = ls())

# Διαγράφει όλα τα διαγράμματα που έχουν δημιουργηθεί.
graphics.off()

# Εδώ θα ορίσουμε τα διανύσματα που θα χρησιμοποιήσουμε.
vector1 <- c(1, 2, 3, 4, 5, 6)
vector2 <- c(1, 2, 3, 4, 5, 6)
vector3 <- c(-0.5, 1, 7.3, 7, 9.4, -8.2, 9, -6, -6.3)
vector4 <- c(0.5, -1, -7.3, -7, -9.4, 8.2, -9, 6, 6.3)
vector5 <- c(-0.5, 1, 7.3, 7, 9.4, -8.2)
vector6 <- c(1.25, 9.02, -7.3, -7, 5, 1.3)
vector7 <- c(0, 0, 0.2)
vector8 <- c(0.2, 0.2, 0) 

# Ορισμός της συνάρτησης euclideanDistance.
euclideanDistance <- function(vec1, vec2) 
 distance <- sqrt(sum((vec1-vec2)^2))

# Καλεί τη συνάρτηση euclideanDistance και υπολογίζει την ευκλείδια απόσταση.
distance_1 <- euclideanDistance(vector1, vector2)
distance_2 <- euclideanDistance(vector3, vector4)
distance_3 <- euclideanDistance(vector5, vector6)
distance_4 <- euclideanDistance(vector7, vector8)

# Εκτυπώνη την Ευκλείδεια απόσταση.
cat("Ευκλείδεια απόσταση:", distance_1, "\n")
cat("Ευκλείδεια απόσταση:", distance_2, "\n")
cat("Ευκλείδεια απόσταση:", distance_3, "\n")
cat("Ευκλείδεια απόσταση:", distance_4, "\n")


# Θέμα 4 (II)

# Διαγράφει όλες τις μεταβλητές που βρίσκονται στο περιβάλλον εργασίας.
rm(list = ls())

# Διαγράφει όλα τα διαγράμματα που έχουν δημιουργηθεί.
graphics.off()

# Εδώ θα ορίσουμε τα διανύσματα που θα χρησιμοποιήσουμε.
v1<- c(25000, 14, 7 )
v2<- c(42000, 17, 9 )
v3<- c(55000, 22, 5 )
v4<- c(27000, 13, 11 )
v5<- c(58000, 21, 13 )

# Ορισμός της συνάρτησης euclideanDistance.
euclideanDistance <- function(vec1, vec2) 
  distance <- sqrt(sum((vec1-vec2)^2))

# Καλεί τη συνάρτηση euclideanDistance και υπολογίζει την ευκλείδια απόσταση.
d1 <- euclideanDistance(v5, v1)
d2 <- euclideanDistance(v5, v2)
d3 <- euclideanDistance(v5, v3)
d4 <- euclideanDistance(v5, v4)

#Μετατροπή σε δείκτη ομοιότητας.
s1<-1/(1+d1)
s2<-1/(1+d2)
s3<-1/(1+d3)
s4<-1/(1+d4)

# Ορισμός συνάρτησης για εύρεση της μεγαλύτερης ομοιότητας.
findMaxDistanceWithProfile<- function(d1, d2, d3, d4) {
  distances <- c(d1, d2, d3, d4)
  max_dist <- max(distances)
  profile_code <- which.max(distances)
  cat("O μεγαλύτερΟς δείκτης ομοιότητας είναι:", max_dist, "\n")
  cat("Κωδικός προφίλ που μοιάζει περισσότερο με τον χρήστη με κωδικό 5 είναι ο χρήστης με κωδικό:",profile_code, "\n")
  return(max_dist)
}

# Καλούμε τη συνάρτηση με τους τέσσερις δείκτες ομοιότητας και θα μας βγάλει τον μεγαλύτερο.
max_dist <- findMaxDistanceWithProfile(s1, s2, s3, s4)






