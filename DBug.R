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
  library(targets)
  library(RSQLite)
}

#création de la tab de données
{
  Brute <- grosse_tab("lepidopteres")
  Brute <- clean_na(Brute)
  Brute <- type_colonne(Brute)
  Brute <- uniformisation_decimales(Brute)
  verif(Brute)
  Brute <- create_unique_id(Brute)
  Brute <- ajouter_id_site(Brute)
  
}

con <- dbConnect(SQLite(), dbname = "verre_de_vino")

# Création des tables
tbl_primaire <- "
CREATE TABLE IF NOT EXISTS primaire (
  observed_scientific_name   VARCHAR(100) NOT NULL,
  dwc_event_date             TIMESTAMP NOT NULL,
  obs_value                  INTEGER NOT NULL,
  unique_id                  INTEGER PRIMARY KEY,
  site_id                    INTEGER NOT NULL,
  FOREIGN KEY (site_id) REFERENCES site(site_id)
);"

tbl_site <- "
CREATE TABLE IF NOT EXISTS site (
  site_id                    INTEGER PRIMARY KEY,
  lat                        REAL NOT NULL,
  lon                        REAL NOT NULL
);"

tbl_date <- "
CREATE TABLE IF NOT EXISTS date (
  unique_id                  INTEGER PRIMARY KEY,
  year_obs                   INTEGER NOT NULL,
  day_obs                    INTEGER NOT NULL,
  time_obs                   TIME,
  FOREIGN KEY (unique_id) REFERENCES primaire(unique_id)
);"

# Exécuter les requêtes de création
dbExecute(con, tbl_primaire)
dbExecute(con, tbl_site)
dbExecute(con, tbl_date)

# Table 'site' : site_id, lat, lon
df_site <- distinct(Brute, site_id, .keep_all = T)
df_site <- df_site[, c("site_id", "lat", "lon")]

# Table 'primaire' : observed_scientific_name, dwc_event_date, obs_value, unique_id, site_id
df_primaire <- Brute[, c("observed_scientific_name", "dwc_event_date", "obs_value", "unique_id", "site_id")]

# Table 'date' : unique_id, year_obs, day_obs, time_obs
df_date <- Brute[, c("unique_id", "year_obs", "day_obs", "time_obs")]

dbWriteTable(con, name = "primaire", value = df_primaire, append = TRUE, row.names = FALSE)
dbWriteTable(con, name = "site", value = df_site, append = TRUE, row.names = FALSE)
dbWriteTable(con, name = "date", value = df_date, append = TRUE, row.names = FALSE)

# Fermer la connexion
dbDisconnect(con)



