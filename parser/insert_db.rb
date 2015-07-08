require 'pg'
require_relative 'body_parser'
require 'geocoder'
require 'geokit'
require 'dotenv'
require 'time'

Dotenv.load
Geokit::default_units = :kms


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
# only select from parse if offer is not in job_offers db
@result = conn.exec( "SELECT * FROM parse WHERE NOT EXISTS (SELECT offer_id FROM job_offers WHERE (parse.id = job_offers.offer_id));").to_a

puts "------------------->>> THERE IS #{@result.length} URLS IN ARRAY <<<------------------------"

nb_offres = @result.length #décompte de ce qu'il reste à insérer ^^
offre_ajout = 0

#---------test avec url d'offre indisponible --------

@result[0..@result.length].each do |item|
  nb_offres = nb_offres - 1
  puts "_______________________________ STARTING ___________________________________"
  puts "-------------------- OFFER ID de l' offre : #{item["id"]} ------------------ "
  puts "---- Disponibilité de l'offre : #{doc.offer_unavailable(item["url"])} (true = indisponible) ---------"

  #-------- Message d'alerte pour vérifier que l'url n'est pas ajouté si le code rome n'est pas bon

  if doc.check_code_rome(item["url"]) == false
    puts "---------- Code Rome Invalide  ---------- "
  end

  if doc.offer_unavailable(item["url"]) == false && doc.check_code_rome(item["url"]) == true
    adress = doc.search_region(item["url"]).gsub(/''/, "'")

    puts "-- #{nb_offres} offre(s) encore à parser sur #{@result.length} au départ-----"

    if adress != adress.upcase
      puts "------------------ #{adress} n'est pas une ville ------------------------- "
    end

    # ------------------- GETTING LATITUDE & LONGITUDE // GEOKIT ------------------------
    if adress != "" && adress == adress.upcase #si adress en majuscule c'est une ville

      geodata = Geokit::Geocoders::GoogleGeocoder.geocode(adress, :bias => 'fr').to_hash
      @latitude, @longitude = geodata[:lat], geodata[:lng]
      puts "Latitude BEFORE --------- #{@latitude} // Longitude  ------------ #{@longitude}"

      #change a little bit data to see offers in the map when we zoom
      @latitude += rand(0.0007..0.0019)
      @longitude += rand(0.0004..0.0019)

      puts "Latitude AFTER  --------- #{@latitude} // Longitude  ------------ #{@longitude}"
      sleep(3)

      # #------- Use Geocoder Gem --------
      # if latitude == nil
      # d = Geocoder.search(adress)
      # puts "this is d---------- #{d}"
      # ll = d[0].data["geometry"]["location"]
      # @latitude, @longitude  = ll['lat'], ll['lng']
      # @latitude += rand(0.0007..0.0019)
      # @longitude += rand(0.0004..0.0019)

      if @latitude != nil

        #  ------------------- USING BODY PARSER  ---------------------

        time = Time.now
        data = [doc.search_region(item["url"]), item["id"], doc.search_title(item["url"]), doc.search_employment_type(item["url"]), doc.search_code_rome(item["url"]), doc.search_publication_date(item["url"]), doc.search_description_offer(item["url"]), item["url"], doc.search_company_description(item["url"]), @latitude, @longitude, time]

        values = data.map {|v| "\'#{v}\'"}.join(',').to_s

        conn.exec("INSERT INTO job_offers (region_adress, offer_id, title, contrat_type, code_rome, publication_date, offer_description, url, company_description, latitude, longitude, created_at) VALUES (#{values});")

        offre_ajout = offre_ajout + 1

        sleep(3)

        puts "---------------------------- DEBUT DE L'INSERTION -------------------------- "
        puts "------------ ADRESS de l'offre : #{doc.search_region(item["url"])}---------- "

        puts "--------------------------- OFFER INSERTED INTO DB :) ---------------------- "
        puts "-- #{nb_offres} offre(s) encore à parser sur #{@result.length} au départ-----"
        puts "__________ Nb d'offres insérées : #{offre_ajout}_____________________________"

      end #fin du test latitude !=nil

    end
    sleep(2)
  end
end



