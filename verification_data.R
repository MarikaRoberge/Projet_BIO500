
verif <- function(df){
  v <- class(df$dwc_event_date) #tester la classe d'objet du dwc_event_date de notre data frame
  
  if(v == "character"){
    cat("le format character est bien programmé \n") 
  }
  if(v != "character"){
    cat("format non character \n")
  }
  
  # Vérifier s'il reste des chaînes vides
  empty_cells <- sapply(df, function(col) any(col == "", na.rm = TRUE)) #regarder toutes les 
  #colonnes du df et retourner une valeur TRUE s'il reste des epaces vides
  
  # Afficher les résultats
  if (any(empty_cells, na.rm = TRUE)) { 
    cat("Il y a encore des cases vides dans les colonnes suivantes :\n")
    print(names(df)[empty_cells])
  } else {
    cat("Toutes les cases vides ont été remplacées par NA.\n")
  }
  
  
  presence <- any(df$obs_variable == "pr@#sence", na.rm = TRUE) #valeur TRUE s'il y a des erreurs de typo pr@#sence 
  
  # Afficher les résultats
  if (any(presence, na.rm = TRUE)) {
    cat("Il y a encore des occurrences de 'pr@#sence' dans la colonne",".\n")
  } else {
    cat("Tous les 'pr@#sence' ont été remplacés par 'presence' dans la colonne", ".\n")
  }
  
  zero <- any(df$time_obs == "0", na.rm = TRUE) #vérifier s'il n'y a plus de valeur 0 dans time_obs, retourner un TRUE s'il y en a
  
  # Afficher les résultats
  if (any(zero, na.rm = TRUE)) {
    cat("Il y a encore des occurrences de '0' dans la colonne",".\n")
  } else {
    cat("Tous les '0' ont été remplacés par 'NA' dans la colonne", ".\n")
  }
  
  date_check <- grepl("^\\d{4}-\\d{2}-\\d{2}$", df$dwc_event_date)
  
  # Afficher les résultats
  if (any(!date_check, na.rm = TRUE)) {
    cat("Il y a des valeurs non conformes dans la colonne 'dwc_event_date'. Ces valeurs doivent être des dates au format 'YYYY-MM-DD'.\n")
  } else {
    cat("Toutes les valeurs dans la colonne 'dwc_event_date' sont des dates au format 'YYYY-MM-DD'.\n")
  }
  
  year_check <- grepl("^\\d{4}$", df$year_obs)  # Vérifie que chaque entrée dans year_obs est une année à 4 chiffres
  
  #Afficher les résultats 
  if (any(!year_check, na.rm = TRUE)) {
    cat("Il y a des valeurs non conformes dans la colonne 'year_obs'. Ces valeurs doivent être des années à 4 chiffres.\n")
  } else {
    cat("Toutes les valeurs dans la colonne 'year_obs' sont des années à 4 chiffres.\n")
  }

  cent <- any(df$obs_value == "11111", na.rm = TRUE) #vérifier s'il n'y a plus de valeur 0 dans time_obs, retourner un TRUE s'il y en a
  
  #Afficher les résultats
  if (any(cent, na.rm = TRUE)) {
    cat("Il y a encore une erreur de 11111 dans la colone obs_value",".\n")
  } else {
    cat("Il n'y a plus d'erreur dans la colone obs_value", ".\n")
  }
  
}
