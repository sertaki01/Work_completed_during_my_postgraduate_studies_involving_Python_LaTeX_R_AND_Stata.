import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os

# Corrected path with 'giannakopoulos_8' and a raw string
new_path = r'C:\Users\kwstasbenek\Desktop\giannakopoulo_8\Tsagkarakis_3h_ergasia\communities+and+crime'

# Change to the corrected directory
os.chdir(new_path)


# Multiply two matrices i.e. mat1 * mat2

def matmultiply(mat1,mat2):
    
    return( np.matmul(mat1, mat2) )
    



# Calculate current value of cost function J(θ).
 # indV: matrix of independent variables, first column must be all 1s
# depV: matrix (dimensions nx1)of dependent variable i.e.
# This function calculates the mean squared error, a measure of the difference between predicted and actual values.
def calculateCost(indV, depV, thetas):
    return( np.sum( ((matmultiply(indV, thetas) - depV)**2) / (2*indV.shape[0]) ) )  
    

def stochasticGradientDescent(indV, depV, learning_rate, num_iterations):
#thetas is being initialized as a column vector of zeros, where the number of rows is equal to the number of features in the independent variable matrix (indV),
#and there is only one column. Each element of this vector corresponds to a coefficient (or weight) associated with a feature in the linear regression model.
    thetas = np.zeros((indV.shape[1], 1))
#blank cost history list
    cost_history = []
# loop, in which each iteration, a random data point is selected from the dataset.
#This is the key difference from batch gradient descent, where all data points are used in each iteration.(lower computational cost)    
    for iteration in range(num_iterations):
        for i in range(indV.shape[0]):
# np.random.randint generates a random integer from a uniform distribution.
#0 is the lower bound (inclusive), and indV.shape[0] is the upper bound (exclusive).
#This line randomly selects an index from the range [0, indV.shape[0]). It's essentially picking a random row index from the data.
            random_index = np.random.randint(0, indV.shape[0])
            x_i = indV[random_index, :].reshape(1, -1)
            y_i = depV[random_index, :].reshape(1, -1)
            
            #This represents the dot product or matrix multiplication between the feature vector x_i and the coefficient vector thetas,
            # it's essentially the predicted value for the given data point. The error is calculated as the predicted value-the actual value.
            #x_i.T transposes the feature vector, turning it from a row vector to a column vector, the transpose operation is necessary to ensure that the dimensions
            #of the matrices align correctly for the matrix multiplication required in the gradient calculation.
            #The gradient represents the direction and magnitude of the steepest increase in the cost function.
            #It's essentially a vector of partial derivatives with respect to each parameter (theta).

            error = matmultiply(x_i, thetas) - y_i
            gradient = matmultiply(x_i.T, error) / x_i.shape[0]
            
            # Update thetas
            thetas = thetas - learning_rate * gradient
            
        # Calculate and append the cost after each epoch
        cost = calculateCost(indV, depV, thetas)
        cost_history.append(cost)
        
        # Print the cost every 100 iterations
        if iteration % 100 == 0:
            print(f'Iteration {iteration}, Cost: {cost}')
    
    return thetas, cost_history


#list of atrribute names
attribute_names = [
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
    'PolicOperBudg', 'LemasPctPolicOnPatr', 'LemasGangUnitDeploy', 'LemasPctOfficDrugUn',
    'PolicBudgPerPop', 'ViolentCrimesPerPop'
]
#empty list to fill wth data
data_list = []

# Now open the file
with open('communities.data', 'r') as values_file:
    for line in values_file:
         # Split each line into values using a comma as the delimiter
        values = line.strip().split(',')
        # Assuming that len(values) is the same as the number of attributes
        if len(values) == len(attribute_names):
            # Create a dictionary with attribute names as keys and values as values
            data_dict = dict(zip(attribute_names, values))
            # Append the dictionary to the list
            data_list.append(data_dict)
        else:
            print(f"Skipping line: {line}")

# Create a DataFrame from the list of dictionaries
df = pd.DataFrame(data_list)


# Display the DataFrame
print(df)
#in the df missing values are denoted as "?", this command replaces all "?" with NA
df = df.replace('?', pd.NA)
#drop missing values
df = df.dropna()
#copy of the df
df_strings = df.copy()

# Convert columns to numeric where possible
for column in df_strings.columns:
    try:
        df_strings[column] = pd.to_numeric(df_strings[column])
    except ValueError:
        # Handle the case where conversion to numeric is not possible
        pass

# Display the DataFrame with non-numeric values kept as strings(there aren't any so it's just the original df but with the variables now recognized as numeric and not objects )
print(df_strings)


#df for indepent variables
X = df_strings[['medIncome', 'whitePerCap', 'blackPerCap', 'HispPerCap', 'PctUnemployed', 'NumUnderPov',
        'HousVacant', 'MedRent', 'NumStreet']]
#df dependent variable
y = df_strings['ViolentCrimesPerPop']
#add const in the form of an extra column at the begining having just ones in it
# Add new column at the beginning representing the constant term b0
X.insert(0, 'b0', 1)

#The dependent variable y is reshaped into a column vector. This ensures that y is a 2D array with a single column
y = y.values.reshape(-1, 1)
# Add to a new variable to make the role of clarity/readbility of the code
independentVars = X


# Initialize thetas with some random values.
# We'll need (independentVars.shape[1])  theta values, one for each independent variable. Basically we loop for each column(independent variable)
# First theta value is coefficient for variable in FIRST column in independent matrix independentVars, second theta variable is coefficient
# for second column in independent matrix independentVars etc
iniThetas = []
for i in range(0, independentVars.shape[1]):
    iniThetas.append( np.random.rand() )
#A NumPy array is a grid of values, all of the same type, and it is indexed by a tuple of nonnegative integers.
#The number of dimensions is the rank of the array; the shape of an array is a tuple of integers giving the size of the array along each dimension
initialThetas = np.array(iniThetas)

# Everything is ok.
# Run stochastic gradient descent and return 2 values: I) the vector of the estimated coefficients (estimatedCoefficients) and II) the values of the
# cost function (costHistory)

estimatedCoefficients, costHistory = stochasticGradientDescent(independentVars.to_numpy(), y, 0.01, 1000 )

# Display the estimated coefficients
print("Estimated Coefficients:", estimatedCoefficients)
#converting costHisorty from list to df so that we can plot it later 
cost_df = pd.DataFrame({"iter": range(len(costHistory)), "cost": costHistory})

# Display the names of variables along with their estimated coefficients
for var, coef in zip(independentVars.columns[1:], estimatedCoefficients[1:]):
    print(f"{var}: {coef}")

# Display now the cost function to see if alpha and the number of iterations were appropriate.
cost_df.plot.scatter(x="iter", y="cost", color='red')
plt.show()
