require 'pg'
require_relative 'body_parser'

# def doc
#  @newdoc = ::BodyParser.new
# end
#
# puts "new object #{doc}"
#
# url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/1863885"
# adress = doc.search_region(url)
# id = 1863885
# puts "-----test #{adress}"

# Output a table of current connections to the DB

offers = []
conn = PGconn.connect(:hostaddr=>"127.0.0.1", :port=>5432, :dbname=>"pejoboffers", :user=>"jobadmin", :password=>'Som3ThinG')

conn.exec( "SELECT * FROM joboffers" ) do |result|
  #puts "     region_adress | ID"
  #puts "---this is result #{result}"
  result.each do |offer|
  offers << offer
  end
end
conn.close

puts "this is offers array ---------- #{offers}"

# ------------------- CONNECTING DATA BASE



# ------------------- INSERT VALUE TO DATA BASE
