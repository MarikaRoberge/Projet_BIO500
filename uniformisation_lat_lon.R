#Cette fonction permet d'uniformiser le format des données pour les valeurs des colonnes lat et lon pour que chaque valeur possède 5 décimales

uniformisation_decimales <- function(df) { 
  df$lat <- round(df$lat, digits = 5)
  df$lon <- round(df$lon, digits = 5)
  return(df)
}
