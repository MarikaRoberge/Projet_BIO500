#Fonction pour créer une table avec les id de site et les dates, bon un des problèmes et que y a des Na... 
create_event_table <- function(primaire, data) { 

event_table<- cbind(primaire$site_id, data$year_obs, data$day_obs, data$time_obs, data$dwc_event_date)
colnames(event_table)<-c("site_id","year_obs","day_obs","time_obs", "dwc_event_date") 

return(as.data.frame(event_table))
}
