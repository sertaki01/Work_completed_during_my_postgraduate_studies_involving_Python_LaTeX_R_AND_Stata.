# set working directory
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\FIRST ASSIGMENT IN R")

# to remove all objects (variables, functions, etc.) from the current workspace
rm(list = ls())

# to close all open graphical devices
graphics.off()

# Read the data from the file.
data <- read.table("CPS_85_Wages-step.txt", header = FALSE)

# Define column names.
colnames(data)<- c("EDUCATION", "SOUTH", "SEX", "EXPERIENCE", "UNION", "WAGE", "AGE", "RACE", "OCCUPATION", "SECTOR", "MARR")

# Display the first few rows of the data.
head(data)

# Print out the last observations in the data.
tail(data)

# Show the structure of a data set.
str(data)

# summary statistics of WAGE.
summary(data$WAGE)

# Mean of WAGE.
mean(data$WAGE)

# Median of WAGE.
median(data$WAGE)

# Variance of WAGE.
var(data$WAGE)

# Standard deviation of the WAGE.
sd(data$WAGE)

# Histogram for WAGE.
hist(data$WAGE,freq=FALSE,col="blue",main="Histogram of WAGE",xlab="WAGE") 

# Structure of our variable.
outlier<-mean(data$WAGE)+3*sd(data$WAGE)

# Count values in "WAGE" greater than 30.
sum(data$WAGE > outlier)

# Find the index of the first value greater than 30 in the "WAGE" column.
WAGE_30 <- which(data$WAGE >outlier)

# Print the WAGE_30.
print(WAGE_30)

# Specify the rows you want to replace
rows_to_replace <- c(107, 157, 169, 171, 181, 410, 432, 450, 495, 503)

# Replace the outlier values in the specified rows with the mean of 'WAGE'
data$WAGE[rows_to_replace] <- mean(data$WAGE)

# A histogram for 'WAGE' after the removal of the outlier value. 
hist(data$WAGE,freq=FALSE,col="blue",main="Histogram of WAGE",xlab="WAGE")

# to produce a frequency table for SECTOR, display SECTOR. 
table_SECTOR<-table(data$SECTOR) 
print(table_SECTOR)

# to produce a frequency table for OCCUPATION, display OCCUPATION.
table_OCCUPATION<-table(data$OCCUPATION)
print(table_OCCUPATION)

# bar-plot for SECTOR,Add a legend to the bar-plot chart with labels.
barplot(table_SECTOR,xlab="SECTOR",ylab="Frequency",main = "Barplot of SECTOR",col="red")
legend("topright", legend = c("0=Other", "1=Manufacturing", "2=Construction"),title="Categories")

# pie chart for SECTOR,Add a legend to the pie chart with labels.
pie(table_SECTOR,xlab="SECTOR",main="Pie chart for SECTOR",labels = paste(names(table_SECTOR), " (", table_SECTOR, ")", sep = ""))
legend("topright", legend = c("0=Other", "1=Manufacturing", "2=Construction"), title = "Categories")

# bar-plot for OCCUPATION,Add a legend to the bar-plot chart with labels.
barplot(table_OCCUPATION,xlab="OCCUPATION",ylab="Frequency",main = "Barplot of OCCUPATION",col="red")
legend("topleft", legend = c("1=Management", "2=Sales", "3=Clerical", "4=Service", "5=Professional", "6=Other"), title = "Categories")

# pie chart for OCCUPATION,Add a legend to the pie chart with labels.
pie(table_OCCUPATION,xlab="OCCUPATION",main="Pie chart for OCCUPATION",labels = paste(names(table_OCCUPATION), " (", table_OCCUPATION, ")", sep = ""))
legend("bottomright", legend = c("1=Management", "2=Sales", "3=Clerical", "4=Service", "5=Professional", "6=Other"), title = "Categories")

# Mean of AGE.
mean(data$AGE)

# scatter plot of AGE against WAGE with a regression line.
plot(data$AGE, data$WAGE, xlab = "AGE", ylab = "WAGE", main = "SCATTER PLOT")

# Fit a linear regression model.
model <- lm(data$WAGE ~ data$AGE)

# Add the regression line to the scatter plot.
abline(model, col = "blue")

# Correlation Test 1 (Pearson Correlation).
cor_test1 <- cor.test(data$AGE, data$WAGE, method = "pearson")
print(cor_test1)

# Creating a variable with ifelse statement.
data$NORTH <- ifelse(data$SOUTH == 0, 1, 0)

# Compute the kernel density of NORTH using density.
density_north<-density(data$NORTH)

# Plot the kernel density estimate for north.
plot(density_north, main = "Kernel Density Estimation for North")

# Apply the logarithm transformation to NORTH. 
log_north<-log(data$NORTH)

# Compute the kernel density of log(NORTH) using density.
density_lognorth<-density(log_north)

# Plot the kernel density estimate for log_north.
plot(density_lognorth, main = "Kernel Density Estimation for log_North")

# Compute the kernel density of log(NORTH) using density,dw adjustment.
density_lognorth<-density(log_north,bw=0.35)

# Plot the kernel density estimate for log_north,dw adjustment.
plot(density_lognorth, main = "Kernel Density Estimation for log_North,bw=0.35")

# Create variable GENDER male=1, female=0.
data$GENDER<-ifelse(data$SEX==1,0,1)

# To produce a frequency table for gender and occupation, display gender and occupation, Display. 
table_gender_occupation<-table(data$GENDER, data$OCCUPATION)
print(table_gender_occupation)

# Create a contingency table using xtabs table that shows the count of each gender within each occupation.
contingency_table <- xtabs(~GENDER+OCCUPATION, data=data)

# Create a barplot for gender proportion by occupation.
barplot(contingency_table,main ="Gender Proportion by Occupation",xlab = "Occupation", ylab = "Frequency",beside = TRUE,col=c("blue","red"))
legend("topleft", legend = c("Female", "Male"), fill = c("blue", "red"))

# transform the "wage" variable into its natural logarithm. 
ln_wage<-log(data$WAGE)

# Normality test for ln_wage.
shapiro.test(ln_wage)

# scatter plot of WAGE against EDUCATION with a regression line.
plot(data$EDUCATION, data$WAGE, xlab = "EDUCATION", ylab = "WAGE", main = "SCATTER PLOT")

# Fit a linear regression model.
model <- lm(data$EDUCATION ~ data$WAGE)

# Add the regression line to the scatter plot.
abline(model, col = "blue")

# Correlation Test 2 (Pearson Correlation).
cor_test2 <- cor.test(data$EDUCATION, data$WAGE, method = "pearson")
print(cor_test2)

# Calculate the mean wage for each gender using the tapply function.
mean_wage_by_gender <- tapply(data$WAGE, data$GENDER, FUN = mean)

# Print the mean wage for each gender.
print(mean_wage_by_gender)

# Boxplot for wage by gender.
boxplot(WAGE~GENDER, data = data, main = "Wage by Gender", xlab = "Gender", ylab = "Wage")

# Q-Q Plot for wage of males.
qqnorm(data$WAGE[data$GENDER == 1])
qqline(data$WAGE[data$GENDER == 1])

# Q-Q Plot for wage of females.
qqnorm(data$WAGE[data$GENDER == 0])
qqline(data$WAGE[data$GENDER == 0])

# Boxplot of log(wage) by occupation.
boxplot(log(WAGE) ~ OCCUPATION, data = data, main = "Log(Wage) by Occupation", xlab = "Occupation", ylab = "Log(Wage)")


# loading the "AER" package and accessing the "CPS1988" dataset.
library(AER)
data("CPS1988")

# Print the first few rows of the dataset.
head(CPS1988)

# Print out the last observations in the data.
tail(CPS1988)

# Show the structure of a data set
str(CPS1988)

# Mean of wage.
mean(CPS1988$wage)

# Structure of our variable.
outlier<-mean(CPS1988$wage)+3*sd(CPS1988$wage)

# Show the value that we calculate.
cat(outlier)

# Count values in "wage" greater than 1964.39 .
sum(CPS1988$wage > outlier)

#We created a new dataframe in which we removed values of wage greater than the outlier
CPS1988 <- subset(CPS1988, wage <= outlier)

# Boxplot for WAGE.
boxplot(CPS1988$wage, main = "Boxplot of WAGE")

# Scatterplot of log(wage) versus experience.
plot(CPS1988$experience, log(CPS1988$wage), xlab = "experience", ylab = "Log(Wage)", main = "Scatterplot of Log(Wage) vs. Experience")

# Fit a linear regression model.
model <- lm(log(CPS1988$wage)~CPS1988$experience)

# Add the regression line to the scatter plot.
abline(model, col = "blue")

# Scatterplot of log(wage) versus education.
plot(CPS1988$education,log(CPS1988$wage), xlab = "education", ylab = "Log(wage)", main = "Scatterplot of Log(Wage) vs. Education")

# Fit a linear regression model.
model <- lm(log(CPS1988$wage)~CPS1988$education)

# Add the regression line to the scatter plot.
abline(model, col = "blue")

#transform the education variable into a factor.
CPS1988$education<-factor(CPS1988$education)

# Parallel boxplots of wage stratified by levels of education.
boxplot(log(CPS1988$wage) ~ CPS1988$education, data = CPS1988,
        main = "Boxplots of Log(Wage) Stratified by Education",
        xlab = "Education Level", ylab = "Log(Wage)",
        col = "lightblue")

# Scatterplot of log(wage) versus ethnicity.
plot(CPS1988$ethnicity, log(CPS1988$wage),
     xlab = "Ethnicity", ylab = "Log(Wage)",
     main = "Scatterplot of Log(Wage) vs. Ethnicity")

# Fit a linear regression model.
model_ethnicity <- lm(log(CPS1988$wage) ~ CPS1988$ethnicity)

# Add the regression line to the scatter plot.
abline(model_ethnicity, col = "blue")

# Scatterplot of log(wage) versus smsa.
plot(CPS1988$smsa, log(CPS1988$wage),
     xlab = "SMSA", ylab = "Log(Wage)",
     main = "Scatterplot of Log(Wage) vs. SMSA")

# Fit a linear regression model.
model_smsa <- lm(log(CPS1988$wage) ~ CPS1988$smsa)

# Add the regression line to the scatter plot.
abline(model_smsa, col = "blue")

# Scatterplot of log(wage) versus region.
plot(CPS1988$region, log(CPS1988$wage),
     xlab = "Region", ylab = "Log(Wage)",
     main = "Scatterplot of Log(Wage) vs. Region")

# Scatterplot of log(wage) versus parttime.
plot(CPS1988$parttime, log(CPS1988$wage),
     xlab = "Part-time", ylab = "Log(Wage)",
     main = "Scatterplot of Log(Wage) vs. Part-time")

# Fit a linear regression model.
model_parttime <- lm(log(CPS1988$wage) ~ CPS1988$parttime)

# Add the regression line to the scatter plot.
abline(model_parttime, col = "blue")
