ajouter_id_site <- function(df, lat_col = "lat", lon_col = "lon") {
  if (!all(c(lat_col, lon_col) %in% colnames(df))) {
    stop("Les colonnes spécifiées n'existent pas dans le data.frame.")
  }
  
  df <- df[!is.na(df[[lat_col]]) & !is.na(df[[lon_col]]), ]  # Supprime les lignes avec NA
  df$site_id <- as.numeric(factor(paste(df[[lat_col]], df[[lon_col]], sep = "_")))
  
  return(df)
}