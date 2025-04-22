#Fonction qui génère une image composé de 6 cartes (de 1875 à 2024 avec des bonds de 25 ans)
#Ces cartes représente des données spatio temporelle des lépidoptères au Québec
#On peut observer le territoire avoir plus de point d'observation et une augmentation d'espèces
creer_cartes_diversite <- function(donnees, cellsize, output_dir) {
  
  # 1. Nettoyage
  donnees <- donnees %>%
    filter(year_obs >= 1875 & year_obs <= 2024) %>% #On prend les dates entre 1875 et 2024 seulement
    mutate(
      periode_25ans = floor((year_obs - 1875) / 25) * 25 + 1875, 
      periode_label = paste0(periode_25ans, "-", periode_25ans + 24) #On produit des périodes distincte de 25 ans
    )
  
  donnees_sf <- st_as_sf(donnees, coords = c("lon", "lat"), crs = 4326)
  
  # 2. Québec + grille
  canada <- ne_states(country = "Canada", returnclass = "sf")
  qc <- canada %>% 
    filter(name_en == "Quebec") %>%
    st_transform(32198)
  
  grid_hex <- st_make_grid(qc, cellsize = cellsize) %>%
    st_as_sf() %>%
    st_intersection(qc) %>%
    st_make_valid() %>%
    mutate(grid_id = row_number()) #On produit une grille hexagonale
  
  donnees_local <- donnees_sf %>%
    st_transform(32198) %>%
    filter(!is.na(observed_scientific_name)) #Filtrer les données pour avoir juste les espèces observer sur le territoire de la province du Québec
  
  # 3. Agrégation spatiale modifiée
  grid_data <- st_join(donnees_local, grid_hex) %>%
    st_drop_geometry() %>%
    group_by(grid_id, periode_label) %>%
    summarise(
      n_especes = n_distinct(observed_scientific_name, na.rm = TRUE), # Comptage des espèces uniques
      .groups = "drop"
    ) %>%
    left_join(grid_hex, by = "grid_id") %>%
    st_as_sf() %>%
    st_transform(4326)

  
  # 4. Création des cartes et stockage
  periodes <- sort(unique(grid_data$periode_label))
  liste_cartes <- list()
  
  for (periode in periodes) {
    data_sub <- grid_data %>% filter(periode_label == periode)
    
    titre <- if (periode == periodes[1]) "Diversité spécifique au Québec" else NULL #Titre des cartes avec la période
    
    p <- ggplot() +
      geom_sf(data = data_sub,
              aes(fill = n_especes),
              color = "white", alpha = 0.8) +
      geom_sf(data = qc %>% st_transform(4326),
              fill = NA, color = "black", linewidth = 0.3) +
      scale_fill_gradientn(
        name = "Nombre moyen d'espèces",
        colors = hcl.colors(10, "RdYlGn"),
        limits = c(1, max(grid_data$n_especes, na.rm = TRUE)) # Échelle dynamique
      ) +
      theme_void() +
      
      labs(title = titre,
           subtitle = paste("Période :", periode))
    
  #5. Ajouter la légende uniquement pour le 6e graphique (en fait c'est juste pour que ça apparaît en bas à droite de l'image globale)
    if (periode == "2000-2024") { 
      p <- p + labs(caption = "Projection locale EPSG:32198 - Données lissées sur 25 ans")
    }
      
    liste_cartes[[periode]] <- p
  }
  
  #6. Création d'un dossier pour mettre la carte
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)}
  
  #7. Combinaison finale des 6 cartes en une seule image
  image_finale <- (liste_cartes[[1]] | liste_cartes[[2]]) /
    (liste_cartes[[3]] | liste_cartes[[4]]) /
    (liste_cartes[[5]] | liste_cartes[[6]])
  
  ggsave(filename = file.path(output_dir, "cartes_combinees.png"),
         plot = image_finale,
         width = 15, height = 10, units = "in", dpi = 300)
  
  #8. Rogner les marges de l'image finale pour que ce soit plus jolie ✨
  img <- image_read(file.path(output_dir, "cartes_combinees.png"))
  img_crop <- image_trim(img)
  image_write(img_crop, path = file.path(output_dir, "cartes_combinees.png"))  # Remplace l’image originale
  
  return(invisible(NULL))
}
