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

get '/emploi/' do
  content_type :json
  data = Array.new()
  @conn.exec('SELECT * FROM joboffers').to_a.each do |row|
    job = { title: row['title'], latitude: row["latitude"], longitude: row["longitude"] }

    data << job
  end
   
  return data.to_json
end

#get '/emploi/:id' do
  #content_type :json
  #data = Array.new()
  #@conn.exec('SELECT * FROM parse').to_a.each do |row|
    #id = { id: params[:id] }

    #data << id
  #end
   
  #return data.to_json
#end
