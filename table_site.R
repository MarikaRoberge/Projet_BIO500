# Fonction pour créer une table secondaire avec les détails du site

  create_site_table <- function(primaire, appel) { 
    # Utiliser les colonnes lat et lon de Brute (appel)
    tab_site <- cbind(primaire$unique_id, appel$lat, appel$lon)
    tab_site <- as.data.frame(tab_site)
    colnames(tab_site) <- c("id_site", "lat", "lon") #renommer les colonnes (mettre site_id si jamais au lieu de unique_id)
    return(tab_site)
  }