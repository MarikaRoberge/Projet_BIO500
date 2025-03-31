#Ceéation d'un id pour le site afin de la rajouter dans la table de base
ajouter_id_site <- function(df) {
  df$id_site <- as.numeric(factor(paste(df$lat, df$lon, sep = "_")))
  return(df)
}
