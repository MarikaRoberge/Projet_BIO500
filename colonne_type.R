library(dplyr)

# Fonction qui définit les types de colonnes
type_colonne <- function(Brute) {  
  Brute %>%
    mutate(
      observed_scientific_name = as.character(observed_scientific_name),
      year_obs = as.integer(year_obs),
      day_obs = as.integer(day_obs),
      time_obs = as.character(time_obs),
      dwc_event_date = as.character(dwc_event_date),  #on le laisse en character pour l'instant
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

# Utilisation de la fonction
Brute <- type_colonne(Brute)  # Applique la transformation au dataframe de nos données brutes

