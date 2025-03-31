#Script de SQL
# Connexion à la base SQLite
connect_db <- function(db_name = "biodiversite.sqlite") {
  dbConnect(SQLite(), dbname = db_name)
  
# CRÉER LA TABLE PRIMAIRE
tbl_primaire <- "
CREATE TABLE primaire (
  observed_scientific_name   VARCHAR(100) NOT NULL,
  dwc_event_date             TIMESTAMP,
  obs_value                  INTEGER,
  id_site                    INTEGER,
  unique_id                  INTEGER PRIMARY KEY,
  FOREIGN KEY (id_site) REFERENCES site(id_site)
);"
  
dbSendQuery(con, tbl_primaire)

# Création des tables
#CRÉER LA TABLE SECONDAIRE DES SITES
tbl_site <- "
CREATE TABLE site (
  id_site                    INTEGER PRIMARY KEY,
  lat                        REAL,
  lon                        REAL
);"
dbSendQuery(con, tbl_site)


# CRÉER LA TABLE SECONDAIRE DATE
tbl_date <- "
CREATE TABLE date (
  unique_id                  INTEGER PRIMARY KEY,
  year_obs                   INTEGER,
  day_obs                    INTEGER,
  time_obs                   TIME,
  FOREIGN KEY (unique_id) REFERENCES primaire(unique_id)
);"

dbSendQuery(con, tbl_date)

  return("Tables créées")
}

