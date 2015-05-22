require 'pg'
require_relative 'body_parser'
require 'geocoder'

#----------------------- DB CONFIG  ------------------------
@hostaddr = "127.0.0.1"
@port = 5432
@dbname = "pejoboffers"
@user = "jobadmin"
@password = 'Som3ThinG'

#----------------------- NEW INSTANCE ----------------------
def doc
 @newdoc = ::BodyParser.new
end
#---------------- DATAS A RECUPERER DS LE SCRIPT D'HAFID ------------
@urls = [["https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/1868508", "1868508"],["https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF","027FLJF"], ["https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/1844533", "184533"],["https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/1675812", "1675812"]]

joboffer_datas = []
adresses = []

@urls.each do |url, offer_id|
  adresses << doc.search_region(url)

    #------------------- GETTING LATITUDE & LONGITUDE ---------------------
    adresses.each do |adress|
      d = Geocoder.search(adress)
      ll = d[0].data["geometry"]["location"]
      #puts "#{adress}\t#{ll['lat']}\t#{ll['lng']}"
      @latitude = ll['lat']
      @longitude = ll['lng']
    end

  joboffer_datas << [doc.search_region(url).chop, offer_id, doc.search_title(url), doc.search_employment_type(url), doc.search_code_rome(url).gsub(/'/, "''"), doc.search_publication_date(url), doc.search_description_offer(url).gsub(/'/, "''"), doc.search_company_description(url).gsub(/'/, "''"), url, @latitude, @longitude]
  end

#--------- Cleaning datas with regex - Clues for refactoring -----------------------

# for datas in joboffer_datas do
#     datas.map do |data|
#         if data.is_a? String
#           data.gsub(/'/, "''")
#         end
#     end
# end


#-------------- INSERT DATAS TO DATABASE---------------------
#----- WATCH OUT URL MUST BE VALID : NO URL, NO DATAS -------

#----------------------- CONNECT DATABASE  ----------------------
conn = PGconn.connect(:hostaddr=>@hostaddr, :port=>@port, :dbname=>@dbname, :user=>@user, :password=>@password)

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

    puts "------------- offre n #{i} : #{company_description}"

    conn.exec("INSERT INTO joboffers (region_adress, offer_id, title, contrat_type, code_rome, publication_date, offer_description, url, company_description, latitude, longitude) VALUES ('#{region_adress}', '#{offer_id}', '#{title}', '#{contrat_type}', '#{code_rome}', '#{publication_date}', '#{offer_description}', '#{url}', '#{company_description}', '#{latitude}', '#{longitude}');")

end

conn.close
