#Ce script génère unique_id après la création de la table primaire 

library(dplyr)

create_unique_id <- function(data) { 
  # if (!is.data.frame(data)) { #chek si l'argument data est vraiment un dataframe
  #   stop("L'entrée doit être un data frame")
  # }
  # 
  # # Concaténer les valeurs de toutes les colonnes en une seule chaîne
  # unique_strings <- apply(data, 1, function(row) paste(row, collapse = "_"))
  # 
  # # Convertir cette concaténation en facteur, puis en entier unique
  # data$unique_id <- as.integer(factor(unique_strings))
  #-------------------------------------------------------------------------------------------
  site_id <- as.data.frame(seq(1:nrow(data))) #créer une seq avce une veleur pour toutes les lignes du df
  df_site <- cbind(data, site_id) 
  colnames(df_site)[ncol(df_site)] <- "site_id" #nomer la nouvelle colonne "site_id"
  return(df_site) 

}

