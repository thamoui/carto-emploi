# ANGO

Projet de cartographie des emplois du numérique en France :  https://ango-jobs.herokuapp.com/


# pré-requis

- ruby '2.1.3' avec rbenv ou un autre gestionnaire de versions
- postgresql http://www.postgresql.org/
`sudo apt-get install postgresql`

- bundler http://bundler.io/
`gem install bundler`


# récupérer le projet

`git clone https://github.com/simplonco/carto-emploi.git`

Puis lancer l'installation des gem :

`bundle install`


# configurer les variables d'environnement

renommer les fichiers .envsample et /parser/.envsample en .env et remplacer les valeurs si nécessaire
Ex :

```
DATABASE_PASSWORD=pole_emploi
DATABASE_USER_NAME="pole_emploi"
DATABASE_URL=postgres://..... #valeur donnée par heroku ou autre
RACK_ENV=development
```


# configuration de la base de données

lancer le terminal de postgres
`sudo su postgres`
puis
`psql`

ou `sudo -u postgres psql`
puis

`create role pole_emploi with createdb login password 'pole_emploi';`

Pour vérifier que le changement est OK et voir la liste des utilisateurs  :

`\dgh`

* utile :
Pour voir l’aide de Postgres :
`\?`
Pour sortir de la console PSQL et revenir à la ligne de commande du terminal Ctrl D (deux fois !).


# créer les tables en local

Lancer la tâche `rake ango:create_tables`

`rake db:create RACK_ENV='development'` est censé remplacer la commande du dessus

essaye bundle exec rake db:create RACK_ENV='development'

rake db:structure:load

ou
`rake db:create`
puis

`rake db:structure:load` qui va charger via active record la structure de la bdd


# créer les tables sur heroku

Dans le terminal :

`heroku pg:psql -a ango-jobs <db/structure.sql`

( heroku pg:psql -a your-app-name <db/structure.sql )


# Lancer le parser

Voir la liste des tâches disponibles ` rake -T`

 1. Récupération des urls

Lancer le premier script qui récupère les urls et id correspondant aux offres d'emplois pour les jobs du numérique

Attention : le script génère de nombreuses url !
Sachant que les départements vont de 1 à 95 et que le 20 n'existe pas, c'est la Corse et est remplacé par 2A et 2B
`rake parser:url_parse_1_19`   # insère les urls des offres des départements 1 à 19
`rake parser:url_parse_21_95`  # insère les urls des offres des départements 21 à 95
`rake parser:url_parse_2A_2B`  # insère les urls des offres disponibles en Corse

 2. Insertion des données des offres d'emplois

`rake parser:insert_offers`    # parse les urls et insère le détail des offres dans la base de données

 3. Nettoyage de la base de données

Pour supprimer de la base job_offers les offres qui ne sont plus disponibles :


```rake clean_db:delete_offers```
supprime les offres invalides de la table des offres (job_offers)

```rake clean_db:delete_urls
```
  supprime les urls invalides de la table des urls (parse)


# Pour faire la même chose en production

Depuis votre terminal, ajouter `heroku run` avant la listes des tâches rake mentionnées au paragraphe précédant.
Exemple :  `heroku run rake -T`


# Lancer l'api sur un serveur

Dans le terminal :

`shotgun carto_emploi.rb`


Ex d'urls pour visualiser le fichier json généré :

- Voir toutes les offres d'emplois disponibles : http://0.0.0.0:9393/emploi?limit=50&p=2
- Chercher un métier parmi les offres : http://0.0.0.0:9393/search/administrateur?limit=3&p=2
- Chercher un métier situé à une certaine distance : http://0.0.0.0:9393/geosearch/48.86833,2.66833?text=administrateur&d=50&limit=5&p=1


# Documentation utile

- Gem Geokit pour la géolocalisation d'une adresse : http://www.rubydoc.info/gems/geokit/1.9.0
