# carto-emploi
Projet de cartographie des emplois du numérique en France


# récupérer le projet

`git clone https://github.com/simplonco/carto-emploi.git`

Puis lancer l'installation des gem :

`bundle install`

Pré-requis : vous devez avoir installer Ruby sur votre machine !



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

et

```
CREATE TABLE parse
(
  url text,
  id text,
  id_key serial NOT NULL
)
WITH (
  OIDS=FALSE
);
```

Créer des primary key :

```
ALTER TABLE job_offers ADD PRIMARY KEY (offer_id);
```

```
ALTER TABLE parse ADD PRIMARY KEY (id_key);
```



Pour voir l’aide de Postgres : \?

Pour sortir de la console PSQL et revenir à la ligne de commande du terminal Ctrl D (deux fois !).

## Lancer le parser

Lancer le premier script qui récupère les urls et id correspondant aux offres d'emplois pour les jobs du numérique

Attention : le script génère de nombreuses url !
Ouvrir le dossier `parser` et lancer l'execution via le terminal :

`ruby pole_emploi_parser.rb 1 19` pour parser du département 1 à 19, sachant que les départements vont de 1 à 95 et que le 20 n'existe pas, c'est la Corse et est remplacé par 2A et 2B

Une fois que le processus est terminé, lancer le parser qui récupère le détail de chaque offre d'emploi et insère les datas dans la BDD :

`ruby insert_db.rb`


Pour supprimer de la base job_offers les offres qui ne sont plus disponibles :


```bash
parser/delete_offers.rb
```

Pour faire la même chose en production, lancer d'abord une console :
`heroku run bash`

# Lancer l'api

Dans le terminal :

`shotgun carto_emploi.rb`


Ex d'urls pour visualiser le fichier json généré :

- Voir toutes les offres d'emplois disponibles : http://0.0.0.0:9393/emploi?limit=50&p=2
- Chercher un métier parmi les offres : http://0.0.0.0:9393/search/administrateur?limit=3&p=2
- Chercher un métier situé à une certaine distance : http://0.0.0.0:9393/geosearch/48.86833,2.66833?text=administrateur&d=50&limit=5&p=1


# Déployement

https://jobmapseeker.herokuapp.com/
