#Injection des données
# Fonction pour injecter les données dans la base de données
insert_data <- function(db_name, df_name) {
  con <- dbConnect(SQLite(), dbname = db_name)
  
  # Vérifier si le data.frame est valide
  if (!is.data.frame(df_name)) {
    stop("Erreur : l'objet fourni n'est pas un data.frame valide.")
  }
  
  # Insérer les données dans la table 'primaire'
  dbWriteTable(con, name = "primaire", value = df_name, append = TRUE, row.names = FALSE)
  
  dbDisconnect(con)
  
  return("Données insérées avec succès")
}

insert_data("lepido.db", ULTIME_database)
