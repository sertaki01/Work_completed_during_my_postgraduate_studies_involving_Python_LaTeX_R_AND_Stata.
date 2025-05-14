# Get working directory

import os

print(os.getcwd())

# Import excel data.

import pandas as pd

risk_premium = pd.read_excel("Risk Premium.xlsx")

term_structure = pd.read_excel("term structure.xlsx")

# Determine a variable's type.

print(type(risk_premium))

print(type(term_structure))

# Get first,last rows of the data frame.

print(risk_premium.head())

print(risk_premium.tail())

print(term_structure.head())

print(term_structure.tail())

# Convert first column from string to datetime.

from datetime import datetime

risk_premium['Date'] = pd.to_datetime(risk_premium['Date'], format='%d/%m/%Y')

term_structure['observation_date'] = pd.to_datetime(term_structure['observation_date'], format='%d/%m/%Y')

print(risk_premium.dtypes)

print(term_structure.dtypes)

print(risk_premium.head())

print(term_structure.head())

# Check for missing values.

print(risk_premium.isnull().sum())

print(term_structure.isnull().sum())

# Check for outliers.

print(risk_premium.describe()[['default risk premium','Price','E_P_U_I_E']])

print(term_structure.describe()[['ts','USbond','FFER','inflation']])

import matplotlib.pyplot as plt

import seaborn as sns 

sns.boxplot(risk_premium[['default risk premium','Price','E_P_U_I_E']])

plt.show()

sns.boxplot(term_structure.describe()[['ts','USbond','FFER','inflation']])

plt.show()

#IQR method,deal with outliers.

def outliers(df,ft):
    q1 = df[ft].quantile(0.25)
    q3 = df[ft].quantile(0.75)
    iqr = q3 - q1
    lower_bound = q1 - 3*iqr
    upper_bound = q3 + 3*iqr
    print(lower_bound)
    print(upper_bound)

    ls=df.index[ (df[ft] < lower_bound) | (df[ft] > upper_bound) ]

    return ls

index_list1 = []

index_list2 = []

for feature1  in ['default risk premium','Price','E_P_U_I_E'] :
    index_list1.extend(outliers(risk_premium,feature1))

print(index_list1)

for feature2 in ['ts','USbond','FFER','inflation']:
    index_list2.extend(outliers(term_structure,feature2))    

print(index_list2)

def remove(df,ls):
    ls = sorted(set(ls))
    df = df.drop(ls)
    return df

risk_premium = remove(risk_premium,index_list1)

term_structure = remove(term_structure,index_list2)

print(risk_premium.shape)

print(term_structure.shape)

sns.boxplot(risk_premium[['default risk premium','Price','E_P_U_I_E']])

plt.show()

sns.boxplot(term_structure.describe()[['ts','USbond','FFER','inflation']])

plt.ylim(-5,30)

plt.show()

# I looked at the distribution of the variables and performed the necessary checks.

import scipy.stats as stats

# For Risk Premium log.

import numpy as np

risk_premium['Price'] = np.log(risk_premium['Price'])

# For Risk Premium plot.

fig, ax=plt.subplots(2,2,figsize = (8,8)) # An empty plot.

ax[0,0].plot(risk_premium['default risk premium'])

ax[0,0].title.set_text("default risk premium")

ax[0,1].plot(risk_premium['Price'])

ax[0,1].title.set_text("Price")

ax[1,0].plot(risk_premium['E_P_U_I_E'])

ax[1,0].title.set_text("E_P_U_I_E")

fig.delaxes(ax[1, 1]) # Remove the empty subplot (bottom-right)

plt.show()

# For Term Structure plot.

fig, ax=plt.subplots(2,2,figsize = (8,8)) # An empty plot.

ax[0,0].plot(term_structure['ts'])

ax[0,0].title.set_text('ts')

ax[0,1].plot(term_structure['USbond'])

ax[0,1].title.set_text('USbond')

ax[1,0].plot(term_structure['FFER'])

ax[1,0].title.set_text('FFER')

ax[1,1].plot(term_structure['inflation'])

ax[1,1].title.set_text('inflation')

plt.show()

# For Risk Premium box plots

fig, ax = plt.subplots(2, 2, figsize=(8, 8))  # An empty plot.

ax[0, 0].boxplot(risk_premium['default risk premium'])

ax[0, 0].set_title("default risk premium")

ax[0, 1].boxplot(risk_premium['Price'])

ax[0, 1].set_title("Price")

ax[1, 0].boxplot(risk_premium['E_P_U_I_E'])

ax[1, 0].set_title("E_P_U_I_E")

# Remove the empty subplot (bottom-right)

fig.delaxes(ax[1, 1])

plt.show()

# For Term Structure box plots

fig, ax = plt.subplots(2, 2, figsize=(8, 8))  # An empty plot.

ax[0, 0].boxplot(term_structure['ts'])

ax[0, 0].set_title('ts')

ax[0, 1].boxplot(term_structure['USbond'])

ax[0, 1].set_title('USbond')

ax[1, 0].boxplot(term_structure['FFER'])

ax[1, 0].set_title('FFER')

ax[1, 1].boxplot(term_structure['inflation'])

ax[1, 1].set_title('inflation')

plt.show()

print(risk_premium.describe().round(2)[['default risk premium','Price','E_P_U_I_E','January Dummy']])

print(term_structure.describe().round(2)[['ts','USbond','FFER','inflation']])

# Dickey fuller test for risk premium.

import statsmodels.api

from statsmodels.tsa.stattools import adfuller

df1 = statsmodels.tsa.stattools.adfuller(risk_premium['default risk premium'], autolag='BIC')

df2 = statsmodels.tsa.stattools.adfuller(risk_premium['Price'], autolag='BIC')

df3 = statsmodels.tsa.stattools.adfuller(risk_premium['E_P_U_I_E'], autolag='BIC')

# Dickey fuller test for term structure.

df4 = statsmodels.tsa.stattools.adfuller(term_structure['ts'], autolag='BIC')

df5 = statsmodels.tsa.stattools.adfuller(term_structure['USbond'], autolag='BIC')

df6 = statsmodels.tsa.stattools.adfuller(term_structure['FFER'], autolag='BIC')

df7 = statsmodels.tsa.stattools.adfuller(term_structure['inflation'], autolag='BIC')

print(df1,df2,df3,df4,df5,df6,df7,sep='\n\n')

# mute Interpolation warning.

import warnings

from statsmodels.tools.sm_exceptions import InterpolationWarning

warnings.simplefilter('ignore', InterpolationWarning)

# Kwiatkowski–Phillips–Schmidt–Shin (KPSS) tests for risk premium.

from statsmodels.tsa.stattools import kpss 

kp1 = statsmodels.tsa.stattools.kpss(risk_premium['default risk premium'])

kp2 =  statsmodels.tsa.stattools.kpss(risk_premium['Price'])

kp3 =  statsmodels.tsa.stattools.kpss(risk_premium['E_P_U_I_E'])

# Kwiatkowski–Phillips–Schmidt–Shin (KPSS) tests for Term structure.

kp4 = statsmodels.tsa.stattools.kpss(term_structure['ts']) 

kp5 = statsmodels.tsa.stattools.kpss(term_structure['USbond'])

kp6 = statsmodels.tsa.stattools.kpss(term_structure['FFER'])

kp7 = statsmodels.tsa.stattools.kpss(term_structure['inflation'])

print(kp1,kp2,kp3,kp4,kp5,kp6,kp7,sep='\n\n')

# Detrending by Differencing.

risk_premium['default risk premium'] = risk_premium['default risk premium'] - risk_premium['default risk premium'].shift(1)

risk_premium['Price'] = risk_premium['Price'] - risk_premium['Price'].shift(1)

risk_premium['E_P_U_I_E'] = risk_premium['E_P_U_I_E'] - risk_premium['E_P_U_I_E'].shift(1)

risk_premium = risk_premium.dropna()

print(risk_premium.head())

print(risk_premium.describe()[['default risk premium','Price','E_P_U_I_E']])

# For term structure.

term_structure['ts'] = term_structure['ts'] - term_structure['ts'].shift(1)

term_structure['USbond'] = term_structure['USbond'] - term_structure['USbond'].shift(1)

term_structure['FFER'] = term_structure['FFER'] - term_structure['FFER'].shift(1)

term_structure['inflation'] = term_structure['inflation'] - term_structure['inflation'].shift(1)

term_structure = term_structure.dropna()

print(term_structure.head())

print(term_structure.describe()[['ts','USbond','FFER','inflation']])

# For Risk Premium plot.

fig, ax=plt.subplots(2,2,figsize = (8,8)) # An empty plot.

ax[0,0].plot(risk_premium['default risk premium'])

ax[0,0].title.set_text("default risk premium")

ax[0,1].plot(risk_premium['Price'])

ax[0,1].title.set_text("Price")

ax[1,0].plot(risk_premium['E_P_U_I_E'])

ax[1,0].title.set_text("E_P_U_I_E")

fig.delaxes(ax[1, 1]) # Remove the empty subplot (bottom-right)

plt.show()

# For Term Structure plot.

fig, ax=plt.subplots(2,2,figsize = (8,8)) # An empty plot.

ax[0,0].plot(term_structure['ts'])

ax[0,0].title.set_text('ts')

ax[0,1].plot(term_structure['USbond'])

ax[0,1].title.set_text('USbond')

ax[1,0].plot(term_structure['FFER'])

ax[1,0].title.set_text('FFER')

ax[1,1].plot(term_structure['inflation'])

ax[1,1].title.set_text('inflation')

plt.show()

# Vol 2

# Dickey fuller test for risk premium.

import statsmodels.api

from statsmodels.tsa.stattools import adfuller

df1 = statsmodels.tsa.stattools.adfuller(risk_premium['default risk premium'], autolag='BIC')

df2 = statsmodels.tsa.stattools.adfuller(risk_premium['Price'], autolag='BIC')

df3 = statsmodels.tsa.stattools.adfuller(risk_premium['E_P_U_I_E'], autolag='BIC')

# Dickey fuller test for term structure.

df4 = statsmodels.tsa.stattools.adfuller(term_structure['ts'], autolag='BIC')

df5 = statsmodels.tsa.stattools.adfuller(term_structure['USbond'], autolag='BIC')

df6 = statsmodels.tsa.stattools.adfuller(term_structure['FFER'], autolag='BIC')

df7 = statsmodels.tsa.stattools.adfuller(term_structure['inflation'], autolag='BIC')

print(df1,df2,df3,df4,df5,df6,df7,sep='\n\n')

# Kwiatkowski–Phillips–Schmidt–Shin (KPSS) tests for risk premium.

from statsmodels.tsa.stattools import kpss 

kp1 = statsmodels.tsa.stattools.kpss(risk_premium['default risk premium'])

kp2 =  statsmodels.tsa.stattools.kpss(risk_premium['Price'])

kp3 =  statsmodels.tsa.stattools.kpss(risk_premium['E_P_U_I_E'])

# Kwiatkowski–Phillips–Schmidt–Shin (KPSS) tests for Term structure.

kp4 = statsmodels.tsa.stattools.kpss(term_structure['ts']) 

kp5 = statsmodels.tsa.stattools.kpss(term_structure['USbond'])

kp6 = statsmodels.tsa.stattools.kpss(term_structure['FFER'])

kp7 = statsmodels.tsa.stattools.kpss(term_structure['inflation'])

print(kp1,kp2,kp3,kp4,kp5,kp6,kp7,sep='\n\n')

# Check for Multicollinearity.

from patsy import dmatrices

from statsmodels.stats.outliers_influence import variance_inflation_factor

risk_premium.rename(columns={
    'default risk premium': 'default_risk_premium',
    'January Dummy': 'January_Dummy'
}, inplace=True)

y, X = dmatrices('default_risk_premium ~ Price + E_P_U_I_E + January_Dummy', data=risk_premium, return_type="dataframe")

VIF_risk_premium = pd.DataFrame()

VIF_risk_premium['variable'] = X.columns

VIF_risk_premium['VIF'] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]

print(VIF_risk_premium)

# Check for term structure.

y, X = dmatrices(' ts ~ USbond + FFER + inflation ', data=term_structure, return_type="dataframe")

VIF_term_structure = pd.DataFrame()

VIF_term_structure['variable'] = X.columns

VIF_term_structure['VIF'] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]

print(VIF_term_structure)

# OLS regression.

from statsmodels.formula.api import ols

model_risk_premium = ols('default_risk_premium ~ Price + E_P_U_I_E + January_Dummy', data= risk_premium).fit()

print(model_risk_premium.summary())

model_term_structure = ols(' ts ~ USbond + FFER + inflation ', data=term_structure).fit()

print(model_term_structure.summary())

# Check for residuals autocorrelated.

from statsmodels.stats.stattools import durbin_watson

print(durbin_watson(model_risk_premium.resid))

print(durbin_watson(model_term_structure.resid))


