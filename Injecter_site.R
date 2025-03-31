#Injecter les données dans le tableau secondaire site
insert_site <- function(con, data) {
  sites_unique <- unique(data[, c("auteur", "statut", "institution", "ville", "pays")])
  dbWriteTable(con, "Sites", sites_unique, append = TRUE, row.names = FALSE)
}
