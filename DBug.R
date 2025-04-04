####################
####################

#Laboratoire permettant de tester des fichiers hors target hors fonction
#meilleur pour le débugage

####################
####################


{
  source("appel_data.R") #script qui met les données brutes dans un dataframe
  source("nettoyage_data.R") #script d'une fonction qui ajoute des NA et corrige les erreurs d'orthographes retrouvés dans les données, il faudrait changer ça pour que ca remplace toutes les cases vides de lepidopteres par NA.
  source("colonne_type.R") #script qui spécifie les types de colones de la table brute
  source("uniformisation_lat_lon.R") #script qui uniformise le nombre de décimales des colonnes "lat" et "lon"
  source("verification_data.R") #sript qui permet de valider et vérifier que nos modifications/corrections se sont bien faites
  source("SQLite_tables.R") #script de SQL qui permet de créer nos tables (notre table primaire et nos deux tables secondaires)
  source("create_unique_id.R") #script qui permet d'ajouter une colonne de id de site à la table primaire
  source("create_site_id.R") #script qui crée un site id pour changer la combinaison unique de lat et lon
}

#création de la tab de données
{
  Brute <- grosse_tab("lepidopteres")
  Brute <- clean_na(Brute)
  Brute <- type_colonne(Brute)
  Brute <- uniformisation_decimales(Brute)
  verif(Brute)
  
}


#table de sites:
# 
# sites_combinaisons <- unique(Brute[, c("lat", "lon")])
# nb <- as.data.frame(1:nrow(sites_combinaisons))
# sites_combinaisons <- cbind(sites_combinaisons, nb)
# 
# s_tab <- function(df, reference){
#     for(i in 1:nrow(df)){
#     for(j in nrow(reference)){
#      
#       pa <- as.character(c(df[i,9], df[i,10]))
#       pb <- as.character(c(reference[j,1], reference[j,2]))
#       
#       if (all(pa == pb)){
#         df[i,7] <- reference[j,3]
#       }
#       
#     }
#   }
#   return(df)
# }

r_tab <- function(df, reference) {
  # Initialize Brute with the same number of rows as df and appropriate columns
  #Brute <- df  # Assuming you want to modify df directly
  
  start_time <- Sys.time()  # Record the start time
  
  for (i in 1:nrow(df)) {
    for (j in 1:nrow(reference)) {  # Iterate over rows of reference
      pa <- as.character(c(df[i, 9], df[i, 10]))
      pb <- as.character(c(reference[j, 1], reference[j, 2]))
      
      if (all(pa == pb)) {
        df[i, 7] <- reference[j, 3]  # Assign value to the 7th column of Brute
      }
    }
    
    # Calculate elapsed time
    elapsed_time <- Sys.time() - start_time
    
    # Estimate remaining time
    estimated_time_per_iteration <- elapsed_time / i
    remaining_iterations <- nrow(df) - i
    estimated_time_left <- estimated_time_per_iteration * remaining_iterations
    
    # Print the estimated time left
    cat(sprintf("Iteration %d of %d. Estimated time left: %s\n", 
                i, nrow(df), format(estimated_time_left, digits = 2)))
  }
  
  total_time <- Sys.time() - start_time
  cat(sprintf("Total time taken: %s\n", format(total_time, digits = 2)))
  
  return(df)  # Return the modified Brute data frame
}

Brute <- r_tab(Brute, sites_combinaisons)
