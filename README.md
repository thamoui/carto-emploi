# carto-emploi
Projet de cartographie des emplois du numérique en France



## configuration de la base de données

`sudo su postgres`

puis

`psql`

puis

`create role pole_emploi with createdb login password 'pole_emploi';`

Pour vérifier que le changement est OK :

`\dgh`

Pour créer la bdd :

`CREATE DATABASE pole_emploi WITH OWNER pole_emploi;`

Créer les colonnes de la table :

`psql -U pole_emploi pole_emploi`

puis :

```sql

CREATE TABLE job_offers
(
  region_adress text,
  id_key serial NOT NULL,
  title text,
  contrat_type text,
  code_rome text,
  offer_description text,
  company_description text,
  url text,
  latitude numeric,
  longitude numeric,
  offer_id text,
  publication_date text
)
WITH (
  OIDS=FALSE
);

```

Pour voir l’aide de Postgres : \?

Pour sortir de la console PSQL et revenir à la ligne de commande du terminal Ctrl D (deux fois !).

## Lancer le parser

lancer le premier script qui récupère les urls et id correspondant aux offres d'emplois pour les jobs du numérique

Attention : le script génère de nombreuses url !
Ouvrir le dossier `parser` et lancer l'execution via le terminal :

`ruby pole_emploi_parser.rb`

Une fois que le processus est terminé, lancer le parser qui récupère le détail de chaque offre d'emploi et insère les datas dans la BDD :

`ruby insert_db.rb`
