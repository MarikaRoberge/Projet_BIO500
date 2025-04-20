#Analyse 1 
creer_graphique_diversite <- function(donnees, output_dir, crs = 4326) {
  
  
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
    geom_line(color = "#1f77b4", linewidth = 1) +
    geom_point(size = 2) +
    labs(
      title = "Évolution de la richesse spécifique des lépidoptères au Québec",
      x = "Année",
      y = "Nombre d'espèces uniques observées"
    ) +
    theme_minimal()
  
  # Définir le chemin du fichier de sortie
  output_file <- file.path(output_dir, "graphique_biodiversite.png")
  
  # Sauvegarder le graphique
  ggsave(filename = output_file, plot = p)
  
  # Retourner aussi les données au cas où
  return(invisible(biodiv_temp))
}
