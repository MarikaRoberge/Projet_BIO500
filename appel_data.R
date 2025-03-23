library(dplyr)

#fonction qui prend le working directory en arrgument et retourne le dataframe avec toutes les données
grosse_tab <- function(chemin){ 
  
  setwd(chemin) #working directory pour le fchier les lepidopteres
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

concordance <- function(df) {
 
  df$dwc_event_date <- as.Date(gsub("T.*", "", df$dwc_event_date)) #converti les char en type DATE pour dwc_event_date
  
  
  return(df)
  
}

#Nouvelle fonction pour clean les données de table primaire 

clean_na <- function(df) { 
  df[df == ''] <- NA# Remplace les cases vides ou "Na" par NA 
  
  df<- df %>% mutate(obs_variable= recode(obs_variable, " pr@#sence " = "presence")) #correction d'erreur d'orthographe
  df <- df%>%mutate(time_obs=recode(time_obs, "0" = "Na")) #remplacement seule donnée "0" par NA
  
  return(df)
  } 

#
