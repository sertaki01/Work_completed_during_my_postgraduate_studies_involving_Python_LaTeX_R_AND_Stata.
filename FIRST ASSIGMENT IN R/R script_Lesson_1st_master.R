install.packages("AER")
library(AER)
## Example 1-The demand for Economic Journals##
library(AER)
data("Journals")
dim(Journals)
names(Journals)
Journals
str(Journals)
head(Journals)
summary(Journals$price)
plot(Journals$price)
mean(Journals$price)
##Scatter plot##
plot(log(subs)~log(price/citations), data=Journals)
Jlm<-lm(log(subs)~log(price/citations), data=Journals)
abline(Jlm)
summary(Jlm)
##priceper citation##
Journals$citeprice<-Journals$price/Journals$citation
attach(Journals)
dim(Journals)
names(Journals)
plot(log(subs)~log(citeprice), data=Journals)
##add ticks##
rug(log(subs))
rug(log(citeprice),side=2)
detach(Journals)
plot(log(subs)~log(citeprice), data=Journals)
##Plot##
plot(log(subs)~log(citeprice), data=Journals, pch=20, col="blue", ylim=c(0,8), xlim=c(-7,4), main="Library subscriptions")

## Example 2##
data("CPS1985")
str(CPS1985)
head(CPS1985)
## attach##
levels(CPS1985$occupation)[c(2,6)]<-c("tech","mgmt")
attach(CPS1985)
head(CPS1985)
summary(wage)
mean(wage)
median(wage)
var(wage)
sd(wage)
hist(wage, freq=FALSE)
hist(log(wage), freq=FALSE)
lines(density(log(wage)), col=4)
##categorical##
summary(occupation)
tab<-table(occupation)
prop.table(tab)
barplot(tab)
pie(tab)
## 2 categorical##
xtabs(~gender+occupation, data=CPS1985)
plot(gender~occupation, data=CPS1985)
## 2 numerical ##
cor(log(wage),education)
cor(log(wage),education, method="spearman")
plot(log(wage)~education)
tapply(log(wage),gender, mean)
plot(log(wage)~gender)

#Q-Q plot#
mwage<-subset(CPS1985, gender=="male")$wage
fwage<-subset(CPS1985, gender=="female")$wage
qqplot(mwage, fwage, xlim=range(wage), ylim=range(wage), 
       xaxs= "i", yaxs= "i" xlab="male", ylab="female")
qqplot(mwage, fwage, xlim=range(wage), ylim=range(wage))
abline(0,1)

## example 3 ##
library("LearnBayes")
data(studentdata)
studentdata[1,]
attach(studentdata)

table(Drink)
barplot(table(Drink), xlab="Drink", ylab="Count")
hours.of.sleep=WakeUp-ToSleep
summary(hours.of.sleep)
hours.of.sleep~Gender
boxplot(hours.of.sleep~Gender, ylab="Hours of Sleep")
Gender=="female"
Haircut[condition]
female.Haircut=Haircut[Gender=="female"]
summary(female.Haircut)

male.Haircut=Haircut[Gender=="male"]
summary(male.Haircut)
