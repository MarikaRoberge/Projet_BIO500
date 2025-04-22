#Ce script génère site_id
#Site_id est un chiffre associé pour tout les points géographique distinct
ajouter_id_site <- function(df, lat_col = "lat", lon_col = "lon") {
  if (!all(c(lat_col, lon_col) %in% colnames(df))) {
    stop("Les colonnes spécifiées n'existent pas dans le data.frame.")
  }
  
  df <- df[!is.na(df[[lat_col]]) & !is.na(df[[lon_col]]), ]  # Supprime les lignes avec NA si il y en a
  df$site_id <- as.numeric(factor(paste(df[[lat_col]], df[[lon_col]], sep = "_")))
  
  return(df)
}