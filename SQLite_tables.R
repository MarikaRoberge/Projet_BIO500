#Script de SQL

# OUVRIR LA CONNECTION 
library(RSQLite)
con <- dbConnect(SQLite(), dbname="lepido.db")
  
# CRÉER LA TABLE PRIMAIRE
tbl_primaire <- "
CREATE TABLE primaire (
  observed_scientific_name   VARCHAR(100) NOT NULL,
  dwc_event_date             TIMESTAMP NOT NULL,
  obs_value                  INTEGER NOT NULL,
  id_site                    INTEGER NOT NULL,
  unique_id                  INTEGER PRIMARY KEY,
  FOREIGN KEY (id_site) REFERENCES site(id_site)
);"
  
dbSendQuery(con, tbl_primaire)

# Création des tables
#CRÉER LA TABLE SECONDAIRE DES SITES
tbl_site <- "
CREATE TABLE site (
  id_site                    INTEGER PRIMARY KEY,
  lat                        REAL NOT NULL,
  lon                        REAL NOT NULL
);"
dbSendQuery(con, tbl_site)


# CRÉER LA TABLE SECONDAIRE DATE
tbl_date <- "
CREATE TABLE date (
  unique_id                  INTEGER PRIMARY KEY,
  year_obs                   INTEGER NOT NULL,
  day_obs                    INTEGER NOT NULL,
  time_obs                   TIME NOT NULL,
  FOREIGN KEY (unique_id) REFERENCES primaire(unique_id)
);"

dbSendQuery(con, tbl_date)

  return("Tables créées")

dbDisconnect(con)
