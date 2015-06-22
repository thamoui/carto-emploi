namespace :clean_db do

  desc 'supprime les urls invalides de la table des urls (parse)'
  task :delete_urls  do
    ruby "./parser/delete_parse.rb"
  end

  desc 'supprime les offres invalides de la table des offres (job_offers)'
  task :delete_offers  do
    ruby "./parser/delete_job_offers.rb"
  end
end
