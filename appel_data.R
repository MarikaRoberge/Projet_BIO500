library(dplyr)

#fonction qui prend le working directory en argument et retourne le dataframe avec toutes les données
grosse_tab <- function(chemin){ 
  
  
  file_list = list.files(pattern="*.csv") #crée une liste avec tous les fichiers terminants avec .csv
  file_list <- file_list[file_list != "taxonomie.csv"] #retire le fichier "taxonomie"
  
  daf <- lapply(file_list, read.csv) #importe tous les fichiers dans une liste et les convertis en dataframe
  df <- data.frame() #création d'un dataframe pour la boucle
  
  for(i in 1:154) { #passe tous les datas frame pour les combiner en un seul
    colnames(daf[[i]]) <- c("observed_scientific_name","year_obs","day_obs","time_obs", #nommer tous les tableaux avec le même
                            #header pour tous les dataframes pour éviter des erreurs de titres eet de non-concordance
                                            "dwc_event_date","obs_variable","obs_unit","obs_value","lat", 
                                            "lon","original_source","creator","title","publisher",
                                            "intellectual_rights","license","owner")
    df <- rbind(df, daf[[i]])  # Append each data frame to df fisionner chque dataframes au dataframe principal (df)
  }
  return(df) #retourne de dataframe
}

