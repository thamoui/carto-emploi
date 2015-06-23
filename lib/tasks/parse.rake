namespace :ango do
  desc 'insère les urls des offres des départements 1 à 19'
  task :url_parse_1_19  do
    ruby "./parser/pole_emploi_parser.rb 1 19"
  end

  desc 'insère les urls des offres disponibles en Corse'
  task :url_parse_2A_2B  do
    ruby "./parser/pole_emploi_parser.rb 2A 2B"
  end

  desc 'insère les urls des offres des départements 21 à 95'
  task :url_parse_21_95  do
    ruby "./parser/pole_emploi_parser.rb 21 95"
  end

  desc 'insère les urls des offres de tous les départements'
  task :a_l_abordage  do
    ruby "./parser/pole_emploi_parser.rb 2A 2B"
    ruby "./parser/pole_emploi_parser.rb 1 19"
    ruby "./parser/pole_emploi_parser.rb 21 95"
  end


  desc 'parse les urls et insère le détail des offres dans la base de données'
  task :insert_offers  do
    ruby "./parser/insert_db.rb"
  end



  # desc 'insère les urls des offres pour un ou des départements au choix'
  # task :url_parse do |dpt_start, dpt_last|
  #   ruby "./parser/pole_emploi_parser.rb #{ARGV[0]} #{ARGV[1]}"
  # end


  task :invite do |dpt_start, dpt_last|
  puts "Invitation sent to '#{dpt_start} <#{dpt_last}>'"
end
end
