
# DSCI522 Group 403 - Student Performance Report

## Motivation & Data Set

Our selected data set summarizes Portuguese high school student’s
academic performance in both Math and Portuguese. For this project we
are trying to answer the question: what are the top five features that
most strongly predict high school student’s performances in their
Portuguese language course? In developing social initiatives to improve
student scores, it could be immensely useful to understand what
attributes play a strong role in predicting performance. Without
identifying these key factors, such initiatives would likely be less
effective and would fail to provide a high return on the school board or
government’s investment.

The data set was sourced from the UCI Machine Learning Repository
(Cortez 2014) which can be found
[here](https://archive.ics.uci.edu/ml/datasets/Student+Performance), and
the original research paper (Cortez and Silva 2008) can be found
[here.](http://www3.dsi.uminho.pt/pcortez/student.pdf) The data was
compiled from official school reports as well as questionnaires provided
to students. Attributes include the student grades, demographic, social
and other school related features. Two datasets are provided regarding
the performance in two distinct subjects: Mathematics (`mat`) and
Portuguese language (`por`), though these datasets do not correspond to
the same students. For the purpose of this analysis, we have decided to
focus only on the Portuguese data set to investigate which student
attributes are the strongest predictors of performance in that subject.

Some key highlights regarding the data set’s attributes:

  - The feature of interest is `G3` which represents the final subject
    grade score at the end of the academic year. The score ranges from 0
    to 20.
  - Multi-categorical attributes such as family size (`famsize`),
    parent’s education (`Fedu`/`Medu`) or weekly study time
    (`studytime`)
  - Binary attributes such as home internet access (`internet`) or
    family educational support (`famsup`)
  - Count attributes such as number of days of absence (`absences`)

## Exploratory Data Analysis

Before building our model, we partitioned the data into a training and
test set (split 80%:20%) and performed exploratory data analysis to
investigate the distribution of our predictive features and explore
whether there are any highly correlated features we might want to omit
from our
analysis.

### Feature Correlations:

<img src="../img/correlation_matrix.png" title="Feature Correlations" width="70%" height="70%" align="middle" />

**Figure 1 - Feature Correlations**

As we can see from Figure 1, our target attribute `G3` has a strong
correlation with attributes `G2` and `G1`. This occurs because `G3` is
the grade issued at the end of the year, while `G1` and `G2` correspond
to the grades for the 1st and 2nd school terms of that year. Though it
will be more difficult to get accurate predictions without these
features, it makes sense to drop them in light of our research question
and motivations outlined above. We’re more interested in which
attributes, other than recent academic performance, will be most
predictive of future academic performance.

### Variable Distributions:

![alt tag](../img/box-plots.png) **Figure 2 - Distribution Boxplots for
Categorical & Binary Features**

Looking at the feature distribution boxplots in Figure 2, we can see
that some of the most noteworthy features include student’s past number
of course failures (`failures`), parental education levels (`Medu`,
`Fedu`), alcohol consumption on weekdays and the weekend (`Dalc`,
`Walc`), and the school they attended (`school`). Each of these appears
to show a clear trend with respect to G3, so we would expect to see some
of these features having strong predictive power in the machine learning
models we
develop.

<img src="../img/absences.png" title="Ridgeplot of Absences Feature" width="50%" height="50%" align="middle" />

**Figure 3 - Ridgeplot of Absences Feature **

Similarly, Figure 3 shows that lower `G3` scores have longer tails of
`absences` counts, indicating this may be a useful predictive feature as
well.

<img src="../img/g3_hist.png" title="Distribution of Response Variable" width="60%" height="60%" align="middle" />

**Figure 4 - Distribution of Response Variable, G3**

Finally, our response variable G3 shows an approximately normal
distribution, with a mean of 11.87 and a median of 12 out of 20. There
are some outliers at the low end (students with a score of 0), which
ends up pulling down the mean value slightly.

## Predictive Modelling

To answer the predictive question posed above, we built and compared
several predictive regression models. We constructed the following
models, optimizing each according to the specified hyperparameters.
Model performance was evaluated using root mean squared error (RMSE).

A total of 5 models were chosen using Scikit Learn (Buitinck et al.
2013), XGBoost (Chen and Guestrin 2016), and Light GBM (Ke et al. 2017):

  - Linear Regression with Lasso (L1)  
  - Linear Regression with Ridge (L2)  
  - Random Forest (L1)  
  - XGBoost Regressor  
  - LightGBM Regressor

The choice for model types stem from the feature extraction
functionalities that they provide, which suit our analysis of top
predictors features. Linear regression models can output the weights of
each feature, while tree models can output the feature importances
according to the node splitting.

We applied the following preprocessing techniques for the data:

  - Standard Scaling for numerical features
  - One-Hot-Encoding for binary/categorical features.

Hyperparameters were tuned with the Bayesian Optimization package
(Nogueira 2017) using 10 fold cross validation. For more details on the
best hyperparameters for each model, please find the stored outputs in
the [data outputs folder](../data/outputs/). The validation results for
each model type is shown in the following:

| Model        | cv\_rmse\_score |
| :----------- | --------------: |
| lm\_lasso    |        2.740778 |
| lm\_ridge    |        2.735043 |
| randomforest |        2.670020 |
| xgb          |        2.704398 |
| lgbm         |        2.726576 |

Using the preprocessed test data, we scored all 5 of the tuned models.
The test results for each tuned model type is as shown:

| Model        | test\_rmse\_score |
| :----------- | ----------------: |
| randomforest |          2.417248 |
| xgb          |          2.452847 |
| lm\_ridge    |          2.481202 |
| lm\_lasso    |          2.483605 |
| lgbm         |          2.577540 |

Based on the results, the RandomForest model performed best with a RMSE
of 2.417.

## Ranked Features & Conclusions

The top 10 ranked features from our Random Forest regression model were
as follows:

![alt tag](../img/ranked_features.png) **Figure 7 - Ranked Features for
Random Forest Model**

For the most part, the results appear to be inline with our expectations
based on the features identified during the EDA process. `failures` and
`absences` are the clear leaders, while many of the other highly
important features were noted during EDA. Figure 7 includes the top 10
features to illustrate that the subsequent 5 most important features
follow closely in terms of their importance scores.

To formally address our research question, the five most predictive
features are:

1.  failures (number of past class failures)
2.  absences (number of school absences)
3.  age (student’s age)
4.  Walc (weekend alcohol consumption)
5.  school (student’s school)

Given that we have identified attributes that are strongly predictive of
academic performance, this information could now be used to develop
social programs or initiatives intending to improve student’s academic
performance. Targeting these specific attributes is likely to improve
the effectiveness of such programs and thereby provide better return on
investment.

## Reflections & Next Steps

**Dropped features:**

We dropped features `G1` and `G2` after our EDA with the intent of
removing features based on recent academic performance. `Failures`,
which ended up being our top predictor, is highly correlated with `G1`
and `G2` and could perhaps be removed in subsequent analysis attempting
to focus on non-academic predictive attributes.

**Math data set:**

For this analysis, we focused on only one of two available student
performance data sets. We looked at student performance in Portuguese,
rather than Math. In the future it would be interesting to explore
whether the same model features are strong predictors across both
subjects, or whether different subjects are predicted better by
different features. We would be curious to see if performance in Math is
strongly predicted by the ‘going out with friends’ attribute, for
example.

**Modelling assumptions:**

In our analysis, we assumed the target variable “G3” as a fully
continuous variable and treated the overall problem as a regression.
However, this is not actually true. Indeed, the variable can take on
discrete values from 0-20 and values such as 1.115 or 19.333 were not
observed.

One might then think to switch to rephrasing this problem as a
multi-class classification instead. However, there is a clear ordering
in the target variable and in particular, the distance between the
predicted score G3 and the actual score is important. If we were to
treat this as a classification problem, an error of predicting a G3
score of 5 for a true G3 of 20 would be viewed the same as an error of
predicting a G3 score of 19 for the same student. This is also
undesirable.

In truth, our problem is neither regression or classification. Our
problem instead is that of ordinal regression, which can be viewed as a
middle ground. We wish to predict discrete labels while still respecting
the relative nature of the labels themselves. Thus, a huge improvement
to our analysis would be to switch to a better framework more suited for
such a response.

# References

<div id="refs" class="references">

<div id="ref-sklearn_api">

Buitinck, Lars, Gilles Louppe, Mathieu Blondel, Fabian Pedregosa,
Andreas Mueller, Olivier Grisel, Vlad Niculae, et al. 2013. “API Design
for Machine Learning Software: Experiences from the Scikit-Learn
Project.” In *ECML Pkdd Workshop: Languages for Data Mining and Machine
Learning*, 108–22.

</div>

<div id="ref-Chen:2016:XST:2939672.2939785">

Chen, Tianqi, and Carlos Guestrin. 2016. “XGBoost: A Scalable Tree
Boosting System.” In *Proceedings of the 22nd Acm Sigkdd International
Conference on Knowledge Discovery and Data Mining*, 785–94. KDD ’16. New
York, NY, USA: ACM. <https://doi.org/10.1145/2939672.2939785>.

</div>

<div id="ref-CortezUCI">

Cortez, Paulo. 2014. “UCI Machine Learning Repository.” University of
California, Irvine, School of Information; Computer Sciences.
<http://archive.ics.uci.edu/ml>.

</div>

<div id="ref-Cortezetal">

Cortez, P., and A. Silva. 2008. “Using Data Mining to Predict Secondary
School Student Performance.” In *Proceedings of 5th Future Business
Technology Conference*, edited by A. Brito and J. Teixeira, 1905:5–12.
FUBUTEC. <https://doi.org/978-9077381-39-7>.

</div>

<div id="ref-Ke2017LightGBMAH">

Ke, Guolin, Qi Meng, Thomas Finley, Taifeng Wang, Wei Chen, Weidong Ma,
Qiwei Ye, and Tie-Yan Liu. 2017. “LightGBM: A Highly Efficient Gradient
Boosting Decision Tree.” In *NIPS*.

</div>

<div id="ref-bayesopt">

Nogueira, Fernando. 2017. *Bayesian Optimization: Pure Python
Implementation of Bayesian Global Optimization with Gaussian Processes.*
<https://github.com/fmfn/BayesianOptimization>.

</div>

</div>
