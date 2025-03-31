library(RSQLite)
con <- dbConnect(SQLite(), dbname="lepido.db")

  
#Injecter les données dans les tables
inject_data <- function(con, data) {
  dbWritetable(con, "tab_primaire")
  dbWriteTable(con, "tab_site", , append = TRUE, row.names = FALSE)
  dbWriteTable(con, "tab_date, sit")
  
    }
  }