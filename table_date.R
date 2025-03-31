# Fonction pour créer une table secondaire donnant des détails sur la date
create_table_date <- function(primaire, data) { 
  
  tab_date <- cbind(primaire$unique_id, data$year_obs, data$day_obs, data$time_obs, data$dwc_event_date)
  colnames(tab_date) <- c("unique_id", "year_obs", "day_obs", "time_obs", "dwc_event_date") #enlever le dwc_event_date si on met un unique_id, car sinon redondance d'information
  
  return(as.data.frame(tab_date))
}
