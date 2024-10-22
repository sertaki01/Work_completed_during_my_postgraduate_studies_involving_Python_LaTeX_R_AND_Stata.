
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
    

# Batch gradient descent
# indV: matrix of independent variables, first column must be all 1s
# depV: matrix (dimensions nx1) of dependent variable i.e.
# alpha: value of learning hyperparameter. Default (i.e. if no argument provided)  0.01
# numIters: number of iterations. Default (i.e. if no argument provided) 100
# verbose: if True, print intermediate results during optimization
# This function performs batch gradient descent to minimize the cost function and obtain optimal parameters (thetas).
def batchGradientDescent(indV, depV, thetas, alpha=0.01, numIters=100, verbose=False):
    calcThetas = thetas
    costHistory = pd.DataFrame(columns=["iter", "cost"])

    for i in range(0, numIters):
       
        # Calculate the predicted values
        predictions = matmultiply(indV, calcThetas)
        
        # Calculate the errors
        errors = predictions - depV
        
        # Update thetas using the gradient descent update rule
        gradient = matmultiply(indV.T, errors) / indV.shape[0]
        calcThetas = calcThetas - alpha * gradient
        
        if verbose:
            print(f">>>> Iteration {i}")
            print("       Calculate thetas:", calcThetas)
        
        # Calculate cost and store it in costHistory
        cost = calculateCost(indV, depV, calcThetas)
        costHistory = pd.concat([costHistory, pd.DataFrame([{"iter": i, "cost": cost}])])

    return calcThetas, costHistory



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

# Add new column at the beginning representing the constant term b0
X.insert(0, 'b0', 1)

# Add to a new variable to make the role of clarity/readbility of the code
independentVars = X


# Initialize thetas with some random values.
# We'll need (independentVars.shape[1])  theta values, one for each independent variable.
# NOTE: First theta value is coefficient for variable in FIRST column in independent matrix independentVars, second theta variable is coefficient
#       for second column in independent matrix independentVars etc
iniThetas = []
for i in range(0, independentVars.shape[1]):
    iniThetas.append( np.random.rand() )

initialThetas = np.array(iniThetas)

# Everything is ok.
# Run BATCH gradient descent and return 2 values: I) the vector of the estimated coefficients (estimatedCoefficients) and II) the values of the
# cost function (costHistory)

estimatedCoefficients, costHistory = batchGradientDescent(independentVars.to_numpy(), y.to_numpy(), initialThetas, 0.01, 1000, verbose=True)

# Display the estimated coefficients
print("Estimated Coefficients:", estimatedCoefficients)
# Display the names of variables along with their estimated coefficients
for var, coef in zip(independentVars.columns[1:], estimatedCoefficients[1:]):
    print(f"{var}: {coef}")
# Display now the cost function to see if alpha and the number of iterations were appropriate.
costHistory.plot.scatter(x="iter", y="cost", color='red')
plt.show()
