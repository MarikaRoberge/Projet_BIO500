creer_cartes_diversite <- function(db_path = "lepido.db",
                                   cellsize = 50000,
                                   output_dir = "cartes_periodes") {
  
  # 1. Connexion DB + requête
  con <- dbConnect(SQLite(), db_path)
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
  donnees <- dbGetQuery(con, query)
  dbDisconnect(con)
  
  # 2. Nettoyage, car une donnée de 405,5 un peu exagérer comparé aux autres
  donnees <- donnees %>%
    filter(n_especes < 100) %>%
    mutate(
      periode_25ans = floor(year_obs / 25) * 25,
      periode_label = paste0(periode_25ans, "-", periode_25ans + 24)
    ) %>%
    group_by(periode_label, lat, lon) %>%
    summarise(
      n_especes = mean(n_especes, na.rm = TRUE),
      valeur_moyenne = mean(valeur_moyenne, na.rm = TRUE),
      n_observations = sum(n_observations, na.rm = TRUE),
      .groups = 'drop'
    )
  
  donnees_sf <- st_as_sf(donnees, coords = c("lon", "lat"), crs = 4326)
  
  # 3. Québec + grille
  canada <- ne_states(country = "Canada", returnclass = "sf")
  qc <- canada %>%
    filter(name_en == "Quebec") %>%
    st_transform(32198)
  
  grid_hex <- st_make_grid(qc, cellsize = cellsize) %>%
    st_as_sf() %>%
    st_intersection(qc) %>%
    st_make_valid() %>%
    mutate(grid_id = row_number())
  
  donnees_local <- donnees_sf %>%
    st_transform(32198) %>%
    filter(!is.na(n_especes))
  
  # 4. Agrégation spatiale
  grid_data <- st_join(donnees_local, grid_hex) %>%
    st_drop_geometry() %>%
    group_by(grid_id, periode_label) %>%
    summarise(
      n_especes = mean(n_especes, na.rm = TRUE),
      n_points = n(),
      .groups = "drop"
    ) %>%
    left_join(grid_hex, by = "grid_id") %>%
    st_as_sf() %>%
    st_transform(4326)
  
  # 5. Création dossier output
  if (!dir.exists(output_dir)) dir.create(output_dir)
  
  # 6. Boucle des cartes
  periodes <- unique(grid_data$periode_label)
  
  for (periode in periodes) {
    data_sub <- grid_data %>% filter(periode_label == periode)
    
    p <- ggplot() +
      geom_sf(data = data_sub,
              aes(fill = n_especes, size = n_points),
              color = "white", alpha = 0.8) +
      geom_sf(data = qc %>% st_transform(4326),
              fill = NA, color = "black", linewidth = 0.3) +
      scale_fill_gradientn(
        name = "Nombre moyen d'espèces",
        colors = hcl.colors(10, "RdYlGn"),
        limits = c(1, 10),
        breaks = seq(1, 10, 2)
      ) +
      scale_size_continuous(
        name = "Nombre de points agrégés",
        range = c(0.5, 5),
        breaks = c(1, 5, 10, 20)
      ) +
      theme_void() +
      labs(title = "Diversité spécifique au Québec",
           subtitle = paste("Période :", periode),
           caption = "Projection locale EPSG:32198 - Données lissées sur 25 ans")
    
    ggsave(filename = file.path(output_dir, paste0("carte_", periode, ".png")),
           plot = p,
           width = 10, height = 8, units = "in", dpi = 300)
    
    message("Carte sauvegardée pour la période ", periode)
  }
  
  return(invisible(NULL))
}
