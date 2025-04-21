#carte du Québec
#######
# {
#   library(ggplot2)
#   library(tidyverse)
#   library(sf)
#   library(maps)
#   #library(rmapshaper) # the package that allows geo shape transformation
#   #library(tmap)
#   library(rnaturalearth)
#   library(rnaturalearthhires)
#   library(dplyr)
#   library(canadianmaps)
#   library(RSQLite)
#   library(patchwork)
# }

# 
# install.packages(
#   "rnaturalearthhires",
#   repos = "https://ropensci.r-universe.dev",
#   type = "source")
#



######

graph_points <- function(donnees_pc,output_dir){

#1. Création carte du canada zoom in sur la belle province  
canada <- ne_states(country = "Canada", returnclass = "sf")
qc <- canada %>%
  filter(name_en == "Quebec") %>%
  st_transform(32198)


#2. À partir des observations des papillons tigrés Papilio canadensis, sélectionner 
#les observations de groupes d'années respectant les limites géographiques du Québec

#3. Sélection des localisations des années 1850 à 1900
donnees_pc1 <- donnees_pc[donnees_pc$year_obs >= 1850 & donnees_pc$year_obs < 1900, ]
donnees_pc1 <- distinct(donnees_pc1, unique_id, .keep_all = TRUE)
donnees_pc1 <- filter(donnees_pc1, (lat >= 45 & lat <= 61) & (lon >= -80 & lon <= -57), .preserve = TRUE)

#4. Sélection des localisations des années 1900 à 1950
donnees_pc2 <- donnees_pc[donnees_pc$year_obs >= 1900 & donnees_pc$year_obs < 1950, ]
donnees_pc2 <- distinct(donnees_pc2, unique_id, .keep_all = TRUE)
donnees_pc2 <- filter(donnees_pc2, (lat >= 45 & lat <= 61) & (lon >= -80 & lon <= -57), .preserve = TRUE)


#5. Sélection des localisations des années 1950 à 2000
donnees_pc3 <- donnees_pc[donnees_pc$year_obs >= 1950 & donnees_pc$year_obs < 2000, ]
donnees_pc3 <- distinct(donnees_pc3, unique_id, .keep_all = TRUE)
donnees_pc3 <- filter(donnees_pc3, (lat >= 45 & lat <= 61) & (lon >= -80 & lon <= -57), .preserve = TRUE)

#6. Sélection des localisations des années 2000 à 2024
donnees_pc4 <- donnees_pc[donnees_pc$year_obs >= 2000 & donnees_pc$year_obs < 2024, ]
donnees_pc4 <- distinct(donnees_pc4, unique_id, .keep_all = TRUE)
donnees_pc4 <- filter(donnees_pc4, (lat >= 45 & lat <= 61) & (lon >= -80 & lon <= -57), .preserve = TRUE)


#7. Transformer les lon et lat en points géographiques interprétables pour la carte (sf)
points_1 <- st_as_sf(donnees_pc1, coords = c("lon", "lat"), crs = 4326)
points_2 <- st_as_sf(donnees_pc2, coords = c("lon", "lat"), crs = 4326)
points_3 <- st_as_sf(donnees_pc3, coords = c("lon", "lat"), crs = 4326)
points_4 <- st_as_sf(donnees_pc4, coords = c("lon", "lat"), crs = 4326)

#8. Créations de listes pour render plusieurs graphiques
pc <- list(points_1, points_2, points_3, points_4)
titre <- list("entre 1850 et 1900", "entre 1901 et 1950", "entre 1951 et 2000",
              "entre 2001 et 2023")

#9. Création des cartes et stockage

liste_cartes <- list()

for (i in 1:4) { #car on a 4 groupes d'années
  data_sub <- pc[[i]]
  
  titre_carte <- if (i == 1) "Observation de Papilio canadensis au Québec" else NULL
  
  p <- ggplot() +
    geom_sf(data = qc, fill = "#FFFFFF", color = "black", size = 1) +  # Carte du Québec
    geom_sf(data = data_sub, aes(geometry = geometry), color = "red", size = 1) +  # Ajouter les points
    theme_minimal() +
    labs(title = titre_carte,  
         subtitle = titre[[i]])
  
  liste_cartes[[i]] <- p
}

#10. Création d'un dossier pour mettre la carte
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)}

#11. Combinaison finale des 6 cartes en une seule image
image_finale <- (liste_cartes[[1]] | liste_cartes[[2]]) /
                   (liste_cartes[[3]] |liste_cartes[[4]])

ggsave(filename = file.path(output_dir, "cartes_pcanadensis.png"),
       plot = image_finale,
       width = 7, height = 5, units = "in", dpi = 300)

#12. Rogner les marges de l'image finale
img <- image_read(file.path(output_dir, "cartes_pcanadensis.png"))
img_crop <- image_trim(img)
image_write(img_crop, path = file.path(output_dir, "cartes_pcanadensis.png"))  # Remplace l’image originale

return(invisible(NULL))
}



