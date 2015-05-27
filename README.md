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
