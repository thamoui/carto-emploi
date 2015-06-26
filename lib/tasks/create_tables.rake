require 'dotenv'
Dotenv.load


namespace :ango do
  desc "Creation des bases de donnees / SQL"
  task :create_tables do

    puts "Current env is #{ENV["RACK_ENV"]} --------------"

    puts "db name ----- #{ENV["DATABASE_NAME"]}"
    puts "user name ------#{ENV["DATABASE_USER_NAME"]}"

    #exec 'psql -U pole_emploi pole_emploi'
    #sh 'psql -U pole_emploi pole_emploi'
    #sql = File.open("./db/create_db.sql").read
    #test = File.open("test.rb").read

    #sh "psql CREATE DATABASE #{ENV["DATABASE_NAME"]} WITH OWNER #{ENV["DATABASE_USER_NAME"]};"
    #sh "psql -U #{ENV["DATABASE_USER_NAME"]}"
    #sh "RUN_ON_MYDB <<SQL"
    # sh "sudo su postgres psql"
    # sh "CREATE DATABASE pole_emploi WITH OWNER pole_emploi;"

    #sh "psql create database 'pole_emploi' with owner 'pole_emploi';"


    sh "psql -h '127.0.0.1' -p 5432 -d #{ENV["DATABASE_NAME"]} -U #{ENV["DATABASE_USER_NAME"]} -f ./db/structure.sql"
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



#
# https://gist.github.com/KevM/1705486


# GOOD : http://stackoverflow.com/questions/15237366/how-to-execute-a-sql-script-on-heroku

# TOP !!! http://stackoverflow.com/questions/23091817/load-a-structure-sql-into-a-rails-database-via-rake

#
# for some reason I really dislike e.g. manually invoking tasks in rake (Rake::Task["apply_sqlserver_sql"].execute()). convention in ruby is to use snake_case for variable names (se_config instead of seConfig f.ex.)
# [12:02] <apeiros> and of course 2 spaces, not tabs :)
