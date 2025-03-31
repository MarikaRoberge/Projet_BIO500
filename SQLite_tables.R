library(DBI)
library(RSQLite)

# Connexion à la base SQLite
connect_db <- function(db_name = "biodiversite.sqlite") {
  dbConnect(SQLite(), dbname = db_name)

# Création des tables
#CRÉER LA TABLE SECONDAIRE DES SITES
tbl_site <- "
CREATE TABLE site (
  id
  lat        
  lon
);"
dbSendQuery(con, tbl_site)
# CRÉER LA TABLE SECONDAIRE ESPECE WROOOONG
tbl_espece <- "
CREATE TABLE espece (
  auteur      VARCHAR(50),
  statut      VARCHAR(40),
  institution VARCHAR(200),
  ville       VARCHAR(40),
  pays        VARCHAR(40),
  PRIMARY KEY (auteur)
);"

dbSendQuery(con, tbl_espece)


# CRÉER LA TABLE SECONDAIRE DATE
tbl_date <- "
CREATE TABLE date (
articleID   VARCHAR(20) NOT NULL,
titre       VARCHAR(200) NOT NULL,
journal     VARCHAR(80),
annee       DATE,
citations   INTEGER CHECK(annee >= 0),
PRIMARY KEY (articleID)
);"

dbSendQuery(con, tbl_date)


# CRÉER LA TABLE PRIMAIRE
tbl_primaire <- "
CREATE TABLE primaire (
  auteur1     VARCHAR(40),
  auteur2     VARCHAR(40),
  articleID   VARCHAR(20),
  PRIMARY KEY (auteur1, auteur2, articleID),
  FOREIGN KEY (auteur1) REFERENCES auteurs(auteur),
  FOREIGN KEY (auteur2) REFERENCES auteurs(auteur),
  FOREIGN KEY (articleID) REFERENCES articles(articleID)
);"

dbSendQuery(con, tbl_primaire)

  return("Tables créées")
}

