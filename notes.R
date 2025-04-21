# Papilio canadensis = 1659 lignes avec cette espèce, donc plus de données dispo que pour Vanessa cardui et Papilio canadensis n'est pas une aussi grande migratrice que cardui. Si on avait pris cardui, les fluctuations auraient pu être dues à des déplacements plutôt qu'à une simple évolution de la répartition résidentielle dans la région. Aussi, aucune mention de Papilo canadensis se trouve à l'extérieur du Québec, donc pas besoin de worry à propos de ça! J'ai vérifier ca avec les lignes de code suivantes, ou j'ai spécifié les limites lat et lon du quebec (38271 en dehors du Québec sur 153 155 lignes de Brute) et ensuite, j'ai demandé d'aller voir s'il y avait des mentions de l'espèce en dehors du Québec :
# Brute_filtered <- Brute[Brute$lat < 45 | Brute$lat > 60 | Brute$lon < -79 | Brute$lon > -64, ]
# View(Brute_filtered)
# Papilio_canadensis_rows <- Brute_filtered[Brute_filtered$scientific_name == "Papilio canadensis", ]
# View(Papilio_canadensis_rows)
# View(papilio_tab)

#image utilisée JPG : Canadian Tiger Swallowtail Papilio canadensis Rothschild & Jordan, 1906
# Dire qu'on considère chaque ligne comme 1 mention (peu importe s'il est écrit 2, 3 ou autre dans la colonne obs_value)
# 
# À faire : 
# 1. changer les noms de colonnes de la table de données brutes pour que ca soit plus compréhensible
# 2. ajouter des étapes dans la fonction nettoyage_data : pour enlever TXX:XX:XX de dwc_event_date et ajuster ca dans verification_data
# 3. S'assurer que obs_value réfère à quelque chose en particulier (presence, abondance, et ajuster les données de ca, ex. 11 111)
# 4. Dans la table secondaire date, voir à ce que chaque ligne soit unique (ex. site de 1 à 10 (donc de 10 lignes de combinaison de lat et lon unique) et dans table primaire à site_id on retrouverait chaque ligne avec 1 à 10)
# 5. Dans la table primaire on aurait les colonnes : nom_scientifique (observed_scientific_name), date (dwc_event_date), abondance (obs_value en filtrant seulement pour abundance dans obs_variable) et site_id et ?
# 6. Changer le nom de certains targets (ex. data_final et ULTIME_database)
#                                                    
# Updates: 
# 2. réglé dans la fonction type_colone, rete en characters
# 3. problème de 11111 réglé
#                                                    
# À faire cette semaine (jusqu'à mardi soir 8 avril) :
# -Corriger l'étape 2 de ''À faire''
# -Revoir le 11 111, qu'est ce qu'on fait avec et qu'est-ce qu'on fait avec l'abondance dans nos analyses?
# -Clairer le site_id (faire le df pour le site_id)
# -Injecter les données
# -Ajouter une ligne de retrait de base de données lepido dans le script de SQL
# -Commencer à écrire le texte dans le Rapport
# -Il faudrait vraiment créer des sous-dossiers dans notre dossier de projet ProjetBIO_500 et mieux structurer tout ca, ca va aider à faire la dépendance du Rapport.Rmd dans le pipeline des targets! Pour ca, on devrait se baser sur le code par après que le prof nous a fourni pour compiler le RMarkDown dans targets. 
# -trouver une facon de juste prendre en considération les lignes de données de lat et lon du québec 


Le rapport doit contenir 
3 figures
Un titre et un résumé
Une courte introduction spécifiant les questions
Une courte description de la méthode et des résultats
Une discussion, enrichie de citations provenant de la littérature scientifique
Références interne aux figures et à la bibliographie
L'ensemble du texte doit faire 1000-1500 mots max
Une bibliographie

install.packages(
  "rnaturalearthhires",
  repos = "https://ropensci.r-universe.dev",
  type = "source"
)
#j'ai passé 30 min à chercher ce boute de code...