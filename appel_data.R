#Fonction qui vva chercher nos donées
grosse_tab <- function(chemin){ 
  file_list <- list.files(path = chemin, pattern = "\\.csv$", full.names = TRUE)
  file_list <- file_list[basename(file_list) != "taxonomie.csv"]  # Exclure taxonomie.csv
  
  if (length(file_list) == 0) {
    stop("Aucun fichier CSV trouvé dans le dossier !")
  }
  
  daf <- lapply(file_list, function(x) read.csv(x, fill = TRUE))  # Lire les fichiers CSV
  df <- data.frame()  # Créer un dataframe vide
  
  column_names <- c("observed_scientific_name", "year_obs", "day_obs", "time_obs", 
                    "dwc_event_date", "obs_variable", "obs_unit", "obs_value", "lat", 
                    "lon", "original_source", "creator", "title", "publisher",
                    "intellectual_rights", "license", "owner")
  
  for (i in seq_along(daf)) {
    if (ncol(daf[[i]]) == length(column_names)) {
      colnames(daf[[i]]) <- column_names
      df <- rbind(df, daf[[i]])
    } else {
      warning(paste("Le fichier", file_list[i], "n'a pas le bon nombre de colonnes et sera ignoré."))
    }
  }
  
  return(df)
}
