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
#only select from parse if offer is not in parse db
@result = conn.exec( "SELECT url FROM parse").to_a
puts @result[0]
puts "------------------->>> THERE IS #{@result.length} URLS IN ARRAY <<<------------------------"
nb_urls = @result.length #décompte de ce qu'il reste à insérer ^^
deleted_urls = 0

@result[0..@result.length].each do |item|
  nb_urls = nb_urls - 1


  puts "_________________ STARTING PARSING ALL JOB OFFERS _____________________________"
  # puts "-------------------- OFFER ID de l' offre : #{item["id"]} -------------------- "
  # puts "---- Disponibilité de l'offre : #{doc.offer_unavailable(item["url"])} ---------"
  #
  if doc.offer_unavailable(item["url"]) == true
    conn.exec("DELETE FROM parse WHERE url = '#{item["url"]}'")
    deleted_urls = deleted_urls + 1
    puts deleted_urls
    puts "-------- L'url #{item["url"]} a été supprimé de la bdd parse-------- "
  end
  puts "--- #{nb_urls} url(s) encore à traiter sur #{@result.length} au départ----"
  puts "_________Nombre d'url(s) supprimée(s)#{deleted_urls}__________________________________"

end
