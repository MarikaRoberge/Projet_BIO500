#Nouvelle fonction pour clean les données de table primaire

clean_na <- function(df) {
  df[df == ''] <- NA# Remplace les cases vides ou "Na" par NA

  df$obs_variable <- gsub("pr@#sence", "presence", df$obs_variable) #correction d'erreur d'orthographe
  df$time_obs <- gsub("0", "NA", df$time_obs) #remplacement seule donnée "0" par NA
  #df <- df%>%mutate(time_obs=recode(time_obs, "0" = "Na")) 
  return(df)
  }