#creation d'une clé primaire de la table primaire nommée site_id

creation_site_id <- function(df)
{
  site_id <- as.data.frame(seq(1:nrow(df))) #créer une seq avce une veleur pour toutes les lignes du df
  df_site <- cbind(df, site_id) 
  colnames(df_site)[ncol(df_site)] <- "site_id" #nomer la nouvelle colonne "site_id"
  return(df_site)
}
