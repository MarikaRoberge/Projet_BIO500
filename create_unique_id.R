#Ce script génère unique_id après la création de la table primaire 

library(dplyr)

create_unique_id <- function(data) { 
  if (!is.data.frame(data)) { #chek si l'argument data est vraiment un dataframe
    stop("L'entrée doit être un data frame")
  }
  
  # Concaténer les valeurs de toutes les colonnes en une seule chaîne
  unique_strings <- apply(data, 1, function(row) paste(row, collapse = "_"))
  
  # Convertir cette concaténation en facteur, puis en entier unique
  data$unique_id <- as.integer(factor(unique_strings))
  
  return(data)
}

