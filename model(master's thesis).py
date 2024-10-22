import os
import pandas as pd 
import warnings
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import numpy as np
from operator import itemgetter
from sklearn.model_selection import train_test_split
from datetime import datetime 
from sklearn.metrics import mean_absolute_error
from sklearn.metrics import root_mean_squared_error
from xgboost import XGBRegressor
from sklearn.pipeline import Pipeline
from skopt import BayesSearchCV
from skopt.space import Real, Integer
from sklearn.utils import shuffle
from scipy import stats
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.model_selection import GridSearchCV

path = "C:\\Users\\User\\Desktop\\Bitcoin electricity consumption index"

os.chdir(path) # Set working directory.

os.getcwd() # Check working directory.

df = pd.read_excel("model.xlsx") # Import dataset. 

print(df.info()) # View of the dataset.

print(df.head()) # First five rows.

print(df.shape) # Dimension of Data Frame.

print(df.duplicated().sum()) # To check if any row is repeated in the dataset.

warnings.filterwarnings('ignore') # Ignore warnings.

print(df.isnull().sum()) # Check for missing values

def Desc(k): # Descriptive statistics of the variables under examination.
    for i in range(0,len(k.columns)):
        print(k.iloc[:,[i]].describe().round(2))
        print("Median of",k.iloc[:,[i]].median().round(2))
        if i != 0:
            print("Skewness of",k.iloc[:,[i]].skew())
            print("Kurtosis of",k.iloc[:,[i]].kurt())

Desc(df)

########## CHARTS.

def graph(a,b,c,d):
    fig, ax = plt.subplots(2, 1, constrained_layout = True) # Arranging multiple Axes in a Figure.
    ax[0].plot(df["DateTime"],a, color="g") # 1.
    ax[0].set_xlabel("DateTime")
    ax[0].set_ylabel(b)
    plt.setp(ax[0].get_xticklabels(), rotation=30, horizontalalignment='right') # Set more properties, fix showing overlapping x-tick labels. 
    ax[1].plot(df["DateTime"],c, color="g") # 2.
    ax[1].set_xlabel("DateTime")
    ax[1].set_ylabel(d)
    plt.setp(ax[1].get_xticklabels(), rotation=30, horizontalalignment='right') 
    fig.tight_layout() # Adjust the padding between and around subplots.
    plt.show()

{graph(df["energy_consumption"], "energy_consumption", df["Average_Blocksize"], "Average_Blocksize")}
{graph(df["Bitcoin_Blockchain"], "Bitcoin_Blockchain",df["Cost_Per_Transaction"], "Cost_Per_Transaction")}
{graph(df["Bitcoin_Hashrate"], "Bitcoin_Hashrate", df["Miner_Revenue"], "Miner_Revenue")}
{graph(df["Unique_Address"], "Unique_Address", df["Transaction_Fee"],  "Transaction_Fee")}
{graph(df["Transaction_Per_Block"], "Transaction_Per_Block",df["Unique_Transaction"], "Unique_Transaction")}
{graph(df["Bitcoin_Market_Price"], "Bitcoin_Market_Price", df["Market_Capitilization"], "Market_Capitilization")}

plt.scatter(df["Average_Blocksize"],df["energy_consumption"], c= "red") # Scatter plot.
plt.xlabel("Average_Blocksize")
plt.ylabel("energy_consumption")
plt.show

def scatter(a,b,c,d): # Scatter plot for testing linear relationship between variables.
    fig, ax = plt.subplots(2, 1, constrained_layout = True) # Arranging multiple Axes in a Figure.
    ax[0].scatter(a,df["energy_consumption"], color="r") # 1.
    ax[0].set_xlabel(b)
    ax[0].set_ylabel("energy_consumption")
    plt.setp(ax[0].get_xticklabels(), rotation=30, horizontalalignment='right') # Set more properties, fix showing overlapping x-tick labels. 
    ax[1].scatter(c,df["energy_consumption"], color="r") # 2.
    ax[1].set_xlabel(d)
    ax[1].set_ylabel("energy_consumption")
    plt.setp(ax[1].get_xticklabels(), rotation=30, horizontalalignment='right') 
    fig.tight_layout() # Adjust the padding between and around subplots.
    plt.show()

{scatter(df["Bitcoin_Blockchain"], "Bitcoin_Blockchain",df["Cost_Per_Transaction"], "Cost_Per_Transaction")}
{scatter(df["Bitcoin_Hashrate"], "Bitcoin_Hashrate", df["Miner_Revenue"], "Miner_Revenue")}
{scatter(df["Unique_Address"], "Unique_Address", df["Transaction_Fee"],  "Transaction_Fee")}
{scatter(df["Transaction_Per_Block"], "Transaction_Per_Block",df["Unique_Transaction"], "Unique_Transaction")}
{scatter(df["Bitcoin_Market_Price"], "Bitcoin_Market_Price", df["Market_Capitilization"], "Market_Capitilization")}

def box(a,b,c,d,e,f,g,h):
    fig, ax = plt.subplots(2,2, constrained_layout = True)
    box_plot = ax[0,0].boxplot(a, sym='+', patch_artist=True) # Change outliers point symbols, Box plots with color.
    ax[0,0].set_title(b)
    for median in box_plot['medians']: # Change the color of median line.
        median.set_color('black')
    box_plot = ax[0,1].boxplot(c, sym='+', patch_artist=True)
    ax[0,1].set_title(d)
    for median in box_plot['medians']: 
        median.set_color('black')
    box_plot = ax[1,0].boxplot(e, sym='+', patch_artist=True) 
    ax[1,0].set_title(f)
    for median in box_plot['medians']: 
        median.set_color('black')
    box_plot = ax[1,1].boxplot(g, sym='+', patch_artist=True) 
    ax[1,1].set_title(h)
    for median in box_plot['medians']: 
        median.set_color('black')
    fig.tight_layout()
    plt.show()

{box(df["energy_consumption"], "energy_consumption", df["Average_Blocksize"], "Average_Blocksize", df["Bitcoin_Blockchain"], "Bitcoin_Blockchain",
       df["Cost_Per_Transaction"], "Cost_Per_Transaction")}
{box(df["Bitcoin_Hashrate"], "Bitcoin_Hashrate", df["Miner_Revenue"], "Miner_Revenue", df["Unique_Address"], "Unique_Address",
       df["Transaction_Fee"],  "Transaction_Fee")}
{box(df["Transaction_Per_Block"], "Transaction_Per_Block",df["Unique_Transaction"], "Unique_Transaction",
        df["Bitcoin_Market_Price"], "Bitcoin_Market_Price", df["Market_Capitilization"], "Market_Capitilization")}

########## COEFFICIENT OF VARIATION(CV).

def cv(x): # Coefficient of variation calculation.
    array = list(df.columns)
    for i in range(1,len(x.columns)):
        print(itemgetter(i)(array)) # Select an item from the list.
        print((np.std(x.iloc[:,i]) / np.mean(x.iloc[:,i])).round(2))

cv(df)

########## PEARSON CORRELATION COEFFICIENT.

def per(y): # Calculate pearson correlation coefficient for each independent variable in relation to the dependent. 
    array = list(df.columns)
    for i in range(2,len(y.columns)):
        print(itemgetter(i)(array))
        print(stats.pearsonr(y.iloc[:,i], df["energy_consumption"]))

per(df)

########## OUTLIERS.

def outliers(df,ft): # A function which returns a list of index of outliers.
    Q1 = df[ft].quantile(0.25)
    Q3 = df[ft].quantile(0.75)
    IQR = Q3 - Q1
    lower_bound = Q1 - 3 * IQR
    upper_bound = Q3 + 3 * IQR
    ls = df.index[ (df[ft] < lower_bound) | (df[ft] > upper_bound) ] # This command is used for finding the position of an element in a list.
    return ls

Index_list = [] # An empty list is used to store the output indices from multiple columns.
for feature in ["energy_consumption", "Average_Blocksize", "Bitcoin_Blockchain", "Cost_Per_Transaction", "Bitcoin_Hashrate", "Miner_Revenue", "Unique_Address", "Transaction_Fee",
                "Transaction_Per_Block", "Unique_Transaction", "Bitcoin_Market_Price", "Market_Capitilization"]:
    Index_list.extend(outliers(df, feature)) # (extend) This specific command is used to add elements of an iterable object (list) to the end of another list. 

def remove(df,ls): # define a function which returns a cleaned dataframe without outliers.
    ls = sorted(set(ls)) # (set) The command set was used to convert an iterable object into a set with distinct elements. 
    df = df.drop(ls) # (drop) removes the specefied row.
    return df

df = remove(df,Index_list)

########## CHECK THE DATA.

print(df.shape)

{box(df["energy_consumption"], "energy_consumption", df["Average_Blocksize"], "Average_Blocksize", df["Bitcoin_Blockchain"], "Bitcoin_Blockchain",
       df["Cost_Per_Transaction"], "Cost_Per_Transaction")}
{box(df["Bitcoin_Hashrate"], "Bitcoin_Hashrate", df["Miner_Revenue"], "Miner_Revenue", df["Unique_Address"], "Unique_Address",
       df["Transaction_Fee"],  "Transaction_Fee")}
{box(df["Transaction_Per_Block"], "Transaction_Per_Block",df["Unique_Transaction"], "Unique_Transaction",
        df["Bitcoin_Market_Price"], "Bitcoin_Market_Price", df["Market_Capitilization"], "Market_Capitilization")}

########## NORMALIZE DATASET.

def norm(df):# Normalize our data by dividing each column by its maximum so that the values are between 0 and 1.
    i = 1
    while i < len(df.columns): # MinMaxScaler
            df.iloc[:,i] = ( df.iloc[:,i] - min(df.iloc[:,i]) ) / ( max(df.iloc[:,i]) - min(df.iloc[:,i]) )
            print(df.iloc[:,i])
            i = i + 1
    return df

norm(df)

########## CHECK THE DATA.

def min_max(df): # Use this function to get the minimum and maximum values from each variable.
    array = list(df.columns)
    for i in range(1,len(df.columns)):
        print(itemgetter(i)(array)) 
        print(min(df.iloc[:,i]))
        print(max(df.iloc[:,i]))

min_max(df)

########## SEPARATE THE DATASET INTO TRAINING AND TEST DATASETS.

X = df.drop( [ "DateTime", "energy_consumption" ], axis= "columns") # Independent variables.

print(X.shape) # Check.

y = df["energy_consumption"] # Dependent variable.

X = shuffle(X, random_state = 0) # Shuffle dataframe.

y = shuffle(y, random_state = 0) # Shuffle array.

# X_full, X_eval, y_full, y_eval = train_test_split(X, y, test_size = 0.2, random_state = 0) Evaluation set.

# print(X_full.shape, X_eval.shape, y_full.shape, y_eval.shape) Check.

# X_train, X_test, y_train, y_test = train_test_split(X_full, y_full, test_size = 0.2, random_state = 0) # Split the dataset into training and test sets.

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.3, random_state = 0) # Split the dataset into training and test sets.

print(X_train.shape, y_train.shape, X_test.shape, y_test.shape) # Check.

########## SCORING FUNCTION.

def NSE(true,pred): # Evaluation metric: Nash-Sutcliffe Efficiency (NSE).
    denominator = np.sum((true - np.mean(true))**2)
    numerator = np.sum((pred - true)**2)
    nse_metric = 1 - numerator/denominator
    return nse_metric

def IA(true,pred): # Evaluation metric: Index Of Agreement(IA).
    a = np.sum((np.square(true - pred)))
    b = np.sum(np.square(np.absolute(pred - np.mean(true)) + np.absolute(true - np.mean(true))))
    IA_metric = 1 - (a/b)
    return IA_metric

########## EXTREME GRADIENT BOOSTING REGRESSION.

estimators = [("xgbr", XGBRegressor(random_state = 0, device = "cuda"))] # [] A sequence of items.

pipe = Pipeline(steps = estimators) # We use a pipeline to automate the process of hyperparameter tuning.

xgbr_search = {  # A set to store a collection of unique elements.
               'xgbr__learning_rate': Real(0, 1.0), # Determines the step size in the parameter adjustments, which will lead to the minimization of the cost function.
               #'xgbr__learning_rate': Real(0.15, 1.0), Rate of learning with evaluation set.
               'xgbr__max_depth': Integer(1,5), # Controls the complexity of the model.
               'xgbr__n_estimators': Integer(100, 400), # Number of gradient boosted trees where each one tries to correct the errors of the previous one.
}

start_time = datetime.now() # Timing starts.

opt = BayesSearchCV(pipe, xgbr_search, n_iter = 75, cv = 10, verbose = 3, random_state = 0) # We use it to optimize the hyperparameters of the machine learning model.

# opt.fit(X_eval, y_eval) Use the eval set to fit the hyperparameters.

opt.fit(X_train, y_train) # Use the eval set to fit the hyperparameters.

print(opt.best_params_) # The combination of hyperparameters that gave the best score on out-of-sample data. 

end_time = datetime.now() # The timer stops. 

print('Duration: {}'.format(end_time - start_time)) # Runtime of the machine learning model.

########## PREDICTION OF THE VARIABLE Y FOR TRAIN AND TEST SET. 

y_pred_train = opt.predict(X_train) # Predict the y values for the data that was used to estimate the parameters. 

print(y_pred_train) # Check.
print(y_train) # Check.

y_pred_test = opt.predict(X_test) # Forecasting - predict the variable y in a new, unseen dataset.

print(y_pred_test) # Check.
print(y_test) # Check.

########## EVALUATION OF THE MODEL.

train_score, tr_score = NSE(y_train, y_pred_train), root_mean_squared_error(y_train, y_pred_train)  # NSE, MAPE evaluation metrics for training set.
MAE_train_score, IA_metric_train = mean_absolute_error(y_train, y_pred_train), IA(y_train, y_pred_train) # MAE, IA evaluation metrics for training set.

test_score, te_score = NSE(y_test, y_pred_test), root_mean_squared_error(y_test, y_pred_test) # NSE, MAPE evaluation metrics for test set.
MAE_test_score, IA_metric_test = mean_absolute_error(y_test, y_pred_test), IA(y_test, y_pred_test) # MAE, IA evaluation metrics for test set. 

print("Train NSE score: %0.2f" % train_score, "Train root_mean_squared_error score  : %0.2f" % tr_score,
      "Train MAE score: %0.2f" % MAE_train_score, "Train IA score: %0.2f" % IA_metric_train ,sep = '\n' ) # Model performance on the training set(training error).

print("Test NSE score: %0.2f" % test_score, "Test root_mean_squared_error score : %0.2f" % te_score,
      "Test MAE score: %0.2f" % MAE_test_score, "Test IA score: %0.2f" % IA_metric_test ,sep = '\n' ) # Model performance on the test set(generalization error).

########## LINEAR REGRESSION MODEL.

lm = LinearRegression() # Multiple Linear Regression model.

lm.fit(X_train, y_train) # Parameter estimation.

train_lm_pred = lm.predict(X_train) # Target variable prediction(training set).

lm_pred = lm.predict(X_test) # Target variable prediction.

########## EVALUATION OF THE LINEAR MODEL.

train_linear_NSE, train_linear_RMSE, train_linear_MAE = NSE(y_train, train_lm_pred), root_mean_squared_error(y_train, train_lm_pred), mean_absolute_error(y_train, train_lm_pred) # NSE, RMSE, MAE evaluation metrics(training).
linear_NSE, linear_RMSE, linear_MAE = NSE(y_test, lm_pred), root_mean_squared_error(y_test, lm_pred), mean_absolute_error(y_test, lm_pred) # NSE, RMSE, MAE evaluation metrics(test).

print("Test NSE score(train_linear): %0.2f" % train_linear_NSE, "Test root_mean_squared_error score(train_linear) : %0.2f" % train_linear_RMSE, "Test MAE score(train_linear): %0.2f" % train_linear_MAE, sep = '\n') # Display model performance(training).
print("Test NSE score(linear): %0.2f" % linear_NSE, "Test root_mean_squared_error score(linear) : %0.2f" % linear_RMSE, "Test MAE score(linear): %0.2f" % linear_MAE, sep = '\n') # Display model performance(test).

########## GRADIENT BOOSTING REGRESSION.

gbr = GradientBoostingRegressor(random_state = 0) # Gradient boosting regressor.

param_grid = {'learning_rate': [0.001, 0.01, 0.1, 0.2, 0.3], # It is the space in which it will search all possible combinations in order to find the best combination of hyperparameters.
              'n_estimators': [100, 200, 300, 400, 500],
              'max_depth': [1,2,3,4,5]}

search_gbr = GridSearchCV(gbr, param_grid, scoring = 'neg_root_mean_squared_error', cv = 5, verbose = 3) # It will search for the best combination using a metric and cross validation method. Using the gradient boosting regressor
                                                                                                         # model and dictionary which contains the hyperparameters under optimization along with the space in which we will search
                                                                                                         # for the best combination. 

search_gbr.fit(X_train, y_train) # Training of the model, i.e. the estimation of its parameters.

print(search_gbr.best_params_) # The combination of hyperparameters that gave the best performance in terms of prediction error.

train_gbr_pred = search_gbr.predict(X_train) # Using the training set to predict target variable. 

gbr_pred = search_gbr.predict(X_test) # The stage at which the dependent variable is predicted. 

########## EVALUATION OF THE GRADIENT BOOSTING REGRESSION.

train_gbr_NSE, train_gbr_RMSE, train_gbr_MAE = NSE(y_train, train_gbr_pred), root_mean_squared_error(y_train, train_gbr_pred), mean_absolute_error(y_train, train_gbr_pred) # NSE, RMSE, MAE evaluation metrics.    
gbr_NSE, gbr_RMSE, gbr_MAE = NSE(y_test, gbr_pred), root_mean_squared_error(y_test, gbr_pred), mean_absolute_error(y_test, gbr_pred) # NSE, RMSE, MAE evaluation metrics.

print("Test NSE score(train_gbr): %0.2f" % train_gbr_NSE, "Test root_mean_squared_error score(train_gbr) : %0.2f" % train_gbr_RMSE, "Test MAE score(train_gbr): %0.2f" % train_gbr_MAE, sep = '\n') # Display model performance(training).
print("Test NSE score(gbr): %0.2f" % gbr_NSE, "Test root_mean_squared_error score(gbr) : %0.2f" % gbr_RMSE, "Test MAE score(gbr): %0.2f" % gbr_MAE, sep = '\n') # Display model performance(test).
