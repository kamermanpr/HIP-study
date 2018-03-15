---
title: "HIP: Demographic data for the manuscript"
author: "Peter Kamerman"
date: "15 March 2018"
output: 
    html_document:
        theme: yeti
        keep_md: true
        highlight: pygments
        toc: true
        toc_float: true
        code_folding: show
---



----

Basic descriptive statistics of core demographic data at baseline (time = 0 weeks) for males, females, and the whole cohort. 

----

# Import data


```r
# Get data
demo <- read_rds('./data/demographics.rds') %>%
    # Transfer CD4 data to CD4_recent if missing CD4_recent data (i.e. most updated CD4 count available)
    mutate(CD4_uptodate =
                     ifelse(is.na(CD4_recent),
                 CD4,
                 CD4_recent)) %>%
    # Categorise years of schooling into 7 years or less, 8-12 years, and more than 12 years of education
    mutate(Education_category = case_when(
        Years_education <= 7 ~ "0-7 years",
        Years_education > 7 & Years_education <= 12 ~ "8-12 years",
        Years_education > 12 ~ "More than 12 years")) %>%
    # Select required columns
    select(Site,
           Sex,
           Age,
           Years_on_ART,
           CD4_uptodate,
           HIV_mx,
           Education_category,
           SOS_mnemonic)
```

----

# Quick look


```r
glimpse(demo)
```

```
## Observations: 160
## Variables: 8
## $ Site               <chr> "U1", "U1", "U1", "U1", "U1", "U1", "U1", "...
## $ Sex                <chr> "female", "female", "female", "female", "fe...
## $ Age                <dbl> 37, 36, 36, 58, 33, 32, 37, 46, 31, 36, 43,...
## $ Years_on_ART       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
## $ CD4_uptodate       <dbl> 354, 728, 172, 189, NA, 86, 667, 205, 325, ...
## $ HIV_mx             <chr> "first-line", "first-line", "first-line", "...
## $ Education_category <chr> "8-12 years", NA, "8-12 years", "0-7 years"...
## $ SOS_mnemonic       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
```

```r
demo %>% 
    skim_to_wide() %>% 
    select(variable, missing, complete, n) %>%
    mutate_at(.vars = c(2:4),
              .funs = as.numeric) %>% 
    arrange(complete) %>% 
    kable(caption = 'Tabular summary of data completeness')
```



Table: Tabular summary of data completeness

variable              missing   complete     n
-------------------  --------  ---------  ----
Years_on_ART               78         82   160
SOS_mnemonic               47        113   160
CD4_uptodate                8        152   160
HIV_mx                      4        156   160
Education_category          2        158   160
Sex                         0        160   160
Site                        0        160   160
Age                         0        160   160

----

# Sample size


```r
# Sample size by study site
demo %>%
    group_by(Site) %>%
    summarise(count = n()) %>%
    knitr::kable(., 
                 caption = 'Sample size by study site', 
                 col.names = c('Site', 'Count'))
```



Table: Sample size by study site

Site    Count
-----  ------
R1         47
R2         49
U1         47
U2         17

```r
##############################

# Load package
library(tableone)

# Create a variable list which we want in Table 1
listVars <- c("Age", "Site", "CD4_uptodate", "HIV_mx", "Education_category", "SOS_mnemonic")

# Define categorical variables
catVars <- c("Site","HIV_mx","Education_category", "SOS_mnemonic", "Sex")

# Create Table 1
table1 <- CreateTableOne(listVars, demo, catVars, strata = c("Sex"))
```



----

# Session information


```
## R version 3.4.3 (2017-11-30)
## Platform: x86_64-apple-darwin15.6.0 (64-bit)
## Running under: OS X El Capitan 10.11.6
## 
## Matrix products: default
## BLAS: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRblas.0.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] tableone_0.9.2     bindrcpp_0.2       magrittr_1.5      
##  [4] skimr_1.0.1        forcats_0.3.0      stringr_1.3.0     
##  [7] dplyr_0.7.4        purrr_0.2.4        readr_1.1.1       
## [10] tidyr_0.8.0        tibble_1.4.2       ggplot2_2.2.1.9000
## [13] tidyverse_1.2.1   
## 
## loaded via a namespace (and not attached):
##  [1] tidyselect_0.2.4  reshape2_1.4.3    pander_0.6.1     
##  [4] splines_3.4.3     haven_1.1.1       lattice_0.20-35  
##  [7] labelled_1.0.1    colorspace_1.3-2  htmltools_0.3.6  
## [10] yaml_2.1.18       survival_2.41-3   rlang_0.2.0      
## [13] e1071_1.6-8       pillar_1.2.1      foreign_0.8-69   
## [16] glue_1.2.0        modelr_0.1.1      readxl_1.0.0     
## [19] bindr_0.1.1       plyr_1.8.4        munsell_0.4.3    
## [22] gtable_0.2.0      cellranger_1.1.0  rvest_0.3.2      
## [25] psych_1.7.8       evaluate_0.10.1   knitr_1.20       
## [28] class_7.3-14      parallel_3.4.3    highr_0.6        
## [31] broom_0.4.3       Rcpp_0.12.16      scales_0.5.0.9000
## [34] backports_1.1.2   jsonlite_1.5      mnormt_1.5-5     
## [37] hms_0.4.2         digest_0.6.15     stringi_1.1.7    
## [40] survey_3.33-2     grid_3.4.3        rprojroot_1.3-2  
## [43] cli_1.0.0         tools_3.4.3       lazyeval_0.2.1   
## [46] crayon_1.3.4      pkgconfig_2.0.1   MASS_7.3-49      
## [49] Matrix_1.2-12     xml2_1.2.0        lubridate_1.7.3  
## [52] assertthat_0.2.0  rmarkdown_1.9     httr_1.3.1       
## [55] rstudioapi_0.7    R6_2.2.2          nlme_3.1-131.1   
## [58] compiler_3.4.3
```
