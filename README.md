# Enhancing clinical decision-making: Unleashing the power of Double Machine Learning (DML) and Explainable AI (XAI)

## Introduction

This code repository comprises of the code for the work done based on two problem statements. 

1. The first problem statement is a binary classification problem where the MIMIC-IV [1] medical data is analysed to understand the available latest readings and the most up-to-date readings of vital signs such as blood pressure, heart rate, respiratory rate etc., of the patient, just before the decision of extubating was made is needed and cases where extubation resulted in re-intubation.The aim is to develop a machine learning model(s) that can predict the successful extubation of mechanically ventilated patients using these features and interpret the model’s predictions using LIME.

2. The second problem statement is a regression problem where a situation is faked where extubation (treatment) is contrasted against a situation with no intervention, examining the outcome SOFA score 24 hours later. The aim is to use double machine learning technique for Interactive regression model to explore how extubation impacts patient outcomes by predicting SOFA scores with intervention and withoiut intervention. Also CATE estimations provide insights on how the patient might benifit from extubation and why by providing explanations through LIME.


## BigQueries

The queries used for this work can be found in the BigQuey folder. To run the queries the users must have access to the MIMIC-IV database and BigQuey console [https://cloud.google.com/bigquery?hl=en](https://cloud.google.com/bigquery?hl=en). The instructions to access the database can be found through this link : [https://mimic.physionet.org/](https://mimic.physionet.org/). 


## Datasets

The datasets used for this work can be accessed by cloning this link: [https://github.com/madhushreesv/basic_dataset.git](https://github.com/madhushreesv/basic_dataset.git) or can also be accessed through the "Datasets" folder. 


## Code 

The code can be found inside the "Code" folder. It contains code for both the problem statements.

## Execution steps

Please follow the below instructions to run the code:

1. Go to "Code" folder. 
2. The file can be accessed by clicking on ms22749_dissertation.ipynb file. Google collab [https://colab.google/](https://colab.google/) or Jupiter notebook [https://jupyter.org/](https://jupyter.org/) or [https://code.visualstudio.com/](https://code.visualstudio.com/) can be used to open the code.
2. Please run all the cells in sequential order.
3. Follow the Text cells for descriptions of the code cells and inferences. Inferences and comments are added wherever needed.
5. Execution of some code cells like hypertuning using gridSearchCV,plots,training of Interactive Regression Model etc.,may take longer execution time due to its complexity and the number of records in the dataset.


## Dependencies/Required libraries

* numpy
* pandas
* scikit-learn
* scipy
* matplotlib
* seaborn
* imblearn
* sklearn
* collections
* lime
* doubleml[2]

## References

[1] A. Johnson, L. Bulgarelli, T. Pollard, S. Horng, L. Celi and R. Mark, MIMIC-IV (version 1.0), PhysioNet, 2020.
 
[2] P. Bach, V. Chernozhukov, M. S. Kurz and M. Spindler, "{DoubleML} -- {A}n Object-Oriented Implementation of Double Machine Learning in {P}ython," Journal of Machine Learning Research, vol. 23, pp. 1--6, 2022. 


