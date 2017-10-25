############################################################
#                                                          #
#                 Extract data from Excel                  #
#                                                          #
############################################################

############################################################
#                                                          #
#               Note: The original data that               #
#            this script cleans is available on            #
#                request. The data have not                #
#        been made publically available because of         #
#        the potential for personal identification.        #
#           However, we have made this cleaning            #
#            script available, which shows all             #
#       steps executed during the cleaning process.        #
#                                                          #
############################################################

# Load packages
library(readxl)
library(dplyr)
library(tidyr)
library(readr)
library(skimr)

############################################################
#                                                          #
#                       Demographics                       #
#                                                          #
############################################################
# Extract demographic information
demographics <- read_excel(path = 'PATH', 
                           sheet = "demographic info") %>%
    # Remove empty rows 
    filter(!is.na(Nr)) %>%
    # Convert '9999' missing to <NA>
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .))) %>%
    # Remove X__1 and DOD columns (provide inconsistent day/month info)
    select(-X__1, -DOD) %>%
    # Fix column names
    rename(ID = Nr,
           Site = `Clinical Site`,
           DOD = X__2,
           Years_on_ART = `Years since ARV start`,
           CD4_recent = `Recent CD4`,
           HIV_stage = `HIV Stage`,
           HIV_mx = `HIV Mx`,
           CM_dx = `CM Dx`,
           SOS_mnemonic = `SOS Mnemonic`) %>%
    # Fix column classes
    mutate(# DOB 
           DOB = gsub(pattern = '/',
                      replacement = '-',
                      x = DOB),
           DOB = lubridate::dmy(DOB)) %>%
    # Fix column formating
    mutate(# DOD
           DOD = as.numeric(DOD),
           # CD4
           CD4 = round(CD4),
           # Recent CD4
           CD4_recent = round(CD4_recent)) %>%
           # Convert all text to lowercase
           mutate_if(is.character, stringr::str_to_lower)

# Have a look
glimpse(demographics)
skim(demographics)

# Check levels of character classes
demographics %>%
    select_if(is.character) %>%
    as.list(.) %>%
    purrr::map(unique)

# Get a vector of participant IDs that were in Group E (u1 only)
group_e <- demographics %>% 
    filter(Group == 'e') %>%
    select(ID) %>%
    .$ID

group_e2 <- stringr::str_to_upper(group_e)

# Further cleaning after inspecting data
demographics <- demographics %>%
    # Remove unneeded column
    select(-Duration,
           -CM_dx,
           -Infections,
           -Language) %>%
    # Simplify analgesics column
    mutate(Adjuvant = case_when(
        stringr::str_detect(.$Analgesic, 'adjuvant') ~ 'yes',
        TRUE ~ 'no'
    ),
    NSAID = case_when(
        stringr::str_detect(.$Analgesic, 'ibuprofen') |
            stringr::str_detect(.$Analgesic, 'nsaid') ~ 'yes',
        TRUE ~ 'no'
    ),
    Paracetamol = case_when(
        stringr::str_detect(.$Analgesic, 'paracetamol') ~ 'yes',
        TRUE ~ 'no'
    ),
    Mild_opioid = case_when(
        stringr::str_detect(.$Analgesic, 'opioid') ~ 'yes',
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
    # Fixing education
    ## Relevel
    mutate(Years_education  = case_when(
        stringr::str_detect(.$HLOE, 'grade 12') ~ '12',
            stringr::str_detect(.$HLOE, 'receptionist training') |
            stringr::str_detect(.$HLOE, 'ecd level 4') |
            stringr::str_detect(.$HLOE, 'anciliary healthcare') |
            stringr::str_detect(.$HLOE, 'tertiary degree') |
            stringr::str_detect(.$HLOE, 'computer course') ~ '12+',
        stringr::str_detect(.$HLOE, 'grade 11') ~ '11',
        stringr::str_detect(.$HLOE, 'grade 10') ~ '10',
        stringr::str_detect(.$HLOE, 'grade 9') ~ '9',
        stringr::str_detect(.$HLOE, 'grade 8') ~ '8',
        stringr::str_detect(.$HLOE, 'grade 7') ~ '7',
        stringr::str_detect(.$HLOE, 'grade 6') ~ '6',
        stringr::str_detect(.$HLOE, 'grade 5') ~ '5',
        stringr::str_detect(.$HLOE, 'grade 4') ~ '4',
        stringr::str_detect(.$HLOE, 'grade 3') ~ '3',
        stringr::str_detect(.$HLOE, 'grade 2') ~ '2',
        stringr::str_detect(.$HLOE, 'grade 1') ~ '1',
        stringr::str_detect(.$HLOE, 'grade r') |
            stringr::str_detect(.$HLOE, 'nil') |
            stringr::str_detect(.$HLOE, 'no formal schooling') ~ '0'
        )) %>%
    # Order education levels
    mutate(Years_education = factor(Years_education,
                                    levels = rev(c('12+', '12', '11', '10', '9', '8', '7',
                                               '6', '5', '4', '3', '2', '1', '0')),
                                    ordered = TRUE)) %>%
    # Remove HLOE column
    select(-HLOE) %>%
    # Fix Occupation column
    mutate(Occupation = ifelse(Occupation == 'temporary employment' |
                                   Occupation == 'employed',
                               yes = 'employed',
                               no = ifelse(Occupation == 'student' |
                                               Occupation == 'volunteering',
                                           yes = 'student/volunteer',
                                           no = Occupation))) %>%
    # Remove Group E participants
    filter(!ID %in% group_e)

# Save outputs
write_rds(x = demographics, 
          path = './data/demographics.rds')
write_csv(x = demographics,
          path = './data/demographics.csv')

############################################################
#                                                          #
#                           BPI                            #
#                                                          #
############################################################
# Extract BPI information
BPI_scores <- read_excel(path = 'PATH', 
                           sheet = "BPI")

# Remove empty row at top of sheet
BPI_clean <- BPI_scores[-1,]

# Remove last few columns (col86-100, now without names)
BPI_clean <- select(BPI_clean, 1:85)
        
# Fix column names by renaming appropriately. Use setnames command with concatenation as assign to BPI_clean data frame:
BPI_clean <-
    setNames(BPI_clean, c(
        'ID', 'Pain_Pres_BL',
        'Pain_Pres_Wk4',
        'Pain_Pres_Wk8',
        'Pain_Pres_Wk12',
        'Pain_Pres_Wk24',
        'Pain_Pres_Wk48',
        'Worst_BL',
        'Worst_Wk4',
        'Worst_Wk8',
        'Worst_Wk12',
        'Worst_Wk24',
        'Worst_Wk48',
        'Least_BL', 'Least_Wk4',
        'Least_Wk8',
        'Least_Wk12',
        'Least_Wk24',
        'Least_Wk48',
        'Avg_BL',
        'Avg_Wk4',
        'Avg_Wk8',
        'Avg_Wk12',
        'Avg_Wk24',
        'Avg_Wk48',
        'Now_BL',
        'Now_Wk4',
        'Now_Wk8',
        'Now_Wk12',
        'Now_Wk24',
        'Now_Wk48',
        'Rx_BL',
        'Rx_Wk4',
        'Rx_Wk8',
        'Rx_Wk12',
        'Rx_Wk24',
        'Rx_Wk48',
        'Relief_BL',
        'Relief_Wk4',
        'Relief_Wk8',
        'Relief_Wk12',
        'Relief_Wk24',
        'Relief_Wk48',
        'Activ_BL',
        'Activ_Wk4',
        'Activ_Wk8',
        'Activ_Wk12',
        'Activ_Wk24',
        'Activ_Wk48',
        'Mood_BL',
        'Mood_Wk4',
        'Mood_Wk8',
        'Mood_Wk12',
        'Mood_Wk24',
        'Mood_Wk48',
        'Walking_BL',
        'Walking_Wk4',
        'Walking_Wk8',
        'Walking_Wk12',
        'Walking_Wk24',
        'Walking_Wk48',
        'Work_BL',
        'Work_Wk4',
        'Work_Wk8',
        'Work_Wk12',
        'Work_Wk24',
        'Work_Wk48',
        'Rel_BL',
        'Rel_Wk4',
        'Rel_Wk8',
        'Rel_Wk12',
        'Rel_Wk24',
        'Rel_Wk48',
        'Sleep_BL',
        'Sleep_Wk4',
        'Sleep_Wk8',
        'Sleep_Wk12',
        'Sleep_Wk24',
        'Sleep_Wk48',
        'Enjoy_BL',
        'Enjoy_Wk4',
        'Enjoy_Wk8',
        'Enjoy_Wk12',
        'Enjoy_Wk24',
        'Enjoy_Wk48'))
    
head(BPI_clean)

# Convert '9999' missing to <NA>
BPI_clean <- BPI_clean %>%    
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .)))

# Fix column classes
BPI_clean <- mutate_at(BPI_clean, c(1:7), as.character)
BPI_clean <- mutate_at(BPI_clean, c(8:85), as.numeric)

# Remove Group E participants
BPI_clean <- filter(BPI_clean, 
                    !ID %in% group_e2)

# Have a look
glimpse(BPI_clean)
skim(BPI_clean)

# Save outputs
write_rds(x = BPI_clean, 
          path = './data/bpi.rds')
write_csv(x = BPI_clean,
          path = './data/bpi.csv')

# Select Baseline columns only for factor analysis
BPI_baseline <- select (BPI_clean, contains('BL'))

# Save output
write_rds(x = BPI_baseline, 
          path = './data/bpi_factor_analysis.rds')
write_csv(x = BPI_baseline, 
          path = './data/bpi_factor_analysis.csv')

############################################################
#                                                          #
#                           BDI                            #
#                                                          #
############################################################
# Extract BDI information
BDI_scores <- read_excel(path = 'PATH', 
                         sheet = "Becks Dep")

# Remove empty row at top of sheet
BDI_clean <- BDI_scores[-1,]

# Remove mid few columns (col62-67)
BDI_clean <- select(BDI_clean, -c(62:67))

# Remove last few columns (col128-end)
BDI_clean <- select(BDI_clean, -c(128:ncol(BDI_clean)))

# Check
glimpse(BDI_clean)

# Fix column names by renaming appropriately. Use setnames command with concatenation as assign to BDI_clean data frame:
BDI_clean <-
    setNames(BDI_clean, c(
        'ID', 'Sadness_BL',
        'Sadness_Wk4',
        'Sadness_Wk8',
        'Sadness_Wk12',
        'Sadness_Wk24',
        'Sadness_Wk48',
        'Pessimism_BL',
        'Pessimism_Wk4',
        'Pessimism_Wk8',
        'Pessimism_Wk12',
        'Pessimism_Wk24',
        'Pessimism_Wk48',
        'Past_fail_BL', 
        'Past_fail_Wk4',
        'Past_fail_Wk8',
        'Past_fail_Wk12',
        'Past_fail_Wk24',
        'Past_fail_Wk48',
        'Loss_pleas_BL',
        'Loss_pleas_Wk4',
        'Loss_pleas_Wk8',
        'Loss_pleas_Wk12',
        'Loss_pleas_Wk24',
        'Loss_pleas_Wk48',
        'Guilty_BL',
        'Guilty_Wk4',
        'Guilty_Wk8',
        'Guilty_Wk12',
        'Guilty_Wk24',
        'Guilty_Wk48',
        'Punish_BL',
        'Punish_Wk4',
        'Punish_Wk8',
        'Punish_Wk12',
        'Punish_Wk24',
        'Punish_Wk48',
        'Self_dislike_BL',
        'Self_dislike_Wk4',
        'Self_dislike_Wk8',
        'Self_dislike_Wk12',
        'Self_dislike_Wk24',
        'Self_dislike_Wk48',
        'Self_crit_BL',
        'Self_crit_Wk4',
        'Self_crit_Wk8',
        'Self_crit_Wk12',
        'Self_crit_Wk24',
        'Self_crit_Wk48',
        'Suicide_BL',
        'Suicide_Wk4',
        'Suicide_Wk8',
        'Suicide_Wk12',
        'Suicide_Wk24',
        'Suicide_Wk48',
        'Crying_BL',
        'Crying_Wk4',
        'Crying_Wk8',
        'Crying_Wk12',
        'Crying_Wk24',
        'Crying_Wk48',
        'Agitation_BL',
        'Agitation_Wk4',
        'Agitation_Wk8',
        'Agitation_Wk12',
        'Agitation_Wk24',
        'Agitation_Wk48',
        'Loss_int_BL',
        'Loss_int_Wk4',
        'Loss_int_Wk8',
        'Loss_int_Wk12',
        'Loss_int_Wk24',
        'Loss_int_Wk48',
        'Indecis_BL',
        'Indecis_Wk4',
        'Indecis_Wk8',
        'Indecis_Wk12',
        'Indecis_Wk24',
        'Indecis_Wk48',
        'Worthless_BL',
        'Worthless_Wk4',
        'Worthless_Wk8',
        'Worthless_Wk12',
        'Worthless_Wk24',
        'Worthless_Wk48',
        'Loss_energy_BL',
        'Loss_energy_Wk4',
        'Loss_energy_Wk8',
        'Loss_energy_Wk12',
        'Loss_energy_Wk24',
        'Loss_energy_Wk48',
        'Sleep_BL',
        'Sleep_Wk4',
        'Sleep_Wk8',
        'Sleep_Wk12',
        'Sleep_Wk24',
        'Sleep_Wk48',
        'Irrit_BL',
        'Irrit_Wk4',
        'Irrit_Wk8',
        'Irrit_Wk12',
        'Irrit_Wk24',
        'Irrit_Wk48',
        'Appetite_BL',
        'Appetite_Wk4',
        'Appetite_Wk8',
        'Appetite_Wk12',
        'Appetite_Wk24',
        'Appetite_Wk48',
        'Concen_BL',
        'Concen_Wk4',
        'Concen_Wk8',
        'Concen_Wk12',
        'Concen_Wk24',
        'Concen_Wk48',
        'Fatigue_BL',
        'Fatigue_Wk4',
        'Fatigue_Wk8',
        'Fatigue_Wk12',
        'Fatigue_Wk24',
        'Fatigue_Wk48',
        'Int_sex_BL',
        'Int_sex_Wk4',
        'Int_sex_Wk8',
        'Int_sex_Wk12',
        'Int_sex_Wk24',
        'Int_sex_Wk48'))

# Check
glimpse(BDI_clean)

# Convert '9999' missing to <NA>
BDI_clean <- BDI_clean %>%    
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .)))

# Fix column classes
BDI_clean <- mutate_at(BDI_clean, 'ID', as.character)
BDI_clean <- BDI_clean %>%
    separate(Appetite_BL, c('Appetite_BL', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Appetite_Wk4, c('Appetite_Wk4', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Appetite_Wk8, c('Appetite_Wk8', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Appetite_Wk12, c('Appetite_Wk12', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Appetite_Wk24, c('Appetite_Wk24', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Appetite_Wk48, c('Appetite_Wk48', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Sleep_BL, c('Sleep_BL', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Sleep_Wk4, c('Sleep_Wk4', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Sleep_Wk8, c('Sleep_Wk8', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Sleep_Wk12, c('Sleep_Wk12', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Sleep_Wk24, c('Sleep_Wk24', 'extra'), sep = 1) %>%
    select(-extra) %>%
    separate(Sleep_Wk48, c('Sleep_Wk48', 'extra'), sep = 1) %>%
    select(-extra)
BDI_clean <- mutate_at(BDI_clean, c(2:ncol(BDI_clean)), as.integer)

# Remove Group E participants
BDI_clean <- filter(BDI_clean, 
                    !ID %in% group_e2)

# Have a look
glimpse(BDI_clean)
skim(BDI_clean)

# Save outputs
write_rds(x = BDI_clean, 
          path = './data/bdi.rds')
write_csv(x = BDI_clean,
          path = './data/bdi.csv')

############################################################
#                                                          #
#                           EQ-5D                          #
#                                                          #
############################################################
# Extract EQ-5D information
EQ5D <- read_excel(path = 'PATH', 
                         sheet = "EQ-5D")

# Remove empty row at top of sheet
EQ5D_clean <- EQ5D[-1,]

# Fix column names by renaming appropriately. Use setnames command with concatenation as assign to BPI_clean data frame:
EQ5D_clean <-
    setNames(EQ5D_clean, c(
        'ID', 'Mobility_BL',
        'Mobility_Wk4',
        'Mobility_Wk8',
        'Mobility_Wk12',
        'Mobility_Wk24',
        'Mobility_Wk48',
        'Self_care_BL',
        'Self_care_Wk4',
        'Self_care_Wk8',
        'Self_care_Wk12',
        'Self_care_Wk24',
        'Self_care_Wk48',
        'Usual_act_BL', 'Usual_act_Wk4',
        'Usual_act_Wk8',
        'Usual_act_Wk12',
        'Usual_act_Wk24',
        'Usual_act_Wk48',
        'EQ_Pain_BL',
        'EQ_Pain_Wk4',
        'EQ_Pain_Wk8',
        'EQ_Pain_Wk12',
        'EQ_Pain_Wk24',
        'EQ_Pain_Wk48',
        'Anx_depr_BL',
        'Anx_depr_Wk4',
        'Anx_depr_Wk8',
        'Anx_depr_Wk12',
        'Anx_depr_Wk24',
        'Anx_depr_Wk48',
        'SOH_BL',
        'SOH_Wk4',
        'SOH_Wk8',
        'SOH_Wk12',
        'SOH_Wk24',
        'SOH_Wk48'))

head(EQ5D_clean)

# Convert '9999' missing to <NA>
EQ5D_clean <- EQ5D_clean %>%    
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .)))

# Fix column classes
EQ5D_clean <-   mutate_at(EQ5D_clean, 'ID', as.character)
EQ5D_clean <-   mutate_at(EQ5D_clean, 2:37, as.numeric)

# Remove Group E participants
EQ5D_clean <- filter(EQ5D_clean, 
                     !ID %in% group_e2)

# Have a look
glimpse(EQ5D_clean)
skim(EQ5D_clean)

# Save outputs
write_rds(x = EQ5D_clean, 
          path = './data/eq5d.rds')
write_csv(x = EQ5D_clean,
          path = './data/eq5d.csv')

############################################################
#                                                          #
#                           SE-6                           #
#                                                          #
############################################################
# Extract SE-6 information
SE6_scores <- read_excel(path = 'PATH', 
                         sheet = "SE 6")

# Remove empty row at top of sheet
SE6_clean <- SE6_scores[-1,]

# Remove last few columns (col38-43)
SE6_clean <- select(SE6_clean, 1:37)

# Fix column names by renaming appropriately. Use setnames command with concatenation and assign to SE6_clean data frame:
SE6_clean <-
    setNames(SE6_clean, c(
        'ID', 'Fatigue_BL',
        'Fatigue_Wk4',
        'Fatigue_Wk8',
        'Fatigue_Wk12',
        'Fatigue_Wk24',
        'Fatigue_Wk48',
        'Discomf_BL',
        'Discomf_Wk4',
        'Discomf_Wk8',
        'Discomf_Wk12',
        'Discomf_Wk24',
        'Discomf_Wk48',
        'Distress_BL', 'Distress_Wk4',
        'Distress_Wk8',
        'Distress_Wk12',
        'Distress_Wk24',
        'Distress_Wk48',
        'Other_sympt_BL',
        'Other_sympt_Wk4',
        'Other_sympt_Wk8',
        'Other_sympt_Wk12',
        'Other_sympt_Wk24',
        'Other_sympt_Wk48',
        'Tasks_BL',
        'Tasks_Wk4',
        'Tasks_Wk8',
        'Tasks_Wk12',
        'Tasks_Wk24',
        'Tasks_Wk48',
        'Non_drug_BL',
        'Non_drug_Wk4',
        'Non_drug_Wk8',
        'Non_drug_Wk12',
        'Non_drug_Wk24',
        'Non_drug_Wk48'))

head(SE6_clean)

# Convert '9999' missing to <NA>
SE6_clean <- SE6_clean %>%    
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .)))

# Fix column classes
SE6_clean <-   mutate_at(SE6_clean, 'ID', as.character)
SE6_clean <-   mutate_at(SE6_clean, c(2:37), as.numeric)

# Remove Group E participants
SE6_clean <- filter(SE6_clean, 
                    !ID %in% group_e2)

# Have a look
glimpse(SE6_clean)
skim(SE6_clean)

# Save outputs
write_rds(x = SE6_clean, 
          path = './data/se6.rds')
write_csv(x = SE6_clean,
          path = './data/se6.csv')

############################################################
#                                                          #
#                           Simmonds                       #
#                                                          #
############################################################
# Extract Simmonds Battery information
Simmonds_scores <- read_excel(path = 'PATH', 
                         sheet = "Simmonds Battery")

# Remove 2 empty rows at top of sheet
Simmonds_clean <- Simmonds_scores[-c(1,2),]

# Remove few blank columns (col38-43)
Simmonds_clean <- select(Simmonds_clean, -c(38:43))

# Fix column names by renaming appropriately. Use setnames command with concatenation and assign to Simmonds_clean data frame:
Simmonds_clean <-
    setNames(Simmonds_clean, c(
        'ID', 
        'Pref_spd_BL',
        'Pref_spd_Wk4',
        'Pref_spd_Wk8',
        'Pref_spd_Wk12',
        'Pref_spd_Wk24',
        'Pref_spd_Wk48',
        'Fast_spd_BL',
        'Fast_spd_Wk4',
        'Fast_spd_Wk8',
        'Fast_spd_Wk12',
        'Fast_spd_Wk24',
        'Fast_spd_Wk48',
        'Unload_reach_BL', 
        'Unload_reach_Wk4',
        'Unload_reach_Wk8',
        'Unload_reach_Wk12',
        'Unload_reach_Wk24',
        'Unload_reach_Wk48',
        'Load_reach_BL',
        'Load_reach_Wk4',
        'Load_reach_Wk8',
        'Load_reach_Wk12',
        'Load_reach_Wk24',
        'Load_reach_Wk48',
        'Sit_st1_BL',
        'Sit_st1_Wk4',
        'Sit_st1_Wk8',
        'Sit_st1_Wk12',
        'Sit_st1_Wk24',
        'Sit_st1_Wk48',
        'Sit_st2_BL',
        'Sit_st2_Wk4',
        'Sit_st2_Wk8',
        'Sit_st2_Wk12',
        'Sit_st2_Wk24',
        'Sit_st2_Wk48',
        'Sock_BL',
        'Sock_Wk4',
        'Sock_Wk8',
        'Sock_Wk12',
        'Sock_Wk24',
        'Sock_Wk48',
        'Reach_up_BL',
        'Reach_up_Wk4',
        'Reach_up_Wk8',
        'Reach_up_Wk12',
        'Reach_up_Wk24',
        'Reach_up_Wk48',
        'Distance_BL',
        'Distance_Wk4',
        'Distance_Wk8',
        'Distance_Wk12',
        'Distance_Wk24',
        'Distance_Wk48',
        'Belt_BL',
        'Belt_Wk4',
        'Belt_Wk8',
        'Belt_Wk12',
        'Belt_Wk24',
        'Belt_Wk48'))

head(Simmonds_clean)

# Convert '9999' missing to <NA>
Simmonds_clean <- Simmonds_clean %>%    
    mutate_all(funs(ifelse(. == '9999',
                           yes = NA,
                           no = .)))

# Fix column classes
Simmonds_clean <-   mutate_at(Simmonds_clean, 'ID', as.character)

# Col 2-13 must be numeric with 2 decimal points
Simmonds_clean <-   mutate_at(Simmonds_clean, c(2:37), as.numeric) 
Simmonds_clean <-   mutate_at(Simmonds_clean, c(2:37), round, digits = 2) 

# Col 14-25 must be integers
Simmonds_clean <-   mutate_at(Simmonds_clean, c(14:25), as.integer) 

# Col 26-end(61) must be numeric with 2 decimal points
Simmonds_clean <-   mutate_at(Simmonds_clean, c(26:ncol(Simmonds_clean)), as.numeric) 
Simmonds_clean <-   mutate_at(Simmonds_clean, c(26:ncol(Simmonds_clean)), round, digits = 2) 

# Remove Group E participants
Simmonds_clean <- filter(Simmonds_clean, 
                         !ID %in% group_e2)

# Have a look
glimpse(Simmonds_clean)
skim(Simmonds_clean)

# Save outputs
write_rds(x = Simmonds_clean, 
          path = './data/simmonds.rds')
write_csv(x = Simmonds_clean,
          path = './data/simmonds.csv')
