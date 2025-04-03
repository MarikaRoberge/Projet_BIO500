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
  date_c(Brute) #fonction dans la fonction car ne fonctionne pas si on met ces lignes
  #directement dans la fonction (petit cheat)
}


#fonction passant la colonne dwc en date puis en character
  #pour enlever les TXX:XX:XX sans garder le format "date" problémaique
date_c <- function(X)
{ 
  X$dwc_event_date <- as.Date(X$dwc_event_date, tryFormats = "%Y-%m-%d" )
  X$dwc_event_date <- as.character(X$dwc_event_date)
  return(X)
}

