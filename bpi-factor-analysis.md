---
title: "HIP: Brief Pain Inventory"
subtitle: "Factor analysis"
author: "Peter Kamerman, Tory Madden"
date: "08 March 2018"
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

A factor analysis of the pain intensity and pain inteference components of the Brief Pain Inventory (BPI). Only data recorded at the baseline (time = 0) was used, and only datasets with complete cases were used (i.e., data from _R1_ is excluded because average pain data were not collected). 

----

# Import data


```r
# Get data
bpi_fac <- read_rds('./data/bpi_factor_analysis.rds')
```

----

# Clean data


```r
# Fix column names
names(bpi_fac) <- c('Worst pain', 'Least pain', 'Average pain', 'Pain now',
                    'Activities of daily living', 'Mood', 'Walking', 'Work', 
                    'Relationship with other', 'Sleep', 'Enjoyment of life')
```

----

# Quick look


```r
glimpse(bpi_fac)
```

```
## Observations: 105
## Variables: 11
## $ `Worst pain`                 <int> 8, 9, 5, 7, 7, 8, 10, 10, 9, 0, 1...
## $ `Least pain`                 <int> 4, 1, 1, 10, 2, 3, 3, 5, 3, 0, 3,...
## $ `Average pain`               <int> 4, 4, 3, 5, 4, 6, 6, 7, 6, 0, 6, ...
## $ `Pain now`                   <int> 6, 4, 0, 5, 2, 9, 0, 0, 9, 0, 3, ...
## $ `Activities of daily living` <int> 6, 9, 4, 6, 4, 6, 6, 0, 10, 0, 7,...
## $ Mood                         <int> 8, 10, 0, 7, 6, 7, 8, 8, 0, 0, 4,...
## $ Walking                      <int> 4, 10, 2, 7, 0, 0, 5, 0, 7, 0, 8,...
## $ Work                         <int> 5, 8, 0, 6, 4, 1, 0, 0, 8, 0, 6, ...
## $ `Relationship with other`    <int> 4, 10, 0, 7, 3, 0, 0, 5, 0, 0, 7,...
## $ Sleep                        <int> 2, 10, 0, 9, 2, 0, 0, 8, 10, 0, 0...
## $ `Enjoyment of life`          <int> 3, 9, 1, 9, 4, 5, 5, 5, 6, 0, 3, ...
```

```r
head(bpi_fac)
```

```
## # A tibble: 6 x 11
##   `Worst pain` `Least pain` `Average pain` `Pain now` `Activities of dail…
##          <int>        <int>          <int>      <int>                <int>
## 1            8            4              4          6                    6
## 2            9            1              4          4                    9
## 3            5            1              3          0                    4
## 4            7           10              5          5                    6
## 5            7            2              4          2                    4
## 6            8            3              6          9                    6
## # ... with 6 more variables: Mood <int>, Walking <int>, Work <int>,
## #   `Relationship with other` <int>, Sleep <int>, `Enjoyment of
## #   life` <int>
```

```r
tail(bpi_fac)
```

```
## # A tibble: 6 x 11
##   `Worst pain` `Least pain` `Average pain` `Pain now` `Activities of dail…
##          <int>        <int>          <int>      <int>                <int>
## 1            7            4              5          8                    4
## 2            9            4              9          5                   10
## 3            4            2              5          0                   10
## 4           10            7              5          2                    9
## 5            7            4              5          8                    5
## 6           10            4              3          8                   10
## # ... with 6 more variables: Mood <int>, Walking <int>, Work <int>,
## #   `Relationship with other` <int>, Sleep <int>, `Enjoyment of
## #   life` <int>
```

```r
skim(bpi_fac)
```

```
## Skim summary statistics
##  n obs: 105 
##  n variables: 11 
## 
## Variable type: integer 
##                    variable missing complete   n mean   sd p0 p25 median
##  Activities of daily living       0      105 105 6.22 2.9   0   4      6
##                Average pain       0      105 105 5.3  2.16  0   4      5
##           Enjoyment of life       0      105 105 5.2  3.34  0   3      5
##                  Least pain       0      105 105 3.24 2.03  0   2      3
##                        Mood       0      105 105 6.14 3.34  0   4      7
##                    Pain now       0      105 105 4.11 3.02  0   2      4
##     Relationship with other       0      105 105 4.29 3.33  0   1      4
##                       Sleep       0      105 105 4.85 3.77  0   1      5
##                     Walking       0      105 105 5.04 3.31  0   2      6
##                        Work       0      105 105 5.66 3.26  0   3      6
##                  Worst pain       0      105 105 7.53 2.12  0   6      8
##  p75 p100     hist
##    9   10 ▂▁▂▆▅▃▃▇
##    6   10 ▁▁▂▇▃▁▁▂
##    8   10 ▆▂▃▇▂▂▂▇
##    4   10 ▅▆▇▆▁▁▁▁
##    9   10 ▃▁▁▃▂▂▃▇
##    6   10 ▇▃▅▇▃▁▃▃
##    7   10 ▇▂▃▅▂▂▂▅
##    8   10 ▇▃▂▃▂▂▂▇
##    8   10 ▇▂▂▆▅▃▅▆
##    8   10 ▅▂▂▇▂▂▅▇
##    9   10 ▁▁▁▃▂▅▃▇
```

----

# Factor analysis

### Scree plot


```r
# Scree plot to check whether 2-factor solution is optimal
# Use Pearson's correlation (ordinal data, but enough levels to treat as continuous)
# and maximum likelihood ('ml') factoring method ('minres' gives warnings)
fa.parallel(x = cor(bpi_fac,
                    method = 'pearson'),
            n.obs = 105,
            fm = 'ml',
            fa = 'fa')
```

<img src="figures/bdi-factor-analysis/factor_analysis-1.png" width="672" style="display: block; margin: auto;" />

```
## Parallel analysis suggests that the number of factors =  2  and the number of components =  NA
```

### Factor structure


```r
# Factor analysis with 2-factor solution
(bpi_fa <- fa(r = cor(bpi_fac,
                      method = 'pearson'),
             nfactors = 2,
             n.obs = 105,
             fm = 'ml',
             rotate = 'varimax'))
```

```
## Factor Analysis using method =  ml
## Call: fa(r = cor(bpi_fac, method = "pearson"), nfactors = 2, n.obs = 105, 
##     rotate = "varimax", fm = "ml")
## Standardized loadings (pattern matrix) based upon correlation matrix
##                             ML1  ML2   h2   u2 com
## Worst pain                 0.34 0.47 0.34 0.66 1.8
## Least pain                 0.17 0.83 0.71 0.29 1.1
## Average pain               0.03 0.63 0.39 0.61 1.0
## Pain now                   0.37 0.46 0.34 0.66 1.9
## Activities of daily living 0.69 0.23 0.53 0.47 1.2
## Mood                       0.55 0.21 0.34 0.66 1.3
## Walking                    0.61 0.20 0.41 0.59 1.2
## Work                       0.68 0.18 0.50 0.50 1.1
## Relationship with other    0.70 0.04 0.49 0.51 1.0
## Sleep                      0.55 0.27 0.38 0.62 1.4
## Enjoyment of life          0.65 0.11 0.43 0.57 1.1
## 
##                        ML1  ML2
## SS loadings           3.11 1.76
## Proportion Var        0.28 0.16
## Cumulative Var        0.28 0.44
## Proportion Explained  0.64 0.36
## Cumulative Proportion 0.64 1.00
## 
## Mean item complexity =  1.3
## Test of the hypothesis that 2 factors are sufficient.
## 
## The degrees of freedom for the null model are  55  and the objective function was  3.68 with Chi Square of  366.07
## The degrees of freedom for the model are 34  and the objective function was  0.35 
## 
## The root mean square of the residuals (RMSR) is  0.04 
## The df corrected root mean square of the residuals is  0.06 
## 
## The harmonic number of observations is  105 with the empirical chi square  22.68  with prob <  0.93 
## The total number of observations was  105  with Likelihood Chi Square =  33.9  with prob <  0.47 
## 
## Tucker Lewis Index of factoring reliability =  1.001
## RMSEA index =  0.023  and the 90 % confidence intervals are  0 0.071
## BIC =  -124.33
## Fit based upon off diagonal values = 0.98
## Measures of factor score adequacy             
##                                                    ML1  ML2
## Correlation of (regression) scores with factors   0.91 0.87
## Multiple R square of scores with factors          0.82 0.77
## Minimum correlation of possible factor scores     0.64 0.53
```

```r
# Plot
fa.plot(bpi_fa,
        labels = names(bpi_fac),
        xlim = c(-0.1, 1),
        ylim = c(-0.1, 1),
        xlab = 'MR1: Pain interference',
        ylab = 'MR2: Pain intensity')
```

<img src="figures/bdi-factor-analysis/factor_analysis2-1.png" width="672" style="display: block; margin: auto;" />

----

# Internal consistency

### Correlation matrix


```r
# Correlation matrix
correlate(bpi_fac) %>% 
    rearrange() %>% 
    shave() 
```

```
## # A tibble: 11 x 12
##    rowname      `Average pain` `Least pain` `Worst pain` `Pain now`   Mood
##    <chr>                 <dbl>        <dbl>        <dbl>      <dbl>  <dbl>
##  1 Average pain       NA             NA           NA         NA     NA    
##  2 Least pain          0.527         NA           NA         NA     NA    
##  3 Worst pain          0.320          0.433       NA         NA     NA    
##  4 Pain now            0.260          0.444        0.383     NA     NA    
##  5 Mood                0.197          0.263        0.248      0.279 NA    
##  6 Sleep               0.104          0.367        0.253      0.320  0.367
##  7 Walking             0.130          0.275        0.335      0.267  0.270
##  8 Activities …        0.164          0.273        0.433      0.439  0.438
##  9 Work                0.206          0.254        0.238      0.329  0.373
## 10 Enjoyment o…        0.0945         0.209        0.267      0.210  0.471
## 11 Relationshi…        0.00153        0.171        0.268      0.285  0.425
## # ... with 6 more variables: Sleep <dbl>, Walking <dbl>, `Activities of
## #   daily living` <dbl>, Work <dbl>, `Enjoyment of life` <dbl>,
## #   `Relationship with other` <dbl>
```

```r
# Network plot of correlaton matrix
correlate(bpi_fac) %>%
    network_plot(legend = TRUE,
                 colors = c('red', 'white', 'blue'))
```

<img src="figures/bdi-factor-analysis/internal_consistency-1.png" width="672" style="display: block; margin: auto;" />

### Cronbach alpha and drop 1 analysis


```r
# Generate alpha and drop-1 summary
alpha(bpi_fac)
```

```
## 
## Reliability analysis   
## Call: alpha(x = bpi_fac)
## 
##   raw_alpha std.alpha G6(smc) average_r S/N   ase mean  sd
##       0.85      0.85    0.86      0.33 5.5 0.021  5.2 1.9
## 
##  lower alpha upper     95% confidence boundaries
## 0.8 0.85 0.89 
## 
##  Reliability if an item is dropped:
##                            raw_alpha std.alpha G6(smc) average_r S/N
## Worst pain                      0.84      0.84    0.85      0.34 5.1
## Least pain                      0.84      0.83    0.84      0.34 5.0
## Average pain                    0.85      0.85    0.86      0.36 5.7
## Pain now                        0.84      0.83    0.85      0.34 5.0
## Activities of daily living      0.82      0.82    0.84      0.32 4.6
## Mood                            0.83      0.83    0.85      0.33 5.0
## Walking                         0.83      0.83    0.85      0.33 4.9
## Work                            0.82      0.83    0.84      0.32 4.8
## Relationship with other         0.83      0.83    0.85      0.33 5.0
## Sleep                           0.83      0.83    0.85      0.33 4.9
## Enjoyment of life               0.83      0.83    0.85      0.33 4.9
##                            alpha se
## Worst pain                    0.023
## Least pain                    0.023
## Average pain                  0.021
## Pain now                      0.023
## Activities of daily living    0.025
## Mood                          0.023
## Walking                       0.024
## Work                          0.025
## Relationship with other       0.024
## Sleep                         0.024
## Enjoyment of life             0.024
## 
##  Item statistics 
##                              n raw.r std.r r.cor r.drop mean  sd
## Worst pain                 105  0.56  0.61  0.55   0.48  7.5 2.1
## Least pain                 105  0.55  0.61  0.57   0.48  3.2 2.0
## Average pain               105  0.37  0.44  0.37   0.27  5.3 2.2
## Pain now                   105  0.59  0.61  0.55   0.49  4.1 3.0
## Activities of daily living 105  0.74  0.73  0.71   0.66  6.2 2.9
## Mood                       105  0.65  0.63  0.57   0.54  6.1 3.3
## Walking                    105  0.67  0.65  0.61   0.57  5.0 3.3
## Work                       105  0.72  0.69  0.67   0.62  5.7 3.3
## Relationship with other    105  0.67  0.64  0.59   0.57  4.3 3.3
## Sleep                      105  0.68  0.65  0.60   0.56  4.8 3.8
## Enjoyment of life          105  0.67  0.64  0.60   0.57  5.2 3.3
```

----

# Summary

The scree plot indicates that a two-factor structure is optimal, and a confirmatory two-factor factor analysis indicates partitioning of items onto pain interference and pain intensity factors. 

The internal consistency is good, and does not show major changes when dropping individual items.

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
##  [1] bindrcpp_0.2       skimr_1.0.1        corrr_0.2.1       
##  [4] psych_1.7.8        magrittr_1.5       forcats_0.3.0     
##  [7] stringr_1.3.0      dplyr_0.7.4        purrr_0.2.4       
## [10] readr_1.1.1        tidyr_0.8.0        tibble_1.4.2      
## [13] ggplot2_2.2.1.9000 tidyverse_1.2.1   
## 
## loaded via a namespace (and not attached):
##  [1] nlme_3.1-131.1     bitops_1.0-6       lubridate_1.7.3   
##  [4] httr_1.3.1         rprojroot_1.3-2    prabclus_2.2-6    
##  [7] tools_3.4.3        backports_1.1.2    utf8_1.1.3        
## [10] R6_2.2.2           KernSmooth_2.23-15 lazyeval_0.2.1    
## [13] colorspace_1.3-2   trimcluster_0.1-2  nnet_7.3-12       
## [16] tidyselect_0.2.4   gridExtra_2.3      mnormt_1.5-5      
## [19] compiler_3.4.3     cli_1.0.0          rvest_0.3.2       
## [22] TSP_1.1-5          xml2_1.2.0         labeling_0.3      
## [25] diptest_0.75-7     caTools_1.17.1     scales_0.5.0.9000 
## [28] DEoptimR_1.0-8     mvtnorm_1.0-7      robustbase_0.92-8 
## [31] digest_0.6.15      foreign_0.8-69     rmarkdown_1.9     
## [34] pkgconfig_2.0.1    htmltools_0.3.6    rlang_0.2.0       
## [37] readxl_1.0.0       rstudioapi_0.7     bindr_0.1         
## [40] jsonlite_1.5       mclust_5.4         gtools_3.5.0      
## [43] dendextend_1.7.0   modeltools_0.2-21  Rcpp_0.12.15      
## [46] munsell_0.4.3      viridis_0.5.0      stringi_1.1.6     
## [49] whisker_0.3-2      yaml_2.1.17        MASS_7.3-49       
## [52] flexmix_2.3-14     gplots_3.0.1       plyr_1.8.4        
## [55] grid_3.4.3         parallel_3.4.3     gdata_2.18.0      
## [58] ggrepel_0.7.0      crayon_1.3.4       lattice_0.20-35   
## [61] haven_1.1.1        pander_0.6.1       hms_0.4.1         
## [64] knitr_1.20         pillar_1.2.1       fpc_2.1-11        
## [67] reshape2_1.4.3     codetools_0.2-15   stats4_3.4.3      
## [70] glue_1.2.0         gclus_1.3.1        evaluate_0.10.1   
## [73] modelr_0.1.1       foreach_1.4.4      cellranger_1.1.0  
## [76] gtable_0.2.0       kernlab_0.9-25     assertthat_0.2.0  
## [79] broom_0.4.3        class_7.3-14       viridisLite_0.3.0 
## [82] seriation_1.2-3    iterators_1.0.9    registry_0.5      
## [85] cluster_2.0.6
```
