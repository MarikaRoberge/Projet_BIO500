#Cette fonction permet d'uniformiser le format des données pour les valeurs des colonnes lat et lon pour que chaque valeur possède 5 décimales

uniformisation_decimales <- function(df, digits = 5) { 
  df$lat <- round(df$lat, digits)
  df$lon <- round(df$lon, digits)
  return(df)
}
