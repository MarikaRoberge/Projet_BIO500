# Projet_BIO500
Projet de session sur les lépidoptères

Titre du projet : Variations spatio-temporelles de la biodiversité des lépidoptères au Québec

Description du projet : Le but du projet est de s'améliorer avec l'utilisation de
R, de SQL, targets et de MarkDown en faisant un fichier automatisé qui charge, 
nettoie et analyse des données csv. 
Les données csv sont des données d'observation de papillons entre 1859 et 2023.
Targets a été utilisé pour charger les données et les mettre en graphique. Un 
graphique de diversité, une heatmap de diversité et une carte
de distribution de Papilio canadensis on été présentés.
Les résultats nous montrent une augmentation des observations de papillons au 
Québec et une différnce de distribution de certaines espèces au Québec durant les
années de récolte de données.

Structure du répertoire : tous les scripts essentiels au fonctionnement du code
sont dans le répertoire principal. _targets.R spécifie les historiques de targets et
les fichiers déjà chargés. Le dossier rapport stock les images créées par les analyses
pour être utilisées dans le rapport markdown. lepidopteres contient les données
brutes en csv. Rapport stock les fichiers markdown et le pdf final du rapport.

Description des fichiers : 
_targets.R : contient les instructions pour charger les fichiers .R et exécuter la commande tar_make()
appel_data.R : Charge les documents csv. et les chargent dans un objet (data.frame)
colonne_type.R : charge les bonnes classes d'objets aux différentes informations du data.frame
create_site_id.R : crée un identifiant unique pour chaque combinaison de longitude et latitude
create_unique.R : crée un identifiant unique de chaque observation des données
creer_carte_diversite.R : crée les 6 heatmaps de diversité d'espèces de lépidoptères au Québec
creer_carte_pcanadensis.R : crée les 4 cartes d'observations de Papilio canadensis au Québec
creer_graph_diversite.R : créer le graphique du nombre d'espèces de lépidoptères au Québec en fonction le temps
intermediaire_cartes.R : fichier intermédaire exécutant la requête des tables SQL pour les heatmaps
intermediaire_graph.R : fichier intermédaire exécutant la requête des tables SQL pour le graphique d'abondance
intermediaire_points.R : fichier intermédaire exécutant la requête des tables SQL pour les cartes de Papilio canadensis
nettoyage_data.R : filtre et nettoie les données brutes venant dans fichiers .csv
SQL_tables: crée les tables primaire, site et date à partir des données nettoyées
uniformisation_lat_lon.R : uniformise les données de lon et lat à 5 décimales
verification_data.R : s'assure que le filtrage des données a été exécuté et retourne un message


Instructions
Comment exécuter le projet : 
1.Aller dans le fichier _targets.R  
2.Charger les sources, librairies et packages au début du fichier _targets.R
3.Utiliser la fonction tar_make()
4.Cliquer sur Rapport.Rmd dans le dossier "Rapport" et faire Knit🧶 pour générer le rapport PDF avec les figures à jour

Comment reproduire les résultats :
-Pour changer de données, remplacer "lepidopteres"
avec le working directory dans la première étape du fichier _targets.R
-Pour les nouveaux utilisateurs du projet, commencer par supprimer lepido.db, le dossier "_targets" et les figures png se trouvant dans le dossier "Rapport"
si jamais ils se retrouvent dans les Files. Ces fichiers et la base de données seront générés lors de l'exécution avec tar_make().

Comment accéder aux données et aux ressources :
Utiliser la fonction tar_load_everything(), les data.frames utilisés pour créer les graphiques 
seront présents dans l'environnement.


Auteurs et contributeurs : Juliette Boulet-Thomas, Bertrand Labrecque et Marika Roberge