require 'pg'
require_relative 'body_parser'

offers = []
conn = PGconn.connect(:hostaddr=>"127.0.0.1", :port=>5432, :dbname=>"pejoboffers", :user=>"jobadmin", :password=>'Som3ThinG')

conn.exec( "SELECT * FROM joboffers" ) do |result|

  result.each do |offer|
  #offers << offer

  puts "---OFFER \n #{offer} -----------"
  puts "----- -- ------------------- -- - "
  end
end
conn.close

#puts "this is offers array ---------- #{offers}"
