create_database <- function(db_name, df_global) { #fonction créant les talbes SQL à partir 
  #d'un  nom de table et des données filtrées
  
  con <- dbConnect(RSQLite::SQLite(), dbname = db_name)
  
  # 1. Désactiver les contraintes
  dbExecute(con, "PRAGMA foreign_keys = OFF;")
  
  # 2. Création de la table site avec le site id unique par combinaison de lon et lat
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS site (
      site_id INTEGER PRIMARY KEY,
      lat REAL NOT NULL,
      lon REAL NOT NULL
    );")
  #création de la table Date intégrant la date des observation liés à l'identifiant de chaque observation
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS Date (
      unique_id INTEGER PRIMARY KEY,
      year_obs INTEGER NOT NULL,
      day_obs INTEGER NOT NULL,
      time_obs TEXT
    );")
  #table prmaire intégrant les noms scientifiques, la date d'observation, les valeurs d'observation,
  #l'identifiant de site, l'identifiant d'observation
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS primaire (
      observed_scientific_name TEXT NOT NULL,
      dwc_event_date TEXT NOT NULL,
      obs_value REAL NOT NULL,
      unique_id INTEGER PRIMARY KEY,
      site_id INTEGER NOT NULL,
      FOREIGN KEY(site_id) REFERENCES site(site_id)
    );")
  
  # 3. Peupler les tables
  dbWriteTable(con, "site", 
               df_global %>% distinct(site_id, lat, lon), 
               append = TRUE)
  
  dbWriteTable(con, "Date", 
               df_global %>% select(unique_id, year_obs, day_obs, time_obs), 
               append = TRUE)
  
  dbWriteTable(con, "primaire", 
               df_global %>% select(observed_scientific_name, dwc_event_date, 
                                    obs_value, unique_id, site_id), 
               append = TRUE)
  
  # 4. Activer les contraintes
  dbExecute(con, "PRAGMA foreign_keys = ON;")
  
  # 5. Validation que les tables ont été effectuéee
  message("Vérification des clés étrangères...")
  dbExecute(con, "PRAGMA foreign_key_check;")
  
  dbDisconnect(con)
  return(db_name)
}
