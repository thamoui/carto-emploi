require 'sinatra'
require 'shotgun'
require 'json'
require 'pg'


configure do
  set :conn, PG.connect(:hostaddr=>"127.0.0.1", :port=>5432, :dbname=>"pole_emploi", :user=>"pole_emploi", :password=>'pole_emploi')
end

before do
  @conn = settings.conn
end

get '/' do
  send_file 'views/index.html'
end

#/--------------emploi : renvoi un tableau JSON avec tous les emplois

get '/emploi' do
  @data_job = []
  @conn.exec("SELECT * FROM job_offers").map do |result|
    result = result
    @data_job << result
  end
 @data_job.to_json
end

get '/emploi/:id' do
  id = ''
  id << params[:id]
  puts "---------------this is id #{id}"
  @data_job = []
  @conn.exec("SELECT * FROM job_offers WHERE offer_id='#{id}' ").map do |result|
  #PG::UndefinedFunction: ERROR: operator does not exist: text = integer LINE 1: SELECT * FROM job_offers WHERE offer_id = 1952080 ^ HINT: No operator matches the given name and argument type(s). You might need to add explicit type casts. >
    result = result
    @data_job << result
  end
 @data_job.to_json

end

#--------------- /emploi/ID : renvoi l'emploi dont l'ID est

get '/search/id' do
  "Hello World"

end

#--------------   /geosearch/LAT,LNG : renvoi les emplois aux alentours

#--------------   /search/S : renvoi un tableau JSON avec les emplois correspondant à la recherche




# get '/emploi' do
#   # content_type :json
#   # data = Array.new()
#   # @conn.exec('SELECT * FROM joboffers').to_a.each do |row|
#   #   job = { title: row['title'], latitude: row["latitude"], longitude: row["longitude"] }
#   #
#   #   data << job
#   # end
#   puts "hello world !"
#
#   return data.to_json
# end

get '/emploi/:id' do
  content_type :json
  data = Array.new()
  @conn.exec('SELECT * FROM parse').to_a.each do |row|
    id = { id: params[:id] }

    data << id
  end

  return data.to_json
end
