#Analyse 1
# Connexion à SQL
con <- dbConnect(RSQLite::SQLite(), "lepido.db")

# 1. Joindre les tables pour extraire toutes les infos utiles
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

# 2. Convertir en objet spatial pour filtrer Québec
donnees_sf <- st_as_sf(donnees, coords = c("lon", "lat"), crs = 4326)

# 3. Obtenir le polygone du Québec
qc <- rnaturalearth::ne_states(country = "Canada", returnclass = "sf") %>%
  filter(name_en == "Quebec") %>%
  st_transform(4326)

# 4. Filtrer les observations situées au Québec
donnees_qc <- st_join(donnees_sf, qc, join = st_within, left = FALSE)

# 5. Compter les espèces uniques par année
biodiv_temp <- donnees_qc %>%
  st_drop_geometry() %>%
  filter(!is.na(observed_scientific_name), !is.na(year_obs)) %>%
  group_by(year_obs) %>%
  summarise(n_especes = n_distinct(observed_scientific_name)) %>%
  arrange(year_obs)

# 6. Visualiser la richesse spécifique dans le temps
ggplot(biodiv_temp, aes(x = year_obs, y = n_especes)) +
  geom_line(color = "#1f77b4", size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Évolution de la richesse spécifique des lépidoptères au Québec",
    x = "Année",
    y = "Nombre d'espèces uniques observées"
  ) +
  theme_minimal()

# Créer le graphique
ggplot(biodiv_temp, aes(x = year_obs, y = n_especes)) +
  geom_line(color = "#1f77b4", size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Évolution de la richesse spécifique des lépidoptères au Québec",
    x = "Année",
    y = "Nombre d'espèces uniques observées"
  ) +
  theme_minimal()

# Si le graphique ne s'affiche pas dans la fenêtre Plots, utilise print()
print(ggplot(biodiv_temp, aes(x = year_obs, y = n_especes)) +
        geom_line(color = "#1f77b4", size = 1) +
        geom_point(size = 2) +
        labs(
          title = "Évolution de la richesse spécifique des lépidoptères au Québec",
          x = "Année",
          y = "Nombre d'espèces uniques observées"
        ) +
        theme_minimal())
