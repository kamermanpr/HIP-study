# Create directories if required
$(shell mkdir -p data-cleaned figures outputs outputs/figures/)

# Dummy outputs
DATA = 	data-cleaned/bpi.csv data-cleaned/bpi.rds \
	data-cleaned/demographics.csv data-cleaned/demographics.rds \
	data-cleaned/bdi.csv data-cleaned/bdi.rds \
	data-cleaned/eq5d.csv data-cleaned/eq5d.rds \
	data-cleaned/se6.csv data-cleaned/se6.rds

1S = 	outputs/supplement-01-summary-statistics.pdf

2S = 	outputs/supplement-02-completeness.pdf

3S = 	outputs/supplement-03-dropout-predictors.pdf

4S = 	outputs/supplement-04-primary-outcome.pdf

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
outputs/supplement-01-summary-statistics.pdf: \
supplement-01-summary-statistics.Rmd \
data-cleaned/demographics.rds \
data-cleaned/bpi.rds \
data-cleaned/eq5d.rds \
data-cleaned/se6.rds
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"

outputs/supplement-02-completeness.pdf: \
supplement-02-completeness.Rmd \
data-cleaned/demographics.rds \
data-cleaned/bpi.rds
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"
	mv figures/supplement-02-completeness outputs/figures/

outputs/supplement-03-dropout-predictors.pdf: \
supplement-03-dropout-predictors.Rmd \
data-cleaned/demographics.rds \
data-cleaned/bdi.rds
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"
	mv figures/supplement-03-dropout-predictors outputs/figures/
	
outputs/supplement-04-primary-outcome.pdf: \
outputs/supplement-04-primary-outcome.Rmd \
data-cleaned/demographics.rds \
data-cleaned/bdi.rds
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"
	mv figures/supplement-04-primary-outcome outputs/figures/
