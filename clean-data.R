############################################################
#                                                          #
#                 Extract data from Excel                  #
#                                                          #
############################################################

############################################################
#                                                          #
#           Note: The original demographic data            #
#           that this script cleans is available           #
#              on request only. The data have              #
#        not been made publically available because        #
#              of the potential for personal               #
#        identification. However, we have made this        #
#        cleaning script available, which shows all        #
#       steps executed during the cleaning process.        #
#                                                          #
############################################################

# Load packages
library(readxl)
library(tidyverse)
library(magrittr)

############################################################
#                                                          #
#                       Demographics                       #
#                                                          #
############################################################
# Group E (for removal later)
# Group E was an additonal group in the U1 cohort, 
# and was not part of the core study.
group_e <- c('J2', 'J8', 'J13', 'J14', 'J15', 'J16', 'J20', 'J21', 'J25', 
             'J26', 'J27', 'J28', 'J39', 'J47', 'J48', 'J50', 'J58', 
             'J63', 'J64', 'J65', 'J66', 'J69', 'J70')

# Extract demographic information
demographics <- read_excel(path = 'data-original/demographics.xlsx', 
                           sheet = "demographics") %>%
    # Remove empty rows 
    filter(!is.na(Nr)) %>%
    # Convert '9999' missing to <NA>
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .))) %>%
    # Remove unnessary columns
    select(-X__1, -X__2, -`CM Dx`, -DOB, -DOD, 
           -Duration, -Infections, -Language) %>%
    # Fix column names
    rename(ID = Nr,
           Study_site = `Clinical Site`,
           Years_on_ART = `Years since ARV start`,
           Age_years = Age,
           CD4_recent = `Recent CD4`,
           CD4_nadir = CD4,
           HAART = `HIV Mx`,
           HIV_stage = `HIV Stage`,
           Highest_level_of_education = HLOE,
           Years_of_schooling = `Years of schooling`,
           SOS_mnemonic = `SOS Mnemonic`) %>%
    # Fix column formating
    mutate(# CD4
           CD4_nadir = round(CD4_nadir),
           # Recent CD4
           CD4_recent = round(CD4_recent)) %>%
    # Convert all text to lowercase
    mutate_if(.predicate = is.character, 
              .funs = str_to_lower) %>% 
    # Convert ID, Group, Site back to uppercase
    mutate_at(.vars = c('ID', 'Group', 'Study_site'), 
              .funs = str_to_upper)

# Have a look
glimpse(demographics)

# Check levels of character classes
demographics %>%
    select_if(is.character) %>%
    as.list(.) %>%
    purrr::map(unique)

# Further cleaning after inspecting data
demographics %<>%
    # Simplify analgesics column
    mutate(Adjuvant = case_when(
        str_detect(.$Analgesic, 'adjuvant') ~ 'yes',
        TRUE ~ 'no'
    ),
    NSAID = case_when(
        str_detect(.$Analgesic, 'ibuprofen') |
            str_detect(.$Analgesic, 'nsaid') ~ 'yes',
        TRUE ~ 'no'
    ),
    Paracetamol = case_when(
        str_detect(.$Analgesic, 'paracetamol') ~ 'yes',
        TRUE ~ 'no'
    ),
    Mild_opioid = case_when(
        str_detect(.$Analgesic, 'opioid') ~ 'yes',
        TRUE ~ 'no'
    )) %>%
    # Specify WHO analgesic ladder
    mutate(WHO_level = ifelse(Mild_opioid == 'yes',
                              yes = 2,
                              no = ifelse(Paracetamol == 'yes' |
                                              NSAID == 'yes',
                                          yes = 1,
                                          no = 0))) %>%
    # Remove Analgesic column
    select(-Analgesic) %>%
    # Fix SOS mnemonic
    mutate(SOS_mnemonic = case_when(
        SOS_mnemonic == 'lhl' ~ 'low health literacy',
        SOS_mnemonic == 'hl' ~ 'health literate'
    )) %>% 
    # Fix education
    ## Relevel
    mutate(Years_education  = case_when(
        stringr::str_detect(.$Highest_level_of_education, 'grade 12') ~ '12',
            stringr::str_detect(.$Highest_level_of_education, 'receptionist training') |
            stringr::str_detect(.$Highest_level_of_education, 'ecd level 4') |
            stringr::str_detect(.$Highest_level_of_education, 'anciliary healthcare') |
            stringr::str_detect(.$Highest_level_of_education, 'tertiary degree') |
            stringr::str_detect(.$Highest_level_of_education, 'computer course') ~ '12+',
        stringr::str_detect(.$Highest_level_of_education, 'grade 11') ~ '11',
        stringr::str_detect(.$Highest_level_of_education, 'grade 10') ~ '10',
        stringr::str_detect(.$Highest_level_of_education, 'grade 9') ~ '9',
        stringr::str_detect(.$Highest_level_of_education, 'grade 8') ~ '8',
        stringr::str_detect(.$Highest_level_of_education, 'grade 7') ~ '7',
        stringr::str_detect(.$Highest_level_of_education, 'grade 6') ~ '6',
        stringr::str_detect(.$Highest_level_of_education, 'grade 5') ~ '5',
        stringr::str_detect(.$Highest_level_of_education, 'grade 4') ~ '4',
        stringr::str_detect(.$Highest_level_of_education, 'grade 3') ~ '3',
        stringr::str_detect(.$Highest_level_of_education, 'grade 2') ~ '2',
        stringr::str_detect(.$Highest_level_of_education, 'grade 1') ~ '1',
        stringr::str_detect(.$Highest_level_of_education, 'grade r') |
            stringr::str_detect(.$Highest_level_of_education, 'nil') |
            stringr::str_detect(.$Highest_level_of_education, 'no formal schooling') ~ '0'
        )) %>%
    # Order education levels
    mutate(Years_education = factor(Years_education,
                                    levels = rev(c('12+', '12', '11', '10', '9',
                                                   '8', '7', '6', '5', '4', '3', 
                                                   '2', '1', '0')),
                                    ordered = TRUE)) %>%
    # Remove Highest_level_of_education column
    select(-Highest_level_of_education) %>%
    # Fix Occupation column
    mutate(Occupation = ifelse(Occupation == 'temporary employment' |
                                   Occupation == 'employed',
                               yes = 'employed',
                               no = ifelse(Occupation == 'student' |
                                               Occupation == 'volunteering',
                                           yes = 'student/volunteer',
                                           no = Occupation)))

# Remove Group E participants
demographics %<>%
    filter(!ID %in% group_e)

# Quick look
glimpse(demographics)

# Save outputs
write_rds(x = demographics, 
          path = 'data-cleaned/demographics.rds')
write_csv(x = demographics,
          path = 'data-cleaned/demographics.csv')

############################################################
#                                                          #
#                           BPI                            #
#                                                          #
############################################################
# Group E (for removal later)
# Group E was an additonal group in the U1 cohort, 
# and was not part of the core study.
group_e <- c('J2', 'J8', 'J13', 'J14', 'J15', 'J16', 'J20', 'J21', 'J25', 
             'J26', 'J27', 'J28', 'J39', 'J47', 'J48', 'J50', 'J58', 
             'J63', 'J64', 'J65', 'J66', 'J69', 'J70')

# Extract BPI information
BPI_scores <- read_excel(path = 'data-original/amalgamated_data.xlsx', 
                         sheet = "BPI")

# Remove empty row at top of sheet
BPI_clean <- BPI_scores[-1,]
        
# Fix column names by renaming appropriately. 
# Use setnames command with concatenation as assign to BPI_clean data frame:
BPI_clean <-
    setNames(BPI_clean, c(
        'ID', 
        'Pain_present.BL',
        'Pain_present.Wk4',
        'Pain_present.Wk8',
        'Pain_present.Wk12',
        'Pain_present.Wk24',
        'Pain_present.Wk48',
        'Worst_pain.BL',
        'Worst_pain.Wk4',
        'Worst_pain.Wk8',
        'Worst_pain.Wk12',
        'Worst_pain.Wk24',
        'Worst_pain.Wk48',
        'Least_pain.BL', 
        'Least_pain.Wk4',
        'Least_pain.Wk8',
        'Least_pain.Wk12',
        'Least_pain.Wk24',
        'Least_pain.Wk48',
        'Average_pain.BL',
        'Average_pain.Wk4',
        'Average_pain.Wk8',
        'Average_pain.Wk12',
        'Average_pain.Wk24',
        'Average_pain.Wk48',
        'Pain_now.BL',
        'Pain_now.Wk4',
        'Pain_now.Wk8',
        'Pain_now.Wk12',
        'Pain_now.Wk24',
        'Pain_now.Wk48',
        'Receiving_rx.BL',
        'Receiving_rx.Wk4',
        'Receiving_rx.Wk8',
        'Receiving_rx.Wk12',
        'Receiving_rx.Wk24',
        'Receiving_rx.Wk48',
        'Relief_rx.BL',
        'Relief_rx.Wk4',
        'Relief_rx.Wk8',
        'Relief_rx.Wk12',
        'Relief_rx.Wk24',
        'Relief_rx.Wk48',
        'Activities_of_daily_living.BL',
        'Activities_of_daily_living.Wk4',
        'Activities_of_daily_living.Wk8',
        'Activities_of_daily_living.Wk12',
        'Activities_of_daily_living.Wk24',
        'Activities_of_daily_living.Wk48',
        'Mood.BL',
        'Mood.Wk4',
        'Mood.Wk8',
        'Mood.Wk12',
        'Mood.Wk24',
        'Mood.Wk48',
        'Walking.BL',
        'Walking.Wk4',
        'Walking.Wk8',
        'Walking.Wk12',
        'Walking.Wk24',
        'Walking.Wk48',
        'Work.BL',
        'Work.Wk4',
        'Work.Wk8',
        'Work.Wk12',
        'Work.Wk24',
        'Work.Wk48',
        'Relationship_with_others.BL',
        'Relationship_with_others.Wk4',
        'Relationship_with_others.Wk8',
        'Relationship_with_others.Wk12',
        'Relationship_with_others.Wk24',
        'Relationship_with_others.Wk48',
        'Sleep.BL',
        'Sleep.Wk4',
        'Sleep.Wk8',
        'Sleep.Wk12',
        'Sleep.Wk24',
        'Sleep.Wk48',
        'Enjoyment_of_life.BL',
        'Enjoyment_of_life.Wk4',
        'Enjoyment_of_life.Wk8',
        'Enjoyment_of_life.Wk12',
        'Enjoyment_of_life.Wk24',
        'Enjoyment_of_life.Wk48'))

# Convert '9999' missing to <NA>
BPI_clean %<>%    
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .)))

# Fix column classes
BPI_clean %<>%
    mutate_at(.vars = c(1:7, 32:37), 
              .funs = as.character) %>% 
    mutate_at(.vars = c(8:31, 38:85), 
              .funs = as.integer)

# Remove Group E participants
BPI_clean <- filter(BPI_clean, 
                    !ID %in% group_e)

# Quick look
glimpse(BPI_clean)

# Save outputs
write_rds(x = BPI_clean, 
          path = 'data-cleaned/bpi.rds')
write_csv(x = BPI_clean,
          path = 'data-cleaned/bpi.csv')

############################################################
#                                                          #
#                           BDI                            #
#                                                          #
############################################################
# Group E (for removal later)
# Group E was an additonal group in the U1 cohort, 
# and was not part of the core study.
group_e <- c('J2', 'J8', 'J13', 'J14', 'J15', 'J16', 'J20', 'J21', 'J25', 
             'J26', 'J27', 'J28', 'J39', 'J47', 'J48', 'J50', 'J58', 
             'J63', 'J64', 'J65', 'J66', 'J69', 'J70')

# Extract BDI information
BDI_scores <- read_excel(path = 'data-original/amalgamated_data.xlsx', 
                         sheet = "BDI")

# Remove empty row at top of sheet
BDI_clean <- BDI_scores[-1,]

# Fix column names and retain baseline scores only
BDI_clean %<>%
    rename(ID = X__1) %>% 
    select(-starts_with('X__')) %>% 
    setNames(c('ID', 'Sadness.BL', 'Pessimism.BL', 'Past_failures.BL', 
        'Loss_of_pleasure.BL', 'Guilty_feelings.BL', 'Punishment_feelings.BL',
        'Self_dislike.BL', 'Self_critical.BL', 'Suicidal.BL', 'Crying.BL',
        'Agitation.BL', 'Loss_of_interest.BL', 'Indecisiveness.BL',
        'Worthlessness.BL', 'Loss_of_energy.BL', 'Sleep_a.BL', 
        'Irritability.BL', 'Appetite_a.BL', 'Concentration_difficulty.BL',
        'Fatigue.BL', 'Loss_of_interest_in_sex.BL'))

# Convert '9999' missing to <NA>
BDI_clean %<>%    
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .)))

# Remove Group E participants
BDI_clean %<>%
    filter(!ID %in% group_e)

# Fix column classes with 
BDI_clean %<>%
    separate(col = Appetite_a.BL, 
             into = c('Appetite.BL', 'extra'), 
             sep = 1) %>% 
    separate(col = Sleep_a.BL, 
             into = c('Sleep.BL', 'extra2'), 
             sep = 1) %>% 
    select(-extra, -extra2)

# Convert columns to numeric
BDI_clean %<>%
    mutate_at(2:ncol(BDI_clean), 
              as.integer)

# Quick look
glimpse(BDI_clean)

# Save outputs
write_rds(x = BDI_clean, 
          path = 'data-cleaned/bdi.rds')
write_csv(x = BDI_clean,
          path = 'data-cleaned/bdi.csv')

############################################################
#                                                          #
#                           EQ-5D                          #
#                                                          #
############################################################
# Group E (for removal later)
# Group E was an additonal group in the U1 cohort, 
# and was not part of the core study.
group_e <- c('J2', 'J8', 'J13', 'J14', 'J15', 'J16', 'J20', 'J21', 'J25', 
             'J26', 'J27', 'J28', 'J39', 'J47', 'J48', 'J50', 'J58', 
             'J63', 'J64', 'J65', 'J66', 'J69', 'J70')

# Extract EQ-5D information
EQ5D <- read_excel(path = 'data-original/amalgamated_data.xlsx', 
                   sheet = "EQ5D")

# Remove empty row at top of sheet
EQ5D_clean <- EQ5D[-1,]

# Fix column names and retain baseline scores only
EQ5D_clean %<>%
    rename(ID = X__1) %>% 
    select(-starts_with('X__')) %>% 
    setNames(c('ID', 'Mobility.BL', 'Self_care.BL', 'Usual_activities.BL',
               'Pain.BL', 'Anxiety_and_depression.BL', 'State_of_health.BL'))

# Convert '9999' missing to <NA>
EQ5D_clean %<>%    
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .)))

# Remove Group E participants
EQ5D_clean %<>% 
    filter(!ID %in% group_e)

# Fix column classes
EQ5D_clean %<>%
    mutate_at(2:ncol(EQ5D_clean), 
              as.integer)

# Have a look
glimpse(EQ5D_clean)

# Save outputs
write_rds(x = EQ5D_clean, 
          path = 'data-cleaned/eq5d.rds')
write_csv(x = EQ5D_clean,
          path = 'data-cleaned/eq5d.csv')

############################################################
#                                                          #
#                           SE-6                           #
#                                                          #
############################################################
# Group E (for removal later)
# Group E was an additonal group in the U1 cohort, 
# and was not part of the core study.
group_e <- c('J2', 'J8', 'J13', 'J14', 'J15', 'J16', 'J20', 'J21', 'J25', 
             'J26', 'J27', 'J28', 'J39', 'J47', 'J48', 'J50', 'J58', 
             'J63', 'J64', 'J65', 'J66', 'J69', 'J70')

# Extract SE-6 information
SE6_scores <- read_excel(path = 'data-original/amalgamated_data.xlsx', 
                         sheet = "SE6")

# Remove empty row at top of sheet
SE6_clean <- SE6_scores[-1,]

# Fix column names and retain baseline scores only
SE6_clean %<>%
    rename(ID = X__1) %>% 
    select(-starts_with('X__')) %>% 
    setNames(c('ID', 'Fatigue.BL', 'Physical_discomfort.BL', 
               'Emotional_distress.BL', 'Other_symptoms.BL', 'Tasks.BL',
               'Non_drug.BL'))

# Convert '9999' missing to <NA>
SE6_clean <- SE6_clean %>%    
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .)))

# Remove Group E participants
SE6_clean %<>%
    filter(!ID %in% group_e)

# Fix column classes
SE6_clean %<>%
    mutate_at(2:ncol(SE6_clean), 
              as.integer)

# Quick check
glimpse(SE6_clean)

# Save outputs
write_rds(x = SE6_clean, 
          path = 'data-cleaned/se6.rds')
write_csv(x = SE6_clean,
          path = 'data-cleaned/se6.csv')
