connect_db <- function(db_name = "biodiversite.sqlite") {
  dbConnect(SQLite(), dbname = db_name)
  con<- dbConnect(SQLite(), dbname="lepido.db") #à vérifier

  
#Injecter les données dans les tables
inject_data <- function(con, data) {
  dbWritetable(con, "tab_primaire")
  dbWriteTable(con, "tab_site", , append = TRUE, row.names = FALSE)
  dbWriteTable(con, "tab_date, sit")
  
    }
  }