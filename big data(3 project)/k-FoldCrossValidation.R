# Διασταυρωμένη Επικύρωση k-Πτυχών


#
# Συνάρτηση που υπολογίζει και επιστρέφει το Μέσο Τετραγωνικό Σφάλμα (Root Mean Squared Error 
# - RMSE) 
# predictedValues: διάνυσμα με τιμές της εξαρτημένης μεταβλητής που προβλέπει το μοντέλο 
#                  παλινδρόμησης
# actualValues: διάνυσμα με τις πραγματικές τιμές της εξαρτημένης με-ταβλητής
# Επιστρέφει το Μέσο Τετραγωνικό Σφάλμα πρόβλεψης
calculateRMSE<-function(predictedValues, actualValues){
  err<- sqrt( mean((actualValues - predictedValues)^2)  )
  return( err )
}


# Συνάρτηση που υλοποιεί τον αλγόριθμο της διασταρωμένης επικύρωσης k-πτυχών.
# Η συνάρτηση κάνει χρήση του μέσου τετραγωνικού σφάλματος (RMSE) ως μετρική σφάλματος.
# Παράμετροι συνάρτησης:
# data: το σύνολο δεδομένων που θα χωριστεί σε τμήματα ελέγχουν κα εκπαίδευσης
# frml: το γραμμικό μοντέλο παλινδρόμησης που θα αξιολογηθεί η ακρί-βεια πρόβλεψής του
# k: η τιμή k της διασταυρωμένης επικύρωσης k-πτυχών που δηλώνει σε πόσα τμήματα θα διαχωριστεί
#    το αρχικό σύνολο δεδομένων
# Επιστρεφόμενη τιμή:
# Η συνάρτηση επιστρέφει τον μέσο όρο του μέσου τετραγωνικού σφάλματος
kFoldCrossValidation<-function(data, frml, k){
  # Τυχαία αναφιάταξη των παρατηρήσεων του συνόλου δεδομένων
  dataset<-data[sample(nrow(data)),]
  #Δημιουργία k σε πλήθος τμημάτων του συνόλου δεδομένων με περίπου ίσο πλήθος 
  # παρατηρήσεων σε κάθε τμήμα.
  folds <- cut(seq(1,nrow(dataset)), breaks=k, labels=FALSE)
  # Διάνυσμα όπου αποθηκεύεται το Μέσο Τε
  RMSE<-vector()
  # Επαναλαηπτική διαδικασία όπου κάθε ένα από τα k τμήματα θα χρησι-μοποιηθεί διαδοχικά
  # ως σύνολο ελέγχου για το μοντέλο παλινδρόμησης και όλα τα υπόλοιπα ως σύνολο εκπαίδευσης. 
  # Η διαδικασία θα τερματίσει εάν όλα τα τμήματα έχουν χρησιμοποιηθεί ως σύνολο σλέγχου.
  for(i in 1:k){
    # Καθορισμός του τμήματος ελέγχου για την τρέχουσα επανάληψη 
    testIndexes <- which(folds==i,arr.ind=TRUE)
    # Καθορισμός συνόλου ελέγχου μοντέλου
    testData <- dataset[testIndexes, ]
    # Καθορισμός συνόλου εκπαίδευσης μοντέλου, που θα είναι όλα τα υπόλοιπα
    # πλην των δεδομένων που χρησιμοποιηθούν για έλεγχο
    trainData <- dataset[-testIndexes, ]
    # Εκτίμηση συντελεστών του μοντέλου παλινδρόμησης χρησιμοποιώντας το σύνολο εκπαίδευσης
    candidate.linear.model<-lm( frml, data = trainData)
    # Υπολογισμός των τιμών της εξαρτημένης μεταβλητής που προβλέπει το μοντέλο 
    # για τις τιμές του τρέχοντος συνόλου ελέγχου 
    predicted<-predict(candidate.linear.model, testData)
    # Υπολογισμός σφάλματος RMSE
    error<-calculateRMSE(predicted, testData[, "mpg"])
    # Αποθήκευση τιμής σφάλματος
    RMSE<-c(RMSE, error)
  }
  # Επιστροφή μέσης τιμής των σφαλμάτων που προέκυψαν απ'όλα τα τμήμα-τα ελέγχου
  return( mean(RMSE) )
}


# Ανάγνωση δεδομένων
# Το αρχείο δεδομένων περιέχει τεχνικά χαρακτηριστικά αυτοκινήτων διαφόρων κατασκευαστών
carData<-read.csv("auto-mpg.csv", sep=";", header=T, stringsAsFactors = F, quote = "\"")


# Έλεγχος για δεδομένα που λείπουν (missing values) και αφαίρεση ολόκληρης γραμμής
# σε περίπτωση που μια τουλάχιστον μεταβλητή έχει missing value
carData<-na.omit(carData)

# Επειδή οι μεταβλητές horsepower και mpg είχαν missing values, πρέπει αυτές να 
# μετατραπούν στον σωστό τύπο δεδομένων (numeric), καθότι είχαν αναγνωστεί ως συμβολοσειρές 
# (character) εξαιτίας των missing value
carData[,"horsepower"] <- as.numeric(carData[,"horsepower"])
carData[,"mpg"] <- as.numeric(carData[,"mpg"])

# Τα τέσσερα υποψήφια μοντέλα των οποίων θα αξιολογηθεί η ικανότητα πρόβλεψης της κατανάλωσης καυσίμου
# (mpg - miles per gallon) με τη μέθοδο της διασταυρωτικής επικύρωσης 10-φορές. 
# Τα μοντέλα παλινδρόμησης αποθηκεύονται στο διάνυσμα ως συμβολοσειρές και θα μετατραπούν
# σε τύπους (formula) της R

predictionModels<-vector()
predictionModels[1]<-"mpg ~ horsepower+weight"
predictionModels[2]<-"mpg ~ horsepower+acceleration+displacement"
predictionModels[3]<-"mpg ~ horsepower+displacement+weight"

# Συμπεριλαμβάνεται και μοντέλο που εισάγει πολυωνυμικό όρο βαθμού 2 weight^2. Η εισαγωγή τέτοιων
# όρων στο μοντέλο απαιτεί τη χρήση της συνάρτησης I() που είναι η συνάρτηση Inhibit Interpretation και
# έχει σαν αποτέλεσμα να μην ερμηνευτεί ο τελεστής ^ στα πλαίσια του τύπου.
# Αυτό γιατί ο τελεστής ^ έχει ειδκή σημασία για τύπους και αν χρησι-μοποιείται σε τέτοιους δίχως τη
# χρήση της I() δεν θα ερμηνευτεί ως ο τελεστής ύψωση σε δύναμη.
predictionModels[4]<-"mpg ~ horsepower+displacement+weight + I(weight^2)"

# Μετά από κάθε διασταυρωμένη επικύρωση, ο μέσος όρος του μέσου τετρα-γωνικού 
# σφάλματος κάθε μοντέλου θα αποθηκευτεί σε διάνυσμα.
modelMeanRMSE<-vector()

# Διασταυρωμένη επικύρωση 10-φορές για κάθε ένα από τα 
# τέσσερα υποψήφια μοντέλα.
for (k in 1:length(predictionModels)){
  # Δισταυρωμένη επικύρωση 10-πτυχών για το γραμμικό μοντέλο παλιν-δρόμησης k
  modelErr<-kFoldCrossValidation(carData, as.formula(predictionModels[k]), 10)
  # Αποθήκευση του μέσου σφάλματος
  modelMeanRMSE<-c(modelMeanRMSE, modelErr)
  print( sprintf("Linear regression model [%s]: prediction error [%f]", predictionModels[k], modelErr ) )
}



# Ποιο μοντέλο είχε το χαμηλότερο μέσο τετραγωνικό σφλάμα;
bestModelIndex<-which( modelMeanRMSE == min(modelMeanRMSE) )
# Εμφάνιση μοντέλου με το μικρότερο μέσο τετραγωνικό σφάμα δηλαδή τη μεγαλύτερη ακρίβεια

print( sprintf("Model with best accuracy was: [%s] error: [%f]", predictionModels[bestModelIndex], modelMeanRMSE[bestModelIndex]) )

# Για το μοντέλο με το χαμηλότερο μέσο σφάλμα, εκτιμώνται οι συντελε-στές του 
# λαμβάνοντας υπόψη ολόκληρο το σύνολο δεδομένων ως σύνολο εκπαίδευσης
final.linear.model<-lm( as.formula(predictionModels[bestModelIndex]), data=carData )
