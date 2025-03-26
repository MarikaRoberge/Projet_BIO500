##Création d'une table primaire regroupant trois colonnes : 

library(dplyr) 

tab_primaire <- function(tab){
  
  #Sélectionner les colonnes d'intérêt provenant de Data : 
  
  table_primaire <- cbind(tab$observed_scientific_name, tab$dwc_event_date, tab$obs_value)
  primaire <- as.data.frame(table_primaire)
  site_id <- as.integer(factor(paste(tab$lat,tab$lon)))
  primaire <- cbind(primaire, site_id) #intégration dans la table primaire de la colonne ''site_id'' #pas mettre ici, mais ajout du site id dans script ajout_id_site
  colnames(primaire) <- c("observed_scientific_name", "dwc_event_date", "obs_value", "site_id")
  
  
  return(primaire)
}


