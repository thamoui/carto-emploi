namespace :ango do
  desc "Creation des bases de données / SQL"
  task :create_tables  do

    #exec 'psql -U pole_emploi pole_emploi'
    #sh 'psql -U pole_emploi pole_emploi'
    #sql = File.open("./db/create_db.sql").read
    #test = File.open("test.rb").read

    sh "psql -h '127.0.0.1' -p 5432 -d pole_emploi -U pole_emploi -f ./db/structure.sql"
  end

end

# Use rake db:structure:load, which will load db/structure.sql.


# Use the database's own SQL load mechanism.
#
# For Postgres this should work (at least if the database exists and you don't need a password):
#
# psql -d databaseName < db/structure.sql
# On Heroku where rake db:setup doesn't work as you can't create a database like that you can do this:
#
# heroku pg:psql < db/structure.sql


#psql -h host -p port -d dbname -U username -f create_db.sql

#psql -h 127.0.0.1 -p 5432 -d pole_emploi -U pole_emploi -f create_db.sql

#----------------------- CONNECT DATABASE LOCALHOST ----------------------
# conn = PGconn.connect(host: "127.0.0.1", port: 5432, dbname: ENV['DATABASE_NAME'], user: ENV['DATABASE_USER_NAME'], password: ENV['DATABASE_PASSWORD'])
# require 'colorize'

#
# https://gist.github.com/KevM/1705486


# GOOD : http://stackoverflow.com/questions/15237366/how-to-execute-a-sql-script-on-heroku

# TOP !!! http://stackoverflow.com/questions/23091817/load-a-structure-sql-into-a-rails-database-via-rake

#
# for some reason I really dislike e.g. manually invoking tasks in rake (Rake::Task["apply_sqlserver_sql"].execute()). convention in ruby is to use snake_case for variable names (se_config instead of seConfig f.ex.)
# [12:02] <apeiros> and of course 2 spaces, not tabs :)
