library(DBI)
library(RSQLite)

# Connexion à la base SQLite
connect_db <- function(db_name = "biodiversite.sqlite") {
  dbConnect(SQLite(), dbname = db_name)

# Création des tables
#CRÉER LA TABLE SECONDAIRE DES SITES
tbl_site <- "
CREATE TABLE site (
  Site_id
  lat        
  lon
);"
dbSendQuery(con, tbl_site)
# CRÉER LA TABLE SECONDAIRE ESPECE WROOOONG
tbl_espece <- "
CREATE TABLE espece (
 Espece_id
 observed_scientific_name
 obs_value
);"

dbSendQuery(con, tbl_espece)


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
  Espece_id
  Site_id
  dwc_event_date
  obs_variable
);"

dbSendQuery(con, tbl_primaire)

  return("Tables créées")
}

