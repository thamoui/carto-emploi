require_relative 'body_parser'
require './lib/pg_db_config_parse'


#------------------------------ NEW INSTANCE ---------------------------
def doc
  ::BodyParser.new
end

# -------------------------- DELETE DUPLICATE -------------------------

puts "----------------Nombre de doublons #{CONN.exec("SELECT * FROM parse WHERE EXISTS (SELECT offer_id FROM job_offers WHERE (parse.id = job_offers.offer_id));").to_a.length}"
puts "#{CONN.exec( "SELECT url FROM parse").to_a.length} - Offers in database BEFORE cleaning"

CONN.exec( "DELETE FROM parse WHERE EXISTS (SELECT offer_id FROM job_offers WHERE (parse.id = job_offers.offer_id));")

puts "#{CONN.exec( "SELECT url FROM parse").to_a.length} - Offers in database AFTER cleaning"


#---------------- GETTING AN ARRAY OF URLS FROM TABLE PARSE ------------
@result = CONN.exec( "SELECT url FROM parse").to_a
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
    puts "----- offre indisponible : #{doc.offer_unavailable(item["url"])} ------ "
    puts "----- code rome incorrect : #{doc.check_code_rome(item["url"])} ------ "
    puts "----- est bien une ville : #{doc.check_is_a_city(item["url"])} ------ "

    CONN.exec("DELETE FROM parse WHERE url = '#{item["url"]}'")
    deleted_urls = deleted_urls + 1
    puts "-------- L'url #{item["url"]} a été supprimé de la bdd parse -------- "
  end
  puts "-------------------- #{nb_urls} url(s) encore à traiter sur #{@result.length} au départ --------------"
  puts "___________________ Nombre d'url(s) supprimée(s)#{deleted_urls}________________________________"
end
