
source("appel_data.R")
source("table_primaire.R")
source("table_date.R")
source("table_site.R")
source("table_espece.R")
source("event_table.R")
source("nettoyage_data.R")
source("colonne_type.R")
source("formattage_date.R")

Data <- grosse_tab("lepidopteres")
#définir le chemin pour le dossier lepidopteres
Data<-concordance(Data)
Data <- clean_na(Data)

tab_prim <- tab_primaire(Data)
tab_site <- create_site_table(tab_prim, Data)
tab_esp <- table_esp(Data)
tab_event <- create_event_table(tab_prim, Data)

