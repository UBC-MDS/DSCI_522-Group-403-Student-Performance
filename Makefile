# student performance data pipeline
# author(s): Brendon Campbell
# date: 2020-01-29

all: data/output/cv_results.csv data/output/feat_importance.csv data/output/final_results.csv data/output/lgbm_hyperparam.csv data/output/lmlasso_hyperparam.csv data/output/lmridge_hyperparam.csv data/output/rf_hyperparam.csv data/output/xgb_hyperparam.csv img/ranked_features.png img/correlation_matrix.png img/box-plots.png img/absences.png img/g3_hist.png doc/student_performance_report.md

# download data
data/raw/student-por.csv data/raw/student-mat.csv data/raw/student-merge.R data/raw/student.txt: src/data-download.py
	python src/data-download.py https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip --file_path=data/raw
	
# wrangle data (e.g. split into train & test)
data/processed/test.csv data/processed/train.csv: src/wrangling.R data/raw/student-por.csv
	Rscript src/wrangling.R data/raw/student-por.csv data/processed

# exploratory data analysis (e.g. visualize feature correlations and predictor distributions)
img/correlation_matrix.png img/box-plots.png img/absences.png img/g3_hist.png: src/eda.R data/processed/train.csv
	Rscript src/eda.R data/processed/train.csv img

# model selection and feature extraction
data/output/cv_results.csv data/output/feat_importance.csv data/output/final_results.csv data/output/lgbm_hyperparam.csv data/output/lmlasso_hyperparam.csv data/output/lmridge_hyperparam.csv data/output/rf_hyperparam.csv data/output/xgb_hyperparam.csv img/ranked_features.png: data/processed/train.csv data/processed/test.csv 
	python src/modelling.py --train_data_file_path="./data/processed/train.csv" --test_data_file_path="./data/processed/test.csv" --csv_output_dir_path="./data/output/" --image_output_dir_path="./img/"

# render report
doc/student_performance_report.md: doc/student_performance_report.Rmd doc/student_performance_refs.bib
	Rscript -e "rmarkdown::render('doc/student_performance_report.Rmd')"

clean: 
	rm -rf data/output/*
	rm -rf data/processed/*
	rm -rf img/*
	rm -rf doc/student_performance_report.md doc/student_performance_report.html