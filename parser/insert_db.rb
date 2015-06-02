require 'pg'
require_relative 'body_parser'
require 'geocoder'

#----------------------- DB CONFIG  ------------------------
@hostaddr = "127.0.0.1"
@port = 5432
@dbname = "pole_emploi"
@user = "pole_emploi"
@password = "pole_emploi"

#----------------------- CONNECT DATABASE  ----------------------
conn = PGconn.connect(:hostaddr=>@hostaddr, :port=>@port, :dbname=>@dbname, :user=>@user, :password=>@password)

#----------------------- NEW INSTANCE ----------------------
def doc
 @newdoc = ::BodyParser.new
end
#---------------- GETTING AN ARRAY OF URLS & IDS FROM DB ------------
@urls= []
 conn.exec( "SELECT * FROM parse" ).map do |result|
   @urls << result.to_a  #result is an hash
 end

@b = []
@urls.each do |a|
  a = a.flatten!
  a = a - ["id"]
  a = a - ["url"]
  @b << a
  # => puts "----------- this is b #{@b}"
  end
@urls = @b[86..90]
#change value if you want to test with only a few urls
#5 by 5 it's good

joboffer_datas = []
adresses = []

@urls.each do |url, offer_id|
    adresses << doc.search_region(url)
    #------------------- GETTING LATITUDE & LONGITUDE ---------------------
    adresses.each do |adress|
      #puts "this is d---------- #{adress}"
      d = Geocoder.search(adress)
      #puts "this is d---------- #{d}"
      ll = d[0].data["geometry"]["location"]
      @latitude = ll['lat']
      @longitude = ll['lng']
    end
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

conn.close
