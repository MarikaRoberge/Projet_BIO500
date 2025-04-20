#Analyse 1 
creer_graphique_diversite <- function(db_path = "lepido.db", output_dir, crs = 4326) {
  # 1. Connexion à la base de données
  con <- dbConnect(RSQLite::SQLite(), db_path)
  
  # 2. Extraction des données via SQL
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
  donnees <- dbGetQuery(con, query)
  dbDisconnect(con)
  
  # 3. Conversion en objet spatial
  donnees_sf <- st_as_sf(donnees, coords = c("lon", "lat"), crs = crs)
  
  # 4. Obtenir le polygone du Québec
  qc <- rnaturalearth::ne_states(country = "Canada", returnclass = "sf") %>%
    filter(name_en == "Quebec") %>%
    st_transform(crs)
  
  # 5. Filtrer pour ne garder que les points au Québec
  donnees_qc <- st_join(donnees_sf, qc, join = st_within, left = FALSE)
  
  # 6. Compter les espèces uniques par année
  biodiv_temp <- donnees_qc %>%
    st_drop_geometry() %>%
    filter(!is.na(observed_scientific_name), !is.na(year_obs)) %>%
    group_by(year_obs) %>%
    summarise(n_especes = n_distinct(observed_scientific_name)) %>%
    arrange(year_obs)
  
  # 7. Création du graphique
  p <- ggplot(biodiv_temp, aes(x = year_obs, y = n_especes)) +
    geom_line(color = "#1f77b4", size = 1) +
    geom_point(size = 2) +
    labs(
      title = "Évolution de la richesse spécifique des lépidoptères au Québec",
      x = "Année",
      y = "Nombre d'espèces uniques observées"
    ) +
    theme_minimal()
  
  # Afficher le graphique
  print(p)
  
  #Sauvegarde du graphique
  ggsave(filename = file.path(output_dir, "graphique_biodiversite.png"),
         plot = p)
  
  # Retourner aussi les données au cas où
  return(invisible(biodiv_temp))
}
