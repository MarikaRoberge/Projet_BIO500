##Création d'une table primaire regroupant trois colonnes : 

library(dplyr)

tab_primaire <- function(tab) {
  # Sélectionner les colonnes d'intérêt pour la table primaire
  primaire <- tab %>%
    select(observed_scientific_name, dwc_event_date, obs_value, site_id) %>%
    as.data.frame(tab_primaire)
  
  return(primaire)
}
