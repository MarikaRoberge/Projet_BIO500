#Fonction qui permet de jumeler des données de cartes SQL pour faire le graphique
intermediaire2 <- function(db_path) {
  # Validation du fichier
  if(!file.exists(db_path)) {
    stop("Fichier de base de données introuvable: ", db_path)
  }
  
  con <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  
  # Vérification des tables
  required_tables <- c("primaire", "site", "Date") #Table où on va piger nos données
  existing_tables <- DBI::dbListTables(con) #connection au SQL
  
  missing_tables <- setdiff(required_tables, existing_tables)
  if(length(missing_tables) > 0) {
    DBI::dbDisconnect(con) #Si table SQL vide, se déconnecter
    stop("Tables manquantes: ", paste(missing_tables, collapse = ", "))
  }
  
  # Requête SQL
  query <- "
    SELECT 
p.observed_scientific_name,
s.lat,
s.lon,
d.year_obs
FROM primaire p
JOIN site s ON p.site_id = s.site_id
JOIN Date d ON p.unique_id = d.unique_id
"
  
  donnees <- DBI::dbGetQuery(con, query)
  DBI::dbDisconnect(con) #déconnection des tables SQL
  
  # Validation des données retournées
  if(nrow(donnees) == 0) {
    warning("La requête a retourné 0 lignes")
  }
  
  return(donnees)
}


