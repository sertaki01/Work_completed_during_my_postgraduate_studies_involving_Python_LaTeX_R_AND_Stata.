#import libraries 
import os
import pandas as pd
import statsmodels.api as sm 
# Corrected path with 'giannakopoulos_8' and a raw string
new_path = r'C:\Users\kwstasbenek\Desktop\giannakopoulo_8\Tsagkarakis_3h_ergasia\communities+and+crime'

# Change to the corrected directory
os.chdir(new_path)

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
#add constant to independent variables
X = sm.add_constant(X)
#OLS model 
model = sm.OLS(y, X).fit()

# Print the summary of the regression
print(model.summary())
