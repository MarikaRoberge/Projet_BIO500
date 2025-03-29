library(dplyr)

#fonction qui prend le working directory en argument et retourne le dataframe avec toutes les données
grosse_tab <- function(chemin){ 
  
  setwd(chemin)
  file_list = list.files(pattern="*.csv") #crée une liste avec tous les fichiers terminants avec .csv
  file_list <- file_list[file_list != "taxonomie.csv"] #retire le fichier "taxonomie"
  
  daf <- lapply(file_list, read.csv) #importe tous les fichiers dans une liste et les convertis en dataframe
  df <- data.frame()  # Création d'un dataframe vide pour concaténer les données
  
  # Nommer les colonnes une seule fois avant la boucle
  column_names <- c("observed_scientific_name", "year_obs", "day_obs", "time_obs", 
                    "dwc_event_date", "obs_variable", "obs_unit", "obs_value", "lat", 
                    "lon", "original_source", "creator", "title", "publisher",
                    "intellectual_rights", "license", "owner")
  
  # Boucle pour itérer sur les fichiers CSV et combiner les données
  for (i in 1:length(file_list)) {
    colnames(daf[[i]]) <- column_names  # Assigner les noms de colonnes à chaque dataframe
    df <- rbind(df, daf[[i]])  # Ajouter chaque dataframe au dataframe principal df
  }
  return(df) #retourne de dataframe
}

