// Question 1.

// Clear out all the previous tasks.
clear all

// Set working directory.
cd "C:\Users\admin\OneDrive\Υπολογιστής\Third Assignment in Special Topics of Business Economics 2023-2024"

// From your file take your dataset.
use Fdata.dta, clear

// Create panel data.
xtset Cod_Comp_Nam year

// Variables description.
describe Tobins_Q_ PM Size Leverage Growth_sales

// boxplot graph.
graph box Tobins_Q_ 
graph box PM 
graph box Size  
graph box Leverage  
graph box Growth_sales

// replace the outliers with mean.
replace Tobins_Q_= 1.015689 if Tobins_Q_>3.66 
replace PM=3.699377 if PM>36.456
replace Size=19.46578 if Size>31.14633 
replace Leverage=.1697574 if Leverage>0.8289304
replace Growth_sales=.3592062 if Growth_sales>0.641289 

// Descriptive Statistics.
xtsum Tobins_Q_ PM Size Leverage Growth_sales

// Tabulate.
tab NACE_Rev_2_main_section

// Transfare the statistics table to the overleaf. 
ssc install estout 

estpost tabstat Tobins_Q_ PM Size Leverage Growth_sales, c(stat) stat(N mean sd min max) 

esttab using stat.tex, replace cells("N(fmt(0)) mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))") title("Summary Statistics") collabels("Obs" "Mean" "Std. Dev." "Min" "Max")  addnote(write something after) noobs   

// Histogram of our variables.
histogram Tobins_Q_, norm
histogram PM, norm 
histogram Size, norm  
histogram Leverage, norm
histogram Growth_sales, norm

// Normality Check.
sktest Tobins_Q_ PM Size Leverage Growth_sales   

// Regression.
reg Tobins_Q_ PM Size Leverage Growth_sales, robust 
 
// Save the regression in a latex type of file.
outreg2 using reg.tex, replace dec(3) ctitle("OLS Regression")  




//Question 2.

// Sum statistics for panel data.
xtsum Ownership_Concetration CPI ROA_before_

// Box plot graph for outliers.
graph box Ownership_Concetration
graph box CPI
graph box ROA_before_ 

// Percentiles check.
summarize ROA_before_, detail

// replace the outliers with mean.
replace ROA_before_= 1.436519  if ROA_before_> 28.701
replace ROA_before_= 1.436519  if ROA_before_< -21.608
 
// Lag Ownership_Concetration.
gen Ownership_Concetration_L1= Ownership_Concetration[_n-1]
    
// Normality Check.
sktest Ownership_Concetration CPI ROA_before_  

//Regression OLS.
reg Ownership_Concetration  CPI 

// Save the results of regression in a latex file.
outreg2 using reg1.tex, replace dec(3) ctitle()

// F test joint significance testing. 
test CPI 
  
// Ownership_Concetration_hat.  
predict hat_1,xb

// Regression OLS.
reg Tobins_Q_ PM Size Leverage Growth_sales hat_1,robust

// Predict residuals of the data that has been regressed.
predict uhat,residual

// F test joint significance testing.
test hat_1=0

// IV two-stage least squares estimator.
ivreg2 Tobins_Q_ (Ownership_Concetration = CPI ) PM Size Leverage Growth_sales,robust    

// Save the IV two-stage least squares estimation in a latex type of file. 
outreg2 using reg1.tex, replace dec(3) ctitle(IV two-stage least squares)

// Convert variable CountryISOcode from string variable to value labels.
encode CountryISOcode, generate(Country)

// IV two-stage least squares estimator with industry and country fixed effects.
ivreg2 Tobins_Q_ (Ownership_Concetration = CPI ) PM Size Leverage Growth_sales i.NACEcode i.Country,robust    

