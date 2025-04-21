#carte du Québec
{
  library(ggplot2)
  library(tidyverse)
  library(sf)
  library(maps)
  #library(rmapshaper) # the package that allows geo shape transformation
  #library(tmap)
  library(rnaturalearth)
  library(rnaturalearthhires)
  library(dplyr)
  library(canadianmaps)
  library(RSQLite)
  library(patchwork)
}
######
canada <- ne_states(country = "Canada", returnclass = "sf")
qc <- canada %>%
  filter(name_en == "Quebec") %>%
  st_transform(32198)



###Aller chercher les données des papillons tigrés Papilio canadensis

con <- dbConnect(SQLite(), dbname = "lepido.db")
request <- "
  SELECT p.*, --1
   CAST(d.year_obs AS INTEGER) AS year_obs, --2
      d.unique_id,
      s.lat, --3
      s.lon
  FROM primaire p
  JOIN site s ON p.site_id = s.site_id --4
  JOIN Date d ON p.unique_id = d.unique_id
  WHERE p.observed_scientific_name = 'Papilio canadensis' --5

"
#1 sélectionner toute la table primaire
#2 années(character) -> années(integer)
#3 sélection de la lattitude de la table site (allias s.)
#4 joindre les tables en précisant les forgein keys les reliant
#5 filtrer la colone de noms scientifiques pour extraire uniquement le papillon tigré

donnees_pc <- dbGetQuery(con, request)
dbDisconnect(con)

#sélection des localisations des années 1850 à 1900
donnees_pc1 <- donnees_pc[donnees_pc$year_obs >= 1850 & donnees_pc$year_obs < 1900, ]
donnees_pc1 <- distinct(donnees_pc1, unique_id, .keep_all = TRUE)
donnees_pc1 <- filter(donnees_pc1, (lat >= 45 & lat <= 61) & (lon >= -80 & lon <= -57), .preserve = TRUE)

#sélection des localisations des années 1900 à 1950
donnees_pc2 <- donnees_pc[donnees_pc$year_obs >= 1900 & donnees_pc$year_obs < 1950, ]
donnees_pc2 <- distinct(donnees_pc2, unique_id, .keep_all = TRUE)
donnees_pc2 <- filter(donnees_pc2, (lat >= 45 & lat <= 61) & (lon >= -80 & lon <= -57), .preserve = TRUE)


#sélection des localisations des années 1950 à 2000
donnees_pc3 <- donnees_pc[donnees_pc$year_obs >= 1950 & donnees_pc$year_obs < 2000, ]
donnees_pc3 <- distinct(donnees_pc3, unique_id, .keep_all = TRUE)
donnees_pc3 <- filter(donnees_pc3, (lat >= 45 & lat <= 61) & (lon >= -80 & lon <= -57), .preserve = TRUE)

#sélection des localisations des années 2000 à 2024
donnees_pc4 <- donnees_pc[donnees_pc$year_obs >= 2000 & donnees_pc$year_obs < 2024, ]
donnees_pc4 <- distinct(donnees_pc4, unique_id, .keep_all = TRUE)
donnees_pc4 <- filter(donnees_pc4, (lat >= 45 & lat <= 61) & (lon >= -80 & lon <= -57), .preserve = TRUE)



points_1 <- st_as_sf(donnees_pc1, coords = c("lon", "lat"), crs = 4326)
points_2 <- st_as_sf(donnees_pc2, coords = c("lon", "lat"), crs = 4326)
points_3 <- st_as_sf(donnees_pc3, coords = c("lon", "lat"), crs = 4326)
points_4 <- st_as_sf(donnees_pc4, coords = c("lon", "lat"), crs = 4326)

pc <- list(points_1, points_2, points_3, points_4)
titre <- list("entre 1850 et 1900", "entre 1901 et 1950", "entre 1951 et 2000",
              "entre 2001 et 2023")
output_dir <- "test123"


# 6. Création des cartes et stockage

liste_cartes <- list()

for (i in 1:4) {
  data_sub <- pc[[i]]
  
  p <- ggplot() +
    geom_sf(data = qc, fill = "lightblue", color = "black") +  # Carte du Québec
    geom_sf(data = data_sub, aes(geometry = geometry), color = "red", size = 2) +  # Ajouter les points
    theme_minimal() +
    labs(title = "Observation de Papilio canadensis",
         subtitle = titre[[i]])
  
  liste_cartes[[i]] <- p
}

#Création d'un dossier pour mettre la carte
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)}

# 7. Combinaison finale des 6 cartes en une seule image
image_finale <- (liste_cartes[[1]] | liste_cartes[[2]]) /
                   (liste_cartes[[3]] |liste_cartes[[4]])

ggsave(filename = file.path(output_dir, "cartes_bert.png"),
       plot = image_finale,
       width = 15, height = 10, units = "in", dpi = 300)

return(invisible(NULL))
}


# 
# install.packages(
#   "rnaturalearthhires",
#   repos = "https://ropensci.r-universe.dev",
#   type = "source")



