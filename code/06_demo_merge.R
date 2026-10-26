##load packages
##tidyverse
library(tidyverse)

##readr
library(readr)

##read xpt
library(haven)

##tidyr
library(tidyr)

##set working directory
setwd("/Users/amyknight/Documents/Uni/AHDS/Assessments/formative")

##read in the demographics dataset & give variable
demographics <- read_xpt("./data/original/DEMO_D.XPT")

###select participant ID, gender, age and ethnicity
mod_demo <- demographics |> 
  distinct(SEQN, RIAGENDR, RIDAGEYR, RIDRETH1)

###read in the body measures data set
body_measures <- read.csv("./data/derived/BMX_D.csv")

###reformatting variable names to lowercase in demographics and body measures data sets
tolower(body_measures)
tolower(mod_demo)

###joining datasets
merged_data <- mod_demo |>
  left_join(body_measures)

##re-organising tibble structure
merged_data |>
relocate(RIAGENDR, RIDAGEYR, RIDRETH1)

##rename gender, age and ethnicity
merged_data <- merged_data |>
  rename (Gender = RIAGENDR) |>
  rename (Age = RIDAGEYR) |>
  rename (Ethnicity = RIDRETH1)

##read in accelerometer availability data
sample_availability <- read.csv("./data/derived/analytical_sample.csv")

##merge with other merged dataset
merged_data<- merged_data |>
  left_join(sample_availability)

##move has_both to the right of SEQN & rename to in_sample
merged_data <- merged_data |> 
  rename(in_sample=has_both) |>
  relocate (in_sample) |>
  relocate (SEQN)

##create a new obesity column
merged_data <- merged_data |>
  mutate ( bmi = BMXWT/(BMXHT/100)^2,
           obesity = case_when(
         bmi >= 30 ~ 1,
         bmi < 30 ~ 0,
         TRUE ~ NA_real_)
         )

## What percentage of the people in the body measurement sample who are considered to
#have obesity also have activity monitor data? How does this compare to the people who are
#not considered to have obesity?

## %obese
merged_data |>
  summarise(
    n_both = sum(obesity == 1 & in_sample == 1, na.rm = TRUE),
    n_total = n(),
    pct_both= n_both/n_total *100
  )

## % not obese
merged_data |>
  summarise(
    n_not = sum(obesity == 0 & in_sample == 1, na.rm= TRUE ),
    n_total = n(),
    pct_not = n_not/n_total *100
  )

##What percentage of males have activity monitor data? How does this compare to females?

## % of males
merged_data |> 
  summarise(
    n_menact = sum(Gender ==1 & in_sample==1, na.rm = TRUE),
    n_men = sum(Gender==1, na.rm=TRUE),
    pct_men = n_menact/ n_men *100
  )

## % of females
merged_data |> 
  summarise(
    n_feact = sum(Gender ==2 & in_sample==1, na.rm = TRUE),
    n_fe = sum(Gender==2, na.rm=TRUE),
    pct_fe = n_feact/ n_fe *100)

##What is the maximum reported height in cm of a child under 16 in this sample?
merged_data |>
  select (Age, BMXHT) |>
  filter(Age < 16) |>
  count(BMXHT, sort =TRUE)

##save as csv
write_csv(merged_data, "./data/derived/body_measurements.csv" )