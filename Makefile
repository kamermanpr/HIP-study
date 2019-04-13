# Create directories if required
$(shell mkdir -p data-cleaned figures outputs outputs/figures/)

# Dummy outputs
DATA = 	data-cleaned/bpi.csv data-cleaned/bpi.rds \
	data-cleaned/demographics.csv data-cleaned/demographics.rds \
	data-cleaned/bdi.csv data-cleaned/bdi.rds \
	data-cleaned/eq5d.csv data-cleaned/eq5d.rds \
	data-cleaned/se6.csv data-cleaned/se6.rds

1S = 	outputs/supplement-01-summary-statistics.html \
		outputs/supplement-01-summary-statistics.md

2S = 	outputs/supplement-02-completeness.html \
		outputs/supplement-02-completeness.md

3S = 	outputs/supplement-03-dropout-predictors.html \
		outputs/supplement-03-dropout-predictors.md

4S = 	outputs/supplement-04-primary-outcome.html \
		outputs/supplement-04-primary-outcome.md

.PHONY: all

all: 	$(DATA) $(1S) $(2S) $(3S) $(4S)

# Clean
clean: 
	rm -rfv figures/ outputs/ data-cleaned/

# Generate data
data-cleaned/bpi.csv data-cleaned/bpi.rds data-cleaned/demographics.csv data-cleaned/demographics.rds data-cleaned/bdi.csv data-cleaned/bdi.rds data-cleaned/eq5d.csv data-cleaned/eq5d.rds data-cleaned/se6.csv data-cleaned/se6.rds: \
clean-data-script.R \
data-original/*.xlsx
	Rscript "$<"

# Generate html and md outputs
outputs/supplement-01-summary-statistics.html outputs/supplement-01-summary-statistics.md: \
supplement-01-summary-statistics.Rmd \
data-cleaned/demographics.rds \
data-cleaned/bpi.rds \
data-cleaned/eq5d.rds \
data-cleaned/se6.rds
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"

outputs/supplement-02-completeness.html outputs/supplement-02-completeness.md: \
supplement-02-completeness.Rmd \
data-cleaned/demographics.rds \
data-cleaned/bpi.rds
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"
	mv figures/supplement-02-completeness outputs/figures/

outputs/supplement-03-dropout-predictors.html outputs/supplement-03-dropout-predictors.md: \
supplement-03-dropout-predictors.Rmd \
data-cleaned/demographics.rds \
data-cleaned/bpi.rds 
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"
	mv figures/supplement-03-dropout-predictors outputs/figures/

outputs/supplement-04-primary-outcome.html outputs/supplement-04-primary-outcome.md: \
supplement-04-primary-outcome.Rmd \
data-cleaned/demographics.rds \
data-cleaned/bpi.rds 
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"
	mv figures/supplement-04-primary-outcome outputs/figures/

