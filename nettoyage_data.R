#Nouvelle fonction pour clean les données de table primaire

clean_na <- function(df) {
  df[df == ''] <- NA# Remplace les cases vides ou "Na" par NA

  df<- df %>% mutate(obs_variable= recode(obs_variable, " pr@#sence " = "presence")) #correction d'erreur d'orthographe
  df <- df%>%mutate(time_obs=recode(time_obs, "0" = "Na")) #remplacement seule donnée "0" par NA

  return(df)
  }