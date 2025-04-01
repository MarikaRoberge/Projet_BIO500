
verif <- function(df){
  v <- class(df$dwc_event_date)
  
  if(v == "Date"){
    cat("le format date est bien programmé \n")
  }
  if(v != "Date"){
    cat("format non date \n")
  }
  
  # Vérifier s'il reste des chaînes vides
  empty_cells <- sapply(df, function(col) any(col == "", na.rm = TRUE))
  
  # Afficher les résultats
  if (any(empty_cells, na.rm = TRUE)) {
    cat("Il y a encore des cases vides dans les colonnes suivantes :\n")
    print(names(df)[empty_cells])
  } else {
    cat("Toutes les cases vides ont été remplacées par NA.\n")
  }
  
  
  presence <- any(df$obs_variable == "pr@#sence", na.rm = TRUE)
  
  # Afficher les résultats
  if (any(presence, na.rm = TRUE)) {
    cat("Il y a encore des occurrences de 'pr@#sence' dans la colonne",".\n")
  } else {
    cat("Tous les 'pr@#sence' ont été remplacés par 'presence' dans la colonne", ".\n")
  }
  
  zero <- any(df$time_obs == "0", na.rm = TRUE)
  
  # Afficher les résultats
  if (any(zero, na.rm = TRUE)) {
    cat("Il y a encore des occurrences de '0' dans la colonne",".\n")
  } else {
    cat("Tous les '0' ont été remplacés par 'NA' dans la colonne", ".\n")
  }
  
}
