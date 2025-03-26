# Fonction pour créer une table secondaire avec les détails du site
  create_site_table <- function(primaire, appel) { 
    
    # Créer une table avec les combinaisons uniques de latitude et longitude
    site_table <- cbind(primaire$unique_id, appel$lat, appel$lon)
    site_table <- as.data.frame(site_table)
    
    # Renommer les colonnes
    colnames(site_table) <- c("unique_id", "lat", "lon")
    
    return(site_table)
  }
  