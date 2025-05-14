# Load necessary libraries
library(Matrix)

# Set the working directory
new_path <- "C:/Users/kwstasbenek/Desktop/giannakopoulo_8/Tsagkarakis_3h_ergasia/communities+and+crime"
setwd(new_path)

# Function to perform matrix multiplication
matmultiply <- function(mat1, mat2) {
  return(mat1 %*% mat2)
}

# Function to calculate the cost function J(θ)
calculateCost <- function(indV, depV, thetas) {
  return(sum(((matmultiply(indV, thetas) - depV)^2) / (2 * nrow(indV))))
}
# Stochastic Gradient Descent function
stochasticGradientDescent <- function(indV, depV, learning_rate, num_iterations) {
  thetas <- matrix(0, nrow = ncol(indV), ncol = 1)
  cost_history <- numeric(0)
  
  for (iteration in 1:num_iterations) {
    for (i in 1:nrow(indV)) {
      # Select a random data point
      random_index <- sample(1:nrow(indV), 1)
      x_i <- as.matrix(indV[random_index, , drop = FALSE])
      y_i <- as.matrix(depV[random_index, , drop = FALSE])
      
      # Calculate error and gradient for the selected data point
      error <- x_i %*% thetas - y_i
      gradient <- t(x_i) %*% error / nrow(x_i)
      
      # Update thetas
      thetas <- thetas - learning_rate * gradient
    }
    
    # Calculate and append the cost after each epoch
    cost <- sum(((indV %*% thetas - depV)^2) / (2 * nrow(indV)))
    cost_history <- c(cost_history, cost)
    
    # Print the cost every 100 iterations
    if (iteration %% 100 == 0) {
      cat("Iteration", iteration, ", Cost:", cost, "\n")
    }
  }
  
  return(list(thetas = thetas, cost_history = cost_history))
}

# Read data from file
df <- read.csv("communities.data", header = FALSE)

# Assuming that the column names are the same as in the Python code
colnames(df) <- c(
  'state', 'county', 'community', 'communityname', 'fold', 'population', 'householdsize',
  'racepctblack', 'racePctWhite', 'racePctAsian', 'racePctHisp', 'agePct12t21', 'agePct12t29',
  'agePct16t24', 'agePct65up', 'numbUrban', 'pctUrban', 'medIncome', 'pctWWage', 'pctWFarmSelf',
  'pctWInvInc', 'pctWSocSec', 'pctWPubAsst', 'pctWRetire', 'medFamInc', 'perCapInc', 'whitePerCap',
  'blackPerCap', 'indianPerCap', 'AsianPerCap', 'OtherPerCap', 'HispPerCap', 'NumUnderPov',
  'PctPopUnderPov', 'PctLess9thGrade', 'PctNotHSGrad', 'PctBSorMore', 'PctUnemployed', 'PctEmploy',
  'PctEmplManu', 'PctEmplProfServ', 'PctOccupManu', 'PctOccupMgmtProf', 'MalePctDivorce',
  'MalePctNevMarr', 'FemalePctDiv', 'TotalPctDiv', 'PersPerFam', 'PctFam2Par', 'PctKids2Par',
  'PctYoungKids2Par', 'PctTeen2Par', 'PctWorkMomYoungKids', 'PctWorkMom', 'NumIlleg', 'PctIlleg',
  'NumImmig', 'PctImmigRecent', 'PctImmigRec5', 'PctImmigRec8', 'PctImmigRec10', 'PctRecentImmig',
  'PctRecImmig5', 'PctRecImmig8', 'PctRecImmig10', 'PctSpeakEnglOnly', 'PctNotSpeakEnglWell',
  'PctLargHouseFam', 'PctLargHouseOccup', 'PersPerOccupHous', 'PersPerOwnOccHous',
  'PersPerRentOccHous', 'PctPersOwnOccup', 'PctPersDenseHous', 'PctHousLess3BR', 'MedNumBR',
  'HousVacant', 'PctHousOccup', 'PctHousOwnOcc', 'PctVacantBoarded', 'PctVacMore6Mos',
  'MedYrHousBuilt', 'PctHousNoPhone', 'PctWOFullPlumb', 'OwnOccLowQuart', 'OwnOccMedVal',
  'OwnOccHiQuart', 'RentLowQ', 'RentMedian', 'RentHighQ', 'MedRent', 'MedRentPctHousInc',
  'MedOwnCostPctInc', 'MedOwnCostPctIncNoMtg', 'NumInShelters', 'NumStreet', 'PctForeignBorn',
  'PctBornSameState', 'PctSameHouse85', 'PctSameCity85', 'PctSameState85', 'LemasSwornFT',
  'LemasSwFTPerPop', 'LemasSwFTFieldOps', 'LemasSwFTFieldPerPop', 'LemasTotalReq',
  'LemasTotReqPerPop', 'PolicReqPerOffic', 'PolicPerPop', 'RacialMatchCommPol', 'PctPolicWhite',
  'PctPolicBlack', 'PctPolicHisp', 'PctPolicAsian', 'PctPolicMinor', 'OfficAssgnDrugUnits',
  'NumKindsDrugsSeiz', 'PolicAveOTWorked', 'LandArea', 'PopDens', 'PctUsePubTrans', 'PolicCars',
  'PolicOperBudg', 'LemasPctPolicOnPatr', 'LemasGangUnitDeploy', 'LemasPctOfficDrugUn', 'PolicBudgPerPop', 'ViolentCrimesPerPop'
)

# Replace "?" with NA
df[df == "?"] <- NA

# Drop missing values
df <- na.omit(df)

# Extract independent variables
X <- df[c('medIncome', 'whitePerCap', 'blackPerCap', 'HispPerCap', 'PctUnemployed', 'NumUnderPov',
          'HousVacant', 'MedRent', 'NumStreet')]

# Extract dependent variable
y <- df$ViolentCrimesPerPop

# Add a constant term (column of ones) to the independent variables
X <- cbind(1, X)

# Convert y to a matrix with one column
y <- matrix(y, ncol = 1)

# Initialize thetas with random values
initialThetas <- runif(ncol(X))
X <- as.matrix(X)
y <- as.matrix(y)
# Run stochastic gradient descent
result <- stochasticGradientDescent(X, y, 0.01, 1000)

# Display estimated coefficients
cat("Estimated Coefficients:", result$thetas, "\n")

# Display the names of variables along with their estimated coefficients
for (var in names(X)[-1]) {
  coef <- result$thetas[match(var, names(X))]
  cat(var, ":", coef, "\n")
}

# Create a data frame for cost history
cost_df <- data.frame(iter = seq_along(result$cost_history), cost = result$cost_history)

# Display cost history
print(cost_df)

# Plot cost history
plot(cost_df$iter, cost_df$cost, col = 'red', xlab = 'Iteration', ylab = 'Cost', main = 'Cost History')
  
  