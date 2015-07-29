# require 'pg'
require_relative 'body_parser'
# require 'dotenv'
#
# Dotenv.load
# #----------------------- HEROKU DB CONFIG  ------------------------
# if ENV['RACK_ENV'] == "production"
#   db_parts = ENV['DATABASE_URL'].split(/\/|:|@/)
#   conn = PGconn.connect(host: db_parts[5], port: 5432, dbname: db_parts[7], user: db_parts[3], password: db_parts[4])
# else
#   #----------------------- CONNECT DATABASE LOCALHOST ----------------------
#   conn = PGconn.connect(host: "127.0.0.1", port: 5432, dbname: ENV['DATABASE_NAME'], user: ENV['DATABASE_USER_NAME'], password: ENV['DATABASE_PASSWORD'])
#   require 'colorize'
# end

require './lib/pg_db_config_parse'


#------------------------------ NEW INSTANCE ---------------------------
def doc
  ::BodyParser.new
end

#---------------- GETTING AN ARRAY OF URLS FROM TABLE PARSE ------------
@result = conn.exec( "SELECT url FROM parse").to_a
puts @result[0]
puts "------------------- THERE IS #{@result.length} URLS IN ARRAY ----------------------"
nb_urls = @result.length #décompte de ce qu'il reste à insérer ^^
deleted_urls = 0

@result[0..@result.length].each do |item|
  nb_urls = nb_urls - 1
  puts "_________________________________________________________________________________"
  puts "______________________ STARTING CLEANING UNAVAILABLE OFFERS FROM PARSE BASE  _____________________________"

  # L'offre est supprimée si elle n'est plus disponible sur le site de pole emploi
  # Ou si le code rome n'est pas dans le secteur de l'informatique
  # Ou si adress n'est pas une ville

  if doc.offer_unavailable(item["url"]) == true || doc.check_code_rome(item["url"]) == false || doc.check_is_a_city(item["url"]) == false

    # doc.search_region(item["url"]) != doc.search_region(item["url"]).upcase
    puts 'Url effacée si code rome ou ville incorrecte ou offre non disponible sur pole emploi '
    conn.exec("DELETE FROM parse WHERE url = '#{item["url"]}'")
    deleted_urls = deleted_urls + 1
    puts "-------- L'url #{item["url"]} a été supprimé de la bdd parse -------- "
  end
  puts "-------------------- #{nb_urls} url(s) encore à traiter sur #{@result.length} au départ --------------"
  puts "___________________ Nombre d'url(s) supprimée(s)#{deleted_urls}________________________________"
end
