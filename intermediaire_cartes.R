#intermediaire
intermediaire1 <- function(db_path) {
  # Validation du fichier
  if (!file.exists(db_path)) {
    stop("Fichier de base de données introuvable: ", db_path)
  }
  
  con <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  
  # Vérification des tables
  required_tables <- c("primaire", "site", "Date")
  existing_tables <- DBI::dbListTables(con)
  
  missing_tables <- setdiff(required_tables, existing_tables)
  if (length(missing_tables) > 0) {
    DBI::dbDisconnect(con)
    stop("Tables manquantes: ", paste(missing_tables, collapse = ", "))
  }
  
  # Requête SQL avec observed_scientific_name directement
  query <- "
    SELECT 
        CAST(d.year_obs AS INTEGER) AS year_obs,
        s.lat,
        s.lon,
        p.observed_scientific_name,
        p.obs_value
    FROM primaire p
    JOIN site s ON p.site_id = s.site_id
    JOIN Date d ON p.unique_id = d.unique_id
  "
  
  donnees <- DBI::dbGetQuery(con, query)
  DBI::dbDisconnect(con)
  
  # Validation des données retournées
  if (nrow(donnees) == 0) {
    warning("La requête a retourné 0 lignes")
  }
  
  return(donnees)
}