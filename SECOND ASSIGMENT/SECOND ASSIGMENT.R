# SECOND ASSIGMENT 

# Deletes all variables located in the working environment.
rm(list = ls())

# Deletes all the plots that have been created.
graphics.off()

# Set working directory.
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\SECOND ASSIGMENT")

# Install and load the dplyr package.
library(dplyr)
library(Benchmarking)
library(tidyr)

# Exercise 1.

# Read csv data.
Data = read.csv('dataset_World.csv', header = TRUE, sep = ";")

# See what type are the variables inside a dataframe.
str(Data)

# Split the DataFrame into a list of sub-DataFrames based on "indicator" and "country.name".
subframes<- split(Data, list( Data$Indicator.Name))

# Display the sub-DataFrames.
print("Υπο-DataFrames:")
print(subframes)

# Create 4 dataframes each for the input and outputs.
df1 <- subframes$"GDP per capita (constant 2010 US$)"
df2 <- subframes$"Gross fixed capital formation (constant 2010 US$)"
df3 <- subframes$"Energy consumption (kg of oil equivalent per capita)"
df4 <- subframes$"Labor force, total"

# Find the positions (rows) with completely empty values in the column "Region".
empty_positions <- which(is.character(df3$"Region") & df3$"Region" == "")

# Display the positions
print(empty_positions)

# Remove the last row of all the dataframes for collision purposes.
df1 <- df1[1:(nrow(df1)-1), ]
df3 <- df3[1:(nrow(df3)-1), ]
df4 <- df4[1:(nrow(df4)-1), ]

# Replace missing based on the variable region.
df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 2, "Middle East & North Africa", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 23,"Latin America & Caribbean" , Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 28, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 29, "Latin America & Caribbean", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 30, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 32, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 34, "Latin America & Caribbean", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 35, "East Asia & Pacific", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 37, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 40, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 41, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 46, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 50, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 51, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 54, "East Asia & Pacific", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 97, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 99, "Middle East & North Africa", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 101, "East Asia & Pacific", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 102, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 105, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 112, "East Asia & Pacific", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 113, "Middle East & North Africa", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 114, "Latin America & Caribbean", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 115, "East Asia & Pacific", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 118, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 120, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 122, "North America", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 123, "Europe & Central Asia", Region))

df3 <- df3 %>%
  mutate(Region = ifelse(row_number() == 125, "East Asia & Pacific", Region))

# Find the name of the column "region" in the df3 dataframe.
region_column_name <- names(df3)[grep("Region", names(df3), ignore.case = TRUE)]

# Replace the "region" column in the df1 dataframe with the corresponding column from the df3 dataframe.
df1[[region_column_name]] <- df3[[region_column_name]]

df4[[region_column_name]] <- df3[[region_column_name]]

df2[[region_column_name]] <- df3[[region_column_name]]

df1 <- arrange(df1, Region)

df2 <- arrange(df2, Region)

df3 <- arrange(df3, Region)

df4 <- arrange(df4, Region)

#Region freq.
table(df1$Region)


df1 <- df1 %>%
  select(-7:-23)

df2 <- df2 %>%
  select(-7:-23)

df3 <- df3 %>%
  select(-7:-23)

df4 <- df4 %>%
  select(-7:-23)

# Separate dataframes based on the variable Region
df1_list <- split(df1, df1$Region)
df2_list <- split(df2, df2$Region)
df3_list <- split(df3, df3$Region)
df4_list <- split(df4, df4$Region)

# Conversion of names of our dataframes.
region_suffix <- "_y"

lapply(names(df1_list), function(region_name) {
  assign(paste(region_name, region_suffix, sep = ""), df1_list[[region_name]], envir = .GlobalEnv)
})

region_suffix <- "_x1"

lapply(names(df2_list), function(region_name) {
  assign(paste(region_name, region_suffix, sep = ""), df2_list[[region_name]], envir = .GlobalEnv)
})

region_suffix <- "_x2"

lapply(names(df3_list), function(region_name) {
  assign(paste(region_name, region_suffix, sep = ""), df3_list[[region_name]], envir = .GlobalEnv)
})

region_suffix <- "_x3"

lapply(names(df4_list), function(region_name) {
  assign(paste(region_name, region_suffix, sep = ""), df4_list[[region_name]], envir = .GlobalEnv)
})

# Run DEA with CRS,VRS East Asia & Pacific
result_crs1 <- dea(X =cbind(`East Asia & Pacific_x1`[,7:14],`East Asia & Pacific_x2`[,7:14],`East Asia & Pacific_x3`[,7:14]), Y = `East Asia & Pacific_y`[,7:14], RTS = "crs", ORIENTATION = "in")

result_vrs1 <- dea(X =cbind(`East Asia & Pacific_x1`[,7:14],`East Asia & Pacific_x2`[,7:14],`East Asia & Pacific_x3`[,7:14]), Y = `East Asia & Pacific_y`[,7:14], RTS = "vrs", ORIENTATION = "in")

# Create a vector with the country names for this region
East_Asia_Pacific<-`East Asia & Pacific_y`$"Country.Name"

# Create vectors from crs,vrs(eff)
result_crs1_vector <- as.vector(result_crs1$eff)
result_vrs1_vector <- as.vector(result_vrs1$eff)

# Round by 3 digits
result_crs1_vector <- round(result_crs1_vector, 3)
result_vrs1_vector <- round(result_vrs1_vector, 3)

resultCrs1<-cbind(East_Asia_Pacific,as.numeric(result_crs1_vector))
resultVrs1<-cbind(East_Asia_Pacific,as.numeric(result_vrs1_vector))

# Results with the countries
cat("Region(East Asia & Pacific), CRS Results:\n")
print(resultCrs1,quote = FALSE)

cat("Region(East Asia & Pacific), VRS Results:\n")
print(resultVrs1,quote=FALSE)


# Run DEA with CRS,VRS Europe Central Asia
result_crs2 <- dea(X =cbind(`Europe & Central Asia_x1`[,7:14],`Europe & Central Asia_x2`[,7:14],`Europe & Central Asia_x3`[,7:14]), Y = `Europe & Central Asia_y`[,7:14], RTS = "crs", ORIENTATION = "in")

result_vrs2 <- dea(X =cbind(`Europe & Central Asia_x1`[,7:14],`Europe & Central Asia_x2`[,7:14],`Europe & Central Asia_x3`[,7:14]), Y = `Europe & Central Asia_y`[,7:14], RTS = "vrs", ORIENTATION = "in")

# Create a vector with the country names for this region
Europe_Central_Asia<-`Europe & Central Asia_y`$"Country.Name"

# Create vectors from crs,vrs(eff)
result_crs2_vector <- as.vector(result_crs2$eff)
result_vrs2_vector <- as.vector(result_vrs2$eff)

# Round by 3 digits
result_crs2_vector <- round(result_crs2_vector, 3)
result_vrs2_vector <- round(result_vrs2_vector, 3)

resultCrs2<-cbind(Europe_Central_Asia,as.numeric(result_crs2_vector))
resultVrs2<-cbind(Europe_Central_Asia,as.numeric(result_vrs2_vector))

# Results with the countries
cat("Region(Europe_Central_Asia), CRS Results:\n")
print(resultCrs2,quote = FALSE)

cat("Region(Europe_Central_Asia), VRS Results:\n")
print(resultVrs2,quote=FALSE)


# Run DEA with CRS,VRS Latin American & Caribbean
result_crs3 <- dea(X =cbind(`Latin America & Caribbean_x1`[,7:14],`Latin America & Caribbean_x2`[,7:14],`Latin America & Caribbean_x3`[,7:14]), Y = `Latin America & Caribbean_y`[,7:14], RTS = "crs", ORIENTATION = "in")

result_vrs3 <- dea(X =cbind(`Latin America & Caribbean_x1`[,7:14],`Latin America & Caribbean_x2`[,7:14],`Latin America & Caribbean_x3`[,7:14]), Y = `Latin America & Caribbean_y`[,7:14], RTS = "vrs", ORIENTATION = "in")

# Create a vector with the country names for this region
Latin_America_Caribbean<-`Latin America & Caribbean_y`$"Country.Name"

# Create vectors from crs,vrs(eff)
result_crs3_vector <- as.vector(result_crs3$eff)
result_vrs3_vector <- as.vector(result_vrs3$eff)

# Round by 3 digits
result_crs3_vector <- round(result_crs3_vector, 3)
result_vrs3_vector <- round(result_vrs3_vector, 3)

resultCrs3<-cbind(Latin_America_Caribbean,as.numeric(result_crs3_vector))
resultVrs3<-cbind(Latin_America_Caribbean,as.numeric(result_vrs3_vector))

# Results with the countries
cat("Region(Latin_America_Caribbean), CRS Results:\n")
print(resultCrs3,quote = FALSE)

cat("Region(Latin_America_Caribbean), VRS Results:\n")
print(resultVrs3,quote=FALSE)


# Run DEA with CRS,VRS Middle East North Africa.
result_crs4 <- dea(X =cbind(`Middle East & North Africa_x1`[,7:14],`Middle East & North Africa_x2`[,7:14],`Middle East & North Africa_x3`[,7:14]), Y = `Middle East & North Africa_y`[,7:14], RTS = "crs", ORIENTATION = "in")

result_vrs4 <- dea(X =cbind(`Middle East & North Africa_x1`[,7:14],`Middle East & North Africa_x2`[,7:14],`Middle East & North Africa_x3`[,7:14]), Y = `Middle East & North Africa_y`[,7:14], RTS = "vrs", ORIENTATION = "in")

# Create a vector with the country names for this region
Middle_East_North_Africa<-`Middle East & North Africa_y`$"Country.Name"

# Create vectors from crs,vrs(eff)
result_crs4_vector <- as.vector(result_crs4$eff)
result_vrs4_vector <- as.vector(result_vrs4$eff)

# Round by 3 digits
result_crs4_vector <- round(result_crs4_vector, 3)
result_vrs4_vector <- round(result_vrs4_vector, 3)

resultCrs4<-cbind(Middle_East_North_Africa,as.numeric(result_crs4_vector))
resultVrs4<-cbind(Middle_East_North_Africa,as.numeric(result_vrs4_vector))

# Results with the countries
cat("Region(Middle_East_North_Africa), CRS Results:\n")
print(resultCrs4,quote = FALSE)

cat("Region(Middle_East_North_Africa), VRS Results:\n")
print(resultVrs4,quote=FALSE)


# Run DEA with CRS,VRS North America.
result_crs5 <- dea(X =cbind(`North America_x1`[,7:14],`North America_x2`[,7:14],`North America_x3`[,7:14]), Y = `North America_y`[,7:14], RTS = "crs", ORIENTATION = "in")

result_vrs5 <- dea(X =cbind(`North America_x1`[,7:14],`North America_x2`[,7:14],`North America_x3`[,7:14]), Y = `North America_y`[,7:14], RTS = "vrs", ORIENTATION = "in")

# Create a vector with the country names for this region
North_America<-`North America_y`$"Country.Name"

# Create vectors from crs,vrs(eff)
result_crs5_vector <- as.vector(result_crs5$eff)
result_vrs5_vector <- as.vector(result_vrs5$eff)

# Round by 3 digits
result_crs5_vector <- round(result_crs5_vector, 3)
result_vrs5_vector <- round(result_vrs5_vector, 3)

resultCrs5<-cbind(North_America,as.numeric(result_crs5_vector))
resultVrs5<-cbind(North_America,as.numeric(result_vrs5_vector))

# Results with the countries
cat("Region(North_America), CRS Results:\n")
print(resultCrs5,quote = FALSE)

cat("Region(North_America), VRS Results:\n")
print(resultVrs5,quote=FALSE)


# Run DEA with CRS,VRS South Asia.
result_crs6 <- dea(X =cbind(`South Asia_x1`[,7:14],`South Asia_x2`[,7:14],`South Asia_x3`[,7:14]), Y = `South Asia_y`[,7:14], RTS = "crs", ORIENTATION = "in")

result_vrs6 <- dea(X =cbind(`South Asia_x1`[,7:14],`South Asia_x2`[,7:14],`South Asia_x3`[,7:14]), Y = `South Asia_y`[,7:14], RTS = "vrs", ORIENTATION = "in")

# Create a vector with the country names for this region
South_Asia<-`South Asia_y`$"Country.Name"

# Create vectors from crs,vrs(eff)
result_crs6_vector <- as.vector(result_crs6$eff)
result_vrs6_vector <- as.vector(result_vrs6$eff)

# Round by 3 digits
result_crs6_vector <- round(result_crs6_vector, 3)
result_vrs6_vector <- round(result_vrs6_vector, 3)

resultCrs6<-cbind(South_Asia,as.numeric(result_crs6_vector))
resultVrs6<-cbind(South_Asia,as.numeric(result_vrs6_vector))

# Results with the countries
cat("Region(South_Asia), CRS Results:\n")
print(resultCrs6,quote = FALSE)

cat("Region(South_Asia), VRS Results:\n")
print(resultVrs6,quote=FALSE)


# Run DEA with CRS,VRS Sub_saharan_africa.
result_crs7 <- dea(X =cbind(`Sub-Saharan Africa_x1`[,7:14],`Sub-Saharan Africa_x2`[,7:14],`Sub-Saharan Africa_x3`[,7:14]), Y = `Sub-Saharan Africa_y`[,7:14], RTS = "crs", ORIENTATION = "in")

result_vrs7 <- dea(X =cbind(`Sub-Saharan Africa_x1`[,7:14],`Sub-Saharan Africa_x2`[,7:14],`Sub-Saharan Africa_x3`[,7:14]), Y = `Sub-Saharan Africa_y`[,7:14], RTS = "vrs", ORIENTATION = "in")

# Create a vector with the country names for this region
Sub_Saharan_Africa<-`Sub-Saharan Africa_y`$"Country.Name"

# Create vectors from crs,vrs(eff)
result_crs7_vector <- as.vector(result_crs7$eff)
result_vrs7_vector <- as.vector(result_vrs7$eff)

# Round by 3 digits
result_crs7_vector <- round(result_crs7_vector, 3)
result_vrs7_vector <- round(result_vrs7_vector, 3)

resultCrs7<-cbind(Sub_Saharan_Africa,as.numeric(result_crs7_vector))
resultVrs7<-cbind(Sub_Saharan_Africa,as.numeric(result_vrs7_vector))

# Results with the countries
cat("Region(Sub_Saharan_Africa), CRS Results:\n")
print(resultCrs7,quote = FALSE)

cat("Region(Sub_Saharan_Africa), VRS Results:\n")
print(resultVrs7,quote=FALSE)





# Exercise 2.

# Scale efficiency for each group(Region).

# East_Asia_Pasific.
efficiency_crs1 <- result_crs1$eff
efficiency_vrs1 <- result_vrs1$eff
scale_efficiency1 <- efficiency_crs1 / efficiency_vrs1
scale_efficiency1<-round(scale_efficiency1,3)
print(scale_efficiency1)

result_scale_efficiency1 <- data.frame(East_Asia_Pacific,scale_efficiency1)
print(result_scale_efficiency1)

# Europe_Central_Asia. 
efficiency_crs2 <- result_crs2$eff
efficiency_vrs2 <- result_vrs2$eff
scale_efficiency2 <- efficiency_crs2 / efficiency_vrs2
scale_efficiency2<-round(scale_efficiency2,3)
print(scale_efficiency2)

result_scale_efficiency2 <- data.frame(Europe_Central_Asia,scale_efficiency2)
print(result_scale_efficiency2)

# Latin American & Caribbean.
efficiency_crs3 <- result_crs3$eff
efficiency_vrs3 <- result_vrs3$eff
scale_efficiency3 <- efficiency_crs3 / efficiency_vrs3
scale_efficiency3<-round(scale_efficiency3,3)
print(scale_efficiency3)

result_scale_efficiency3 <- data.frame(Latin_America_Caribbean,scale_efficiency3)
print(result_scale_efficiency3)

# Middle_East_North_Africa.
efficiency_crs4 <- result_crs4$eff
efficiency_vrs4 <- result_vrs4$eff
scale_efficiency4 <- efficiency_crs4 / efficiency_vrs4
scale_efficiency4<-round(scale_efficiency4,3)
print(scale_efficiency4)

result_scale_efficiency4 <- data.frame(Middle_East_North_Africa,scale_efficiency4)
print(result_scale_efficiency4)

# North_America.
efficiency_crs5 <- result_crs5$eff
efficiency_vrs5 <- result_vrs5$eff
scale_efficiency5 <- efficiency_crs5 / efficiency_vrs5
scale_efficiency5<-round(scale_efficiency5,3)
print(scale_efficiency5)

result_scale_efficiency5 <- data.frame(North_America,scale_efficiency5)
print(result_scale_efficiency5)

# South_Asia. 
efficiency_crs6 <- result_crs6$eff
efficiency_vrs6 <- result_vrs6$eff
scale_efficiency6 <- efficiency_crs6 / efficiency_vrs6
scale_efficiency6<-round(scale_efficiency6,3)
print(scale_efficiency6)

result_scale_efficiency6 <- data.frame(South_Asia,scale_efficiency6)
print(result_scale_efficiency6)

# Sub_Saharan_Africa.
efficiency_crs7 <- result_crs7$eff
efficiency_vrs7 <- result_vrs7$eff
scale_efficiency7 <- efficiency_crs7 / efficiency_vrs7
scale_efficiency7<-round(scale_efficiency7,3)
print(scale_efficiency7)

result_scale_efficiency7 <- data.frame(Sub_Saharan_Africa,scale_efficiency7)
print(result_scale_efficiency7)





# Exercise 3.

# Deletes all variables located in the working environment.
rm(list = ls())

# Deletes all the plots that have been created.
graphics.off()

# Set working directory.
setwd("C:\\Users\\admin\\OneDrive\\Υπολογιστής\\SECOND ASSIGMENT")

# Install and load the dplyr package.
library(dplyr)
library(Benchmarking)
library(tidyr)

# Read csv data.
Data = read.csv('dataset_World.csv', header = TRUE, sep = ";")

# See what type are the variables inside a dataframe.
str(Data)

# Split the DataFrame into a list of sub-DataFrames based on "indicator" and "country.name".
subframes<- split(Data, list( Data$Indicator.Name))

# Display the sub-DataFrames.
print("Υπο-DataFrames:")
print(subframes)

# Create 4 dataframes each for the input and outputs.
df1 <- subframes$"GDP per capita (constant 2010 US$)"
df2 <- subframes$"Gross fixed capital formation (constant 2010 US$)"
df3 <- subframes$"Energy consumption (kg of oil equivalent per capita)"
df4 <- subframes$"Labor force, total"

# Remove the last row of all the dataframes for collision purposes.
df1 <- df1[1:(nrow(df1)-1), ]
df3 <- df3[1:(nrow(df3)-1), ]
df4 <- df4[1:(nrow(df4)-1), ]

# Remove columns from table df2,df3,df4
df2 <- df2[, -c(1:6)]
df3 <- df3[, -c(1:6)]
df4 <- df4[, -c(1:6)]

# Sum numeric dataframes from inputs.
df<-df2+df3+df4

# Country name vector
country_name<-as.data.frame(df1$Country.Name)

# output vectors.
y_1990<-as.data.frame(df1[,7])
y_1990 <- cbind(country_name,y_1990)

y_1991<-as.data.frame(df1[,8])
y_1991 <- cbind(country_name,y_1991)

y_1992<-as.data.frame(df1[,9])
y_1992 <- cbind(country_name,y_1992)

y_1993<-as.data.frame(df1[,10])
y_1993 <- cbind(country_name,y_1993)

y_1994<-as.data.frame(df1[,11])
y_1994 <- cbind(country_name,y_1994)

y_1995<-as.data.frame(df1[,12])
y_1995 <- cbind(country_name,y_1995)

y_1996<-as.data.frame(df1[,13])
y_1996 <- cbind(country_name,y_1996)

y_1997<-as.data.frame(df1[,14])
y_1997 <- cbind(country_name,y_1997)

y_1998<-as.data.frame(df1[,15])
y_1998 <- cbind(country_name,y_1998)

y_1999<-as.data.frame(df1[,16])
y_1999 <- cbind(country_name,y_1999)

y_2000<-as.data.frame(df1[,17])
y_2000 <- cbind(country_name,y_2000)

y_2001<-as.data.frame(df1[,18])
y_2001 <- cbind(country_name,y_2001)

y_2002<-as.data.frame(df1[,19])
y_2002<- cbind(country_name,y_2002)

y_2003<-as.data.frame(df1[,20])
y_2003 <- cbind(country_name,y_2003)

y_2004<-as.data.frame(df1[,21])
y_2004 <- cbind(country_name,y_2004)

y_2005<-as.data.frame(df1[,22])
y_2005 <- cbind(country_name,y_2005)

y_2006<-as.data.frame(df1[,23])
y_2006 <- cbind(country_name,y_2006)

y_2007<-as.data.frame(df1[,24])
y_2007 <- cbind(country_name,y_2007)

y_2008<-as.data.frame(df1[,25])
y_2008 <- cbind(country_name,y_2008)

y_2009<-as.data.frame(df1[,26])
y_2009 <- cbind(country_name,y_2009)

y_2010<-as.data.frame(df1[,27])
y_2010 <- cbind(country_name,y_2010)

y_2011<-as.data.frame(df1[,28])
y_2011 <- cbind(country_name,y_2011)

y_2012<-as.data.frame(df1[,29])
y_2012 <- cbind(country_name,y_2012)

y_2013<-as.data.frame(df1[,30])
y_2013 <- cbind(country_name,y_2013)

y_2014<-as.data.frame(df1[,31])
y_2014 <- cbind(country_name,y_2014)


# input vectors.
x_1990<-as.data.frame(df[,1])
x_1990 <- cbind(country_name,x_1990)

x_1991<-as.data.frame(df[,2])
x_1991 <- cbind(country_name,x_1991)

x_1992<-as.data.frame(df[,3])
x_1992 <- cbind(country_name,x_1992)

x_1993<-as.data.frame(df[,4])
x_1993 <- cbind(country_name,x_1993)

x_1994<-as.data.frame(df[,5])
x_1994 <- cbind(country_name,x_1994)

x_1995<-as.data.frame(df[,6])
x_1995 <- cbind(country_name,x_1995)

x_1996<-as.data.frame(df[,7])
x_1996 <- cbind(country_name,x_1996)

x_1997<-as.data.frame(df[,8])
x_1997 <- cbind(country_name,x_1997)

x_1998<-as.data.frame(df[,9])
x_1998 <- cbind(country_name,x_1998)

x_1999<-as.data.frame(df[,10])
x_1999 <- cbind(country_name,x_1999)

x_2000<-as.data.frame(df[,11])
x_2000 <- cbind(country_name,x_2000)

x_2001<-as.data.frame(df[,12])
x_2001 <- cbind(country_name,x_2001)

x_2002<-as.data.frame(df[,13])
x_2002<- cbind(country_name,x_2002)

x_2003<-as.data.frame(df[,14])
x_2003 <- cbind(country_name,x_2003)

x_2004<-as.data.frame(df[,15])
x_2004 <- cbind(country_name,x_2004)

x_2005<-as.data.frame(df[,16])
x_2005 <- cbind(country_name,x_2005)

x_2006<-as.data.frame(df[,17])
x_2006 <- cbind(country_name,x_2006)

x_2007<-as.data.frame(df[,18])
x_2007 <- cbind(country_name,x_2007)

x_2008<-as.data.frame(df[,19])
x_2008 <- cbind(country_name,x_2008)

x_2009<-as.data.frame(df[,20])
x_2009 <- cbind(country_name,x_2009)

x_2010<-as.data.frame(df[,21])
x_2010 <- cbind(country_name,x_2010)

x_2011<-as.data.frame(df[,22])
x_2011 <- cbind(country_name,x_2011)

x_2012<-as.data.frame(df[,23])
x_2012 <- cbind(country_name,x_2012)

x_2013<-as.data.frame(df[,24])
x_2013 <- cbind(country_name,x_2013)

x_2014<-as.data.frame(df[,25])
x_2014 <- cbind(country_name,x_2014)

# test  malmquist productivity index and its components for the period 1990-1991.
malquist_index_1990_1991 <- malmq(
  X0 =as.matrix(x_1990[,2]) ,
  Y0 =as.matrix(y_1990[,2]),
  ID0 = as.factor(x_1990[,1]),
  X1 = as.matrix(x_1991[,2]),
  Y1 = as.matrix(y_1991[,2]),
  ID1 =as.factor(x_1991[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 1990-1991.
malmquist_productivity_index_1990_1991 <- as.data.frame(malquist_index_1990_1991$m)
technical_change_1990_1991 <- as.data.frame(malquist_index_1990_1991$tc)
efficiency_change_1990_1991 <- as.data.frame(malquist_index_1990_1991$ec)


# test  malmquist productivity index and its components for the period 1991-1992.
malquist_index_1991_1992 <- malmq(
  X0 =as.matrix(x_1991[,2]) ,
  Y0 =as.matrix(y_1991[,2]),
  ID0 = as.factor(x_1991[,1]),
  X1 = as.matrix(x_1992[,2]),
  Y1 = as.matrix(y_1992[,2]),
  ID1 =as.factor(x_1992[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 1991-1992.
malmquist_productivity_index_1991_1992 <- as.data.frame(malquist_index_1991_1992$m)
technical_change_1991_1992 <- as.data.frame(malquist_index_1991_1992$tc)
efficiency_change_1991_1992 <- as.data.frame(malquist_index_1991_1992$ec)


# test  malmquist productivity index and its components for the period 1992-1993.
malquist_index_1992_1993 <- malmq(
  X0 =as.matrix(x_1992[,2]) ,
  Y0 =as.matrix(y_1992[,2]),
  ID0 = as.factor(x_1992[,1]),
  X1 = as.matrix(x_1993[,2]),
  Y1 = as.matrix(y_1993[,2]),
  ID1 =as.factor(x_1993[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 1992-1993.
malmquist_productivity_index_1992_1993 <- as.data.frame(malquist_index_1992_1993$m)
technical_change_1992_1993 <- as.data.frame(malquist_index_1992_1993$tc)
efficiency_change_1992_1993 <- as.data.frame(malquist_index_1992_1993$ec)


# test  malmquist productivity index and its components for the period 1993-1994.
malquist_index_1993_1994 <- malmq(
  X0 =as.matrix(x_1993[,2]) ,
  Y0 =as.matrix(y_1993[,2]),
  ID0 = as.factor(x_1993[,1]),
  X1 = as.matrix(x_1994[,2]),
  Y1 = as.matrix(y_1994[,2]),
  ID1 =as.factor(x_1994[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 1993-1994.
malmquist_productivity_index_1993_1994 <- as.data.frame(malquist_index_1993_1994$m)
technical_change_1993_1994 <- as.data.frame(malquist_index_1993_1994$tc)
efficiency_change_1993_1994 <- as.data.frame(malquist_index_1993_1994$ec)


# test  malmquist productivity index and its components for the period 1994-1995.
malquist_index_1994_1995 <- malmq(
  X0 =as.matrix(x_1994[,2]) ,
  Y0 =as.matrix(y_1994[,2]),
  ID0 = as.factor(x_1994[,1]),
  X1 = as.matrix(x_1995[,2]),
  Y1 = as.matrix(y_1995[,2]),
  ID1 =as.factor(x_1995[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 1994-1995.
malmquist_productivity_index_1994_1995 <- as.data.frame(malquist_index_1994_1995$m)
technical_change_1994_1995 <- as.data.frame(malquist_index_1994_1995$tc)
efficiency_change_1994_1995 <- as.data.frame(malquist_index_1994_1995$ec)


# test  malmquist productivity index and its components for the period 1995-1996.
malquist_index_1995_1996 <- malmq(
  X0 =as.matrix(x_1995[,2]) ,
  Y0 =as.matrix(y_1995[,2]),
  ID0 = as.factor(x_1995[,1]),
  X1 = as.matrix(x_1996[,2]),
  Y1 = as.matrix(y_1996[,2]),
  ID1 =as.factor(x_1996[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 1995-1996.
malmquist_productivity_index_1995_1996 <- as.data.frame(malquist_index_1995_1996$m)
technical_change_1995_1996 <- as.data.frame(malquist_index_1995_1996$tc)
efficiency_change_1995_1996 <- as.data.frame(malquist_index_1995_1996$ec)


# test  malmquist productivity index and its components for the period 1996-1997.
malquist_index_1996_1997 <- malmq(
  X0 =as.matrix(x_1996[,2]) ,
  Y0 =as.matrix(y_1996[,2]),
  ID0 = as.factor(x_1996[,1]),
  X1 = as.matrix(x_1997[,2]),
  Y1 = as.matrix(y_1997[,2]),
  ID1 =as.factor(x_1997[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 1996-1997.
malmquist_productivity_index_1996_1997 <- as.data.frame(malquist_index_1996_1997$m)
technical_change_1996_1997 <- as.data.frame(malquist_index_1996_1997$tc)
efficiency_change_1996_1997 <- as.data.frame(malquist_index_1996_1997$ec)


# test  malmquist productivity index and its components for the period 1997-1998.
malquist_index_1997_1998 <- malmq(
  X0 =as.matrix(x_1997[,2]) ,
  Y0 =as.matrix(y_1997[,2]),
  ID0 = as.factor(x_1997[,1]),
  X1 = as.matrix(x_1998[,2]),
  Y1 = as.matrix(y_1998[,2]),
  ID1 =as.factor(x_1998[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 1997-1998.
malmquist_productivity_index_1997_1998 <- as.data.frame(malquist_index_1997_1998$m)
technical_change_1997_1998 <- as.data.frame(malquist_index_1997_1998$tc)
efficiency_change_1997_1998 <-as.data.frame(malquist_index_1997_1998$ec)


# test  malmquist productivity index and its components for the period 1998-1999.
malquist_index_1998_1999 <- malmq(
  X0 =as.matrix(x_1998[,2]) ,
  Y0 =as.matrix(y_1998[,2]),
  ID0 = as.factor(x_1998[,1]),
  X1 = as.matrix(x_1999[,2]),
  Y1 = as.matrix(y_1999[,2]),
  ID1 =as.factor(x_1999[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 1998-1999.
malmquist_productivity_index_1998_1999 <- as.data.frame(malquist_index_1998_1999$m)
technical_change_1998_1999 <- as.data.frame(malquist_index_1998_1999$tc)
efficiency_change_1998_1999 <- as.data.frame(malquist_index_1998_1999$ec)


# test  malmquist productivity index and its components for the period 1999-2000.
malquist_index_1999_2000 <- malmq(
  X0 =as.matrix(x_1999[,2]) ,
  Y0 =as.matrix(y_1999[,2]),
  ID0 = as.factor(x_1999[,1]),
  X1 = as.matrix(x_2000[,2]),
  Y1 = as.matrix(y_2000[,2]),
  ID1 =as.factor(x_2000[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 1999-2000.
malmquist_productivity_index_1999_2000 <- as.data.frame(malquist_index_1999_2000$m)
technical_change_1999_2000 <- as.data.frame(malquist_index_1999_2000$tc)
efficiency_change_1999_2000 <- as.data.frame(malquist_index_1999_2000$ec)


# test  malmquist productivity index and its components for the period 2000-2001.
malquist_index_2000_2001 <- malmq(
  X0 =as.matrix(x_2000[,2]) ,
  Y0 =as.matrix(y_2000[,2]),
  ID0 = as.factor(x_2000[,1]),
  X1 = as.matrix(x_2001[,2]),
  Y1 = as.matrix(y_2001[,2]),
  ID1 =as.factor(x_2001[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2000-2001.
malmquist_productivity_index_2000_2001 <- as.data.frame(malquist_index_2000_2001$m)
technical_change_2000_2001 <- as.data.frame(malquist_index_2000_2001$tc)
efficiency_change_2000_2001 <- as.data.frame(malquist_index_2000_2001$ec)


# test  malmquist productivity index and its components for the period 2001-2002.
malquist_index_2001_2002 <- malmq(
  X0 =as.matrix(x_2001[,2]) ,
  Y0 =as.matrix(y_2001[,2]),
  ID0 = as.factor(x_2001[,1]),
  X1 = as.matrix(x_2002[,2]),
  Y1 = as.matrix(y_2002[,2]),
  ID1 =as.factor(x_2002[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2001-2002.
malmquist_productivity_index_2001_2002 <- as.data.frame(malquist_index_2001_2002$m)
technical_change_2001_2002 <- as.data.frame(malquist_index_2001_2002$tc)
efficiency_change_2001_2002 <- as.data.frame(malquist_index_2001_2002$ec)


# test  malmquist productivity index and its components for the period 2002-2003.
malquist_index_2002_2003 <- malmq(
  X0 =as.matrix(x_2002[,2]) ,
  Y0 =as.matrix(y_2002[,2]),
  ID0 = as.factor(x_2002[,1]),
  X1 = as.matrix(x_2003[,2]),
  Y1 = as.matrix(y_2003[,2]),
  ID1 =as.factor(x_2003[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2002-2003.
malmquist_productivity_index_2002_2003 <- as.data.frame(malquist_index_2002_2003$m)
technical_change_2002_2003 <- as.data.frame(malquist_index_2002_2003$tc)
efficiency_change_2002_2003 <- as.data.frame(malquist_index_2002_2003$ec)


# test  malmquist productivity index and its components for the period 2003-2004.
malquist_index_2003_2004 <- malmq(
  X0 =as.matrix(x_2003[,2]) ,
  Y0 =as.matrix(y_2003[,2]),
  ID0 = as.factor(x_2003[,1]),
  X1 = as.matrix(x_2004[,2]),
  Y1 = as.matrix(y_2004[,2]),
  ID1 =as.factor(x_2004[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2003-2004.
malmquist_productivity_index_2003_2004 <- as.data.frame(malquist_index_2003_2004$m)
technical_change_2003_2004 <- as.data.frame(malquist_index_2003_2004$tc)
efficiency_change_2003_2004 <- as.data.frame(malquist_index_2003_2004$ec)


# test  malmquist productivity index and its components for the period 2004-2005.
malquist_index_2004_2005 <- malmq(
  X0 =as.matrix(x_2004[,2]) ,
  Y0 =as.matrix(y_2004[,2]),
  ID0 = as.factor(x_2004[,1]),
  X1 = as.matrix(x_2005[,2]),
  Y1 = as.matrix(y_2005[,2]),
  ID1 =as.factor(x_2005[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2004-2005.
malmquist_productivity_index_2004_2005 <- as.data.frame(malquist_index_2004_2005$m)
technical_change_2004_2005 <- as.data.frame(malquist_index_2004_2005$tc)
efficiency_change_2004_2005 <- as.data.frame(malquist_index_2004_2005$ec)


# test  malmquist productivity index and its components for the period 2005-2006.
malquist_index_2005_2006 <- malmq(
  X0 =as.matrix(x_2005[,2]) ,
  Y0 =as.matrix(y_2005[,2]),
  ID0 = as.factor(x_2005[,1]),
  X1 = as.matrix(x_2006[,2]),
  Y1 = as.matrix(y_2006[,2]),
  ID1 =as.factor(x_2006[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2005-2006.
malmquist_productivity_index_2005_2006 <- as.data.frame(malquist_index_2005_2006$m)
technical_change_2005_2006 <- as.data.frame(malquist_index_2005_2006$tc)
efficiency_change_2005_2006 <- as.data.frame(malquist_index_2005_2006$ec)


# test  malmquist productivity index and its components for the period 2006-2007.
malquist_index_2006_2007 <- malmq(
  X0 =as.matrix(x_2006[,2]) ,
  Y0 =as.matrix(y_2006[,2]),
  ID0 = as.factor(x_2006[,1]),
  X1 = as.matrix(x_2007[,2]),
  Y1 = as.matrix(y_2007[,2]),
  ID1 =as.factor(x_2007[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2006-2007.
malmquist_productivity_index_2006_2007 <- as.data.frame(malquist_index_2006_2007$m)
technical_change_2006_2007 <- as.data.frame(malquist_index_2006_2007$tc)
efficiency_change_2006_2007 <- as.data.frame(malquist_index_2006_2007$ec)


# test  malmquist productivity index and its components for the period 2007-2008.
malquist_index_2007_2008 <- malmq(
  X0 =as.matrix(x_2007[,2]) ,
  Y0 =as.matrix(y_2007[,2]),
  ID0 = as.factor(x_2007[,1]),
  X1 = as.matrix(x_2008[,2]),
  Y1 = as.matrix(y_2008[,2]),
  ID1 =as.factor(x_2008[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2007-2008.
malmquist_productivity_index_2007_2008 <- as.data.frame(malquist_index_2007_2008$m)
technical_change_2007_2008 <- as.data.frame(malquist_index_2007_2008$tc)
efficiency_change_2007_2008 <- as.data.frame(malquist_index_2007_2008$ec)


# test  malmquist productivity index and its components for the period 2008-2009.
malquist_index_2008_2009 <- malmq(
  X0 =as.matrix(x_2008[,2]) ,
  Y0 =as.matrix(y_2008[,2]),
  ID0 = as.factor(x_2008[,1]),
  X1 = as.matrix(x_2009[,2]),
  Y1 = as.matrix(y_2009[,2]),
  ID1 =as.factor(x_2009[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2008-2009.
malmquist_productivity_index_2008_2009 <- as.data.frame(malquist_index_2008_2009$m)
technical_change_2008_2009 <- as.data.frame(malquist_index_2008_2009$tc)
efficiency_change_2008_2009 <- as.data.frame(malquist_index_2008_2009$ec)


# test  malmquist productivity index and its components for the period 2009-2010.
malquist_index_2009_2010 <- malmq(
  X0 =as.matrix(x_2009[,2]) ,
  Y0 =as.matrix(y_2009[,2]),
  ID0 = as.factor(x_2009[,1]),
  X1 = as.matrix(x_2010[,2]),
  Y1 = as.matrix(y_2010[,2]),
  ID1 =as.factor(x_2010[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2009-2010.
malmquist_productivity_index_2009_2010 <- as.data.frame(malquist_index_2009_2010$m)
technical_change_2009_2010 <- as.data.frame(malquist_index_2009_2010$tc)
efficiency_change_2009_2010 <- as.data.frame(malquist_index_2009_2010$ec)


# test  malmquist productivity index and its components for the period 2010-2011.
malquist_index_2010_2011 <- malmq(
  X0 =as.matrix(x_2010[,2]) ,
  Y0 =as.matrix(y_2010[,2]),
  ID0 = as.factor(x_2010[,1]),
  X1 = as.matrix(x_2011[,2]),
  Y1 = as.matrix(y_2011[,2]),
  ID1 =as.factor(x_2011[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2010-2011.
malmquist_productivity_index_2010_2011 <- as.data.frame(malquist_index_2010_2011$m)
technical_change_2010_2011 <- as.data.frame(malquist_index_2010_2011$tc)
efficiency_change_2010_2011 <- as.data.frame(malquist_index_2010_2011$ec)


# test  malmquist productivity index and its components for the period 2011-2012.
malquist_index_2011_2012 <- malmq(
  X0 =as.matrix(x_2011[,2]) ,
  Y0 =as.matrix(y_2011[,2]),
  ID0 = as.factor(x_2011[,1]),
  X1 = as.matrix(x_2012[,2]),
  Y1 = as.matrix(y_2012[,2]),
  ID1 =as.factor(x_2012[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2011-2012.
malmquist_productivity_index_2011_2012 <- as.data.frame(malquist_index_2011_2012$m)
technical_change_2011_2012 <- as.data.frame(malquist_index_2011_2012$tc)
efficiency_change_2011_2012 <- as.data.frame(malquist_index_2011_2012$ec)


# test  malmquist productivity index and its components for the period 2012-2013.
malquist_index_2012_2013 <- malmq(
  X0 =as.matrix(x_2012[,2]) ,
  Y0 =as.matrix(y_2012[,2]),
  ID0 = as.factor(x_2012[,1]),
  X1 = as.matrix(x_2013[,2]),
  Y1 = as.matrix(y_2013[,2]),
  ID1 =as.factor(x_2013[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2012-2013.
malmquist_productivity_index_2012_2013 <-as.data.frame(malquist_index_2012_2013$m)
technical_change_2012_2013 <- as.data.frame(malquist_index_2012_2013$tc)
efficiency_change_2012_2013 <- as.data.frame(malquist_index_2012_2013$ec)


# test  malmquist productivity index and its components for the period 2013-2014.
malquist_index_2013_2014 <- malmq(
  X0 =as.matrix(x_2013[,2]) ,
  Y0 =as.matrix(y_2013[,2]),
  ID0 = as.factor(x_2013[,1]),
  X1 = as.matrix(x_2014[,2]),
  Y1 = as.matrix(y_2014[,2]),
  ID1 =as.factor(x_2014[,1]),
  RTS = "vrs",
  ORIENTATION = "out"
)


# Extracting components for the period 2013-2014.
malmquist_productivity_index_2013_2014 <- as.data.frame(malquist_index_2013_2014$m)
technical_change_2013_2014 <- as.data.frame(malquist_index_2013_2014$tc)
efficiency_change_2013_2014 <- as.data.frame(malquist_index_2013_2014$ec)



# Sum of malmquist_productivity.  
malquist_productivity_sum<-(malmquist_productivity_index_1990_1991+malmquist_productivity_index_1991_1992+malmquist_productivity_index_1992_1993+malmquist_productivity_index_1993_1994+malmquist_productivity_index_1994_1995+
                                      malmquist_productivity_index_1995_1996+malmquist_productivity_index_1996_1997+malmquist_productivity_index_1997_1998+malmquist_productivity_index_1998_1999+malmquist_productivity_index_1999_2000+
                                      malmquist_productivity_index_2000_2001+malmquist_productivity_index_2001_2002+malmquist_productivity_index_2002_2003+malmquist_productivity_index_2003_2004+malmquist_productivity_index_2004_2005+
                                      malmquist_productivity_index_2005_2006+malmquist_productivity_index_2006_2007+malmquist_productivity_index_2007_2008+malmquist_productivity_index_2008_2009+malmquist_productivity_index_2009_2010+
                                      malmquist_productivity_index_2010_2011+malmquist_productivity_index_2011_2012+malmquist_productivity_index_2012_2013+malmquist_productivity_index_2013_2014)
                                                                              
# Divide each element of the dataframe by 24.
malquist_productivity_mean <- malquist_productivity_sum / 24

# Round malquist_productivity_mean. 
malquist_productivity_mean <- round(malquist_productivity_mean, 3)

# Add 1 extra column to a dataframe.
malquist_productivity_mean<-cbind(country_name,malquist_productivity_mean)


# Mean of technical change.
technical_change_sum<-(technical_change_1990_1991+technical_change_1991_1992+technical_change_1992_1993+technical_change_1993_1994+technical_change_1994_1995+
                        technical_change_1995_1996+technical_change_1996_1997+technical_change_1997_1998+technical_change_1998_1999+technical_change_1999_2000+
                        technical_change_2000_2001+technical_change_2001_2002+technical_change_2002_2003+technical_change_2003_2004+technical_change_2004_2005+
                        technical_change_2005_2006+technical_change_2006_2007+technical_change_2007_2008+technical_change_2008_2009+technical_change_2009_2010+
                        technical_change_2010_2011+technical_change_2011_2012+technical_change_2012_2013+technical_change_2013_2014)

# Divide each element of the dataframe by 24.
technical_change_mean<-technical_change_sum/24

# Round Mean of technical change. 
technical_change_mean <- round(technical_change_mean, 3)

# Add 1 extra column to a dataframe.
technical_change_mean<-cbind(country_name,technical_change_mean)


# Mean of efficiency change.
efficiency_change_sum<-(efficiency_change_1990_1991+efficiency_change_1991_1992+efficiency_change_1992_1993+efficiency_change_1993_1994+efficiency_change_1994_1995+
                        efficiency_change_1995_1996+efficiency_change_1996_1997+efficiency_change_1997_1998+efficiency_change_1998_1999+efficiency_change_1999_2000+
                        efficiency_change_2000_2001+efficiency_change_2001_2002+efficiency_change_2002_2003+efficiency_change_2003_2004+efficiency_change_2004_2005+
                        efficiency_change_2005_2006+efficiency_change_2006_2007+efficiency_change_2007_2008+efficiency_change_2008_2009+efficiency_change_2009_2010+
                        efficiency_change_2010_2011+efficiency_change_2011_2012+efficiency_change_2012_2013+efficiency_change_2013_2014)

# Divide each element of the dataframe by 24
efficiency_change_mean<-efficiency_change_sum/24

# Round Mean of efficiency change. 
efficiency_change_mean <- round(efficiency_change_mean, 3)

# Add 1 extra column to a dataframe.
efficiency_change_mean<-cbind(country_name,efficiency_change_mean)