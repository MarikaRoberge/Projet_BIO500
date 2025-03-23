  create_site_table <- function(primaire, appel) { 
    
    #Créer une table avec les combinaisons uniques de latitude et longitude 
    
    site_table <- cbind(primaire$site_id, appel$lat, appel$lon)
    site_table <- as.data.frame(site_table)
    colnames(site_table) <- c("site_id", "lat","lon")
    return(site_table)
  }
  