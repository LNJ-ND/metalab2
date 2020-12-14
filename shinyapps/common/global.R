library(shiny)
library(shinyBS)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(ggplot2)
library(purrr)
library(langcog)
library(feather)
library(plotly)
library(here)
library(DT)
library(stringr)
library(metalabr)

source(here("mv_functions.R"))

get_metavoice_data_shiny <- function(directory) {
  files <- list.files(directory, full.names = TRUE, pattern = "csv")
  data <- lapply(files, read.csv, stringsAsFactors = FALSE)
  ret_df <- do.call(rbind, data)
  ret_df$all_mod <- ""
  ret_df
}

fields <- get_metavoice_field_info()

fields_derived <- get_metavoice_derived_field_info()

metavoice_data <- get_metavoice_data_shiny(here("shinyapps", "site_data"))

dataset_yaml <- get_metavoice_dataset_info() #this goes to github, maybe
                                           #should be local too? how
                                           #is it used?
dataset_info <- add_metavoice_summary_info(dataset_yaml, metavoice_data)


feature_help_texts <- c(
  "speech_duration" = "Duration of speech (referring to e.g. syllables, lexical items (words) or full utterances)",
  "speech_rate" = "Speed of speech, measured as syllables or words over time (in minutes or seconds)",
  "speech_percentage" = "Percentage of spoken time (i.e. non-pause time)",
  "pause_duration" = "Mean pause duration",
  "pause_number" = "Number of pauses, as defined by the single study",
  "pause_length" = "Total length of pauses (in ms or s)",
  "pause_total_length" = "Total length of pauses (in ms or s)",
  "response_latency" = "Time passing between a stimulus and the initiation of speech by the subject",
  "pause_variability" = "Dispersion of pause duration, measured in variance or standard deviation",
  "pitch" = "Mean pitch reflects the frequency of vibrations of the vocal cords. The fundamental frequenecy (f0) is perceived as pitch which is the log-transform of f0.",
  "pitch_sd" = "Dispersion of pitch, measured in standard deviations",
  "pitch_variability" = "Dispersion of pitch, measured in standard deviation or variance (whether it is in relation to a phoneme, word or utterance)",
  "pitch_range" = "Difference between the lowest and highest value of pitch",
  "f1" = "The 1st spectral peak of the sound spectrum generated in speech",
  "f2" = "The 2nd spectral peak of the sound spectrum generated in speech",
  "f3" = "The 3rd spectral peak of the sound spectrum generated in speech",
  "f4" = "The 4th spectral peak of the sound spectrum generated in speech",
  "f5" = "The 5th spectral peak of the sound spectrum generated in speech",
  "f6" = "The 6th spectral peak of the sound spectrum generated in speech",
  "formant_bandwidth" = "No definition available, as feature is underspecified in original paper",
  "format_amplitude" = "No definition available, as feature is underspecified in original paper",
  "intensity" = "The amount of energy carried by a sound wave (perceived as loudness)",
  "intensity_variability" = "Dispersion of intensity (variance, standard deviation, change)"
)

