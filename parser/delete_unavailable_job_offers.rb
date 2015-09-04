require_relative 'body_parser'
require './lib/pg_db_config_parse'
require 'colorize'

#----------------------- NEW INSTANCE ---------------------------------------------------
def doc
  ::BodyParser.new
end

#---------------- GETTING AN ARRAY OF URLS FROM TABLE JOB OFFERS ---------------------------------
@result = CONN.exec( "SELECT url FROM job_offers").to_a
puts @result[0]
puts "------------------->>> THERE IS #{@result.length} URLS IN ARRAY <<<------------------------"
nb_offres = @result.length #décompte de ce qu'il reste à insérer ^^
deleted_offer = 0

@result[0..@result.length].each do |item|
  nb_offres = nb_offres - 1

  #------------------------ DELETE FROM DB IF OFFER IS NO LONGER AVAILABLE -----------------
  puts "_________________________________________________________________________________"
  puts "_________________ STARTING CLEANING JOB OFFERS BASE _____________________________"
  if doc.offer_unavailable(item["url"]) == true
    CONN.exec("DELETE FROM job_offers WHERE url = '#{item["url"]}'")
    deleted_offer = deleted_offer + 1
    puts "-------- L'url #{item["url"]} a été supprimé de la bdd job_offers car elle n'est plus disponible-------- ".colorize(:red)
  end
  puts "--- #{nb_offres} offre(s) encore à traiter sur #{@result.length} au départ----"
  puts "_____________________ Nombre d'offre(s) supprimée(s)#{deleted_offer} ___________________________"
end
