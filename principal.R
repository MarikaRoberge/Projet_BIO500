#ajout et modif de la table brute
source("appel_data.R") #script qui met les données brutes dans un dataframe
source("nettoyage_data.R") #Ajoute les NA et corrige les erreurs d'orthographes
source("colonne_type.R") #spécifie les types de colones de la table brute
source("formattage_date.R") #converti la colone dc_event_dte en type date


source("table_primaire.R")
source("table_date.R")
source("table_site.R")
source("table_espece.R")
source("event_table.R")


Data <- grosse_tab("lepidopteres")
#définir le chemin pour le dossier lepidopteres
Data<-concordance(Data)
Data <- clean_na(Data)

tab_prim <- tab_primaire(Data)
tab_site <- create_site_table(tab_prim, Data)
tab_esp <- table_esp(Data)
tab_event <- create_event_table(tab_prim, Data)

