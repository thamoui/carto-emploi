namespace :clean_db do

  desc 'supprime les urls invalides (indispos ou code rome pas informatique) de la table des urls (parse)'
  task :delete_2_urls_from_parse  do

    t1 = Time.now
    puts "-------------------------- DEBUT :  #{Time.now} ------------------------"
    ruby "./parser/clean_parse_table.rb"

    t2 = Time.now
    task = t2 - t1
    puts "------------------------ DUREE :  #{task/60} minutes ------------------"



  end

  desc 'supprime les offres d emploi qui ne sont plus disponibles de la table (job_offers)'
  task :delete_offers_from_job_offers  do
    ruby "./parser/delete_unavailable_job_offers.rb"
  end

  # tache a supprimer si clean_parse_table le fait systématiquement
  desc "Supprime les urls (parse) qui ont déja été ajoutées dans la base des offres (job_offers)"
  task :delete_1_duplicate_parse => :dotenv do
    if ENV["RACK_ENV"] == 'production'
      #sh "heroku pg:psql -a ango-jobs <db/delete_from_parse.sql"

      system ('/usr/local/bin/dokku postgresql:console angold < /root/db/del_duplicate.sql ')
    else
            sh "psql -h '127.0.0.1' -p 5432 -d #{ENV["DATABASE_NAME"]} -U #{ENV["DATABASE_USER_NAME"]} -f ./db/delete_from_parse.sql"
    end
  end

  # ----------------- fin de tache a supprimer peut etre --------------------------

  desc "Vider la base parse"
  task :truncate_parse do
    sh "psql -h '127.0.0.1' -p 5432 -d #{ENV["DATABASE_NAME"]} -U #{ENV["DATABASE_USER_NAME"]} -f ./db/truncate_parse.rb"
  end

  desc "Vider la base job_offers"
  task :truncate_job_offers do
    sh "psql -h '127.0.0.1' -p 5432 -d #{ENV["DATABASE_NAME"]} -U #{ENV["DATABASE_USER_NAME"]} -f ./db/truncate_job_offers.rb"
  end
end
