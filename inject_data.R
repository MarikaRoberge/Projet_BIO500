#Injection des données
insert_data <- function(db_name, Base_de_donnees) {
  con <- dbConnect(SQLite(), dbname = db_name)
  
  # Vérifier si le data.frame est valide
  if (!is.data.frame(Base_de_donnees)) {
    print("Erreur : l'objet fourni n'est pas un data.frame valide.")
    dbDisconnect(con)
    return(NULL)
  }
  
  # Insérer les données
  dbWriteTable(con, name = "primaire", value = Base_de_donnees, append = TRUE, row.names = FALSE)
  
  dbDisconnect(con)
  return("Données insérées avec succès")
}

# Insérer les données dans la base
insert_data("lepido.db", jj)

