namespace :clean_db do

  desc 'supprime les urls invalides (indispos ou code rome pas informatique) de la table des urls (parse)'
  task :delete_urls_from_parse  do
    ruby "./parser/clean_parse_table.rb"
  end

  desc 'supprime les offres d emploi qui ne sont plus disponibles de la table (job_offers)'
  task :delete_offers_from_job_offers  do
    ruby "./parser/delete_unavailable_job_offers.rb"
  end

  desc "Supprime les urls (parse) qui ont déja été ajoutées dans la base des offres (job_offers)"
  task :delete_duplicate_parse => :dotenv do
    sh "psql -h '127.0.0.1' -p 5432 -d #{ENV["DATABASE_NAME"]} -U #{ENV["DATABASE_USER_NAME"]} -f ./db/delete_from_parse.sql"
  end
end
