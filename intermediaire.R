#intermediaire
intermediaire <- function(db_path) {
  # Validation du fichier
  if(!file.exists(db_path)) {
    stop("Fichier de base de données introuvable: ", db_path)
  }
  
  con <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  
  # Vérification des tables
  required_tables <- c("primaire", "site", "Date")
  existing_tables <- DBI::dbListTables(con)
  
  missing_tables <- setdiff(required_tables, existing_tables)
  if(length(missing_tables) > 0) {
    DBI::dbDisconnect(con)
    stop("Tables manquantes: ", paste(missing_tables, collapse = ", "))
  }
  
  # Requête SQL
  query <- "
    SELECT 
        CAST(d.year_obs AS INTEGER) AS year_obs,
        s.lat,
        s.lon,
        COUNT(DISTINCT p.observed_scientific_name) AS n_especes,
        AVG(p.obs_value) AS valeur_moyenne,
        COUNT(*) AS n_observations
    FROM primaire p
    JOIN site s ON p.site_id = s.site_id
    JOIN Date d ON p.unique_id = d.unique_id
    GROUP BY s.site_id, d.year_obs
  "
  
  donnees <- DBI::dbGetQuery(con, query)
  DBI::dbDisconnect(con)
  
  # Validation des données retournées
  if(nrow(donnees) == 0) {
    warning("La requête a retourné 0 lignes")
  }
  
  return(donnees)
}
#