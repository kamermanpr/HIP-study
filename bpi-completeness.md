---
title: "HIP: Brief Pain Inventory"
subtitle: "Data completeness"
author: "Peter Kamerman"
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

A descriptive analysis of the completeness of the Brief Pain Inventory data.

----

# Import data


```r
# Read in bpi data
bpi <- read_rds('./data/bpi.rds') 

# Read in site and group info
foo <- read_rds('./data/demographics.rds') %>%
    select(ID, Site, Group, Sex)

# Join the two datasets 
bpi %<>%
    left_join(foo)
    
# Remove foo
rm(foo)
```

----

# Quick look 


```r
glimpse(bpi)
```

```
## Observations: 160
## Variables: 88
## $ ID                              <chr> "J1", "J3", "J4", "J5", "J6", ...
## $ Pain_present.BL                 <chr> "Yes", "Yes", "Yes", "Yes", "Y...
## $ Pain_present.Wk4                <chr> NA, NA, "Yes", NA, NA, "Yes", ...
## $ Pain_present.Wk8                <chr> NA, NA, "Yes", NA, NA, NA, "Ye...
## $ Pain_present.Wk12               <chr> NA, NA, "Yes", NA, NA, NA, "Ye...
## $ Pain_present.Wk24               <chr> NA, NA, "Yes", NA, NA, NA, "Ye...
## $ Pain_present.Wk48               <chr> NA, NA, "Yes", NA, NA, NA, "Ye...
## $ Worst_pain.BL                   <int> 8, 9, 5, 7, 7, 8, 10, 10, 9, 0...
## $ Worst_pain.Wk4                  <int> NA, NA, 3, NA, NA, 8, 8, 9, 8,...
## $ Worst_pain.Wk8                  <int> NA, NA, 0, NA, NA, NA, 8, 9, 1...
## $ Worst_pain.Wk12                 <int> NA, NA, 3, NA, NA, NA, 7, 9, 1...
## $ Worst_pain.Wk24                 <int> NA, NA, 6, NA, NA, NA, 7, 9, N...
## $ Worst_pain.Wk48                 <int> NA, NA, 6, NA, NA, NA, 7, 8, N...
## $ Least_pain.BL                   <int> 4, 1, 1, 10, 2, 3, 3, 5, 3, 0,...
## $ Least_pain.Wk4                  <int> NA, NA, 1, NA, NA, 3, 5, 4, 2,...
## $ Least_pain.Wk8                  <int> NA, NA, 0, NA, NA, NA, 3, 4, 5...
## $ Least_pain.Wk12                 <int> NA, NA, 1, NA, NA, NA, 3, 6, 5...
## $ Least_pain.Wk24                 <int> NA, NA, 2, NA, NA, NA, 3, 5, N...
## $ Least_pain.Wk48                 <int> NA, NA, 2, NA, NA, NA, 3, 5, N...
## $ Average_pain.BL                 <int> 4, 4, 3, 5, 4, 6, 6, 7, 6, 0, ...
## $ Average_pain.Wk4                <int> NA, NA, 1, NA, NA, 5, 5, 6, 5,...
## $ Average_pain.Wk8                <int> NA, NA, 0, NA, NA, NA, 5, 7, 8...
## $ Average_pain.Wk12               <int> NA, NA, 2, NA, NA, NA, 4, 7, 7...
## $ Average_pain.Wk24               <int> NA, NA, 4, NA, NA, NA, 5, 7, N...
## $ Average_pain.Wk48               <int> NA, NA, 4, NA, NA, NA, 5, 7, N...
## $ Pain_now.BL                     <int> 6, 4, 0, 5, 2, 9, 0, 0, 9, 0, ...
## $ Pain_now.Wk4                    <int> NA, NA, 0, NA, NA, 8, 8, 4, 6,...
## $ Pain_now.Wk8                    <int> NA, NA, 0, NA, NA, NA, 3, 5, 1...
## $ Pain_now.Wk12                   <int> NA, NA, 2, NA, NA, NA, 8, 5, 1...
## $ Pain_now.Wk24                   <int> NA, NA, 2, NA, NA, NA, 3, 8, N...
## $ Pain_now.Wk48                   <int> NA, NA, 4, NA, NA, NA, 3, 2, N...
## $ Receiving_rx.BL                 <chr> "Panado", "Nil", "Nil", "Parac...
## $ Receiving_rx.Wk4                <chr> NA, NA, "Nil", NA, NA, "Parace...
## $ Receiving_rx.Wk8                <chr> NA, NA, "Nil", NA, NA, NA, "St...
## $ Receiving_rx.Wk12               <chr> NA, NA, "Panado", NA, NA, NA, ...
## $ Receiving_rx.Wk24               <chr> NA, NA, "Panado", NA, NA, NA, ...
## $ Receiving_rx.Wk48               <chr> NA, NA, "Nil", NA, NA, NA, "My...
## $ Relief_rx.BL                    <int> 0, 0, NA, 70, 10, 80, 10, 0, 3...
## $ Relief_rx.Wk4                   <int> NA, NA, NA, NA, NA, 40, 20, 0,...
## $ Relief_rx.Wk8                   <int> NA, NA, NA, NA, NA, NA, 30, 0,...
## $ Relief_rx.Wk12                  <int> NA, NA, 80, NA, NA, NA, 20, 0,...
## $ Relief_rx.Wk24                  <int> NA, NA, 50, NA, NA, NA, 30, 0,...
## $ Relief_rx.Wk48                  <int> NA, NA, NA, NA, NA, NA, 60, 40...
## $ Activities_of_daily_living.BL   <int> 6, 9, 4, 6, 4, 6, 6, 0, 10, 0,...
## $ Activities_of_daily_living.Wk4  <int> NA, NA, 0, NA, NA, 9, 5, 9, 0,...
## $ Activities_of_daily_living.Wk8  <int> NA, NA, 0, NA, NA, NA, 5, 8, 1...
## $ Activities_of_daily_living.Wk12 <int> NA, NA, 0, NA, NA, NA, 5, 8, 1...
## $ Activities_of_daily_living.Wk24 <int> NA, NA, 6, NA, NA, NA, 5, 5, N...
## $ Activities_of_daily_living.Wk48 <int> NA, NA, 5, NA, NA, NA, 6, 6, N...
## $ Mood.BL                         <int> 8, 10, 0, 7, 6, 7, 8, 8, 0, 0,...
## $ Mood.Wk4                        <int> NA, NA, 0, NA, NA, 0, 6, 6, 0,...
## $ Mood.Wk8                        <int> NA, NA, 0, NA, NA, NA, 3, 7, 3...
## $ Mood.Wk12                       <int> NA, NA, 4, NA, NA, NA, 7, 4, 1...
## $ Mood.Wk24                       <int> NA, NA, 7, NA, NA, NA, 7, 6, N...
## $ Mood.Wk48                       <int> NA, NA, 7, NA, NA, NA, 8, 5, N...
## $ Walking.BL                      <int> 4, 10, 2, 7, 0, 0, 5, 0, 7, 0,...
## $ Walking.Wk4                     <int> NA, NA, 0, NA, NA, 0, 7, 0, 0,...
## $ Walking.Wk8                     <int> NA, NA, 0, NA, NA, NA, 4, 7, 7...
## $ Walking.Wk12                    <int> NA, NA, 2, NA, NA, NA, 7, 7, 1...
## $ Walking.Wk24                    <int> NA, NA, 5, NA, NA, NA, 6, 4, N...
## $ Walking.Wk48                    <int> NA, NA, 4, NA, NA, NA, 8, 4, N...
## $ Work.BL                         <int> 5, 8, 0, 6, 4, 1, 0, 0, 8, 0, ...
## $ Work.Wk4                        <int> NA, NA, 0, NA, NA, 0, 4, 3, 0,...
## $ Work.Wk8                        <int> NA, NA, 0, NA, NA, NA, 1, 3, 1...
## $ Work.Wk12                       <int> NA, NA, 0, NA, NA, NA, 3, 4, 1...
## $ Work.Wk24                       <int> NA, NA, 5, NA, NA, NA, 5, 5, N...
## $ Work.Wk48                       <int> NA, NA, 5, NA, NA, NA, NA, 5, ...
## $ Relationship_with_others.BL     <int> 4, 10, 0, 7, 3, 0, 0, 5, 0, 0,...
## $ Relationship_with_others.Wk4    <int> NA, NA, 0, NA, NA, 10, 3, 0, 0...
## $ Relationship_with_others.Wk8    <int> NA, NA, 0, NA, NA, NA, 1, 4, 6...
## $ Relationship_with_others.Wk12   <int> NA, NA, 2, NA, NA, NA, 2, 4, 7...
## $ Relationship_with_others.Wk24   <int> NA, NA, 6, NA, NA, NA, 7, 6, N...
## $ Relationship_with_others.Wk48   <int> NA, NA, 5, NA, NA, NA, 6, 6, N...
## $ Sleep.BL                        <int> 2, 10, 0, 9, 2, 0, 0, 8, 10, 0...
## $ Sleep.Wk4                       <int> NA, NA, 0, NA, NA, 7, 8, 6, 10...
## $ Sleep.Wk8                       <int> NA, NA, 0, NA, NA, NA, 8, 0, 1...
## $ Sleep.Wk12                      <int> NA, NA, 0, NA, NA, NA, 4, 6, 1...
## $ Sleep.Wk24                      <int> NA, NA, 3, NA, NA, NA, 7, 4, N...
## $ Sleep.Wk48                      <int> NA, NA, 0, NA, NA, NA, 7, 7, N...
## $ Enjoyment_of_life.BL            <int> 3, 9, 1, 9, 4, 5, 5, 5, 6, 0, ...
## $ Enjoyment_of_life.Wk4           <int> NA, NA, 0, NA, NA, 6, 3, 0, 0,...
## $ Enjoyment_of_life.Wk8           <int> NA, NA, 0, NA, NA, NA, 2, 5, 1...
## $ Enjoyment_of_life.Wk12          <int> NA, NA, 0, NA, NA, NA, 2, 4, 1...
## $ Enjoyment_of_life.Wk24          <int> NA, NA, 5, NA, NA, NA, 5, 4, N...
## $ Enjoyment_of_life.Wk48          <int> NA, NA, 5, NA, NA, NA, 5, 8, N...
## $ Site                            <chr> "U1", "U1", "U1", "U1", "U1", ...
## $ Group                           <chr> "P", "T", "P", "P", "P", "T", ...
## $ Sex                             <chr> "female", "female", "female", ...
```

```r
skim_to_list(bpi) %>% 
    map(~ select(.x, variable, missing, complete, n)) %>% 
    walk(~ print(.x, n = 100))
```

```
## # A tibble: 16 x 4
##    variable          missing complete n    
##  * <chr>             <chr>   <chr>    <chr>
##  1 Group             0       160      160  
##  2 ID                0       160      160  
##  3 Pain_present.BL   16      144      160  
##  4 Pain_present.Wk12 79      81       160  
##  5 Pain_present.Wk24 73      87       160  
##  6 Pain_present.Wk4  57      103      160  
##  7 Pain_present.Wk48 82      78       160  
##  8 Pain_present.Wk8  58      102      160  
##  9 Receiving_rx.BL   52      108      160  
## 10 Receiving_rx.Wk12 94      66       160  
## 11 Receiving_rx.Wk24 104     56       160  
## 12 Receiving_rx.Wk4  89      71       160  
## 13 Receiving_rx.Wk48 87      73       160  
## 14 Receiving_rx.Wk8  91      69       160  
## 15 Sex               0       160      160  
## 16 Site              0       160      160  
## # A tibble: 72 x 4
##    variable                        missing complete n    
##  * <chr>                           <chr>   <chr>    <chr>
##  1 Activities_of_daily_living.BL   18      142      160  
##  2 Activities_of_daily_living.Wk12 79      81       160  
##  3 Activities_of_daily_living.Wk24 73      87       160  
##  4 Activities_of_daily_living.Wk4  57      103      160  
##  5 Activities_of_daily_living.Wk48 82      78       160  
##  6 Activities_of_daily_living.Wk8  58      102      160  
##  7 Average_pain.BL                 51      109      160  
##  8 Average_pain.Wk12               94      66       160  
##  9 Average_pain.Wk24               104     56       160  
## 10 Average_pain.Wk4                89      71       160  
## 11 Average_pain.Wk48               114     46       160  
## 12 Average_pain.Wk8                91      69       160  
## 13 Enjoyment_of_life.BL            17      143      160  
## 14 Enjoyment_of_life.Wk12          79      81       160  
## 15 Enjoyment_of_life.Wk24          74      86       160  
## 16 Enjoyment_of_life.Wk4           57      103      160  
## 17 Enjoyment_of_life.Wk48          82      78       160  
## 18 Enjoyment_of_life.Wk8           58      102      160  
## 19 Least_pain.BL                   16      144      160  
## 20 Least_pain.Wk12                 79      81       160  
## 21 Least_pain.Wk24                 73      87       160  
## 22 Least_pain.Wk4                  58      102      160  
## 23 Least_pain.Wk48                 82      78       160  
## 24 Least_pain.Wk8                  58      102      160  
## 25 Mood.BL                         18      142      160  
## 26 Mood.Wk12                       79      81       160  
## 27 Mood.Wk24                       73      87       160  
## 28 Mood.Wk4                        58      102      160  
## 29 Mood.Wk48                       82      78       160  
## 30 Mood.Wk8                        58      102      160  
## 31 Pain_now.BL                     16      144      160  
## 32 Pain_now.Wk12                   79      81       160  
## 33 Pain_now.Wk24                   73      87       160  
## 34 Pain_now.Wk4                    57      103      160  
## 35 Pain_now.Wk48                   82      78       160  
## 36 Pain_now.Wk8                    58      102      160  
## 37 Relationship_with_others.BL     19      141      160  
## 38 Relationship_with_others.Wk12   79      81       160  
## 39 Relationship_with_others.Wk24   73      87       160  
## 40 Relationship_with_others.Wk4    57      103      160  
## 41 Relationship_with_others.Wk48   82      78       160  
## 42 Relationship_with_others.Wk8    58      102      160  
## 43 Relief_rx.BL                    65      95       160  
## 44 Relief_rx.Wk12                  102     58       160  
## 45 Relief_rx.Wk24                  117     43       160  
## 46 Relief_rx.Wk4                   99      61       160  
## 47 Relief_rx.Wk48                  121     39       160  
## 48 Relief_rx.Wk8                   104     56       160  
## 49 Sleep.BL                        17      143      160  
## 50 Sleep.Wk12                      79      81       160  
## 51 Sleep.Wk24                      73      87       160  
## 52 Sleep.Wk4                       57      103      160  
## 53 Sleep.Wk48                      82      78       160  
## 54 Sleep.Wk8                       58      102      160  
## 55 Walking.BL                      17      143      160  
## 56 Walking.Wk12                    79      81       160  
## 57 Walking.Wk24                    75      85       160  
## 58 Walking.Wk4                     57      103      160  
## 59 Walking.Wk48                    82      78       160  
## 60 Walking.Wk8                     58      102      160  
## 61 Work.BL                         17      143      160  
## 62 Work.Wk12                       78      82       160  
## 63 Work.Wk24                       74      86       160  
## 64 Work.Wk4                        58      102      160  
## 65 Work.Wk48                       83      77       160  
## 66 Work.Wk8                        58      102      160  
## 67 Worst_pain.BL                   16      144      160  
## 68 Worst_pain.Wk12                 79      81       160  
## 69 Worst_pain.Wk24                 73      87       160  
## 70 Worst_pain.Wk4                  57      103      160  
## 71 Worst_pain.Wk48                 82      78       160  
## 72 Worst_pain.Wk8                  59      101      160
```

Looking at the missing data column in the `skimr::skim` output, missing data for the first question (`Pain_present`) is a good proxy of missing data across all other questions (i.e., participant had or had not answered the entire questionnaire at a given time point). As such, our analysis of data completeness will only include an assessment of the `Pain_present` data.

----

# Clean data


```r
# Gather into long format and process time/question column
bpi %<>%
    select(ID, Site, Group, starts_with('Pain_present')) %>% 
    gather(key = question,
           value = answer,
           -ID, - Site, - Group) %>%
    # Separate pain_question into constituent parts
    separate(col = question, 
             into = c('question', 'time'),
             sep = '\\.') %>%
    # Convert time points to integer
    ungroup() %>%
    mutate(time = str_replace(string = time, 
                              pattern = 'Wk',
                              replacement = ''),
           time = str_replace(string = time, 
                              pattern = 'BL',
                              replacement = '0'),
           time = as.integer(time)) 
```

----

# Data completeness

### Study site


```r
bpi %>%
    # Code whether data in bdi_rating is missing or not
    mutate(coding = ifelse(is.na(answer), 
                           yes = 'Missing data',
                           no = 'Data available')) %>% 
    # Get nominal sample size for each site
    group_by(Site, time) %>% 
    mutate(sample_size = n()) %>%
    ungroup() %>% 
    mutate(Site = paste0(Site, ' (n = ', sample_size, ')')) %>% 
    # Plot
    ggplot(data = .) +
    aes(x = question) +
    geom_bar(aes(fill = coding),
             position = position_fill()) +
    labs(title = 'Completeness of data for the BPI questionnaire at each study site',
         subtitle = "Nominal sample size at each site is given in the 'Site' facet label",
         x = 'Time (weeks)',
         y = 'Proportion of participants') +
    scale_fill_brewer(type = 'qual', 
                      palette = 'Dark2') +
    facet_grid(Site ~ time,
               labeller = label_both) +
    theme(legend.position = 'top',
          legend.title = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank())
```

<img src="figures/bpi-completeness/completeness_site-1.png" width="864" style="display: block; margin: auto;" />

### Study site and group


```r
complete_group <- bpi %>%
    # Code whether data in bdi_rating is missing or not
    mutate(coding = ifelse(is.na(answer), 
                           yes = 'Missing data',
                           no = 'Data available')) %>% 
    # Nest
    group_by(Site) %>% 
    nest() %>% 
    arrange(Site) %>%
    # Calculate nominal number of participants per Site
    mutate(summary_p = map(.x = data,
                           ~ filter(.data = .x, 
                                    Group == 'p') %>%
                               summarise(count = as.integer(
                                   sum(!is.na(ID)) / 6))),
           summary_t = map(.x = data,
                           ~ filter(.data = .x, 
                                    Group == 't') %>% 
                               summarise(count = as.integer(
                                   sum(!is.na(ID)) / 6)))) %>% 
    # Plot data
    mutate(plot = pmap(.l = list(data, Site, 
                                 summary_p, summary_t),
                       ~ ggplot(data = ..1) +
                           aes(x = question,
                               fill = coding) +
                           geom_bar(position = position_fill()) +
                           labs(title = str_glue('Site: {..2} - Completeness of data for the BPI questionnaire for each intervention group'),
                                subtitle = str_glue('Nominal sample size (Group P): {..3}\nNominal sample size (Group T): {..4}'),
                                x = 'Time (weeks)',
                                y = 'Proportion of participants') +
                           scale_fill_brewer(type = 'qual', 
                                             palette = 'Dark2') +
                           facet_grid(Group ~ time, 
                                      labeller = label_both) +
                           theme(legend.position = 'top',
                                 legend.title = element_blank(),
                                 axis.text.x = element_blank(),
                                 axis.ticks.x = element_blank()))) 

# Print output
walk(.x = complete_group$plot, ~ print(.x))
```

<img src="figures/bpi-completeness/completeness_group-1.png" width="864" style="display: block; margin: auto;" /><img src="figures/bpi-completeness/completeness_group-2.png" width="864" style="display: block; margin: auto;" /><img src="figures/bpi-completeness/completeness_group-3.png" width="864" style="display: block; margin: auto;" /><img src="figures/bpi-completeness/completeness_group-4.png" width="864" style="display: block; margin: auto;" />

----

# Summary

Other than site _R1_, the other sites have 100% or near 100% (_U1_) records at baseline (time = 0 weeks), thereafter, there is a trend for progressively more incomplete data over time. 

----

## Session information

```r
sessionInfo()
```

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
##  [1] bindrcpp_0.2       skimr_1.0.1        magrittr_1.5      
##  [4] forcats_0.3.0      stringr_1.3.0      dplyr_0.7.4       
##  [7] purrr_0.2.4        readr_1.1.1        tidyr_0.8.0       
## [10] tibble_1.4.2       ggplot2_2.2.1.9000 tidyverse_1.2.1   
## 
## loaded via a namespace (and not attached):
##  [1] tidyselect_0.2.4   reshape2_1.4.3     pander_0.6.1      
##  [4] haven_1.1.1        lattice_0.20-35    colorspace_1.3-2  
##  [7] htmltools_0.3.6    yaml_2.1.17        utf8_1.1.3        
## [10] rlang_0.2.0        pillar_1.2.1       foreign_0.8-69    
## [13] glue_1.2.0         RColorBrewer_1.1-2 modelr_0.1.1      
## [16] readxl_1.0.0       bindr_0.1          plyr_1.8.4        
## [19] munsell_0.4.3      gtable_0.2.0       cellranger_1.1.0  
## [22] rvest_0.3.2        psych_1.7.8        evaluate_0.10.1   
## [25] labeling_0.3       knitr_1.20         parallel_3.4.3    
## [28] broom_0.4.3        Rcpp_0.12.15       scales_0.5.0.9000 
## [31] backports_1.1.2    jsonlite_1.5       mnormt_1.5-5      
## [34] hms_0.4.1          digest_0.6.15      stringi_1.1.6     
## [37] grid_3.4.3         rprojroot_1.3-2    cli_1.0.0         
## [40] tools_3.4.3        lazyeval_0.2.1     crayon_1.3.4      
## [43] pkgconfig_2.0.1    xml2_1.2.0         lubridate_1.7.3   
## [46] assertthat_0.2.0   rmarkdown_1.9      httr_1.3.1        
## [49] rstudioapi_0.7     R6_2.2.2           nlme_3.1-131.1    
## [52] compiler_3.4.3
```
