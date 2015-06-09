require 'pg'
require_relative 'body_parser'
require 'geocoder'
require 'geokit'
require 'dotenv'
Dotenv.load
Geokit::default_units = :kms


#----------------------- HEROKU DB CONFIG  ------------------------
if ENV['RACK_ENV'] == "production"
  db_parts = ENV['DATABASE_URL'].split(/\/|:|@/)
  conn = PGconn.connect(hostaddr: db_parts[5], port: 5432, dbname: db_parts[7], user: db_parts[3], password: db_parts[4])
else
#----------------------- CONNECT DATABASE LOCALHOST ----------------------
  conn = PGconn.connect(hostaddr: "127.0.0.1", port: 5432, dbname: "pole_emploi", user: "pole_emploi", password: "pole_emploi")
  end

#----------------------- NEW INSTANCE ----------------------
def doc
  ::BodyParser.new
end
#---------------- GETTING AN ARRAY OF URLS & IDS FROM DB ------------

@result = conn.exec( "SELECT * FROM parse WHERE NOT EXISTS (SELECT offer_id FROM job_offers WHERE (parse.id = job_offers.offer_id));").to_a

puts "--------------- THERE IS #{@result.length} URLS IN ARRAY "

#---------test avec url d'offre indisponible --------

@result[0..10].each do |item|
  #@result[0..10]

    if doc.offer_unavailable(item["url"]) != "L'offre que vous souhaitez consulter n'est plus disponible."
    adress = doc.search_region(item["url"])
  # ------------------- GETTING LATITUDE & LONGITUDE // GEOKIT ------------------------

  if adress == "" #|| adress == nil
    @latitude = 46.16
    @longitude = 1.23
  else
    geodata = Geokit::Geocoders::GoogleGeocoder.geocode(adress).to_hash
    @latitude, @longitude = geodata[:lat], geodata[:lng]
    #@longitude = b[1].to_f.abs
    puts "Latitude  ------------ #{@latitude}"
    puts "Latitude  ------------ #{@longitude}"
    sleep(5)
  end


  # #------------------- GETTING LATITUDE & LONGITUDE // GEOCODER ---------------------
  #     adresses.each do |adress|
  #       if adress == ""
  #         @latitude = 46.16
  #         @longitude = 1.23
  #       else
  #         puts "this is d---------- #{adress}"
  #         d = Geocoder.search(adress)
  #         puts "this is d---------- #{d}"
  #         ll = d[0].data["geometry"]["location"]
  #         @latitude = ll['lat']
  #         @longitude = ll['lng']
  #       end
  #     end
  #     sleep(8)
  #------------------- USING BODY PARSER  ---------------------

  data = [doc.search_region(item["url"]), item["id"], doc.search_title(item["url"]), doc.search_employment_type(item["url"]), doc.search_code_rome(item["url"]), doc.search_publication_date(item["url"]), doc.search_description_offer(item["url"]), item["url"], doc.search_company_description(item["url"]), @latitude, @longitude]

  values = data.map {|v| "\'#{v}\'"}.join(',').to_s

  conn.exec("INSERT INTO job_offers (region_adress, offer_id, title, contrat_type, code_rome, publication_date, offer_description, url, company_description, latitude, longitude) VALUES (#{values});")

  sleep(5)
  puts "---------------------------- DEBUT DE L'INSERTION -------------------------- "
  puts "------------ ADRESS de l'offre : #{doc.search_region(item["url"])}---------- "
  puts "-------------------- OFFER ID de l' offre : #{item["id"]} ------------------ "
  puts "--------------------------- OFFER INSERTED INTO DB ------------------------- "

end
end

conn.close
