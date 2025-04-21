#creer_cartes
creer_cartes_diversite <- function(donnees, cellsize, output_dir) {
  
  # 3. Nettoyage
  donnees <- donnees %>%
    filter(n_especes < 100) %>%
    filter(year_obs >= 1875 & year_obs <= 2024) %>%  # bornes fixes
    mutate(
      periode_25ans = floor((year_obs - 1875) / 25) * 25 + 1875,
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
  
  # 4. Québec + grille
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
  
  # 5. Agrégation spatiale
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
  
  # 6. Création des cartes et stockage
  periodes <- sort(unique(grid_data$periode_label))
  liste_cartes <- list()
  
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
    
    liste_cartes[[periode]] <- p
  }
  
  #Création d'un dossier pour mettre la carte
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)}
  
  # 7. Combinaison finale des 6 cartes en une seule image
  image_finale <- (liste_cartes[[1]] | liste_cartes[[2]]) /
    (liste_cartes[[3]] | liste_cartes[[4]]) /
    (liste_cartes[[5]] | liste_cartes[[6]])
  
  ggsave(filename = file.path(output_dir, "cartes_combinees.png"),
         plot = image_finale,
         width = 15, height = 10, units = "in", dpi = 300)
  
  return(invisible(NULL))
}
