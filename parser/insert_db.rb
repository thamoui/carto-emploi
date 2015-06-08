require 'pg'
require_relative 'body_parser'
require 'geocoder'
require 'geokit'
require 'dotenv'
Dotenv.load

Geokit::default_units = :kms

#----------------------- HEROKU DB CONFIG  ------------------------
  db_parts = ENV['DATABASE_URL'].split(/\/|:|@/)
  username = db_parts[3]
  password = db_parts[4]
  host = db_parts[5]
  db = db_parts[7]


  conn = PGconn.connect(:host =>  host, :dbname => db, :user=> username, :password=> password)


# ----------------------- DB CONFIG  LOCALHOST ------------------------
# @hostaddr = "127.0.0.1"
# @port = 5432
# @dbname = "pole_emploi"
# @user = "pole_emploi"
# @password = "pole_emploi"
#
# # #----------------------- CONNECT DATABASE LOCALHOST ----------------------
# conn = PGconn.connect(:hostaddr=>@hostaddr, :port=>@port, :dbname=>@dbname, :user=>@user, :password=>@password)

#----------------------- NEW INSTANCE ----------------------
def doc
 @newdoc = ::BodyParser.new
end
#---------------- GETTING AN ARRAY OF URLS & IDS FROM DB ------------
@urls_unclean= []
 conn.exec( "SELECT * FROM parse" ).map do |result|
   @urls_unclean << result.to_a  #result is an hash
 end

@urls_id = []

@urls_unclean.each do |a|
  a = a.flatten!
  a = a - ["id"]
  a = a - ["url"]
  @urls_id << a
  #puts "----------- this is b #{@b}"
  end

#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
#------------------ STARTING URLS PARSING FIVE by FIVE WITH A PAUSE ------------------
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------


#0.step(30,5) do |num| #30 is the limit, depends on database size
puts "---------------- Theres is #{@urls_id.length} urls in the database --------------- "


#(@urls_id.length - 8).step(@urls_id.length, 5) do |num|

#0.step(@urls_id.length, 5) do |num|
4112.step(4153, 2) do |num|
  #le parser entre les x premières urls, avec un pas de 5

    @five_urls = @urls_id[num..num+1]
    puts "------------- 2 urls suivantes start #{num} -------------------------------"
    puts @five_urls

  joboffer_datas = []
  adresses = []

  @five_urls.each do |url, offer_id|
      adresses << doc.search_region(url)


# ------------------- GETTING LATITUDE & LONGITUDE // GEOKIT ------------------------
adresses.each do |adress|
      if adress == ""
        @latitude = 46.16
        @longitude = 1.23
      else
a = Geokit::Geocoders::GoogleGeocoder.geocode adress
b = a.ll.split(',', 2)
@latitude = b[0].to_f.abs
@longitude = b[1].to_f.abs
puts "Latitude  ------------ #{@latitude}"
puts "Latitude  ------------ #{@longitude}"
end
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


  joboffer_datas << [doc.search_region(url), offer_id, doc.search_title(url), doc.search_employment_type(url), doc.search_code_rome(url), doc.search_publication_date(url), doc.search_description_offer(url), doc.search_company_description(url), url, @latitude, @longitude]
     end
  #-------------- INSERT DATAS TO DATABASE---------------------
  #----- WATCH OUT URL MUST BE VALID : NO URL, NO DATAS -------
  (0..joboffer_datas.length-1).each do |i|

      region_adress = joboffer_datas[i][0]
      offer_id = joboffer_datas[i][1]
      title = joboffer_datas[i][2]
      contrat_type = joboffer_datas[i][3]
      code_rome = joboffer_datas[i][4]
      publication_date = joboffer_datas[i][5]
      offer_description = joboffer_datas[i][6]
      company_description = joboffer_datas[i][7]
      url = joboffer_datas[i][8]
      latitude = joboffer_datas[i][9]
      longitude = joboffer_datas[i][10]

      puts "-------------CODE ROME de l'offre n #{i} : #{code_rome}"
      puts "-------------CODE ROME de l' offre n #{i} : #{title}"

      conn.exec("INSERT INTO job_offers (region_adress, offer_id, title, contrat_type, code_rome, publication_date, offer_description, url, company_description, latitude, longitude) VALUES ('#{region_adress}', '#{offer_id}', '#{title}', '#{contrat_type}', '#{code_rome}', '#{publication_date}', '#{offer_description}', '#{url}', '#{company_description}', '#{latitude}', '#{longitude}');")
  end
    sleep(5)
    puts "--------------------------- OFFER INSERTED INTO DB ------------------ "
end

conn.close
