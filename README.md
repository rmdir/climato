# climato

Quelques scripts pour valider l'hypothèse qu'on rejette trop d'eau à la mer
Les valeurs sont téléchargées sur hubeau et infoclimat et insérées dans une base postgres.


## Paramétrages

  - Schema de la bdd : data/stations\_hubeau.sql
  - Liste des stations infoclimat : data/stations\_infoclimat.yml
  - Exemple de config : data/sample_config.yaml
  - Liste des station hubeau : data/hydrlogy.sql

## Code

  - Wrapper pour la crontab cron.sh
  - Collecte de la pluviométrie et moyenne pluie.pl
  - Collecte des données hubeau : hauteur.pl
  - Effort de factorisation :  lib/Mesures/Utils.pm
