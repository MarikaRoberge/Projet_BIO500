# Équipe : Juliette Boulet-Thomas, Bertrand Labrecque et Marika Roberge
# Travail sur les données de lépidoptères

##Charger les scripts nécessaires
#Ajouts et modifications de la table brute
{
  source("appel_data.R") #1. script qui met les données brutes dans un dataframe
  source("nettoyage_data.R") #2. script d'une fonction qui ajoute des NA et corrige les erreurs d'orthographes retrouvés dans les données
  source("colonne_type.R") #3. script qui spécifie les types de colones de la table brute
  source("uniformisation_lat_lon.R") #4. script qui uniformise le nombre de décimales des colonnes "lat" et "lon"
  source("verification_data.R") #5. sript qui permet de valider et vérifier que nos modifications/corrections se sont bien faites
  source("SQLite_tables.R") #6. script de SQL qui permet de créer nos tables (notre table primaire et nos deux tables secondaires)
  source("create_unique_id.R") #7. script qui permet d'ajouter une colonne de id de site à la table primaire
  source("create_site_id.R") #8. script qui crée un site id pour changer la combinaison unique de lat et lon
  source("creer_cartes_diversite.R") #10. script pour faire les cartes de biodiversité dans le temps avec des gap de 25 ans
  source("creer_graph_diversite.R")
  source("intermediaire.R")
  source("SQL2.0.R")
  ##Téléchargement des librairies pour _targets.R
  library(targets)
  library(tarchetypes) # Utilisé pour render le rapport (tar_render)
  tar_option_set(packages = c("dplyr", "RSQLite", "readr", "DBI", "tarchetypes", "sf", "ggplot2","canadianmaps", "rnaturalearth", "patchwork", "rmarkdown", "wk", "labeling")) #Ici, on met les packages qui seront nécessaires pour les différentes fonctions de nos différents scripts
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
  
  #Étape 9: Association au rapport RMarkDown
  tar_render(
    name = rapport, # Cible du rapport
    path = "Rapport/Rapport.Rmd" # Le path du rapport à renderiser
  ),

  #Étape intermédiaire
  tar_target(
    name = donnees_carte,
    command = intermediaire(create_db)
  ),
  
  #Étape 10: Faire les cartes de biodiversité dans le temps
  tar_target(
    cartes_diversite,
    creer_cartes_diversite(
      donnees = donnees_carte,
      cellsize = 50000,
      output_dir = "Figures_analyse"
    ),
    format = "file" 
  ),
  #Étape 11: Faire le graphique de biodiversité dans le temps
  tar_target(
    graphique_diversite,
    creer_graphique_diversite(
      donnees = donnees_qc,  # Remplace 'donnees_qc' par le nom réel de l'objet filtré pour Québec si différent
      output_dir = "Figures_analyse"
    )
  )
)





