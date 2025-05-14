# Θέμα 6 

# Ορίζεται ο φάκελος που αποθηκεύει και αναζητά τα αρχεία.
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\big data (1 project)")

# Διαγράφει όλες τις μεταβλητές που βρίσκονται στο περιβάλλον εργασίας.
rm(list = ls())

# Διαγράφει όλα τα διαγράμματα που έχουν δημιουργηθεί.
graphics.off()

# Εδώ θα ορίσουμε τα διανύσματα που θα χρησιμοποιήσουμε.
v1<- c("Green", "Potato", "Ford")
v2<- c("Tyrian purple", "Pasta", "Opel")
v3<- c("Eagle", "Ronaldo", "Real madrid", "Prussian blue", "Michael Bay")
v4<- c("Eagle", "Ronaldo", "Real madrid", "Prussian blue", "Michael Bay")
v5<- c("Werner Herzog", "Aquirre, the wrath of God", "Audi", "Spanish red")
v6<- c("Martin Scorsese", "Taxi driver", "Toyota", "Spanish red")

# Συνάρτηση με όνομα nominalDistance, η οποία Υπολογίζει την απόσταση με βάση ενός δείκτη που κυμαίνεται απο το 0 εώς το 1. Όσο αυξάνεται ο δείκτης τόσο μεγαλύτερη απόσταση έχουν τα δυο διανύσματα μεταξύ τους.
nominalDistance<-function(vec1,vec2) {
  distance <- sum(vec1==vec2)
  index<- distance/length(vec1)
  return(index)
}

# Καλούμε τη συνάρτηση nominalDistance για τα διανύσματα και εκτυπώνουμε το αποτέλεσμα.
index1<-nominalDistance(v1,v2)
index2<-nominalDistance(v3,v4)
index3<-nominalDistance(v5,v6)

cat("distance 1:", index1 , "\n")
cat("distance 2:", index2 , "\n")
cat("distance 3:", index3 , "\n")

  
