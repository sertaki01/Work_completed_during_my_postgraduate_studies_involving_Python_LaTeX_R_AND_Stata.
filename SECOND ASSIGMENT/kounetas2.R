# Set our working directory and import data from csv file
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\SECOND ASSIGMENT")

worldData = read.csv('dataset_World.csv', header = TRUE, sep = ";")

library(dplyr)
library(stringr)

# convert to numeric (don't think we need to)
# for (i in 1990:2014) {  worldData[ ,paste0("X", i)] <- as.numeric(worldData[ ,paste0("X", i)]) }

yearly_gdp <- data.frame(matrix(nrow = 767, ncol = 128))
yearly_gross_capital <- data.frame(matrix(nrow = 767, ncol = 128))
yearly_CO2 <- data.frame(matrix(nrow = 767, ncol = 128))
yearly_energy <- data.frame(matrix(nrow = 767, ncol = 128))
yearly_renewable_energy <- data.frame(matrix(nrow = 767, ncol = 128))
yearly_labor <- data.frame(matrix(nrow = 767, ncol = 128))


for (i in seq_along(worldData$X)) {
    #put all the data from the years into the row_data variable
    #you can print (or copy to another dataframe) the data contained in the yearly_whatever variable for easier handling
    row_data <- worldData[i, paste0("X", 1990:2014)]
  if (any(grepl("GDP", worldData$Indicator.Name[i]))) {
    print(paste("GDP found in line",i,"for",worldData$Country.Name[i]))
    yearly_gdp <- row_data
    }
  else if (any(grepl("Gross fixed capital", worldData$Indicator.Name[i]))) {
    print(paste("Gross Fixed Capital found in line",i,"for",worldData$Country.Name[i]))
    yearly_gross_capital <- row_data
    }
  else if (any(grepl("CO2 emissions", worldData$Indicator.Name[i]))) {
    print(paste("Emissions found in line",i,"for ",worldData$Country.Name[i]))
    yearly_CO2 <- row_data
    }
  else if (any(grepl("kg of oil", worldData$Indicator.Name[i]))) {
    print(paste("Energy consumption found in line",i,"for",worldData$Country.Name[i]))
    yearly_energy <- row_data
    }
  else if (any(grepl("Renewable", worldData$Indicator.Name[i]))) {
    print(paste("Renewable Energy consumption found in line",i,"for",worldData$Country.Name[i]))
    yearly_renewable_energy <- row_data
    }
  else if (any(grepl("Labor force", worldData$Indicator.Name[i]))) {
    print(paste("Labor force found in line",i,"for",worldData$Country.Name[i]))
    yearly_labor <- row_data
    }
}

# print all unique regions found in the "Region" column
unique_regions <- unique(worldData$Region)
print(unique_regions)

