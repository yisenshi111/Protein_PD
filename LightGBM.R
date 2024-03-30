####LightGBM#####
ames <- read.csv("data.csv")
library(mlr3verse)
task = as_task_classif(ames, target = "PD")
task
#Preprocessing
prep = po("removeconstants", ratio = 0.05) #Remove features that are approximately constant: exclude if the proportion of distinct values is less than 5%.
task = prep$train(task)[[1]]
#task
##Split the dataset into training and test sets
set.seed(123)
split = partition(task, ratio = 0.7)
#remotes::install_github("mlr-org/mlr3extralearners")
#install.packages("lightgbm")
library(mlr3extralearners)
learner = lrn("classif.lightgbm") #The lightgbm package needs to be installed

##Hyperparameter tuning
search_space = ps(
    max_bin=p_int(100,300),
    max_depth=p_int(lower= 3, upper= 5),
    num_leaves= p_int(lower =2,upper=30),
    bagging_fraction=p_dbl(lower= 0.8,upper=1),
    feature_fraction=p_dbl(lower= 0.8,upper=1),
    lambda_l1=p_int(lower= 0, upper= 1000),
    lambda_l2=p_int(lower= 0, upper= 1000),
    is_unbalance=T)

at = auto_tuner(
    tuner = tnr("random_search"),
    learner= learner,
    resampling= rsmp("cv", folds= 10), 
    measure= msr("classif.auc"), 
    search_space=search_space,
    term_evals= 50) 
set.seed(1)
at$train(task, row_ids= split$train)
at$tuning_result

#Train the model
learner$param_set$values =
    at$tuning_result$learner_param_vals[[1]]#用调参得到的最优参数更新学习器的超参数
learner$train(task, row_ids = split$train)
#Predict and evaluate on the test set
predictions = learner$predict(task,
                              row_ids = split$test)
predictions$score(msr("classif.auc"))
