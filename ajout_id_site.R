#Fonction pour créer une table avec les id de site et les dates, bon un des problèmes et que y a des Na... 
create_event_table <- function(data) { 

#Créer une table avec des IDs d'événements basés sur les combinaisons uniques de site_id et dwc_event_date 

data$event_id <- paste(data$site_id, data$year_obs, data$day_obs, data$time_obs ,data$dwc_event_date, sep = "_") 

#Créer la table #Revoir car on ne crée pas de table, on veux seulement merger cette nouvelle colonne avec la table primaire!!

event_table <- data.frame( site_id = data$site_id, year= data$year_obs, field_day=data$day_obs, time=data$time_obs, dwc_event_date = data$dwc_event_date ) 

return(event_table) } 
