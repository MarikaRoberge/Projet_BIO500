# Fonction pour créer une table secondaire avec les détails du site

  create_site_table <- function(primaire, appel) { 
    # Utiliser les colonnes lat et lon de Brute (appel)
    site_table <- cbind(primaire$unique_id, appel$lat, appel$lon)
    site_table <- as.data.frame(site_table)
    colnames(site_table) <- c("unique_id", "lat", "lon") #renommer les colonnes
    return(site_table)
  }