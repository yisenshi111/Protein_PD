####Batch Cox proportional hazard regression#####
data <- read.csv("data_for_cox.csv")
library(ezcox)
column_names <- colnames(data[,2:1464])####Number of columns in which proteins were analyzed
res = ezcox(data, covariates = c(column_names),
                          controls = c("cov1","cov2"),###Adjusted variables
                          time = "time",  ###Time of occurrence of the ending
                          status = "status")  ##Disease status