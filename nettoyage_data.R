#Ce script crée une fonction pour nettoyer les données

clean_na <- function(df) {
  df[df == ''] <- NA # Remplace les cases vides ou "Na" par NA

  df$obs_variable <- gsub("pr@#sence", "presence", df$obs_variable) #correction des erreurs d'orthographe et occurence=presence donc changer occurence pour presence
  df$time_obs <- gsub("00:00:00", NA, df$time_obs)
  df$time_obs <- gsub("0", NA, df$time_obs) #remplacement seule donnée "0" et "00:00:00" par NA
  df$dwc_event_date <- sub("T00:00:00$", "", df$dwc_event_date)
  df$year_obs <- sub("^([0-9]{4}).*", "\\1", ma_table$year_obs)
  df$obs_value <- gsub("11111", "1", df$obs_value) #élimine la valeur problématique 111111 dans obs_value, cette valeur n'est pas vraiment cohérente
  return(df)
}
