# Équipe : Juliette Boulet-Thomas, Bertrand Labrecque et Marika Roberge
# Travail sur les données de lépidoptères

##Charger les scripts nécessaires
#Ajouts et modifications de la table brute
{
  source("appel_data.R") #script qui met les données brutes dans un dataframe
  source("nettoyage_data.R") #script d'une fonction qui ajoute des NA et corrige les erreurs d'orthographes retrouvés dans les données
  source("colonne_type.R") #script qui spécifie les types de colones de la table brute
  source("uniformisation_lat_lon.R") #script qui uniformise le nombre de décimales des colonnes "lat" et "lon"
  source("verification_data.R") #sript qui permet de valider et vérifier que nos modifications/corrections se sont bien faites
  source("create_unique_id.R") #script qui permet d'ajouter une colonne de id de site à la table primaire
  source("create_site_id.R") #script qui crée un site id pour changer la combinaison unique de lat et lon
  source("creer_cartes_diversite.R") #script pour faire les cartes de biodiversité dans le temps avec des gap de 25 ans
  source("creer_graph_diversite.R") #script pour créer le graphique de diversité
  source("intermediaire_cartes.R") #script qui joint les fichiers pour l'analyse des cartes de diversit.
  source("intermediaire_graph.R") #script qui joint les fichiers pour l'analyse graphique
  source("intermediaire_points.R") #script qui joint les fichiers pour creation graphique points
  source("creer_cartes_pcanadensis.R") #fonction qui crée les graphiques de points
  source("SQLtables.R")  # script de SQL qui permet de créer nos tables (notre table primaire et nos deux tables secondaires)
  ##Téléchargement des librairies pour _targets.R
  library(targets)
  library(tarchetypes) # Utilisé pour render le rapport (tar_render)
  tar_option_set(packages = c("dplyr", "RSQLite", "readr", "DBI", "tarchetypes", #Ici, on met les packages qui seront nécessaires pour les différentes fonctions de nos différents scripts
                              "sf", "ggplot2","canadianmaps", "rnaturalearth", 
                              "patchwork", "rmarkdown", "wk", "labeling","magick")) 
}

##Liste des targets (étapes du pipeline)
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
  
  #Étape 6 : Ajouter unique_id dans la database
  tar_target(
    name= data_avec_unique_id,
    command= create_unique_id(data_final)
  ),
  
  #Étape 7: Ajouter site_id dans la database
  tar_target(
    name= ULTIME_database,
    command= ajouter_id_site(data_avec_unique_id)
  ), 
  
  #Étape 8: créer les table SQLs
  tar_target(
    name= create_db,
    command= create_database("lepido.db", ULTIME_database)
  ),

  #Étape 9 : intermédiaire cartes
  tar_target(
    name = donnees_carte,
    command = intermediaire1(create_db)
  ),
  
  # Étape 10 : Cartes de diversité
  tar_target(
    name = cartes_diversite,
    command = creer_cartes_diversite(donnees_carte, 50000, "Rapport"),
    format = "file"
  ),
  
  # Étape 11 : Intermédiaire graphique
  tar_target(
    name = donnees_graphique, 
    command = intermediaire2(create_db)),
  
  # Étape 12 : Graphique de diversité
  tar_target(
    name = graphique_diversite,
    command = creer_graphique_diversite(donnees_graphique, "Rapport"),
    format= "file"
  ),
  
  # Étape 13 : Intermédiaire points
  tar_target(
    name = donnees_points, 
    command = intermediaire3(create_db)),
  
  # Étape 14 : Graphiques de points
  tar_target(
    name = graphique_points,
    command =graph_points(donnees_points, "Rapport"),
    format = "file"
  )
  
   #Étape 13: Association au rapport RMarkDown
  # tar_render(
  #  name = rapport, # Cible du rapport
  #  path = "Rapport/Rapport.Rmd" # Le path du rapport à renderiser
   )


