#Ce script génère unique_id après la création de la table primaire 
#Cet id est unique à chaque observation
library(dplyr)

create_unique_id <- function(data) { 
  site_id <- as.data.frame(seq(1:nrow(data))) #créer une seq avce une veleur pour toutes les lignes du df
  df_site <- cbind(data, site_id) 
  colnames(df_site)[ncol(df_site)] <- "unique_id" #nommer la nouvelle colonne "site_id"
  return(df_site) 

}

