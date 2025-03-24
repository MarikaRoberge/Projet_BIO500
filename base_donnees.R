# OUVRIR LA CONNECTION 
library(RSQLite)
con <- dbConnect(SQLite(), dbname="lepido.db")

# CRÉER LA TABLE SECONDAIRE SITE
tbl_site <- "
CREATE TABLE site (
  auteur      VARCHAR(50),    #évidemment changer les noms de colonnes et leurs types
  statut      VARCHAR(40),
  institution VARCHAR(200),
  ville       VARCHAR(40),
  pays        VARCHAR(40),
  PRIMARY KEY (auteur)
);"

dbSendQuery(con, tbl_site)


# CRÉER LA TABLE SECONDAIRE ESPECE
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

# LECTURE DES FICHIERS CSV
bd_sites <- read.csv(file = 'XXXXXXXXx.csv') #créer un CSV de chaque table de préférence?
bd_especes <- read.csv(file = 'XXXXXXXXXXXX.csv')
bd_dates <- read.csv(file = 'XXXXXXXXXX.csv')
bd_prim <- read.csv(file = 'XXXXXXXXX.csv')

# INJECTION DES DONNÉES
dbWriteTable(con, append = TRUE, name = "site", value = bd_sites, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "espece", value = bd_especes, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "date", value = bd_dates, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "primaire", value = bd_prim, row.names = FALSE)
