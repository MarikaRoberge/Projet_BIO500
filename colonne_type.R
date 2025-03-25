library(readr)
library(dplyr)

# Définition des types de colonnes
col_types <- cols(
  observed_scientific_name = col_character(),
  year_obs = col_integer(),
  day_obs = col_integer(),
  time_obs = col_character(),      # On laisse en character (pour le moment)
  dwc_event_date = col_character(),  # On laisse en character (pour le moment)
  obs_variable = col_character(),
  obs_unit = col_character(),
  obs_value = col_double(),
  lat = col_double(),
  lon = col_double(),
  original_source = col_character(),
  creator = col_character(),
  title = col_character(),
  publisher = col_character(),
  intellectual_rights = col_character(),
  license = col_character(),
  owner = col_character()
)

# Fonction pour charger un fichier et appliquer les corrections
type_colonne <- function(file_path) {
  df <- read.csv(file_path, col_types = col_types, col_names = TRUE, na = c("", "NA"))  #ne marche pas 
  return(df)  # Pas de conversion des dates ici
}

library(dplyr)
#Fonction qui définit les types de colonnes :

col_types <- function(Brute) {
  Brute %>%
    mutate(
      observed_scientific_name = as.character(observed_scientific_name),
      year_obs = as.integer(year_obs),
      day_obs = as.integer(day_obs),
      time_obs = as.character(time_obs),
      dwc_event_date = as.character(dwc_event_date),
      obs_variable = as.character(obs_variable),
      obs_unit = as.character(obs_unit),
      obs_value = as.numeric(obs_value),
      lat = as.numeric(lat),
      lon = as.numeric(lon),
      original_source = as.character(original_source),
      creator = as.character(creator),
      title = as.character(title),
      publisher = as.character(publisher),
      intellectual_rights = as.character(intellectual_rights),
      license = as.character(license),
      owner = as.character(owner)
    )
}

