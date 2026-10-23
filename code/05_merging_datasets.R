### load in packages
library(dplyr)
library(ggplot2)
library(tools)
library(readr)

###setting the working directory 
setwd("/Users/amyknight/Documents/Uni/AHDS/Assessments/formative")

##check working directory
print(getwd())

##readin body measures data
body_measures <- read_csv("./data/derived/BMX_D.csv")

##setting up accelerometer file directory
accel_dir <- "./data/derived/accel"

###reading in accel files
accel_files<-(list.files (accel_dir, pattern= "\\.txt$", full.names=TRUE))
###inspecting 1 accel file
one <- read_delim(accel_files[1], show_col_types = FALSE)   
head(one); dim(one); spec(one)

###summarising accel files to make merge easier
summarise_one <- function(f) {
  d <- read_delim(f, show_col_types = FALSE)
  
  tibble(
    participant_id = sub("\\D*(\\d)","\\1", file_path_sans_ext(basename(f))),  # ID from the filename
    n_rows         = nrow(d),                          # how many rows the file has
    mean_activity  = mean(d$PAXINTEN, na.rm = TRUE)
  )
}
accel_summary <- map_dfr(accel_files, summarise_one)

###checking summary - number of rows should equal the number of accelerometer files 
nrow(accel_summary)

##making participant_id numeric
accel_summary$participant_id <- as.numeric(accel_summary$participant_id)
##merging accelerometer summary file and body measures
accel_bm <- left_join(body_measures, accel_summary, by = c("SEQN" = "participant_id"))

###deciding whcih rows have both accel & bm data
id_both <- accel_bm |>
  transmute(SEQN, has_both = as.integer(!is.na(n_rows)))

##save as a csv
write_csv(id_both, "./data/derived/analytical_sample.csv")