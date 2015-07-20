namespace :clean_db do

  desc 'supprime les urls invalides (indispos ou code rome pas informatique) de la table des urls (parse)'
  task :delete_2_urls_from_parse  do
    ruby "./parser/clean_parse_table.rb"
  end

  desc 'supprime les offres d emploi qui ne sont plus disponibles de la table (job_offers)'
  task :delete_offers_from_job_offers  do
    ruby "./parser/delete_unavailable_job_offers.rb"
  end

  desc "Supprime les urls (parse) qui ont déja été ajoutées dans la base des offres (job_offers)"
  task :delete_1_duplicate_parse => :dotenv do
    if ENV["RACK_ENV"] == 'production'
      sh "heroku pg:psql -a ango-jobs <db/delete_from_parse.sql"
    else
      sh "psql -h '127.0.0.1' -p 5432 -d #{ENV["DATABASE_NAME"]} -U #{ENV["DATABASE_USER_NAME"]} -f ./db/delete_from_parse.sql"
    end
  end

  #si env = production sh "heroku pg:psql -a ango-jobs <db/delete_from_parse.sql"

  desc "Vider la base parse"
  task :truncate_parse do
    sh "psql -h '127.0.0.1' -p 5432 -d #{ENV["DATABASE_NAME"]} -U #{ENV["DATABASE_USER_NAME"]} -f ./db/truncate_parse.rb"
  end

  desc "Vider la base job_offers"
  task :truncate_job_offers do
    sh "psql -h '127.0.0.1' -p 5432 -d #{ENV["DATABASE_NAME"]} -U #{ENV["DATABASE_USER_NAME"]} -f ./db/truncate_job_offers.rb"
  end
end
