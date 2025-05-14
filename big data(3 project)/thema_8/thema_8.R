  # Remove all objects from the workspace
  rm(list = ls())
  
  # Close all open graphical devices
  graphics.off()
  install.packages("arules")
  library(arules)
  # Specify the path to your text file
  file_path <- "C:\\Users\\kwstasbenek\\Desktop\\giannakopoulo_8\\Tsagkarakis_3h_ergasia\\fertility\\fertility_Diagnosis.txt"
  
  # Read the text file into a data frame
  data <- read.table(file_path, header = TRUE, sep = ",")
  
  # Display the first few rows of the data frame
  head(data)
  # Assuming your_data is already defined
  colnames(data) <- c(
    "Season",
    "Age",
    "Childish_diseases",
    "Accident_or_serious_trauma",
    "Surgical_intervention",
    "High_fevers_last_year",
    "Alcohol_consumption_frequency",
    "Smoking_habit",
    "Hours_sitting_per_day",
    "Diagnosis"
  )
  
  
  # Add descriptions to the variables
  attr(data$Season, "description") <- "1) winter, 2) spring, 3) Summer, 4) fall.  (-1, -0.33, 0.33, 1)"
  attr(data$Age, "description") <- "18-36  (0, 1)"
  attr(data$Childish_diseases, "description") <- "1) yes, 2) no.  (0, 1)"
  attr(data$Accident_or_serious_trauma, "description") <- "1) yes, 2) no.  (0, 1)"
  attr(data$Surgical_intervention, "description") <- "1) yes, 2) no.  (0, 1)"
  attr(data$High_fevers_last_year, "description") <- "1) less than three months ago, 2) more than three months ago, 3) no.  (-1, 0, 1)"
  attr(data$Alcohol_consumption_frequency, "description") <- "1) several times a day, 2) every day, 3) several times a week, 4) once a week, 5) hardly ever or never  (0, 1)"
  attr(data$Smoking_habit, "description") <- "1) never, 2) occasional 3) daily.  (-1, 0, 1)"
  attr(data$Hours_sitting_per_day, "description") <- "ene-16  (0, 1)"
  attr(data$Diagnosis, "description") <- "normal (N), altered (O)"
  
  # Display the updated data frame
  data
  # remove columns "Age at the time of analysis" and "Hours_sitting_per_day "
  modified_fertility_data <- subset(data, select = -c(Age, `Hours_sitting_per_day`))
  #set data to categorical variables 
  
  modified_fertility_data$Season <- factor(modified_fertility_data$Season, levels = c(-1, -0.33, 0.33,1))
  modified_fertility_data$Childish_diseases<- factor(modified_fertility_data$Childish_diseases, levels = c(0,1))
  modified_fertility_data$Accident_or_serious_trauma<- factor(modified_fertility_data$Accident_or_serious_trauma, levels = c(0,1))
  modified_fertility_data$Surgical_intervention<- factor(modified_fertility_data$Surgical_intervention, levels = c(0,1))
  modified_fertility_data$High_fevers_last_year<- factor(modified_fertility_data$High_fevers_last_year, levels = c(-1,0,1))
  modified_fertility_data$Alcohol_consumption_frequency<- factor(modified_fertility_data$Alcohol_consumption_frequency, levels = c(0, 0.2, 0.4, 0.6,0.8,1.0))
  modified_fertility_data$Smoking_habit<- factor(modified_fertility_data$Smoking_habit, levels = c(-1,0,1))
  modified_fertility_data$Diagnosis<- factor(modified_fertility_data$Diagnosis, levels = c("N","O"))
  
  
  
  # turn data into transaction format
  #transaction format is a data format :each row represent a transaction, each column represent an item and it takes a binary form (1,0) accounting for the presence or abcense of an obeject in the specific tranaction 
  # Apriori is designed to work on transaction format data since it figures out rules for items that frequently co-ccour in transactions 
  #to identify frequently re-occuring item sets, the algorithm calculates support for each possible itemset
  #support in this context being the proportion of transactions, in refference to the total n of transactions that contain the specific itemset
  transactions <- as(modified_fertility_data, "transactions")
  
  # perform apriori
  #apriori algorithm is used to discover these association rules by identifying frequent itemsets
  rules <- apriori(transactions)
  
  # print n of rules 
  #rules in this context refers to a statement that describes potential assosiations between item sets in the daata set, based on pattern recognision 
  cat("Πλήθος Κανόνων:", length(rules), "\n")
  
  # check out rules 
  inspect(rules)
  # support = 0.02,  means that only itemsets that appear in at least 2% of transactions will be considered frequent
  #Confidence measures the probability of the occurrence of the consequent given the presence of the antecedent in a rule
  #confidence=1 means that nly rules with 100% confidence will be considered. This implies that the presence of the antecedent guarantees the presence of the consequent.
  rules <- apriori(transactions, parameter = list(support = 0.02, confidence = 1))
  
  # "Diagnosis=O" is the condition that the right-hand side of the rule should match.
  # rhs stands for right-hand side.
  # grepl is a function in R that searches for a pattern in a character vector and 
  # returns a logical vector indicating whether a match was found in each element of the vector.
  # So, in this line of code, we check the labels of all right-hand side rules produced for Diagnosis="O" and
  # then create a subset containing all the rules with Diagnosis=O.
  # The resulting 'altered_rules' data frame contains rules where the right-hand side matches the pattern "Diagnosis=O".
  
  altered_rules <- subset(rules, subset = grepl("Diagnosis=O", labels(rhs(rules))))
  
  # print/inspect new rules 
  cat("Πλήθος Κανόνων με Diagnosis=altered:", length(altered_rules), "\n")
  inspect(altered_rules)
  
#sort rules by lift
#decreasing=TRUE indicated that the rules will be sorted in a decreasing order 
#lift measured the "strength" of a rule, it is calculated as the ratio of the support of the combined itemset 
#to the product of the individual supports of the antecedent and consequent.
rules_sorted <- sort(altered_rules, by = "lift", decreasing = TRUE)

# define a function to give us if a rule is a super rule 
#comp_rule@lhs %in% rule@lhs checks if each item in the LHS of comp_rule is present in the LHS of rule.
#all(...) ensures that all elements in comp_rule@lhs are present in rule@lhs
#The result, is_subset_lhs, is a logical value indicating whether the LHS of comp_rule is a subset of the LHS of rule
#I use as.character to convert the LHS vectors to character before checking for subset using %in% 
#identical is a function that checks if 2 objects are identical, we apply this to check if the rhs is the same (it is we already know that just to be sure though)
#overall in this function for a comp_rule to be a super rule it need to have identical rhs(with the rule we check) && lhs of theb rule we check must be a subset of comp_rule&& comp_rule needs to ave greater or equal lift value
#is_super_rule_rhs is logical function
is_super_rule_lhs <- function(rule, comp_rule) {
  is_subset_lhs <- all(as.character(comp_rule@lhs) %in% as.character(rule@lhs))
  identical(rule@rhs, comp_rule@rhs) && is_subset_lhs && comp_rule@quality["lift"] >= rule@quality["lift"]
}

#empty list to put the super rules in 
pruned_rules <- list()

#This code applies the lapply function to the list rules_sorted@quality
#I use @quality becasue i couldnt find any other way to itterate through the "rules_sorted" S4 object, and overall that the reason for this whole over-complication
#For each element (current_rule) in the list, it executes the code inside the anonymous function
#current_rule represents an element of the rules_sorted@quality list
#The sapply function is used to apply the is_super_rule_lhs function to each element in pruned_rules to check if current_rule is a super rule compared to any rule in pruned_rules
# If there is no super rule for the current_rule  it is included in the final result (return(current_rule))
#if there is a super rule  it is excluded from the final result (return(NULL))
pruned_rules <- lapply(rules_sorted@quality, function(current_rule) {
  # Check if the current rule is not a super rule based on LHS
  if (!any(sapply(pruned_rules, function(comp_rule) is_super_rule_lhs(current_rule, comp_rule)))) {
    return(current_rule)
  }
  return(NULL)
})

# Filter out NULL values(not super rules)
pruned_rules <- Filter(Negate(is.null), pruned_rules)

# Display pruned rules
cat("Πλήθος Κανόνων μετά την αφαίρεση περιττών κανόνων:", length(pruned_rules), "\n")
View(pruned_rules)

