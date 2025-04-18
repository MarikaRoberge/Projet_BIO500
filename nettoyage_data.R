#Ce script crée une fonction pour nettoyer les données

clean_na <- function(df) {
  df[df == ''] <- NA # Remplace les cases vides ou "Na" par NA

  df$obs_variable <- gsub("pr@#sence", "presence", df$obs_variable) #correction des erreurs d'orthographe et occurence=presence donc changer occurence pour presence
  df$time_obs <- gsub("00:00:00", NA, df$time_obs)
  df$time_obs <- gsub("0", NA, df$time_obs) #remplacement seule donnée "0" et "00:00:00" par NA 
  #df <- df%>%mutate(time_obs=recode(time_obs, "0" = "Na"))   #remplace les valeurs "0" par "Na" dans la colonne time_obs du data frame df
  #df$obs_value <- gsub("11111", "1", df$obs_value) #élimine la valeur problématique 111111 dans obs_value
  return(df)
}

#rajouter une ligne pour changer XX:XX:XX pour rien dans la colonne dwc_event_date
#si on change nettoyage_data on doit aussi changer verification data