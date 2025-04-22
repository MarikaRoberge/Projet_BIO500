# Projet_BIO500
Projet de session sur les lépidoptères

Titre du projet : Variations spatio-temporelles de la biodiversité
des lépidoptères au Québec

Description du projet : Le but du projet est de s'améliorer avec l'utilisation de
R, de SQL, targes et de Markdown en faisant un fichier automatisé qui charge, 
nettoie et analyse des données csv. 
Les données csv sont des données d'observation de papillons entre 1859 et 2023.
Target a été utiliés pour charger les données et les mettre en graphique. un 
graphique de diversité, une heatmap de diversité et une carte
de distribution de papilio canadensis on .t. présentées.
Les résultats nous montre une augmentation des observation de papillons au 
Québec et une différnce de distribtion de certaines espèces au québec durant les
années de récolte de données

Structure du répertoire : touts les scripts essentiels au fonctionnement du code
sont dans le répertoire principal. _target spécifie les historique de targets et
les fichiers déjà chargés. Figure_analyse stock les images créer par les analyses
pour êtrent utilisées dans le rapport markdown. lepidopteres contient les données
brutes en csv. Rapport stock les fichiers markdown et le pdf final du rappot.

Description des fichiers : 
_targets.R : contient les instruction pour charger les fichiers .R et éxécuter la commande tar_make()
appel_data.R : Charge les documents csv. et les charge dans un objet (data.frame)
colone_type.R : charge les bonnes classes d'objets au différentes informatioon du data.frame
create_site_id.R : créee un identifiant unique pour chaque combinaisons de longitude et lattitude
create_unique.R : crée un identifiant unique de chaques observations des données
creer_carte_diversité.R :crée les 6 heatmaps des abondance d'espèces de Lépidoptères au Québec
creer_carte_pcanadensis.R : crée les 4 cartes d'observations de Papilio cnadesis au Québec
creer_graph_diveriste.R : créer le graphique du nombre d'espèces au Québec dans le temps
DBug.R : fichier de débugage hors target hors fonction
intermediaire_cartes.R : fichier intermédaire exécutant la requête des tables SQL pour les heatmaps
intermediaire_graph.R : fichier intermédaire exécutant la requête des tables SQL pour le graphique d'abondance
intermediaire_points.R : fichier intermédaire exécutant la requête des tables SQL pour les cartes de papilio canadensis
nettoyage_data.R : filtre et nettoei les données brutes venant deans fichiers .csv
SQL_tables: crées les tables primaire, site et date à partir des données nettoyées
uniformisation_lat_lon.R : uniformise les données de lon et lat à 5 décimales
verification_data.R : s'assure que le filtrage des données a été éxécuté et retourne un message


Instructions
Comment exécuter le projet : 1.aller dans le fichier _targets.R  2.charger les 
source au début du fichier  3.utiliser la fonction tar_make()

Comment reproduire les résultats. Pour changer de données, remplacer "lepidoptère"
avec le working directory dans la première étape du fichier _targets.R

Comment accéder aux données et aux ressources. Utiliser la fonction 
tar_load_everything(), les data.frames utilis.s pour créer les graphiques 
seront présent dans l'environnement


Auteurs et contributeurs : Juliette Boulet-Thomas, Bertrand Labrecque et Marika Roberge