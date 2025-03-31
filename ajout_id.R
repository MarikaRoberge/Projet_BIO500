#Pour rajouter un id_site dans la base de données
ajouter_id_site <- function(df) {
  df$id_site <- as.numeric(factor(paste(df$lat, df$lon, sep = "_")))
  return(df)
}
