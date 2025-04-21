#intermediaire_points
intermediaire3 <- function(db_path) {
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
  
  request <- "
  SELECT p.*, --1
   CAST(d.year_obs AS INTEGER) AS year_obs, --2
      d.unique_id,
      s.lat, --3
      s.lon
  FROM primaire p
  JOIN site s ON p.site_id = s.site_id --4
  JOIN Date d ON p.unique_id = d.unique_id
  WHERE p.observed_scientific_name = 'Papilio canadensis' --5

"
  #1 sélectionner toute la table primaire
  #2 années(character) -> années(integer)
  #3 sélection de la lattitude de la table site (allias s.)
  #4 joindre les tables en précisant les forgein keys les reliant
  #5 filtrer la colone de noms scientifiques pour extraire uniquement le papillon tigré
  
  
  donnees <- DBI::dbGetQuery(con, query)
  DBI::dbDisconnect(con)
  
  # Validation des données retournées
  if(nrow(donnees) == 0) {
    warning("La requête a retourné 0 lignes")
  }
  
  return(donnees)
}
  
  