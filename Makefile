# Create directories if required
$(shell mkdir -p data-cleaned figures outputs outputs/figures/)

# Dummy outputs
DATA = 	data-cleaned/bpi.csv data-cleaned/bpi.rds \
	data-cleaned/demographics.csv data-cleaned/demographics.rds \ 				
	data-cleaned/bdi.csv data-cleaned/bdi.rds \
	data-cleaned/eq5d.csv data-cleaned/eq5d.rds \
	data-cleaned/se6.csv data-cleaned/se6.rds

1S = 	outputs/supplement-01-completeness.html \
		outputs/supplement-01-completeness.md

2S = 	outputs/supplement-02-summary-statistics.html \
		outputs/supplement-02-summary-statistics.md

3S = 	outputs/Suppl-03-binomial-analysis.html \
	outputs/Suppl-03-binomial-analysis.md

4S = 	outputs/Suppl-04-stimulus-intensity-change.html \
	outputs/Suppl-04-stimulus-intensity-change.md

.PHONY: all

all: 	$(DATA_A) $(1S) $(2S) $(3S) $(4S)

# Clean
clean:
	rm -rfv figures/ outputs/ data-cleaned/

# Generate data
data-cleaned/bpi.csv data-cleaned/bpi.rds data-cleaned/demographics.csv data-cleaned/demographics.rds data-cleaned/bdi.csv data-cleaned/bdi.rds data-cleaned/eq5d.csv data-cleaned/eq5d.rds data-cleaned/se6.csv data-cleaned/se6.rds: \
clean-data.R \
data-original/*.xlsx
	Rscript "$<"

# Generate html and md outputs
outputs/supplement-01-completeness.html outputs/supplement-01-completeness.md: \
supplement-01-completeness.Rmd \
data-cleaned/demographics.rds \
data-cleaned/bpi.rds \
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"
	mv figures/supplement-01-completeness outputs/figures/

outputs/supplement-02-summary-statistics.html outputs/supplement-02-summary-statistics.md: \
supplement-02-summary-statistics.Rmd \
data-cleaned/demographics.rds \
data-cleaned/bpi.rds \
data-cleaned/bdi.rds \
data-cleaned/eq5d.rds \
data-cleaned/se6.rds \
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"
	mv figures/supplement-02-summary-statistics outputs/figures/

outputs/Suppl-03-binomial-analysis.html	outputs/Suppl-03-binomial-analysis.md: \
Suppl-03-binomial-analysis.Rmd \
data-cleaned/SPARS_A.rds \
data-cleaned/SPARS_B.rds
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"
	mv figures/Suppl-03-binomial-analysis outputs/figures/

outputs/Suppl-04-stimulus-intensity-change.html outputs/Suppl-04-stimulus-intensity-change.md: \
Suppl-04-stimulus-intensity-change.Rmd \
data-cleaned/SPARS_A.rds \
data-cleaned/SPARS_B.rds
	Rscript -e "rmarkdown::render('$<', output_dir = 'outputs/')"
	mv figures/Suppl-04-stimulus-intensity-change outputs/figures/
