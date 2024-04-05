###Boruta###
library(Boruta)
data_boruta <- read.csv("data_boruta.csv")
set.seed(123)
boruta_output.PD <- Boruta(PD ~ ., data=data_boruta, pValue = 0.01, mcAdj = TRUE, doTrace = 2)
summary(boruta_output.PD)
####Visualize the importance of features
importance <- as.data.frame(boruta_output.PD$ImpHistory)  #This result term can be interpreted as the variable importance score obtained by Boruta
importance
library(tidyr)
Importance_fig <- gather(importance, key = "Variable", value = "Importance_Value")
library(tidyverse)
library(forcats)
library(ggplot2)
Importance_fig %>% 
  ggplot(aes(x= fct_reorder(Variable,Importance_Value), y=Importance_Value, fill=Variable)) +
  geom_boxplot() +
  theme_classic()+theme(axis.text = element_text(angle = 90,colour = "Black",face = "bold"))+
  labs(x = "", y = "Importance")
