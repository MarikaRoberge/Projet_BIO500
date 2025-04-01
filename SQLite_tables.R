#Script de SQL
create_database <- function(db_name) {
  
  # Vérifier si le fichier de base de données existe déjà
  if (!file.exists(db_name)) {
    # Ouvrir la connexion (cela crée le fichier si nécessaire)
    con <- dbConnect(SQLite(), dbname = db_name)
    
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
      time_obs                   TIME NOT NULL,
      FOREIGN KEY (unique_id) REFERENCES primaire(unique_id)
    );"
    
    # Exécuter les requêtes de création
    dbExecute(con, tbl_primaire)
    dbExecute(con, tbl_site)
    dbExecute(con, tbl_date)
    
    # Table 'site' : site_id, lat, lon
    df_site <- df_global[, c("site_id", "lat", "lon")]
    
    # Table 'primaire' : observed_scientific_name, dwc_event_date, obs_value, unique_id, site_id
    df_primaire <- df_global[, c("observed_scientific_name", "dwc_event_date", "obs_value", "unique_id", "site_id")]
    
    # Table 'date' : unique_id, year_obs, day_obs, time_obs
    df_date <- df_global[, c("unique_id", "year_obs", "day_obs", "time_obs")]
    
    dbWriteTable(con, name = "primaire", value = df_primaire, append = TRUE, row.names = FALSE)
    dbWriteTable(con, name = "site", value = df_site, append = TRUE, row.names = FALSE)
    dbWriteTable(con, name = "date", value = df_date, append = TRUE, row.names = FALSE)
    
    # Fermer la connexion
    dbDisconnect(con)
  }
  
  # Retourner le nom de la base de données créée ou existante
  return(db_name)
  
}


