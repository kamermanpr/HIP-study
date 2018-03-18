---
title: "HIP: Dropout predictors"
subtitle: "Do baseline employment and/or depression predict dropout by week 8?"
author: "Peter Kamerman and Tory Madden"
date: "15 March 2018"
output: 
    html_document:
        theme: yeti
        keep_md: true
        highlight: pygments
        toc: true
        toc_float: true
        code_folding: show
editor_options: 
  chunk_output_type: console
---



----

We assessed two predictors of dropout (employment/stable income, depression) from the study at week 8, with week 8 being two weeks after the completion on the 6 week programme. 

----

# Import data


```r
# Get data
## BPI
bpi <- read_rds('data/bpi.rds') %>% 
    select(ID, Pain_present.Wk8)

## Demographics
demo <- read_rds('data/demographics.rds') %>% 
    select(ID, Site, Group, Sex, Occupation)

## BDI
bdi <- read_rds('data/bdi.rds') %>% 
    select(ID, ends_with('BL'))
```

----

# Quick look


```r
glimpse(bpi)
```

```
## Observations: 160
## Variables: 2
## $ ID               <chr> "J1", "J3", "J4", "J5", "J6", "J7", "J9", "J1...
## $ Pain_present.Wk8 <chr> NA, NA, "Yes", NA, NA, NA, "Yes", "Yes", "Yes...
```

```r
glimpse(demo)
```

```
## Observations: 160
## Variables: 5
## $ ID         <chr> "J1", "J3", "J4", "J5", "J6", "J7", "J9", "J10", "J...
## $ Site       <chr> "U1", "U1", "U1", "U1", "U1", "U1", "U1", "U1", "U1...
## $ Group      <chr> "P", "T", "P", "P", "P", "T", "T", "T", "P", "T", "...
## $ Sex        <chr> "female", "female", "female", "female", "female", "...
## $ Occupation <chr> "employed", NA, "employed", "unemployed - looking f...
```

```r
glimpse(bdi)
```

```
## Observations: 160
## Variables: 22
## $ ID                          <chr> "J1", "J3", "J4", "J5", "J6", "J7"...
## $ Sadness.BL                  <chr> "1", "3", "0", "0", "2", "1", "0",...
## $ Pessimism.BL                <chr> "2", "3", "0", "1", "0", "0", "0",...
## $ Past_failures.BL            <chr> "2", "3", "0", "2", "1", "0", "0",...
## $ Loss_of_pleasure.BL         <chr> "2", "2", "1", "3", "2", "0", "1",...
## $ Guilty_feelings.BL          <chr> "2", "3", "0", "0", "1", "3", "0",...
## $ Punishment_feelings.BL      <chr> "3", "3", "0", "3", "3", "0", "0",...
## $ Self_dislike.BL             <chr> "1", "2", "0", "1", "1", "0", "0",...
## $ Self_critical.BL            <chr> "3", "3", "0", "3", "0", "0", "3",...
## $ Suicidal.BL                 <chr> "3", "1", "0", "0", "1", "0", "0",...
## $ Crying.BL                   <chr> "3", "1", "0", "0", "2", "2", "3",...
## $ Agitation.BL                <chr> "3", "1", "3", "2", "3", "3", "3",...
## $ Loss_of_interest.BL         <chr> "3", "1", "0", "1", "1", "0", "3",...
## $ Indecisiveness.BL           <chr> "2", "2", "0", "3", "2", "0", "1",...
## $ Worthlessness.BL            <chr> "2", "3", "1", "2", "2", "0", "0",...
## $ Loss_of_energy.BL           <chr> "1", "1", "0", "1", "0", "0", "2",...
## $ Sleep.BL                    <chr> "3", "0", "2", "1", "1", "2", "2",...
## $ Irritability.BL             <chr> "2", "3", "0", "1", "2", "3", "1",...
## $ Appetite.BL                 <chr> "1", "1", "0", "2", "0", "2", "0",...
## $ Concentration_difficulty.BL <chr> "3", "1", "0", "2", "1", "0", "2",...
## $ Fatigue.BL                  <chr> "2", "0", "0", "1", "0", "2", "1",...
## $ Loss_of_interest_in_sex.BL  <chr> "2", "1", "1", "3", "3", "2", "1",...
```

----

# Clean data


```r
############################################################
#                                                          #
#                           BPI                            #
#                                                          #
############################################################
# Recode whether there is pain data at week 8  (data completeness)
bpi %<>% 
    select(ID, Pain_present.Wk8) %>% 
    mutate(coding = ifelse(is.na(Pain_present.Wk8), 
                           yes = 'Data missing',
                           no = 'Data available')) %>% 
    select(-Pain_present.Wk8)

############################################################
#                                                          #
#                       Demographics                       #
#                                                          #
############################################################
# Mutate new column to reclassify employment status into income grouping
# Employment status was recoded as stable income (employed or on a grant) 
# or unstable income (all other categories, including being a student).
demo %<>%
    mutate(income_stability = case_when(
        Occupation == "employed" | 
            Occupation == "unable to work - disability grant" ~ "Stable income",
        Occupation == "student/volunteer" | 
            Occupation == "unemployed - looking for work" | 
            Occupation == "unemployed - not looking for work" ~ "Unstable or no income"
        )) %>% 
    select(ID, Site, Group, Sex, income_stability)

# Join with completeness ('bpi') data
demo %<>% 
    right_join(bpi)

############################################################
#                                                          #
#                           BDI                            #
#                                                          #
############################################################
# Calculate BDI total score
bdi %<>% 
    mutate_at(.vars = 2:22,
              .funs = as.integer) %>%
    mutate(Total.BL = rowSums(.[2:22])) 

# Join with demo to get site info
bdi %<>%
    left_join(demo) %>%
    select(ID, Site, Total.BL)

# Convert total BDI scores into categories 
## Site U1 used BDI II
## Site U2, R1, and R2 used BDI I
bdi %<>% 
    mutate(bdi_category = case_when(
    Site == "U1" & Total.BL <  14 ~ "none_minimal",
    Site == "U1" & Total.BL > 13 & Total.BL < 20 ~ "mild",
    Site == "U1" & Total.BL > 19 & Total.BL < 29 ~ "moderate-severe",
    Site == "U1" & Total.BL > 28 ~ "severe",
    Site != "U1" & Total.BL <  11 ~ "none-minimal",
    Site != "U1" & Total.BL > 9 & Total.BL < 19 ~ "mild",
    Site != "U1" & Total.BL > 18 & Total.BL < 30 ~ "moderate-severe",
    Site != "U1" & Total.BL > 29 ~ "severe"))

# Convert bdi category into an ordered factor
bdi %<>% mutate(bdi_category = factor(bdi_category, 
                                      levels = c("none-minimal", 
                                                 "mild", 
                                                 "moderate-severe", 
                                                 "severe"), 
                                      ordered = TRUE))
# Drop Site column
bdi %<>% 
    select(-Site)

# Join with completeness ('bpi') data
bdi %<>% 
    right_join(bpi)
```

----

# Employment/income stability

### Tabulate 

_(no stratification)_


```r
demo %>% group_by(income_stability) %>%
    summarise(count = n()) %>% 
    knitr::kable(.,
                 caption = 'Access to stable income',
                 col.names = c('', 'Count'))
```



Table: Access to stable income

                         Count
----------------------  ------
Stable income               59
Unstable or no income       98
NA                           3

### Null hypothesis significance testing (NHST)


```r
# xtabulate the data
employ <- xtabs(~ income_stability + coding, 
                data = demo)

# Produce mosaic plot
mosaicplot(employ,
           main = 'Income stability vs data completeness',
           xlab = '',
           ylab = '',
           cex = 1.2, 
           color = c('#56B4E9', '#E69F00'))
```

<img src="figures/dropout-predictors/employment_nhst-1.png" width="672" style="display: block; margin: auto;" />

```r
# Fishers exact test
knitr::kable(tidy(fisher.test(employ)),
             caption = 'Association between income stability and data completeness',
             col.names = c('Estimate', 'p-value', 
                           'Lower 95% CI', 'Upper 95% CI',
                           'Method', 'Alternative'),
             digits = 3)
```



Table: Association between income stability and data completeness

 Estimate   p-value   Lower 95% CI   Upper 95% CI  Method                               Alternative 
---------  --------  -------------  -------------  -----------------------------------  ------------
    1.439     0.309          0.691          3.067  Fisher's Exact Test for Count Data   two.sided   

----

# Depression and anxiety

### Tabulate 

_(no stratification)_


```r
bdi %>% group_by(bdi_category) %>%
    summarise(count = n()) %>% 
    knitr::kable(.,
                 caption = 'BDI severity category',
                 col.names = c('', 'Count'))
```



Table: BDI severity category

                   Count
----------------  ------
none-minimal          15
mild                  33
moderate-severe       39
severe                39
NA                    34

### Null hypothesis significance testing (NHST)


```r
# xtabulate the data
depression <- xtabs(~ bdi_category + coding, 
                    data = bdi)

# Produce mosaic plot
mosaicplot(depression,
           main = 'Depression severity vs data completeness',
           xlab = '',
           ylab = '',
           cex = 1.2, 
           color = c('#56B4E9', '#E69F00'))
```

<img src="figures/dropout-predictors/depression_nhst-1.png" width="672" style="display: block; margin: auto;" />

```r
# Logistic regression on ordered independent variable 
model <- glm(factor(coding) ~ bdi_category, 
             data = bdi, 
             family = binomial(link = "logit"))

# Model summary
car::Anova(model)
```

```
## Analysis of Deviance Table (Type II tests)
## 
## Response: factor(coding)
##              LR Chisq Df Pr(>Chisq)  
## bdi_category   9.5066  3    0.02326 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
# Model summary
summary(model)
```

```
## 
## Call:
## glm(formula = factor(coding) ~ bdi_category, family = binomial(link = "logit"), 
##     data = bdi)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.0701  -1.0277  -0.7981   1.2887   2.3272  
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)     -1.0602     0.2994  -3.541 0.000399 ***
## bdi_category.L   1.7355     0.7362   2.357 0.018403 *  
## bdi_category.Q  -0.7766     0.5988  -1.297 0.194703    
## bdi_category.C   0.1179     0.4186   0.282 0.778130    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 161.75  on 125  degrees of freedom
## Residual deviance: 152.25  on 122  degrees of freedom
##   (34 observations deleted due to missingness)
## AIC: 160.25
## 
## Number of Fisher Scoring iterations: 5
```

```r
# Print odds ratios
ci <- exp(confint(model))[-1]
oddR <- data_frame('Item' = names(exp(coef(model))[-1]),
                   'Odds ratio' = round(exp(coef(model))[-1], 3),
                   'Lower 95% CI' = round(ci[1:3], 3),
                   'Upper 95% CI' = round(ci[4:6], 3))

knitr::kable(oddR,
             caption = 'Odds ratio of regression coefficients')
```



Table: Odds ratio of regression coefficients

Item              Odds ratio   Lower 95% CI   Upper 95% CI
---------------  -----------  -------------  -------------
bdi_category.L         5.672          1.713          0.576
bdi_category.Q         0.460          0.099         41.295
bdi_category.C         1.125          0.502          1.285

----

# Study group allocation

### Tabulate 

_(no stratification)_


```r
demo %>% group_by(Group) %>%
    summarise(count = n()) %>% 
    knitr::kable(.,
                 caption = 'Study group allocation',
                 col.names = c('', 'Count'))
```



Table: Study group allocation

      Count
---  ------
P        88
T        72

### Null hypothesis significance testing (NHST)


```r
# xtabulate the data
group <- xtabs(~ Group + coding,  
               data = demo)

# Produce mosaic plot
mosaicplot(group,
           main = 'Study group allocation vs data completeness',
           xlab = 'Study group',
           ylab = '',
           cex = 1.2, 
           color = c('#56B4E9', '#E69F00'))
```

<img src="figures/dropout-predictors/group_nhst-1.png" width="672" style="display: block; margin: auto;" />

```r
# Fishers exact test
knitr::kable(tidy(fisher.test(employ)),
             caption = 'Association between study group allocation and data completeness',
             col.names = c('Estimate', 'p-value', 
                           'Lower 95% CI', 'Upper 95% CI',
                           'Method', 'Alternative'),
             digits = 3)
```



Table: Association between study group allocation and data completeness

 Estimate   p-value   Lower 95% CI   Upper 95% CI  Method                               Alternative 
---------  --------  -------------  -------------  -----------------------------------  ------------
    1.439     0.309          0.691          3.067  Fisher's Exact Test for Count Data   two.sided   

---- 

# Sex

### Tabulate 

_(no stratification)_


```r
demo %>% group_by(Sex) %>%
    summarise(count = n()) %>% 
    knitr::kable(.,
                 caption = 'Sex',
                 col.names = c('', 'Count'))
```



Table: Sex

          Count
-------  ------
female       97
male         63

### Null hypothesis significance testing (NHST)


```r
# xtabulate the data
sex <- xtabs(~ Sex + coding,  
               data = demo)

# Produce mosaic plot
mosaicplot(sex,
           main = 'Sex vs data completeness',
           xlab = '',
           ylab = '',
           cex = 1.2, 
           color = c('#56B4E9', '#E69F00'))
```

<img src="figures/dropout-predictors/sex_nhst-1.png" width="672" style="display: block; margin: auto;" />

```r
# Fishers exact test
knitr::kable(tidy(fisher.test(employ)),
             caption = 'Association between sex and data completeness',
             col.names = c('Estimate', 'p-value', 
                           'Lower 95% CI', 'Upper 95% CI',
                           'Method', 'Alternative'),
             digits = 3)
```



Table: Association between sex and data completeness

 Estimate   p-value   Lower 95% CI   Upper 95% CI  Method                               Alternative 
---------  --------  -------------  -------------  -----------------------------------  ------------
    1.439     0.309          0.691          3.067  Fisher's Exact Test for Count Data   two.sided   

----

# Summary

Income stability, sex, and group allocation did not predict whether or not an individual's data were present at 8 weeks.  However, depression did: those with greater depression (on BDI) were more likely to have been lost to follow-up at the 8-week time point (main effect of depression severity: likelihood ratio = 11.31, df = 3, p = 0.01; OR for linear component of logistic regression = 4.01, 95% CI = 1.68 - 11.59).

----

# Session information


```
## R version 3.4.3 (2017-11-30)
## Platform: x86_64-apple-darwin15.6.0 (64-bit)
## Running under: macOS High Sierra 10.13.3
## 
## Matrix products: default
## BLAS: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRblas.0.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] en_GB.UTF-8/en_GB.UTF-8/en_GB.UTF-8/C/en_GB.UTF-8/en_GB.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] bindrcpp_0.2       coin_1.2-2         survival_2.41-3   
##  [4] broom_0.4.3        forcats_0.3.0      stringr_1.3.0     
##  [7] dplyr_0.7.4        purrr_0.2.4        readr_1.1.1       
## [10] tidyr_0.8.0        tibble_1.4.2       ggplot2_2.2.1.9000
## [13] tidyverse_1.2.1    magrittr_1.5      
## 
## loaded via a namespace (and not attached):
##  [1] httr_1.3.1         jsonlite_1.5       splines_3.4.3     
##  [4] modelr_0.1.1       assertthat_0.2.0   highr_0.6         
##  [7] stats4_3.4.3       cellranger_1.1.0   yaml_2.1.17       
## [10] pillar_1.2.1       backports_1.1.2    lattice_0.20-35   
## [13] quantreg_5.35      glue_1.2.0         digest_0.6.15     
## [16] rvest_0.3.2        minqa_1.2.4        colorspace_1.3-2  
## [19] sandwich_2.4-0     htmltools_0.3.6    Matrix_1.2-12     
## [22] plyr_1.8.4         psych_1.7.8        pkgconfig_2.0.1   
## [25] SparseM_1.77       haven_1.1.1        mvtnorm_1.0-7     
## [28] scales_0.5.0.9000  MatrixModels_0.4-1 lme4_1.1-15       
## [31] mgcv_1.8-23        car_2.1-6          TH.data_1.0-8     
## [34] nnet_7.3-12        lazyeval_0.2.1     pbkrtest_0.4-7    
## [37] cli_1.0.0          mnormt_1.5-5       crayon_1.3.4      
## [40] readxl_1.0.0       evaluate_0.10.1    nlme_3.1-131.1    
## [43] MASS_7.3-49        xml2_1.2.0         foreign_0.8-69    
## [46] tools_3.4.3        hms_0.4.1          multcomp_1.4-8    
## [49] munsell_0.4.3      compiler_3.4.3     rlang_0.2.0       
## [52] grid_3.4.3         nloptr_1.0.4       rstudioapi_0.7    
## [55] rmarkdown_1.9      gtable_0.2.0       codetools_0.2-15  
## [58] reshape2_1.4.3     R6_2.2.2           zoo_1.8-1         
## [61] lubridate_1.7.3    knitr_1.20         bindr_0.1         
## [64] rprojroot_1.3-2    modeltools_0.2-21  stringi_1.1.6     
## [67] parallel_3.4.3     Rcpp_0.12.15
```