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



# date_c <- function(X){
#  
#   X$dwc_event_date <- as.Date(X$dwc_event_date, tryFormats = "%Y-%m-%d" )
#   X$dwc_event_date <- as.character(X$dwc_event_date)
#   return(X)
#   
# }



print(class(Brute$dwc_event_date))
Brute$dwc_event_date <- as.Date(Brute$dwc_event_date, tryFormats = "%Y-%m-%d" )
Brute$dwc_event_date <- as.character(Brute$dwc_event_date)
print(class(Brute$dwc_event_date))
