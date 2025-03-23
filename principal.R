#ajout et modif de la table brute
source("appel_data.R") #script qui met les données brutes dans un dataframe
source("nettoyage_data.R") #script d'une fonction qui ajoute des NA et corrige les erreurs d'orthographes retrouvés dans les données, il faudrait changer ça pour que ca remplace toutes les cases vides de lepidopteres par NA.
source("colonne_type.R") #script qui spécifie les types de colones de la table brute
source("formattage_date.R") #script qui converti la colonne dc_event_dte en type date
source("verification_data.R") #sript qui permet de valider et vérifier que nos modifications/corrections se sont bien faites

source("ajout_id_site.R") #script qui permet d'ajouter une colonne de id de site
source("table_primaire.R") #script qui assemble les données sous forme d'une table primaire 
source("table_date.R") #script qui permet de construire la table secondaire date, contenant les informations relatives à la date  
source("table_site.R") #script qui permet de construire la table secondaire site, contenant les informations relatives au site (avec le site_id)
source("table_espece.R") #script qui permet de construire la table secondaire espece, contenant les informations relatives à l'espèce




Data <- grosse_tab("lepidopteres")
#définir le chemin pour le dossier lepidopteres
Data<-concordance(Data)
Data <- clean_na(Data)

tab_prim <- tab_primaire(Data)
tab_site <- create_site_table(tab_prim, Data)
tab_esp <- table_esp(Data)
tab_event <- create_event_table(tab_prim, Data)

