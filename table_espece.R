  #Ici, on veut créer une table secondaire qui réfère aux informations de n_espece de la table primaire, 
#soit: #obs_value et observed_scientific_name  

table_esp <- function(data) { 
  
  table_esp <- cbind(data$observed_scientific_name, data$obs_value) 
  colnames(table_esp) <- c("observed_scientific_name", "obs_value") 
    
    return(as.data.frame(table_esp))  
  
} 

#faudrait-il rajouter le site_id dans cette table?