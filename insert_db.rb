require 'pg'
require_relative 'body_parser'

def doc
 @newdoc = ::BodyParser.new
end

puts "new object #{doc}"

url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/1863885"
adress = doc.search_region(url)
id = 1863885
puts "-----test #{adress}"

# Output a table of current connections to the DB
conn = PGconn.connect(:hostaddr=>"127.0.0.1", :port=>5432, :dbname=>"pejoboffers", :user=>"jobadmin", :password=>'Som3ThinG')
conn.exec("INSERT INTO joboffers (region_adress, id) VALUES ('#{adress}', #{id});")
puts conn
# conn.exec( "SELECT * FROM joboffers" ) do |result|
#   puts "     region_adress | "
#   puts result
# result.each do |row|
#     puts " %7d | %-16s | %s " %
#       row.values_at('region_adress')
#   end
# end

#------------------- CONNECTING DATA BASE

#query_result  = conn.exec('SELECT * FROM joboffers')

#------------------- INSERT VALUE TO DATA BASE


# conn.close
