require 'pg'
require_relative 'body_parser'
require 'dotenv'

Dotenv.load
#----------------------- HEROKU DB CONFIG  ------------------------
if ENV['RACK_ENV'] == "production"
  db_parts = ENV['DATABASE_URL'].split(/\/|:|@/)
  conn = PGconn.connect(host: db_parts[5], port: 5432, dbname: db_parts[7], user: db_parts[3], password: db_parts[4])
else
  #----------------------- CONNECT DATABASE LOCALHOST ----------------------
  conn = PGconn.connect(host: "127.0.0.1", port: 5432, dbname: ENV['DATABASE_NAME'], user: ENV['DATABASE_USER_NAME'], password: ENV['DATABASE_PASSWORD'])
  require 'colorize'
end

#----------------------- NEW INSTANCE ----------------------
def doc
  ::BodyParser.new
end
#---------------- GETTING AN ARRAY OF URLS & IDS FROM DB ------------
#only select from parse if offer is not in job_offers db
@result = conn.exec( "SELECT url FROM job_offers").to_a
puts @result[0]
puts "------------------->>> THERE IS #{@result.length} URLS IN ARRAY <<<------------------------"
nb_offres = @result.length #décompte de ce qu'il reste à insérer ^^
deleted_offer = 0

@result[0..@result.length].each do |item|
  nb_offres = nb_offres - 1
  deleted_offer + 1
  puts "_________________ STARTING PARSING ALL JOB OFFERS _____________________________"
  # puts "-------------------- OFFER ID de l' offre : #{item["id"]} -------------------- "
  # puts "---- Disponibilité de l'offre : #{doc.offer_unavailable(item["url"])} ---------"
  #
  if doc.offer_unavailable(item["url"]) == "L'offre que vous souhaitez consulter n'est plus disponible."
    conn.exec("DELETE FROM job_offers WHERE url = '#{item["url"]}'")
    puts "-------- L'url #{item["url"]} a été supprimé de la bdd job_offers-------- "
  end
  puts "--- #{nb_offres} offre(s) encore à parser sur #{@result.length} au départ----"
  puts "_________Nombre d'offre(s) supprimée(s)#{deleted_offer}__________________________________"

end
