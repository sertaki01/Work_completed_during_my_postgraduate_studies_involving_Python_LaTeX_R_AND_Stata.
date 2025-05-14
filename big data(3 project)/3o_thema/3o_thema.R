myData <- data.frame(y=numeric(0), x1=numeric(0),
                     x2=numeric(0),
                     x3=numeric(0),
                     x4=numeric(0),
                     x5=numeric(0),
                     x6=numeric(0))
for (i in 1:4){
  myData[i,] <- runif(7, min=1, max=10)
}
rModel<-lm( y ~ ., data=myData)
print(rModel$coefficients)
# Check correlation matrix
cor(myData)

# Get the design matrix from the linear model
design_matrix <- model.matrix(rModel)

# Check the condition number
condition_number <- kappa(design_matrix)
print(condition_number)
#check more diagnostics in the model 
summary(rModel)
