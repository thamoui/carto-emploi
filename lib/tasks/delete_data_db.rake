namespace :clean_db do

  desc 'supprime les urls invalides de la table des urls (parse)'
  task :delete_urls  do
    ruby "./parser/clean_parse.rb"
  end

  desc 'supprime les offres invalides de la table des offres (job_offer)'
  task :delete_offers  do
    ruby "./parser/clean_job_offer.rb"
  end

  desc "Supprime les urls (parse) qui ont déja été ajoutées dans la base des offres (job_offer)"
  task :delete_duplicate_parse => :dotenv do
    sh "psql -h '127.0.0.1' -p 5432 -d #{ENV["DATABASE_NAME"]} -U #{ENV["DATABASE_USER_NAME"]} -f ./db/delete_from_parse.sql"
  end
end
