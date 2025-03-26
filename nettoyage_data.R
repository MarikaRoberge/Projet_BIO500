#Nouvelle fonction pour clean les données de table primaire

clean_na <- function(df) {
  df[df == ''] <- NA # Remplace les cases vides ou "Na" par NA

  df$obs_variable <- gsub("pr@#sence", "presence", df$obs_variable) #correction des erreurs d'orthographe
  df$time_obs <- gsub("00:00:00", NA, df$time_obs)
  df$time_obs <- gsub("0", NA, df$time_obs) #remplacement seule donnée "0" et "00:00:00" par NA 
  #df <- df%>%mutate(time_obs=recode(time_obs, "0" = "Na"))   #changer 0 pour rien et ensuite rien pour NA car problème 00:00:00 devient NANA:NANA:NANA
  return(df)
  }