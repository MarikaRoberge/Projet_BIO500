#Script de SQL
create_database <- function(db_name) {
  library(RSQLite)
  
  # Ouvrir la connexion
  con <- dbConnect(SQLite(), dbname = lepido.db)
  
  # Création des tables
  tbl_primaire <- "
  CREATE TABLE IF NOT EXISTS primaire (
    observed_scientific_name   VARCHAR(100) NOT NULL,
    dwc_event_date             TIMESTAMP NOT NULL,
    obs_value                  INTEGER NOT NULL,
    id_site                    INTEGER NOT NULL,
    unique_id                  INTEGER PRIMARY KEY,
    FOREIGN KEY (id_site) REFERENCES site(id_site)
  );"
  
  tbl_site <- "
  CREATE TABLE IF NOT EXISTS site (
    id_site                    INTEGER PRIMARY KEY,
    lat                        REAL NOT NULL,
    lon                        REAL NOT NULL
  );"
  
  tbl_date <- "
  CREATE TABLE IF NOT EXISTS date (
    unique_id                  INTEGER PRIMARY KEY,
    year_obs                   INTEGER NOT NULL,
    day_obs                    INTEGER NOT NULL,
    time_obs                   TIME NOT NULL,
    FOREIGN KEY (unique_id) REFERENCES primaire(unique_id)
  );"
  
  # Exécuter les requêtes de création
  dbExecute(con, tbl_primaire)
  dbExecute(con, tbl_site)
  dbExecute(con, tbl_date)
  
  # Fermer la connexion
  dbDisconnect(con)
  
  return("Tables créées")
}


