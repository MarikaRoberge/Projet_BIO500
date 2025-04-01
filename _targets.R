# Équipe : Juliette Boulet-Thomas, Bertrand Labrecque et Marika Roberge
# Travail sur les données de lépidoptères



## Charger les scripts nécessaires

#ajout et modif de la table brute
source("appel_data.R") #script qui met les données brutes dans un dataframe
source("nettoyage_data.R") #script d'une fonction qui ajoute des NA et corrige les erreurs d'orthographes retrouvés dans les données, il faudrait changer ça pour que ca remplace toutes les cases vides de lepidopteres par NA.
source("colonne_type.R") #script qui spécifie les types de colones de la table brute
source("uniformisation_lat_lon.R") #script qui uniformise le nombre de décimales des colonnes "lat" et "lon"
source("verification_data.R") #sript qui permet de valider et vérifier que nos modifications/corrections se sont bien faites
source("site_id.R")
source("SQLite_tables.R")
source("inject_data.R")
#création de la table primaire et des tables secondaires
source("table_primaire.R") #script qui permet de construire la table primaire 
source("create_unique_id.R") #script qui permet d'ajouter une colonne de id de site à la table primaire
source("table_site.R") #script  qui permet de construire la table secondaire site, contenant les informations relatives au site (avec le site_id) 
source("table_date.R") #script qui permet de construire la table secondaire date, contenant les informations relatives à la date 


library(targets)
tar_option_set(packages = c("dplyr", "RSQLite", "readr", "DBI")) #Ici on met les packages qui seront nécessaire pour les différentes fonctions

#Faire une liste des targets (étapes du pipeline)

list(
  #Étape 1 : Mettre les données lepidopteres (brutes) dans un dataframe 
  tar_target(
    name= Brute, 
    command = grosse_tab("lepidopteres")  #définir le chemin pour le dossier lepidopteres
  ),
 
  #Étape 2 : Remplace les cases vides par NA et corrige les fautes d'orthographes retrouvées dans lepidopteres
  tar_target(
    name= data_no_na,
    command= clean_na(Brute)
  ),
  
  #Étape 3 : Définir les types des colonnes et appliquer les corrections
  tar_target(
    name= data_colonne_correction,
    command= type_colonne(data_no_na)
  ),
  
  #Étape 4 : Uniformisation du nombre de décimales des colonnes lat et long pour 5 décimales
  tar_target(
    name= data_final,
    command= uniformisation_decimales(data_colonne_correction)
  ),
  
  #Étape 5 : Vérification des corrections apportées lors des étapes 2 à 4
  tar_target(
    name= data_verif_fin,
    command= verif(data_final) #Ne crée pas un data frame mais simplement une conclusion
  ),
  
  #Étape 6 : ajouter id unique dans la database
  tar_target(
    name= data_avec_unique_id,
    command= create_unique_id(data_final)
  ),
  
  #Étape 7:  ajouter id_site dans la database
  tar_target(
    name= ULTIME_database,
    command= creation_site_id(data_avec_unique_id)
  ), 
  
  #Étape 8: créer SQL
  tar_target(
    name= create_db,
    command= create_database("lepido.db", ULTIME_database)
  )
)
  

