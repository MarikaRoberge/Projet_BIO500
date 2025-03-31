# Équipe : Juliette Boulet-Thomas, Bertrand Labrecque et Marika Roberge
# Travail sur les données de lépidoptères

##On pourrait ajouter les librairies qu'on a utilisé dans les scripts (au lieu de les répéter dans chaque script concerné)


## Charger les scripts nécessaires

#ajout et modif de la table brute
source("appel_data.R") #script qui met les données brutes dans un dataframe
source("nettoyage_data.R") #script d'une fonction qui ajoute des NA et corrige les erreurs d'orthographes retrouvés dans les données, il faudrait changer ça pour que ca remplace toutes les cases vides de lepidopteres par NA.
source("colonne_type.R") #script qui spécifie les types de colones de la table brute
source("uniformisation_lat_lon.R") #script qui uniformise le nombre de décimales des colonnes "lat" et "lon"
source("verification_data.R") #sript qui permet de valider et vérifier que nos modifications/corrections se sont bien faites
source("create_unique_id")
source("Ajout_id_site")
#création de la table primaire et des tables secondaires
source("table_primaire.R") #script qui permet de construire la table primaire 
source("create_unique_id.R") #script qui permet d'ajouter une colonne de id de site à la table primaire
source("table_site.R") #script  qui permet de construire la table secondaire site, contenant les informations relatives au site (avec le site_id) 
source("table_date.R") #script qui permet de construire la table secondaire date, contenant les informations relatives à la date 

library(targets)
tar_option_set(packages = c("dplyr", "RSQLite", "readr")) #Ici on met les packages qui seront nécessaire pour les différentes fonctions

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
    name= data_uniform_dec,
    command= uniformisation_decimales(data_no_na)
  ),
  
  #Étape 5 : Vérification des corrections apportées lors des étapes 2 à 5
  tar_target(
    name= data_brute_ULTIME,
    command= verif(data_uniform_dec)
  ),
  
  tar_target(
    name= data_idsite
    command= ajouter_id_site(data_brute_ULTIME)
  )
  tar_target(
    name= data_ULTIME_with_ID,
    command= create_unique_id(data_idsite)
  ),
  
  
  ####Ajouter une étape ou on crée un nouveau dataframe Brute avec les modifs apportés? on devrait référer à ce nouveau dataframe dans les prochaines étapes pour la création de nos tables.
  ####Car par exemple, dans la table primaire, dwc_event_date ne sort pas dans le bon format (on aimerait seulement année-mois-jour et aussi enlever dwc_event_date dans la table de date, car redondance)
  
  #Étape 6 : Création de la table primaire (sans unique_id) ####BUG POUR TARGET
  tar_target(
    name= tab_prim_sans_id,
    command= tab_primaire(data_brute_ULTIME)
  ),
  
  #Étape 7 : Ajout de `unique_id` basé sur les colonnes de `tab_prim`de l'étape 6
  tar_target(
    name= tab_prim,
    command= create_unique_id(tab_prim_sans_id)
  ),
  
  #Étape 8 : Création de la table secondaire site
  tar_target(
    name= tab_site,
    command= create_site_table(tab_prim_vide, data_brute_ULTIME)
  ),
  
  #Étape 9 : Création de la table secondaire date
  tar_target(
    name= tab_date,
    command= create_table_date(tab_prim, data_brute_ULTIME)
  )
)


