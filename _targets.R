# Équipe : Juliette Boulet-Thomas, Bertrand Labrecque et Marika Roberge
# Travail sur les données de lépidoptères

## Charger les scripts nécessaires

#ajout et modif de la table brute
source("appel_data.R") #script qui met les données brutes dans un dataframe
source("nettoyage_data.R") #script d'une fonction qui ajoute des NA et corrige les erreurs d'orthographes retrouvés dans les données, il faudrait changer ça pour que ca remplace toutes les cases vides de lepidopteres par NA.
source("colonne_type.R") #script qui spécifie les types de colones de la table brute
source("uniformisation_lat_lon.R") #script qui uniformise le nombre de décimales des colonnes "lat" et "lon"
source("verification_data.R") #sript qui permet de valider et vérifier que nos modifications/corrections se sont bien faites
source("SQLite_tables.R") #script de SQL qui permet de créer nos tables (notre table primaire et nos deux tables secondaires)
source("create_unique_id.R") #script qui permet d'ajouter une colonne de id de site à la table primaire
source("cahier_laboratoire.Rmd") #script qui réfère à notre cahier de laboratoire, première version de notre RMarkDown pour le travail de session.
source("create_site_id.R") #script qui crée un site id pour changer la combinaison unique de lat et lon
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
    command= ajouter_id_site(data_avec_unique_id)
  ), 
  
  #Étape 8: créer SQL
  tar_target(
    name= create_db,
    command= create_database("lepido.db", ULTIME_database)
  ),
  
  #Étape 9: association au RMarkDown
  tar_render(
    cahier_labo,
    render("cahier_laboratoire.Rmd")
  )
)
  
#Nous n'avons pas réussi à afficher les données dans nos tables (notre table primaire et nos deux tables secondaires) et pas été en mesure non plus de faire une étape 9 pour faire le lien avec notre RmarkDown cahier de laboratoire.
#Pour le RMarkDown, on aurait ajouter ça comme étape 9 du pipeline : 
#tar_target(  #il faudrait mettre tar_render() ici et ensuite on peut le mettre dans notre pipeline
#cahier_labo,
#render("cahier_laboratoire.Rmd", output_format = "html_document"),
#format = "file"
#)
