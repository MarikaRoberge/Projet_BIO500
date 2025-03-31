

# Connexion à la base SQLite
connect_db <- function(db_name = "biodiversite.sqlite") {
  dbConnect(SQLite(), dbname = db_name)

# Création des tables
#CRÉER LA TABLE SECONDAIRE DES SITES
tbl_site <- "
CREATE TABLE site (
  id_site
  lat        
  lon
);"
dbSendQuery(con, tbl_site)


# CRÉER LA TABLE SECONDAIRE DATE
tbl_date <- "
CREATE TABLE date (
  dwc_event_date
  time_obs
);"

dbSendQuery(con, tbl_date)


# CRÉER LA TABLE PRIMAIRE
tbl_primaire <- "
CREATE TABLE primaire (
  observed_scientific_name
  dwc_event_date
  obs_value
  id_site
  unique_id
);"

dbSendQuery(con, tbl_primaire)

  return("Tables créées")
}

