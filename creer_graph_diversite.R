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
  
  p <- ggplot(biodiv_temp, aes(x = year_obs, y = n_especes)) +
    geom_line(color = "#2ca02c", linewidth = 1) +
    labs(
      title = "Évolution de la richesse spécifique des \nlépidoptères au Québec",
      x = "Année",
      y = "Nombre d'espèces uniques observées"
    ) +
    theme_minimal() +
    theme(
      axis.line = element_line(size = 1, color = "black"),  # Lignes des axes plus épaisses et noires
      axis.ticks = element_line(size = 1, color = "black"),  # Tic des axes
      panel.grid.major = element_line(size = 0.5, color = "gray"),  # Quadrillage majeur plus visible
      panel.grid.minor = element_line(size = 0.5, color = "lightgray"),  # Quadrillage mineur
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5),  # Titre du graphique
      axis.title.x = element_text(size = 14, face = "bold"),  # Nom de l'axe X
      axis.title.y = element_text(size = 14, face = "bold")   # Nom de l'axe Y
    )
  
  # Définir le chemin du fichier de sortie
  output_file <- file.path(output_dir, "graphique_biodiversite.png")
  
  # Sauvegarder le graphique
  ggsave(filename = output_file, plot = p)
  
  # Retourner aussi les données au cas où
  return(invisible(biodiv_temp))
}
