##Création d'une table primaire regroupant trois colonnes : 

library(dplyr)

tab_primaire <- function(tab) {
  # Sélectionner les colonnes d'intérêt pour la table primaire
  primaire <- tab %>%
<<<<<<< HEAD
    select(observed_scientific_name, dwc_event_date, obs_value, id_site, unique_id) %>%
=======
    select(observed_scientific_name, dwc_event_date, obs_value, site_id) %>%
>>>>>>> 5da16b924a55645e80e0ec6a86d70ff130bc9022
    as.data.frame(tab_primaire)
  
  return(primaire)
}
