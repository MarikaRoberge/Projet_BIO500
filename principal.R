# Équipe : Juliette Boulet-Thomas, Bertrand Labrecque et Marika Roberge
# Travail sur les données de lépidoptères

## Charger les scripts nécessaires

#ajout et modif de la table brute
source("appel_data.R") #script qui met les données brutes dans un dataframe
source("nettoyage_data.R") #script d'une fonction qui ajoute des NA et corrige les erreurs d'orthographes retrouvés dans les données, il faudrait changer ça pour que ca remplace toutes les cases vides de lepidopteres par NA.
source("colonne_type.R") #script qui spécifie les types de colones de la table brute
source("formatage_date.R") #script qui converti la colonne dc_event_date en type date
source("uniformisation_lat_lon") #script qui uniformise le nombre de décimales des colonnes "lat" et "lon"
source("verification_data.R") #sript qui permet de valider et vérifier que nos modifications/corrections se sont bien faites

#création de la table primaire et des tables secondaires
source("table.primaire") #script qui permet de construire la table primaire 
source("ajout_id_site.R") #script qui permet d'ajouter une colonne de id de site à la table primaire
source("table_site.R") #script  qui permet de construire la table secondaire site, contenant les informations relatives au site (avec le site_id) 
source("table_date.R") #script qui permet de construire la table secondaire date, contenant les informations relatives à la date 
source("table_espece.R") #script qui permet de construire la table secondaire espece, contenant les informations relatives à l'espèce


##Étapes :   #écrire des étapes qui montrent ce à quoi chaque fonction réfère

#Étape 1 : Mettre les données lepidopteres (brutes) dans un dataframe 
Brute <- grosse_tab("lepidopteres") #définir le chemin pour le dossier lepidopteres

#Étape 2 : Remplace les cases vides par NA et corrige les fautes d'orthographes retrouvées dans lepidopteres
clean_na(Brute)

#Étape 3 : Définir les types des colonnes et appliquer les corrections
type_colonne(Brute)

#Étape 4 : Conversion de la colonne dwc_event_date en en type DATE
formatage_data(Brute)

#Étape 5 : Uniformisation du nombre de décimales des colonnes lat et long pour 5 décimales
uniformisation_decimales(Brute)

#Étape 6 : Vérification des corrections apportées lors des étapes 2 à 5
verification_data(Brute)

#Étape 7 : Création de la table primaire 
tab_primaire(Brute)

#Étape 8 : Ajout d'une colonne id_site (revoir si c'est le bon nom de colonne) à la table primaire
#revoir le nom de la fonction

#Étape 9 : Création de la table secondaire site
create_site_table(primaire)

#Étape 10 : Création de la table secondaire date
#revoir pour le nom de la fonction (semble être le même que pour l'étape 8)

#Étape 11 : Création de la table secondaire espece
table_esp(primaire)

#Étape 12 : SQL de la table primaire et des tables secondaires?



## Charger la table primaire et les tables secondaires

tab_prim <- tab_primaire(Brute) 
tab_site <- create_site_table(tab_prim, Brute)
tab_esp <- table_esp(Brute)
tab_date <- create_event_table(tab_prim, Brute) 

